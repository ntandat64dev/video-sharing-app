import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/pages/auth/auth_methods_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/main_page.dart';
import 'package:video_sharing_app/presentation/pages/welcome/welcome_page.dart';

class RouteProvider extends ChangeNotifier {
  final UserRepository _userRepository = UserRepositoryImpl();
  late Widget _route;

  RouteProvider() {
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
