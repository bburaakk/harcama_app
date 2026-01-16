import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/premium_notifier.dart';
import 'package:harcama_app/presentation/pages/premium_upgrade_page.dart';
import 'package:harcama_app/presentation/pages/premium_profile_view.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/section_header.dart';
import 'package:harcama_app/presentation/widgets/profile_list_item.dart';
import 'package:harcama_app/presentation/widgets/usage_bar.dart';
import 'package:harcama_app/presentation/widgets/square_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final premiumNotifier = context.watch<PremiumNotifier>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPremium = premiumNotifier.isPremium;

    // Colors from AppColors
    final backgroundColor = AppColors.premiumBackground(isDark);
    final surfaceColor = AppColors.premiumSurface(isDark);
    final textColor = AppColors.premiumText(isDark);
    final borderColor = AppColors.premiumBorder(isDark);
    
    // Shadow styles
    final cardShadow = [
      BoxShadow(
        color: isDark ? AppColors.premiumCardShadowDark.withOpacity(0.5) : AppColors.cardShadowLight,
        offset: const Offset(0, 4),
        blurRadius: 0,
      )
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  SquareButton(
                    icon: Icons.settings,
                    bgColor: surfaceColor,
                    borderColor: borderColor,
                    shadows: cardShadow,
                    isDark: isDark,
                    onTap: () {
                      // Debug: Toggle premium status
                      if (isPremium) {
                        context.read<PremiumNotifier>().deactivatePremium();
                      } else {
                        context.read<PremiumNotifier>().activatePremium();
                      }
                    },
                  ),
                ],
              ),
            ),

            if (isPremium)
              PremiumProfileView(isDark: isDark)
            else
              _buildGuestProfile(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestProfile(BuildContext context, bool isDark) {
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

    void navigateToPremium() {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PremiumUpgradePage()),
      );
    }

    Future<void> clearLocalData() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Clear Local Data?"),
          content: const Text("This will permanently delete all your transactions. This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              child: const Text("Delete Everything"),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        if (context.mounted) {
          await context.read<TransactionNotifier>().clearAllTransactions();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All local data cleared.")),
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
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? Colors.grey[600]! : Colors.grey[300]!, width: 6),
                color: isDark ? Colors.grey[700] : Colors.grey[100],
                boxShadow: cardShadow,
              ),
              child: Icon(Icons.person, size: 64, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              "Guest User",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Local usage (no account)",
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
              // Go Premium Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.premiumGold,
                  borderRadius: BorderRadius.circular(24),
                  border: const Border(bottom: BorderSide(color: AppColors.premiumGoldDark, width: 4)),
                  boxShadow: premiumShadow,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -16,
                      top: -16,
                      child: Opacity(
                        opacity: 0.2,
                        child: Transform.rotate(
                          angle: 0.2,
                          child: const Icon(Icons.stars, size: 96, color: Colors.black),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Go Premium",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Unlock cloud sync, unlimited ledgers, and zero ads.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: PressableContainer(
                            onPressed: navigateToPremium,
                            pressOffset: 4.0, // Match border width
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 4)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 4),
                                  blurRadius: 0,
                                )
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            child: const Text(
                              "UPGRADE NOW",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.premiumGoldDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Usage Limits
              SectionHeader(title: "Usage Limits", color: subTextColor),
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
                    UsageBar(label: "Ledgers", value: "1 / 1", percentage: 1.0, progressColor: AppColors.premiumPrimary, isDark: isDark),
                    const SizedBox(height: 16),
                    UsageBar(label: "Accounts", value: "2 / 3", percentage: 0.66, progressColor: AppColors.premiumPrimary, isDark: isDark),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Account
              SectionHeader(title: "Account", color: subTextColor),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: ProfileListItem(
                  icon: Icons.login,
                  iconColor: Colors.blue[600]!,
                  iconBgColor: Colors.blue[100]!,
                  title: "Sign in / Create account",
                  subtitleWidget: const Row(
                    children: [
                      Icon(Icons.stars, size: 14, color: AppColors.premiumGoldDark),
                      SizedBox(width: 4),
                      Text(
                        "Premium only",
                        style: TextStyle(
                          color: AppColors.premiumGoldDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  textColor: textColor,
                  isLast: true,
                  onTap: navigateToPremium,
                  borderColor: borderColor,
                ),
              ),

              const SizedBox(height: 32),

              // Data
              SectionHeader(title: "Data", color: subTextColor),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      color: isDark ? Colors.blueGrey.shade800.withOpacity(0.5) : Colors.grey[50],
                      child: ProfileListItem(
                        icon: Icons.save,
                        iconColor: Colors.grey[500]!,
                        iconBgColor: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                        title: "Local data stored",
                        subtitle: "Everything stays on this device",
                        textColor: textColor,
                        subTextColor: subTextColor,
                        borderColor: borderColor,
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: ProfileListItem(
                        icon: Icons.cloud_upload,
                        iconColor: Colors.blueGrey[400]!,
                        iconBgColor: Colors.blueGrey[100]!,
                        title: "Online backup",
                        subtitle: "Premium only",
                        textColor: subTextColor,
                        subTextColor: subTextColor,
                        borderColor: borderColor,
                        trailingIcon: Icons.lock,
                        trailingIconColor: AppColors.premiumGold,
                        onTap: navigateToPremium,
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: ProfileListItem(
                        icon: Icons.sync,
                        iconColor: Colors.blueGrey[400]!,
                        iconBgColor: Colors.blueGrey[100]!,
                        title: "Automatic backup",
                        subtitle: "Premium only",
                        textColor: subTextColor,
                        subTextColor: subTextColor,
                        borderColor: borderColor,
                        trailingIcon: Icons.lock,
                        trailingIconColor: AppColors.premiumGold,
                        onTap: navigateToPremium,
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: ProfileListItem(
                        icon: Icons.upload_file,
                        iconColor: Colors.blueGrey[400]!,
                        iconBgColor: Colors.blueGrey[100]!,
                        title: "Export data",
                        subtitle: "Premium only",
                        textColor: subTextColor,
                        subTextColor: subTextColor,
                        isLast: true,
                        trailingIcon: Icons.lock,
                        trailingIconColor: AppColors.premiumGold,
                        onTap: navigateToPremium,
                        borderColor: borderColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Ads
              SectionHeader(title: "Ads", color: subTextColor),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: ProfileListItem(
                  icon: Icons.ad_units,
                  iconColor: AppColors.premiumGoldDark,
                  iconBgColor: AppColors.premiumGold.withOpacity(0.1),
                  title: "Remove ads",
                  subtitle: "Upgrade to Premium",
                  textColor: textColor,
                  subTextColor: AppColors.premiumGoldDark,
                  isLast: true,
                  trailingIconColor: AppColors.premiumGoldDark,
                  onTap: navigateToPremium,
                  borderColor: borderColor,
                ),
              ),

              const SizedBox(height: 32),

              // About
              SectionHeader(title: "About", color: subTextColor),
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
                            "App version",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "0.0.1 Beta",
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
                            "Privacy policy",
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
                  children: const [
                    Icon(Icons.delete_forever, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "CLEAR LOCAL DATA",
                      style: TextStyle(
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
                  "THIS ACTION CANNOT BE UNDONE",
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
