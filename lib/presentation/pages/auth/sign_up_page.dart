import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/pages/auth/sign_in_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/main_page.dart';
import 'package:video_sharing_app/presentation/route_provider.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final UserRepository _userRepository = UserRepositoryImpl();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isRememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              Image.asset(Asset.youtubeLogo, width: 128),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Create Your Account', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
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
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
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
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _confirmPasswordController,
                  cursorColor: Colors.white54,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Confirm Password',
                    fillColor: Colors.white10,
                    filled: true,
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: Colors.white54,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CheckboxListTile(
                    checkColor: Theme.of(context).colorScheme.onPrimary,
                    activeColor: Theme.of(context).colorScheme.primary,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Remember me'),
                    onChanged: (value) => setState(() => _isRememberMe = !_isRememberMe),
                    value: _isRememberMe,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () => onSignUp(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text('Sign up', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Forgot the password?', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15.0)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(thickness: 1.5, endIndent: 12.0, color: Theme.of(context).colorScheme.outline.withAlpha(30))),
                    const Text('or continue with'),
                    Expanded(child: Divider(thickness: 1.5, indent: 12.0, color: Theme.of(context).colorScheme.outline.withAlpha(30))),
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
                          side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
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
                          side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
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
                          side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                        ),
                        backgroundColor: Colors.white10,
                        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                      ),
                      child: Image.asset(Asset.appleLogo, width: 24.0, color: Theme.of(context).colorScheme.onSurface),
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
                    const Text('Already have an account?'),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInPage()),
                        (route) => route.isFirst,
                      ),
                      child: Text('Sign in', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }

  void onSignUp(context) async {
    if (_passwordController.text != _confirmPasswordController.text) return;
    bool result = await _userRepository.signUp(email: _emailController.text, password: _passwordController.text);
    if (result == true && context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Provider.of<RouteProvider>(context, listen: false).route = const MainPage();
    }
  }
}
