import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/data/repository_impl/auth_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/presentation/pages/auth/auth_methods_page.dart';
import 'package:video_sharing_app/presentation/route_provider.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with TickerProviderStateMixin {
  final AuthRepository authRepository = AuthRepositoryImpl();
  late PageController pageViewController;
  late TabController tabController;
  var currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageViewController = PageController(initialPage: currentPageIndex);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    pageViewController.dispose();
    tabController.dispose();
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
              controller: pageViewController,
              children: <Widget>[
                Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Image.asset(Asset.illustration1, width: 350),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.wellcomePage1,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Image.asset(Asset.illustration2, width: 350),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.wellcomePage2,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: backgroundColor,
                  child: Column(
                    children: [
                      Image.asset(Asset.illustration3, width: 350),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!.wellcomePage3,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TabPageSelector(
            controller: tabController,
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
                onPressed: next,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: Text(
                    currentPageIndex == 2
                        ? AppLocalizations.of(context)!.getStartedButton
                        : AppLocalizations.of(context)!.nextButton,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(height: 32)
        ],
      ),
    );
  }

  void next() async {
    if (currentPageIndex == 2) {
      authRepository.markFirstLaunched();
      if (context.mounted) {
        Provider.of<RouteProvider>(context, listen: false).route = const AuthMethodsPage();
      }
    } else {
      currentPageIndex++;
      pageViewController.animateToPage(currentPageIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      tabController.animateTo(currentPageIndex);
      setState(() {});
    }
  }
}
