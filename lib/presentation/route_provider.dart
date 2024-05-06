import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/auth_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/presentation/pages/auth/auth_methods_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/main_page.dart';
import 'package:video_sharing_app/presentation/pages/welcome/welcome_page.dart';

class RouteProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepositoryImpl();
  late Widget _route;

  RouteProvider() {
    _route = _authRepository.wasUserLoggedIn()
        ? const MainPage()
        : _authRepository.isFirstLaunch()
            ? const AuthMethodsPage()
            : const WelcomePage();
  }

  Widget get route => _route;
  set route(value) {
    _route = value;
    notifyListeners();
  }
}
