import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class SelectCategoryPage extends StatefulWidget {
  const SelectCategoryPage({super.key});

  @override
  State<SelectCategoryPage> createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  final VideoRepository videoRepository = VideoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).colorScheme.outlineVariant)),
        titleSpacing: 4.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.onInverseSurface,
            filled: true,
            prefixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.all(8.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: videoRepository.getAllCategories(),
        builder: (context, snapshot) {
          if (snapshot.data == null) return const SizedBox.shrink();
          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categroy = categories[index];
              return InkWell(
                onTap: () {
                  Navigator.pop(context, categroy);
                },
                child: ListTile(
                  title: Text(
                    categroy.category,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
