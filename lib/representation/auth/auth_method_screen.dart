import 'package:flutter/material.dart';
import 'package:video_sharing_app/representation/auth/sign_in_screen.dart';
import 'package:video_sharing_app/representation/auth/sign_up_screen.dart';

class AuthMethodScreen extends StatelessWidget {
  const AuthMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.background),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/hotel_booking_cuate.png', width: 200),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text('Let\'s you in', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white12), borderRadius: BorderRadius.circular(16.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/facebook.png', width: 28),
                      const SizedBox(width: 16.0),
                      const Text('Continue with Facebook', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white12), borderRadius: BorderRadius.circular(16.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/google.png', width: 28),
                      const SizedBox(width: 16.0),
                      const Text('Continue with Google', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.white12), borderRadius: BorderRadius.circular(16.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/apple.png', width: 28, color: Colors.white),
                      const SizedBox(width: 16.0),
                      const Text('Continue with Apple', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Expanded(child: Divider(thickness: 1.5, endIndent: 12.0, color: Colors.white24)),
                  Text('or'),
                  Expanded(child: Divider(thickness: 1.5, indent: 12.0, color: Colors.white24)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(18.0),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Sign in with password'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'s have any account?'),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: Text('Sign up', style: TextStyle(color: Colors.red.shade400))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
