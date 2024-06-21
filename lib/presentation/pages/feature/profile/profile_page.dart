import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/bottom_sheet.dart';
import 'package:video_sharing_app/presentation/components/radio_dialog.dart';
import 'package:video_sharing_app/presentation/pages/auth/auth_methods_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/profile/settings_page.dart';
import 'package:video_sharing_app/presentation/route_provider.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';
import 'package:video_sharing_app/presentation/theme/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authRepository = getIt<AuthRepository>();
  final userRepository = getIt<UserRepository>();

  User? updatedUser;
  var updatingImage = false;
  var sigingOut = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.yourProfileAppBarTitle),
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Container(
              alignment: Alignment.center,
              child: Image.asset(Asset.logoLow, width: 34.0),
            ),
          ),
          titleSpacing: 6.0,
          actions: const [
            NotificationButton(),
            SearchButton(),
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
                    future: updatedUser != null ? Future.value(updatedUser) : userRepository.getUserInfo(),
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
                                GestureDetector(
                                  onTap: () async {
                                    final picker = ImagePicker();
                                    final file = await picker.pickImage(source: ImageSource.gallery);
                                    if (file != null) {
                                      setState(() => updatingImage = true);
                                      updatedUser = await userRepository.changeProfileImage(imageLocalPath: file.path);
                                      if (updatedUser != null) {
                                        await DefaultCacheManager()
                                            .downloadFile(updatedUser!.thumbnails[Thumbnail.kDefault]!.url);
                                      }
                                      setState(() => updatingImage = false);
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100.0),
                                        child: CachedNetworkImage(
                                          imageUrl: user.thumbnails[Thumbnail.kDefault]!.url,
                                          fit: BoxFit.cover,
                                          fadeInDuration: const Duration(milliseconds: 100),
                                          fadeOutDuration: const Duration(milliseconds: 100),
                                          width: 108.0,
                                          height: 108.0,
                                        ),
                                      ),
                                      !updatingImage
                                          ? const SizedBox.shrink()
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(100.0),
                                              child: Container(
                                                width: 108,
                                                height: 108,
                                                color: Theme.of(context).colorScheme.background.withAlpha(150),
                                                child: SpinKitThreeBounce(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0, right: 6.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(100.0),
                                      ),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        size: 13.0,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            Text(user.username, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                          Icon(CupertinoIcons.chevron_forward, color: Theme.of(context).colorScheme.primary)
                        ],
                      ),
                    ),
                  ),
                ),
                // Edit profile
                profileListTile(
                  onTap: () {},
                  title: AppLocalizations.of(context)!.editProfile,
                  leading: const Icon(CupertinoIcons.square_pencil),
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
                  leading: const Icon(CupertinoIcons.moon),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Provider.of<ThemeProvider>(context).getLocalizedThemeModeName(context),
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(width: 8.0),
                      const Icon(CupertinoIcons.chevron_right, size: 20.0),
                    ],
                  ),
                ),
                // Settings
                profileListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                  title: AppLocalizations.of(context)!.settings,
                  leading: const Icon(CupertinoIcons.gear),
                ),
                // Logout
                InkWell(
                  onTap: () {
                    showConsistentBottomSheet(
                      context: context,
                      height: 220,
                      title: Text(
                        AppLocalizations.of(context)!.logout,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      negativeButton: bottomSheetNegativeButton(
                        context: context,
                        onPressed: () {
                          sigingOut = false;
                          Navigator.pop(context);
                        },
                      ),
                      confirmButton: StatefulBuilder(
                        builder: (context, setState) {
                          return sigingOut
                              ? const Center(child: CircularProgressIndicator())
                              : bottomSheetConfirmButton(
                                  context: context,
                                  onPressed: () async {
                                    setState(() => sigingOut = true);
                                    final isSuccess = await authRepository.signOut();
                                    setState(() => sigingOut = false);
                                    if (isSuccess && context.mounted) {
                                      Navigator.pop(context);
                                      Provider.of<RouteProvider>(context, listen: false).route =
                                          const AuthMethodsPage();
                                    } else if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Log out failed. Please try again!'),
                                        ),
                                      );
                                    }
                                  },
                                );
                        },
                      ),
                      content: Text(
                        AppLocalizations.of(context)!.youSureLogout,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    leading: Icon(CupertinoIcons.square_arrow_right, color: Theme.of(context).colorScheme.error),
                    title: Text(
                      AppLocalizations.of(context)!.logout,
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500),
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
        trailing: trailing ?? const Icon(CupertinoIcons.chevron_right, size: 20.0),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
