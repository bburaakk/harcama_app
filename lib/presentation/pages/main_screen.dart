import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/pages/add_transaction_page.dart';
import 'package:harcama_app/presentation/pages/home_page.dart';
import 'package:harcama_app/presentation/pages/chart_page.dart';
import 'package:harcama_app/presentation/pages/profile_page.dart';
import 'package:harcama_app/presentation/pages/report_page.dart';
import 'package:harcama_app/presentation/viewmodels/nav_model.dart';
import 'package:harcama_app/presentation/widgets/nav_bar.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeKey = GlobalKey<NavigatorState>();
  final chartKey = GlobalKey<NavigatorState>();
  final reportKey = GlobalKey<NavigatorState>();
  final profileKey = GlobalKey<NavigatorState>();

  int selected = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(page: const HomePage(), navKey: homeKey),
      NavModel(page: const ChartPage(), navKey: chartKey),
      NavModel(page: const ReportPage(), navKey: reportKey),
      NavModel(page: const ProfilePage(), navKey: profileKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                          setState(() => selected = i);
                        }
                      },
                    ),
                    PressableContainer(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 300,
                            ),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    AddTransactionPage(),
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: animation.drive(
                                  Tween(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).chain(CurveTween(curve: Curves.easeOut)),
                                ),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      margin: EdgeInsets.only(bottom: 20 + MediaQuery.of(context).padding.bottom),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppColors.cardBorderRadius,
                        ),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.3),
                          width: 4,
                        ),
                        color: AppColors.primaryCardColor,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.primaryCardShadow,
                          offset: AppColors.cardShadowOffset,
                        ),
                      ],
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Center(
                          child: Icon(
                            Symbols.add_rounded,
                            size: 42,
                            weight: 700,
                            opticalSize: 20,
                            grade: 200,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
          ],
      ),
    )
    );
}
}