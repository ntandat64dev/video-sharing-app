import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/components/custom_text_field.dart';
import 'package:video_sharing_app/presentation/pages/auth/components/logo_button.dart';
import 'package:video_sharing_app/presentation/pages/auth/sign_in_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _authRepository = getIt<AuthRepository>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isRememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBar(leading: appBarBackButton(context)),
                Image.asset(Asset.logoMedium, width: 96),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!.createYourAccount,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomTextField(
                    controller: _usernameController,
                    hintText: AppLocalizations.of(context)!.username,
                    prefixIcon: const Icon(Icons.person_rounded),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomTextField(
                    controller: _passwordController,
                    hintText: AppLocalizations.of(context)!.password,
                    prefixIcon: const Icon(Icons.lock_rounded),
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: AppLocalizations.of(context)!.confirmPassword,
                    prefixIcon: const Icon(Icons.lock_rounded),
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
                      title: Text(AppLocalizations.of(context)!.rememberMe),
                      onChanged: (value) => setState(() => _isRememberMe = !_isRememberMe),
                      value: _isRememberMe,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _isLoading
                        ? const SizedBox(
                            height: 56.0,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : SizedBox(
                            height: 56.0,
                            child: TextButton(
                              onPressed: () => onSignUp(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              ),
                              child: Text(AppLocalizations.of(context)!.signup, style: const TextStyle(fontSize: 16)),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context)!.forgotThePassword,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          endIndent: 12.0,
                          color: Theme.of(context).colorScheme.outline.withAlpha(30),
                        ),
                      ),
                      Text(AppLocalizations.of(context)!.orContinueWith),
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          indent: 12.0,
                          color: Theme.of(context).colorScheme.outline.withAlpha(30),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      logoButton(
                        onTap: () {},
                        context: context,
                        image: Image.asset(Asset.facebookLogo, width: 24.0),
                      ),
                      const SizedBox(width: 16.0),
                      logoButton(
                        onTap: () {},
                        context: context,
                        image: Image.asset(Asset.googleLogo, width: 24.0),
                      ),
                      const SizedBox(width: 16.0),
                      logoButton(
                        onTap: () {},
                        context: context,
                        image: Image.asset(
                          Asset.appleLogo,
                          width: 24.0,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.alreadyHaveAccount),
                      const SizedBox(width: 8.0),
                      GestureDetector(
                        onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInPage()),
                          (route) => route.isFirst,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.signin,
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSignUp(context) async {
    setState(() => _isLoading = true);
    if (_passwordController.text != _confirmPasswordController.text) return;
    String? error =
        await _authRepository.signUp(username: _usernameController.text, password: _passwordController.text);
    setState(() => _isLoading = false);
    if (error == null && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => route.isFirst,
      );
    } else if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.signupFailed)));
    }
  }
}
