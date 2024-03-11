import 'package:flutter/material.dart';
import 'package:video_sharing_app/representation/auth/auth_method_screen.dart';
import 'package:video_sharing_app/service/shared_preferences_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  var _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: _currentPageIndex);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.background;
    return Scaffold(
      appBar: AppBar(backgroundColor: backgroundColor),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageViewController,
              children: <Widget>[
                Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Image.asset('assets/images/smart_home_bro.png', width: 350),
                      const SizedBox(height: 32),
                      Text(
                        'Watch interesting videos from around the world',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Image.asset('assets/images/smart_home_cuate.png', width: 350),
                      const SizedBox(height: 32),
                      Text(
                        'Watch interesting videos easily from your smartphone',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Image.asset('assets/images/smart_home_pana.png', width: 350),
                      const SizedBox(height: 32),
                      Text(
                        'Let\'s explore videos around the world with MeTube now!',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TabPageSelector(
            controller: _tabController,
            color: Theme.of(context).colorScheme.onBackground.withAlpha(75),
            borderStyle: BorderStyle.none,
            selectedColor: Colors.red,
          ),
          const SizedBox(height: 42),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_currentPageIndex == 2) {
                    (await SharedPreferencesService.getInstance()).isFirstLaunched = true;
                    if (context.mounted) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthMethodScreen()));
                    }
                  } else {
                    _currentPageIndex++;
                    _pageViewController.animateToPage(_currentPageIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    _tabController.animateTo(_currentPageIndex);
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: Text(_currentPageIndex == 2 ? 'Get Started' : 'Next', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(height: 32)
        ],
      ),
    );
  }
}
