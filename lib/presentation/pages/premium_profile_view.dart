import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';

class PremiumProfileView extends StatelessWidget {
  final bool isDark;

  const PremiumProfileView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
                  child: const Text(
                    "PREMIUM",
                    style: TextStyle(
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
              _buildSectionHeader("Usage Status", subTextColor),
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
                              "Ledgers",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "Unlimited",
                          style: TextStyle(
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
                              "Accounts",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Unlimited",
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
              _buildSectionHeader("Account", subTextColor),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: _buildListItem(
                  icon: Icons.check_circle,
                  iconColor: AppColors.premiumPrimaryDark,
                  iconBgColor: AppColors.premiumPrimary.withOpacity(0.1),
                  title: "Logged in",
                  subtitle: "Manage your cloud account",
                  textColor: AppColors.premiumPrimaryDark,
                  subTextColor: subTextColor,
                  borderColor: borderColor,
                  onTap: () {}, // Action for managing account
                ),
              ),

              const SizedBox(height: 32),

              // Data Management
              _buildSectionHeader("Data Management", subTextColor),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: cardShadow,
                ),
                child: Column(
                  children: [
                    _buildListItem(
                      icon: Icons.cloud_upload,
                      iconColor: Colors.purple[600]!,
                      iconBgColor: Colors.purple[100]!,
                      title: "Online backup",
                      subtitle: "Safe in the cloud",
                      textColor: textColor,
                      subTextColor: subTextColor,
                      borderColor: borderColor,
                      onTap: () {},
                    ),
                    _buildListItem(
                      icon: Icons.sync,
                      iconColor: Colors.orange[600]!,
                      iconBgColor: Colors.orange[100]!,
                      title: "Automatic backup",
                      subtitle: "Syncing every change",
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
                    _buildListItem(
                      icon: Icons.upload_file,
                      iconColor: Colors.cyan[600]!,
                      iconBgColor: Colors.cyan[100]!,
                      title: "Export data",
                      subtitle: "CSV, JSON, PDF",
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
              _buildSectionHeader("About", subTextColor),
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

  Widget _buildSectionHeader(String title, Color? color) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 14,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    Widget? subtitleWidget,
    required Color textColor,
    Color? subTextColor,
    IconData? trailingIcon,
    Color? trailingIconColor,
    bool isLast = false,
    Color borderColor = Colors.grey,
    VoidCallback? onTap,
    Widget? customTrailing,
  }) {
    Widget content = Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: iconColor.withOpacity(0.2), width: 2),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              if (subtitleWidget != null)
                subtitleWidget
              else if (subtitle != null)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        if (customTrailing != null)
          customTrailing
        else if (onTap != null)
          Icon(trailingIcon ?? Icons.chevron_right, color: trailingIconColor ?? Colors.grey[300])
        else if (trailingIcon != null)
          Icon(trailingIcon, color: trailingIconColor ?? Colors.grey[300]),
      ],
    );

    if (onTap == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: borderColor, width: 2)),
        ),
        child: content,
      );
    }

    return PressableContainer(
      onPressed: onTap,
      pressOffset: 2.0,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: isLast ? null : Border(bottom: BorderSide(color: borderColor, width: 2)),
      ),
      child: content,
    );
  }
}
