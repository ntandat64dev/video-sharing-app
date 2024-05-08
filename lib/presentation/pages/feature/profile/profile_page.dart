import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/data/repository_impl/auth_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/pages/auth/auth_methods_page.dart';
import 'package:video_sharing_app/presentation/route_provider.dart';

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
        appBar: AppBar(title: const Text('Profile')),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24.0),
                // Avatar
                SizedBox(
                  height: 180.0,
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
                                  padding: const EdgeInsets.only(bottom: 4.0, right: 10.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      size: 18.0,
                                      color: Theme.of(context).colorScheme.onPrimary,
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
                // Logout
                InkWell(
                  onTap: () {
                    authRepository.signOut();
                    if (context.mounted) {
                      Provider.of<RouteProvider>(context, listen: false).route = const AuthMethodsPage();
                    }
                  },
                  child: const ListTile(
                    contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 16.0),
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
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
