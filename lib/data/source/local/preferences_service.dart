import 'package:video_sharing_app/domain/entity/user.dart';

abstract class PreferencesService {
  bool get isFirstLaunched;
  set isFirstLaunched(bool value);

  User? getUser();
  void setUser(User user);
  void removeUser();
}
