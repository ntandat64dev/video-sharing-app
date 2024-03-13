import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/auth/auth_methods_page.dart';
import 'package:video_sharing_app/presentation/feature/main_page.dart';
import 'package:video_sharing_app/presentation/welcome/welcome_page.dart';

class RoutingProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepositoryImpl();
  late Widget _route;

  RoutingProvider() {
    _route = _userRepository.getLoggedUser() != null
        ? const MainPage()
        : _userRepository.isFirstLaunch()
            ? const AuthMethodsPage()
            : const WelcomePage();
  }

  Widget get route => _route;
  set route(value) {
    _route = value;
    notifyListeners();
  }
}
