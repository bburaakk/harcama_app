import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/notifiers/theme_notifier.dart';
import 'package:harcama_app/presentation/notifiers/premium_notifier.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/premium_feature_item.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class PremiumUpgradePage extends StatefulWidget {
  const PremiumUpgradePage({super.key});

  @override
  State<PremiumUpgradePage> createState() => _PremiumUpgradePageState();
}

class _PremiumUpgradePageState extends State<PremiumUpgradePage> {
  bool isYearlySelected = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    // Colors from AppColors
    final backgroundColor = AppColors.premiumBackground(isDark);
    final textColor = AppColors.premiumText(isDark);
    final subTextColor = AppColors.premiumSubText(isDark);
    final cardColor = AppColors.premiumSurface(isDark);
    final borderColor = AppColors.premiumBorder(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: textColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 48), // Balance the close button
                      child: Text(
                        l10n.premium,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                children: [
                  // Hero Illustration Area
                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 192,
                            height: 192,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDark
                                    ? [Colors.yellow[900]!.withOpacity(0.3), Colors.yellow[800]!.withOpacity(0.2)]
                                    : [Colors.yellow[100]!, Colors.yellow[200]!],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.workspace_premium, // Using workspace_premium as rewarded_ads might not be available
                                size: 96,
                                color: Colors.amber,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: Transform.rotate(
                              angle: 0.2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.premiumPrimary,
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  l10n.hugeValue,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.unlockTheBest,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.takeControl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Features List
                  PremiumFeatureItem(
                    icon: Icons.cloud_upload,
                    iconColor: Colors.blue[600]!,
                    iconBgColor: isDark ? Colors.blue[900]!.withOpacity(0.4) : Colors.blue[100]!,
                    title: l10n.cloudBackupSync,
                    subtitle: l10n.neverLoseData,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    cardColor: cardColor,
                  ),
                  const SizedBox(height: 16),
                  PremiumFeatureItem(
                    icon: Icons.analytics,
                    iconColor: Colors.purple[600]!,
                    iconBgColor: isDark ? Colors.purple[900]!.withOpacity(0.4) : Colors.purple[100]!,
                    title: l10n.advancedAnalytics,
                    subtitle: l10n.deepDiveSpending,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    cardColor: cardColor,
                  ),
                  const SizedBox(height: 16),
                  PremiumFeatureItem(
                    icon: Icons.block,
                    iconColor: Colors.red[600]!,
                    iconBgColor: isDark ? Colors.red[900]!.withOpacity(0.4) : Colors.red[100]!,
                    title: l10n.adFreeExperience,
                    subtitle: l10n.noInterruptions,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    cardColor: cardColor,
                  ),
                  const SizedBox(height: 16),
                  PremiumFeatureItem(
                    icon: Icons.construction,
                    iconColor: Colors.orange[600]!,
                    iconBgColor: isDark ? Colors.orange[900]!.withOpacity(0.4) : Colors.orange[100]!,
                    title: l10n.smartFinanceTools,
                    subtitle: l10n.aiBudgeting,
                    textColor: textColor,
                    subTextColor: subTextColor,
                    cardColor: cardColor,
                  ),

                  const SizedBox(height: 32),

                  // Plan Selection
                  GestureDetector(
                    onTap: () => setState(() => isYearlySelected = true),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isYearlySelected ? AppColors.premiumPrimary : borderColor,
                          width: 2,
                        ),
                        boxShadow: isYearlySelected
                            ? [BoxShadow(color: AppColors.premiumPrimary, offset: const Offset(0, 4), blurRadius: 0)]
                            : [BoxShadow(color: borderColor, offset: const Offset(0, 4), blurRadius: 0)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.yearlyAccess,
                                style: const TextStyle(
                                  color: AppColors.premiumPrimary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.yearlyPrice,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.premiumPrimary,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  l10n.savePercent,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.monthlyPrice,
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => setState(() => isYearlySelected = false),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: !isYearlySelected ? AppColors.premiumPrimary : borderColor,
                          width: 2,
                        ),
                        boxShadow: !isYearlySelected
                            ? [BoxShadow(color: AppColors.premiumPrimary, offset: const Offset(0, 4), blurRadius: 0)]
                            : [BoxShadow(color: borderColor, offset: const Offset(0, 4), blurRadius: 0)],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.monthly,
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.monthlyFullPrice,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            !isYearlySelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: !isYearlySelected ? AppColors.premiumPrimary : subTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Footer / CTA
                  PressableContainer(
                    onPressed: () {
                      // Activate premium and close the page
                      context.read<PremiumNotifier>().activatePremium();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.premiumWelcomeMessage)),
                      );
                    },
                    decoration: BoxDecoration(
                      color: AppColors.premiumPrimary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.premiumPrimaryDark,
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        l10n.continueText,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Center(
                    child: Text(
                      l10n.cancelAnytime,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.termsOfService,
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        l10n.privacyPolicy.toUpperCase(),
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
