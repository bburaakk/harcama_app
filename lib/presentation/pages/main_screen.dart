import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/pages/home_page.dart';
import 'package:harcama_app/presentation/pages/chart_page.dart';
import 'package:harcama_app/presentation/pages/settings_page.dart';
import 'package:harcama_app/presentation/pages/goal_page.dart';
import 'package:harcama_app/presentation/viewmodels/nav_model.dart';
import 'package:harcama_app/presentation/widgets/nav_bar.dart';
import 'package:harcama_app/presentation/widgets/floating_add_button.dart';
import 'package:harcama_app/presentation/notifiers/navigation_notifier.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeKey = GlobalKey<NavigatorState>();
  final chartKey = GlobalKey<NavigatorState>();
  final reportKey = GlobalKey<NavigatorState>();
  final settingsKey = GlobalKey<NavigatorState>();

  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(page: const HomePage(), navKey: homeKey),
      NavModel(page: const ChartPage(), navKey: chartKey),
      NavModel(page: const GoalPage(), navKey: reportKey),
      NavModel(page: const SettingsPage(), navKey: settingsKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationNotifier = context.watch<NavigationNotifier>();
    final selected = navigationNotifier.selectedIndex;

    return WillPopScope(
      onWillPop: () async {
        if (items[selected].navKey.currentState?.canPop() ?? false) {
          items[selected].navKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: selected,
              children: items.map((e) {
                return Navigator(
                  key: e.navKey,
                  onGenerateInitialRoutes: (navigator, _) {
                    return [
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 250),
                        pageBuilder: (_, animation, __) => e.page,
                        transitionsBuilder: (_, anim, __, child) {
                          return FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                              position: anim.drive(
                                Tween(
                                  begin: const Offset(0.1, 0),
                                  end: Offset.zero,
                                ).chain(CurveTween(curve: Curves.easeOutCubic)),
                              ),
                              child: child,
                            ),
                          );
                        },
                      ),
                    ];
                  },
                );
              }).toList(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                    NavBar(
                      index: selected,
                      onTap: (i) {
                        if (i == selected) {
                          items[i].navKey.currentState?.popUntil(
                            (route) => route.isFirst,
                          );
                        } else {
                          context.read<NavigationNotifier>().setIndex(i);
                        }
                      },
                    ),
                    const FloatingAddButton(),
                  ],
                ),
              ),
            
          ],
      ),
    )
    );
}
}
