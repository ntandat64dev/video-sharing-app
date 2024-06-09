import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';

class SelectCategoryPage extends StatefulWidget {
  const SelectCategoryPage({super.key});

  @override
  State<SelectCategoryPage> createState() => _SelectCategoryPageState();
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  final videoRepository = getIt<VideoRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: appBarBackButton(context),
        title: Text(
          AppLocalizations.of(context)!.selectCategoryAppBarTitle,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: const [
          MoreButon(),
        ],
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
