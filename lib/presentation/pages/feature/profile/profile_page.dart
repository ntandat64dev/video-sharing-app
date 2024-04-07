import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/pages/auth/auth_methods_page.dart';
import 'package:video_sharing_app/presentation/route_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepository userRepository = UserRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ElevatedButton(
          onPressed: () async {
            var isSignedOut = await userRepository.signOut();
            if (isSignedOut && context.mounted) {
              Provider.of<RouteProvider>(context, listen: false).route = const AuthMethodsPage();
            }
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
