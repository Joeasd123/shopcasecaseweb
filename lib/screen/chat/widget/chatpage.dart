import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final String? apikey = dotenv.env["Apikey"];
final String? supabaseUrl = dotenv.env["API__URL"];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // ตรวจสอบให้แน่ใจว่าโหลด .env แล้ว
  await Supabase.initialize(
    url: supabaseUrl!,
    anonKey: apikey!,
  );

  runApp(const ProviderScope(
      child: MyApp())); // ถ้าใช้ Riverpod ต้องครอบด้วย ProviderScope
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulHookConsumerWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  late final SupabaseClient _supabase;
  late final RealtimeChannel _channel;

  @override
  void initState() {
    super.initState();
    _supabase = Supabase.instance.client;
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _fetchInitialMessages();

    _channel = _supabase.channel('public_messages_channel');
    _channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            final newMessage = payload.newRecord;
            setState(() {
              _messages.add(newMessage);
              _scrollToBottom();
            });
          },
        )
        .subscribe();
  }

  Future<void> _fetchInitialMessages() async {
    final data = await _supabase
        .from('messages')
        .select('*')
        .order('created_at', ascending: true)
        .limit(50);

    setState(() {
      _messages.clear();
      _messages.addAll(List<Map<String, dynamic>>.from(data));
      _scrollToBottom();
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final String messageContent = _messageController.text.trim();
    _messageController.clear();
    final User? currentUser = _supabase.auth.currentUser;
    final Session? currentSession = _supabase.auth.currentSession;
    print('--- _sendMessage Debug Info ---');
    print('currentUser: ${currentUser?.id ?? 'NULL'}');
    print('currentSession: ${currentSession?.accessToken ?? 'NULL'}');
    print(
        'userToken![\'id\'] (from provider): ${ref.read(userTokenProvifer)?['id']}');
    print('-----------------------------');

    if (currentUser == null || currentSession == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to send messages.')),
      );
      return;
    }

    try {
      await _supabase.from('messages').insert({
        'user_id': currentUser.id,
        'content': messageContent,
      });
      print('Message sent successfully!');
    } catch (error) {
      print('Failed to send message: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $error')),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _supabase.removeChannel(_channel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? currentLoggedInUserId = _supabase.auth.currentUser?.id;
    final userToken = ref.watch(userTokenProvifer);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isCurrentUser =
                    message['user_id'] == currentLoggedInUserId;
                final DateTime createdAt =
                    DateTime.parse(message['created_at']);
                final String formattedTime =
                    DateFormat('HH:mm').format(createdAt.toLocal());

                return Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color:
                          isCurrentUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: isCurrentUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['content'] as String,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          formattedTime,
                          style: TextStyle(
                              fontSize: 10.0, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: () {
                    _sendMessage();
                  },
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
