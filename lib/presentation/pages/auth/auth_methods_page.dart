import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/pages/auth/sign_in_page.dart';
import 'package:video_sharing_app/presentation/pages/auth/sign_up_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class AuthMethodsPage extends StatelessWidget {
  const AuthMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Image.asset(Asset.illustration2, width: 200),
              const SizedBox(height: 24.0),
              Text(
                'Let\'s you in',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(50)),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Asset.facebookLogo, width: 28),
                        const SizedBox(width: 16.0),
                        const Text('Continue with Facebook', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(50)),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Asset.googleLogo, width: 28),
                        const SizedBox(width: 16.0),
                        const Text('Continue with Google', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(50)),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Asset.appleLogo, width: 28, color: Theme.of(context).colorScheme.onSurface),
                        const SizedBox(width: 16.0),
                        const Text('Continue with Apple', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(thickness: 1.5, endIndent: 12.0, color: Theme.of(context).colorScheme.outline.withAlpha(30))),
                    const Text('or'),
                    Expanded(child: Divider(thickness: 1.5, indent: 12.0, color: Theme.of(context).colorScheme.outline.withAlpha(30))),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage())),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(18.0),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: const Text('Sign in with password'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have any account?'),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage())),
                        child: Text('Sign up', style: TextStyle(color: Theme.of(context).colorScheme.primary))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
