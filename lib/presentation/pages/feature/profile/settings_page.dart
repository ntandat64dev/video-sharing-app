import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/repository/preference_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/components/radio_dialog.dart';
import 'package:video_sharing_app/presentation/locale_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/profile/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final preferenceRepository = getIt<PreferenceRepository>();

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingsAppBarTitle),
          leading: appBarBackButton(context),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              profileListTile(
                onTap: () {
                  showRadioDialog(
                    context: context,
                    title: AppLocalizations.of(context)!.selectLanguage,
                    onOkClicked: (value) {
                      localeProvider.setLocale(Locale(value!));
                    },
                    radioTitles: [
                      AppLocalizations.of(context)!.langEn,
                      AppLocalizations.of(context)!.langVi,
                    ],
                    radioValues: ['en', 'vi'],
                    groupValue: localeProvider.locale.languageCode,
                  );
                },
                title: AppLocalizations.of(context)!.settingLanguage,
                leading: const Icon(CupertinoIcons.globe),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localeProvider.getLocalizedLocaleName(context),
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(width: 8.0),
                    const Icon(CupertinoIcons.chevron_right, size: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
