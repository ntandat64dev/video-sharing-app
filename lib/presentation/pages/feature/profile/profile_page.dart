import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/data/repository_impl/auth_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/components/radio_dialog.dart';
import 'package:video_sharing_app/presentation/pages/auth/auth_methods_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/profile/settings_page.dart';
import 'package:video_sharing_app/presentation/route_provider.dart';
import 'package:video_sharing_app/presentation/theme/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthRepository authRepository = AuthRepositoryImpl();
  final UserRepository userRepository = UserRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.yourProfileAppBarTitle),
          leading: Icon(Icons.videocam, size: 32.0, color: Theme.of(context).colorScheme.primary),
          titleSpacing: 0.0,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Badge(
                label: Text('2'),
                child: Icon(Icons.notifications_rounded),
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24.0),
                // Avatar
                SizedBox(
                  height: 160.0,
                  child: FutureBuilder(
                    future: userRepository.getUserInfo(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      var user = snapshot.data!;
                      return SizedBox(
                        height: double.infinity,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user.thumbnails[Thumbnail.kDefault]!.url),
                                  radius: 54.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0, right: 7.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(100.0),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        size: 14.0,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Text(user.username, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                            if (user.bio != null) Text(user.bio!),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Premium
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(34.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant.withAlpha(50),
                        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5),
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            size: 64.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.joinPremium,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(AppLocalizations.of(context)!.joinPremiumSubtext),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary)
                        ],
                      ),
                    ),
                  ),
                ),
                // Edit profile
                profileListTile(
                  onTap: () {},
                  title: AppLocalizations.of(context)!.editProfile,
                  leading: const Icon(Icons.edit),
                ),
                // Theme
                profileListTile(
                  onTap: () {
                    showRadioDialog<ThemeMode>(
                      context: context,
                      title: AppLocalizations.of(context)!.selectTheme,
                      onOkClicked: (value) {
                        Provider.of<ThemeProvider>(context, listen: false).themeMode = value!;
                      },
                      radioTitles: [
                        AppLocalizations.of(context)!.light,
                        AppLocalizations.of(context)!.dark,
                        AppLocalizations.of(context)!.system,
                      ],
                      radioValues: [
                        ThemeMode.light,
                        ThemeMode.dark,
                        ThemeMode.system,
                      ],
                      groupValue: Provider.of<ThemeProvider>(context, listen: false).themeMode,
                    );
                  },
                  title: AppLocalizations.of(context)!.theme,
                  leading: const Icon(Icons.dark_mode_rounded),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Provider.of<ThemeProvider>(context).getLocalizedThemeModeName(context),
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                // Settings
                profileListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                  title: AppLocalizations.of(context)!.settings,
                  leading: const Icon(Icons.settings),
                ),
                // Logout
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32.0),
                            topRight: Radius.circular(32.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 8.0),
                            Container(
                              width: 36.0,
                              height: 3.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.outlineVariant,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                AppLocalizations.of(context)!.logout,
                                style: const TextStyle(color: Colors.red, fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              height: 0.0,
                              thickness: 0.2,
                              indent: 16.0,
                              endIndent: 16.0,
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              AppLocalizations.of(context)!.youSureLogout,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(50),
                                        foregroundColor: Theme.of(context).colorScheme.primary,
                                        padding: const EdgeInsets.all(16.0),
                                      ),
                                      child: Text(AppLocalizations.of(context)!.cancel),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        authRepository.signOut();
                                        if (context.mounted) {
                                          Provider.of<RouteProvider>(context, listen: false).route =
                                              const AuthMethodsPage();
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                        padding: const EdgeInsets.all(16.0),
                                      ),
                                      child: Text(AppLocalizations.of(context)!.logoutYes),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      AppLocalizations.of(context)!.logout,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget profileListTile({
  required void Function() onTap,
  required String title,
  required Widget leading,
  Widget? trailing,
}) =>
    InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        leading: leading,
        trailing: trailing ?? const Icon(Icons.chevron_right),
        title: Text(title),
      ),
    );
