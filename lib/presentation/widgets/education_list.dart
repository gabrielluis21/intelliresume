import 'package:flutter/material.dart';

class EducationList extends StatelessWidget {
  final List<String> items;
  final TextTheme theme;

  const EducationList({super.key, required this.items, required this.theme});

  @override
  Widget build(BuildContext c) {
    if (items.isEmpty) return const Text('Nenhuma formação');
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder:
          (c, i) => ListTile(
            leading: const Icon(Icons.school_outlined),
            title: Text(
              items[i],
              style: theme.bodyMedium!.copyWith(
                color:
                    MediaQuery.of(c).platformBrightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
    );
  }
}
