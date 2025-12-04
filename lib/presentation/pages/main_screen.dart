import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/pages/add_transaction_page.dart';
import 'package:harcama_app/presentation/pages/home_page.dart';
import 'package:harcama_app/presentation/pages/chart_page.dart';
import 'package:harcama_app/presentation/pages/profile_page.dart';
import 'package:harcama_app/presentation/pages/report_page.dart';
import 'package:harcama_app/presentation/viewmodels/nav_model.dart';
import 'package:harcama_app/presentation/widgets/nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final chartNavKey = GlobalKey<NavigatorState>();
  final reportNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();

  int selectedTab = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(page: const HomePage(), navKey: homeNavKey),
      NavModel(page: const ChartPage(), navKey: chartNavKey),
      NavModel(page: const ReportPage(), navKey: reportNavKey),
      NavModel(page: const ProfilePage(), navKey: profileNavKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: selectedTab,
              children: items.map((page) {
                return Navigator(
                  key: page.navKey,
                  onGenerateInitialRoutes: (navigator, initialRoute) {
                    return [MaterialPageRoute(builder: (context) => page.page)];
                  },
                );
              }).toList(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    NavBar(
                      pageIndex: selectedTab,
                      onTap: (index) {
                        if (index == selectedTab) {
                          items[index].navKey.currentState?.popUntil(
                            (route) => route.isFirst,
                          );
                        } else {
                          setState(() {
                            selectedTab = index;
                          });
                        }
                      },
                    ),

                    Container(
                      margin: const EdgeInsets.only(bottom: 25),
                      height: 64,
                      width: 64,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 3, color: Colors.green),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 300,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      AddTransactionPage(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    final tween = Tween(
                                      begin: const Offset(0, 1),
                                      end: Offset.zero,
                                    ).chain(CurveTween(curve: Curves.easeOut));

                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
