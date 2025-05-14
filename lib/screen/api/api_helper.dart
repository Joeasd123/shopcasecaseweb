import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIHelper {
  static final String? _baseURL = dotenv.env["API__URL"];
  static Uri getURL({
    required final String path,
    final Map<String, dynamic>? queryParameters,
  }) {
    final url = Uri.parse(
      "$_baseURL$path",
    ).replace(
      queryParameters: queryParameters,
    );
    return url;
  }

  static String getPATH({
    required final String path,
  }) {
    final url = "$_baseURL$path";

    return url;
  }
}
