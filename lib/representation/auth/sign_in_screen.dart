import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Image.asset('assets/images/youtube.png', width: 128),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Login to Your Account', style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
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
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = !_rememberMe;
                    });
                  },
                  value: _rememberMe,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  onPressed: () {},
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
                    child: Image.asset('assets/images/facebook.png', width: 24.0),
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
                    child: Image.asset('assets/images/google.png', width: 24.0),
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
                    child: Image.asset('assets/images/apple.png', width: 24.0, color: Colors.white),
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
                  const Text('Don\'s have any account?'),
                  const SizedBox(width: 8.0),
                  GestureDetector(onTap: () {}, child: Text('Sign up', style: TextStyle(color: Colors.red.shade400))),
                ],
              ),
            ),
            const SizedBox(height: 64.0),
          ],
        ),
      ),
    );
  }
}
