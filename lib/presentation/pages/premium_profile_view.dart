import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/section_header.dart';
import 'package:harcama_app/presentation/widgets/profile_list_item.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class PremiumProfileView extends StatelessWidget {
  final bool isDark;

  const PremiumProfileView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Colors from AppColors
    final surfaceColor = AppColors.premiumSurface(isDark);
    final textColor = AppColors.premiumText(isDark);
    final subTextColor = AppColors.premiumSubText(isDark);
    final borderColor = AppColors.premiumBorder(isDark);

    final cardShadow = [
      BoxShadow(
        color: isDark ? AppColors.premiumCardShadowDark.withOpacity(0.5) : AppColors.cardShadowLight,
        offset: const Offset(0, 4),
        blurRadius: 0,
      )
    ];

    final premiumShadow = [
      const BoxShadow(
        color: AppColors.premiumGoldDark,
        offset: Offset(0, 4),
        blurRadius: 0,
      )
    ];

    final dangerShadow = [
      const BoxShadow(
        color: AppColors.dangerDark,
        offset: Offset(0, 4),
        blurRadius: 0,
      )
    ];

    Future<void> clearLocalData() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.clearLocalDataTitle),
          content: Text(l10n.clearLocalDataContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              child: Text(l10n.deleteEverything),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        if (context.mounted) {
          await context.read<TransactionNotifier>().clearAllTransactions();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.allLocalDataCleared)),
            );
          }
        }
      }
    }

    return Column(
      children: [
        // Profile Header
        Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.premiumGold, width: 6),
                    color: isDark ? Colors.grey[700] : Colors.white,
                    boxShadow: premiumShadow,
                    image: const DecorationImage(
                      image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDNroNldBPBCzjQpS0yOoEvrXdMwlFrC0q_Hmky1NLCAQMrBvb_wZYsDHXqZiTCad8K09xPVucBcQJXinlseXCvrIYkHt0q10MojSVC2SooNnirxfSQj3h5iCuv0dWoOKQjVXLucv6EYzfpwcgZkxIy8dLkHyz6uL65iCTQ5R0N8lr3iOCvFWCiKu2Em4vfJrTwPon7a5VKzcEqjiijcMgJZY0tDvEjWzpf_NyGS1E7uzbv5dFW4Ebf2DgyGVvHEPTANHoXmm15prBF"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.premiumGold,
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? AppColors.premiumScaffoldBackgroundDark : Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.workspace_premium, size: 20, color: Colors.white), // crown icon
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Alex Pro",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.premiumGold,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.premium.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "alex.pro@example.com",
              style: TextStyle(
                color: subTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Usage Status
              SectionHeader(title: l10n.usageStatus, color: subTextColor),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.premiumPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.premiumPrimary.withOpacity(0.2), width: 2),
                              ),
                              child: const Icon(Icons.folder, color: AppColors.premiumPrimaryDark, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.ledgers,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          l10n.unlimited,
                          style: const TextStyle(
                            color: AppColors.premiumPrimaryDark,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[200]!, width: 2),
                              ),
                              child: Icon(Icons.account_balance_wallet, color: Colors.blue[600], size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.accounts,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          l10n.unlimited,
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Account
              SectionHeader(title: l10n.account, color: subTextColor),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: ProfileListItem(
                  icon: Icons.check_circle,
                  iconColor: AppColors.premiumPrimaryDark,
                  iconBgColor: AppColors.premiumPrimary.withOpacity(0.1),
                  title: l10n.loggedIn,
                  subtitle: l10n.manageCloudAccount,
                  textColor: AppColors.premiumPrimaryDark,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  onTap: () {}, // Action for managing account
                ),
              ),

              const SizedBox(height: 32),

              // Data Management
              SectionHeader(title: l10n.dataManagement, color: subTextColor),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: Column(
                  children: [
                    ProfileListItem(
                      icon: Icons.cloud_upload,
                      iconColor: Colors.purple[600]!,
                      iconBgColor: Colors.purple[100]!,
                      title: l10n.onlineBackup,
                      subtitle: l10n.safeInCloud,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      borderColor: borderColor,
                      onTap: () {},
                    ),
                    ProfileListItem(
                      icon: Icons.sync,
                      iconColor: Colors.orange[600]!,
                      iconBgColor: Colors.orange[100]!,
                      title: l10n.automaticBackup,
                      subtitle: l10n.syncingEveryChange,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      borderColor: borderColor,
                      customTrailing: Container(
                        width: 40,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.premiumPrimary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ProfileListItem(
                      icon: Icons.upload_file,
                      iconColor: Colors.cyan[600]!,
                      iconBgColor: Colors.cyan[100]!,
                      title: l10n.exportData,
                      subtitle: l10n.csvJsonPdf,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      borderColor: borderColor,
                      isLast: true,
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // About
              SectionHeader(title: l10n.about, color: subTextColor),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.appVersion,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "2.4.1",
                            style: TextStyle(
                              color: subTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: borderColor, thickness: 2),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.privacyPolicy,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Icon(Icons.open_in_new, color: Colors.grey[300]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Clear Local Data Button
              PressableContainer(
                onPressed: clearLocalData,
                pressOffset: 4.0,
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(bottom: BorderSide(color: AppColors.dangerDark, width: 4)),
                  boxShadow: dangerShadow,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete_forever, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      l10n.clearLocalData,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l10n.thisActionCannotBeUndone,
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ],
    );
  }
}
