import 'package:flutter/material.dart';
import 'package:flutter_web/screen/category/controllers/categorycontrollers.dart';
import 'package:flutter_web/screen/category/model/category_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryMobile extends StatefulHookConsumerWidget {
  const CategoryMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryMobileState();
}

class _CategoryMobileState extends ConsumerState<CategoryMobile> {
  final Map<int, bool> _isHoveringMap = {};
  @override
  Widget build(BuildContext context) {
    final fetchcategory = ref.watch(fetchcategoryMobilepovider);
    return fetchcategory.when(
      data: (List<CategoryModel> data) {
        if (data.isEmpty) return Center(child: Text("ไม่พบข้อมูล"));
        return SizedBox(
          height: 220.0,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.95,
              crossAxisCount: 4,
            ),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final bool isHovering = _isHoveringMap[index] ?? false;
              return MouseRegion(
                onEnter: (event) {
                  setState(() {
                    _isHoveringMap[index] = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _isHoveringMap[index] = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: isHovering
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ]
                          : [],
                      border: Border.all(color: Colors.grey, width: 0.5)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(data[index].image ?? ""),
                        ),
                        Text(data[index].name ?? ""),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (err, stack) => Center(child: Text("ไม่พบข้อมูล")),
    );
  }
}
