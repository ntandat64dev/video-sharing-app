import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/data/repository_impl/preference_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/preference_repository.dart';
import 'package:video_sharing_app/presentation/components/radio_dialog.dart';
import 'package:video_sharing_app/presentation/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/presentation/pages/feature/profile/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final PreferenceRepository preferenceRepository = PreferenceRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingsAppBarTitle)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              profileListTile(
                  onTap: () {
                    showRadioDialog(
                      context: context,
                      title: AppLocalizations.of(context)!.selectLanguage,
                      onOkClicked: (value) {
                        Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale(value!));
                      },
                      radioTitles: [
                        AppLocalizations.of(context)!.langEn,
                        AppLocalizations.of(context)!.langVi,
                      ],
                      radioValues: ['en', 'vi'],
                      groupValue: Provider.of<LocaleProvider>(context, listen: false).locale.languageCode,
                    );
                  },
                  title: AppLocalizations.of(context)!.settingLanguage,
                  leading: const Icon(Icons.language),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Provider.of<LocaleProvider>(context).getLocalizedLocaleName(context),
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}