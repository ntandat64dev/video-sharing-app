import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchNotFound extends StatelessWidget {
  const SearchNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          Asset.emptyList,
          fit: BoxFit.cover,
          width: 300,
        ),
        Text(
          AppLocalizations.of(context)!.notFound,
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            AppLocalizations.of(context)!.explainNotFound,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15.0),
          ),
        ),
        const SizedBox(height: 120.0),
      ],
    );
  }
}
