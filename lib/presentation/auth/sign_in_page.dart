import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/auth/sign_up_page.dart';
import 'package:video_sharing_app/presentation/feature/main_page.dart';
import 'package:video_sharing_app/presentation/routing_change_notifier.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final UserRepository _userRepository = UserRepositoryImpl();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Image.asset(Asset.youtubeLogo, width: 128),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Login to Your Account', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _emailController,
                cursorColor: Colors.white54,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Email',
                  fillColor: Colors.white10,
                  filled: true,
                  prefixIcon: const Icon(Icons.email),
                  prefixIconColor: Colors.white54,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _passwordController,
                cursorColor: Colors.white54,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: 'Password',
                  fillColor: Colors.white10,
                  filled: true,
                  prefixIcon: const Icon(Icons.lock),
                  prefixIconColor: Colors.white54,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.0),
                child: CheckboxListTile(
                  checkColor: Colors.white,
                  activeColor: Colors.red,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Remember me'),
                  onChanged: (value) => setState(() => _rememberMe = !_rememberMe),
                  value: _rememberMe,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: () => signIn(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sign in', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Forgot the password?', style: TextStyle(color: Colors.red.shade400, fontSize: 15.0)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(child: Divider(thickness: 1.5, endIndent: 12.0, color: Colors.white24)),
                  Text('or continue with'),
                  Expanded(child: Divider(thickness: 1.5, indent: 12.0, color: Colors.white24)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: const BorderSide(color: Colors.white10),
                      ),
                      backgroundColor: Colors.white10,
                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                    ),
                    child: Image.asset(Asset.facebookLogo, width: 24.0),
                  ),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: const BorderSide(color: Colors.white10),
                      ),
                      backgroundColor: Colors.white10,
                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                    ),
                    child: Image.asset(Asset.googleLogo, width: 24.0),
                  ),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: const BorderSide(color: Colors.white10),
                      ),
                      backgroundColor: Colors.white10,
                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                    ),
                    child: Image.asset(Asset.appleLogo, width: 24.0, color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have any account?'),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                      (route) => route.isFirst,
                    ),
                    child: Text('Sign up', style: TextStyle(color: Colors.red.shade400)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64.0),
          ],
        ),
      ),
    );
  }

  void signIn(context) async {
    bool result = await _userRepository.signIn(email: _emailController.text, password: _passwordController.text);
    if (result == true && context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Provider.of<RoutingProvider>(context, listen: false).route = const MainPage();
    }
  }
}
