import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/top_bar.dart';
import 'package:harcama_app/presentation/widgets/ledger_dropdown.dart';
import 'package:harcama_app/presentation/widgets/remaining_balance_card.dart';
import 'package:harcama_app/presentation/widgets/daily_goal_card.dart';
import 'package:harcama_app/presentation/widgets/transaction_list.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:material_symbols_icons/symbols.dart';

// Eğer AddGoalCard widget'ı ayrı bir dosyadaysa import etmeyi unutmayın.
// Yoksa ve aynı dosyadaysa aşağıya dummy bir class ekledim, onu kullanabilirsiniz.
// import 'package:harcama_app/presentation/widgets/add_goal_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  bool showLedgerSheet = false;

  void _toggleLedgerSheet() {
    setState(() {
      showLedgerSheet = !showLedgerSheet;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txNotifier = context.watch<TransactionNotifier>();
    final ledgerNotifier = context.watch<LedgerNotifier>();

    final activeLedgerId = ledgerNotifier.selectedLedger?.id;

    // Filtreleme işlemleri
    final visibleTx = activeLedgerId == null || activeLedgerId == 'default'
        ? txNotifier.transactions
        : txNotifier.transactions
        .where((t) => t.ledgerID == activeLedgerId)
        .toList();

    final income = visibleTx
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expense = visibleTx
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = income - expense;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Ana İçerik
            GestureDetector(
              onTap: showLedgerSheet ? _toggleLedgerSheet : null,
              behavior: HitTestBehavior.translucent, // Boşluklara tıklamayı da algıla
              child: Column(
                children: [
                  // Üst Bar
                  TopBar(
                    isSearching: isSearching,
                    onSearchToggle: () =>
                        setState(() => isSearching = !isSearching),
                    onLedgerTap: _toggleLedgerSheet,
                  ),

                  // Kaydırılabilir İçerik Alanı
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),

                          // Arama yapılmıyorsa Üst Widget'ları Göster
                          if (!isSearching) ...[
                            // Bakiye Kartı
                            RemainingBalanceCard(balance: balance),

                            const SizedBox(height: 24),

                            // Hedefler Başlığı
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Daily Goals",
                                  style: TextStyle(
                                    color: AppColors.text(context),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  "See All",
                                  style: TextStyle(
                                    color: AppColors.primaryDark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // --- DÜZELTİLEN GRID ALANI ---
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: GridView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                // GridDelegate ile sabit yükseklik veriyoruz:
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,       // Yan yana 2 tane
                                  crossAxisSpacing: 24,    // Yatay boşluk
                                  mainAxisSpacing: 12,     // Dikey boşluk
                                  mainAxisExtent: 80,     // [ÖNEMLİ] Sabit Yükseklik (100px)
                                ),
                                children: [
                                  DailyGoalCard(
                                    icon: Symbols.restaurant_rounded,
                                    label: "Food",
                                    current: 12,
                                    target: 20,
                                    color: AppColors.secondaryYellow,
                                    colorDark: AppColors.secondaryYellowDark,
                                  ),
                                  DailyGoalCard(
                                    icon: Symbols.directions_car_rounded,
                                    label: "Travel",
                                    current: 5,
                                    target: 15,
                                    color: AppColors.secondaryBlue,
                                    colorDark: AppColors.secondaryBlueDark,
                                  ),
                                  DailyGoalCard(
                                    icon: Symbols.confirmation_number_rounded,
                                    label: "Fun",
                                    current: 8,
                                    target: 10,
                                    color: AppColors.primary,
                                    colorDark: AppColors.primaryDark,
                                  ),
                                  // AddGoalCard widget'ınızın import edildiğinden emin olun
                                  const AddGoalCard(),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Son Aktiviteler Başlığı
                            Row(
                              children: [
                                Text(
                                  "Recent Activity",
                                  style: TextStyle(
                                    color: AppColors.text(context),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],

                          // Alt Liste (İşlemler)
                          // Listeyi Expanded içine alarak kalan tüm alanı kaplamasını sağlıyoruz
                          Expanded(
                            child: SingleChildScrollView(
                              // Liste içinde liste kaydırma sorununu çözmek için:
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  TransactionList(
                                    transactions: visibleTx,
                                    notifier: txNotifier,
                                  ),
                                  // Listenin altında biraz boşluk bırakır (FAB veya bottom bar için)
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Ledger Seçim Ekranı (Overlay)
            if (showLedgerSheet)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleLedgerSheet,
                  behavior: HitTestBehavior.translucent,
                  child: Stack(
                    children: [
                      LedgerDropdown(
                        isVisible: showLedgerSheet,
                        ledgerNotifier: ledgerNotifier,
                        onToggle: _toggleLedgerSheet,
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
