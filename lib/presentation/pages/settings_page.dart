import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/l10n/app_localizations.dart';
import 'package:harcama_app/presentation/notifiers/theme_notifier.dart';
import 'package:harcama_app/presentation/notifiers/language_notifier.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/goal_notifier.dart';
import 'package:harcama_app/presentation/notifiers/subscription_notifier.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:material_symbols_icons/symbols.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageNotifier = context.watch<LanguageNotifier>();
    final currencyNotifier = context.watch<CurrencyNotifier>();

    // Colors
    final backgroundColor = isDark ? AppColors.scaffoldBackgroundDark : AppColors.scaffoldBackground;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDark ? AppColors.grayDark400 : AppColors.gray400;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.settings,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // General Section
            _buildSectionHeader(l10n.general, subTextColor),
            
            _buildSettingsItem(
              context,
              icon: Symbols.currency_exchange,
              iconColor: Colors.blue,
              iconBgColor: Colors.blue.withOpacity(0.1),
              title: l10n.defaultCurrency,
              trailing: Row(
                children: [
                  Text(
                    currencyNotifier.currencyCode,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Symbols.chevron_right, color: subTextColor),
                ],
              ),
              onTap: () {
                _showCurrencyDialog(context);
              },
            ),
            
            _buildSettingsItem(
              context,
              icon: Symbols.translate,
              iconColor: Colors.orange,
              iconBgColor: Colors.orange.withOpacity(0.1),
              title: l10n.language,
              trailing: Row(
                children: [
                  Text(
                    languageNotifier.currentLocale.languageCode == 'tr' ? 'Türkçe' : 'English',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: subTextColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Symbols.chevron_right, color: subTextColor),
                ],
              ),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),

            _buildSettingsItem(
              context,
              icon: Symbols.dark_mode,
              iconColor: Colors.purple,
              iconBgColor: Colors.purple.withOpacity(0.1),
              title: l10n.darkMode,
              trailing: Switch(
                value: isDark,
                onChanged: (value) {
                  context.read<ThemeNotifier>().toggleTheme();
                },
                activeColor: AppColors.primary,
              ),
              onTap: () {
                context.read<ThemeNotifier>().toggleTheme();
              },
            ),

            const SizedBox(height: 24),

            // Data Section
            _buildSectionHeader(l10n.data, subTextColor),
            
            _buildSettingsItem(
              context,
              icon: Symbols.table_view,
              iconColor: Colors.teal,
              iconBgColor: Colors.teal.withOpacity(0.1),
              title: l10n.exportData,
              trailing: Icon(Symbols.chevron_right, color: subTextColor),
              onTap: () {},
            ),
            
            _buildSettingsItem(
              context,
              icon: Symbols.delete,
              iconColor: Colors.red,
              iconBgColor: Colors.red.withOpacity(0.1),
              title: l10n.clearLocalData,
              titleColor: Colors.red,
              onTap: () {
                _showClearDataDialog(context);
              },
            ),

            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader(l10n.about, subTextColor),

            _buildSettingsItem(
              context,
              icon: Symbols.policy,
              iconColor: Colors.blueGrey,
              iconBgColor: Colors.blueGrey.withOpacity(0.1),
              title: l10n.privacyPolicy,
              trailing: Icon(Symbols.open_in_new, color: subTextColor),
              onTap: () {
                // TODO: Open Privacy Policy
              },
            ),

            _buildSettingsItem(
              context,
              icon: Symbols.description,
              iconColor: Colors.blueGrey,
              iconBgColor: Colors.blueGrey.withOpacity(0.1),
              title: l10n.termsOfUse,
              trailing: Icon(Symbols.open_in_new, color: subTextColor),
              onTap: () {
                // TODO: Open Terms of Use
              },
            ),

            _buildSettingsItem(
              context,
              icon: Symbols.info,
              iconColor: Colors.blueGrey,
              iconBgColor: Colors.blueGrey.withOpacity(0.1),
              title: l10n.aboutUs,
              trailing: Icon(Symbols.chevron_right, color: subTextColor),
              onTap: () {
                // TODO: Open About Us
              },
            ),

            const SizedBox(height: 24),

            // Version
            Center(
              child: Text(
                "VERSION 0.0.1",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: subTextColor,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showClearDataDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight;
    final shadowColor = isDark ? AppColors.cardBorderDark : AppColors.cardShadowLight;

    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack).value,
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(0, 8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Symbols.delete_forever,
                        color: AppColors.danger,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      l10n.clearLocalDataTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Content
                    Text(
                      l10n.clearLocalDataContent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.grayDark400 : AppColors.gray400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildDialogButton(
                            context,
                            label: l10n.cancel,
                            onTap: () => Navigator.of(context).pop(false),
                            isPrimary: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDialogButton(
                            context,
                            label: l10n.deleteEverything,
                            onTap: () => Navigator.of(context).pop(true),
                            isPrimary: true,
                            isDanger: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      if (context.mounted) {
        await context.read<TransactionNotifier>().clearAllTransactions();
        if (context.mounted) {
          await context.read<GoalNotifier>().clearAllGoals();
        }
        if (context.mounted) {
          await context.read<SubscriptionNotifier>().clearAllSubscriptions();
        }
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.allLocalDataCleared)),
          );
          
          // Stay on Settings Page
        }
      }
    }
  }

  Widget _buildDialogButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
    bool isDanger = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowColor = isDark ? AppColors.cardBorderDark : AppColors.cardShadowLight;
    
    Color bgColor;
    Color textColor;
    Color borderColor;

    if (isDanger) {
      bgColor = AppColors.danger;
      textColor = Colors.white;
      borderColor = AppColors.dangerDark;
    } else {
      bgColor = isDark ? AppColors.cardDark : AppColors.cardLight;
      textColor = isDark ? AppColors.textLight : AppColors.textDark;
      borderColor = isDark ? AppColors.grayDark100 : AppColors.gray200;
    }

    return PressableContainer(
      onPressed: onTap,
      pressOffset: 4.0,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: isDanger ? AppColors.dangerDark : shadowColor,
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight;
    final shadowColor = isDark ? AppColors.cardBorderDark : AppColors.cardShadowLight;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack).value,
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(0, 8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.language,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Consumer<LanguageNotifier>(
                      builder: (context, notifier, _) {
                        return Column(
                          children: [
                            _buildLanguageOption(
                              context,
                              label: 'English',
                              isSelected: notifier.currentLocale.languageCode == 'en',
                              onTap: () {
                                notifier.setLocale(const Locale('en'));
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildLanguageOption(
                              context,
                              label: 'Türkçe',
                              isSelected: notifier.currentLocale.languageCode == 'tr',
                              onTap: () {
                                notifier.setLocale(const Locale('tr'));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight;
    final shadowColor = isDark ? AppColors.cardBorderDark : AppColors.cardShadowLight;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack).value,
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(0, 8),
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.defaultCurrency,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Consumer<CurrencyNotifier>(
                      builder: (context, notifier, _) {
                        return Column(
                          children: [
                            _buildLanguageOption(
                              context,
                              label: 'TRY (₺)',
                              isSelected: notifier.currencyCode == 'TRY',
                              onTap: () {
                                notifier.setCurrency('TRY');
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildLanguageOption(
                              context,
                              label: 'USD (\$)',
                              isSelected: notifier.currencyCode == 'USD',
                              onTap: () {
                                notifier.setCurrency('USD');
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildLanguageOption(
                              context,
                              label: 'EUR (€)',
                              isSelected: notifier.currencyCode == 'EUR',
                              onTap: () {
                                notifier.setCurrency('EUR');
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildLanguageOption(
                              context,
                              label: 'GBP (£)',
                              isSelected: notifier.currencyCode == 'GBP',
                              onTap: () {
                                notifier.setCurrency('GBP');
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final selectedColor = AppColors.primary;
    final shadowColor = isDark ? AppColors.cardBorderDark : AppColors.cardShadowLight;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    
    return PressableContainer(
      onPressed: onTap,
      pressOffset: 4.0,
      decoration: BoxDecoration(
        color: isSelected ? selectedColor.withOpacity(0.1) : cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? selectedColor : (isDark ? AppColors.grayDark100 : AppColors.gray200),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isSelected ? selectedColor : textColor,
            ),
          ),
          if (isSelected)
            Icon(
              Symbols.check_circle,
              color: selectedColor,
              fill: 1,
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    Widget? trailing,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textLight : AppColors.textDark;
    final cardColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight;
    // Match ProfileListItem shadow logic
    final shadowColor = isDark ? AppColors.cardBorderDark : AppColors.cardShadowLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: PressableContainer(
        onPressed: onTap,
        pressOffset: 4.0, // Match shadow offset
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  bottom: BorderSide(
                    color: iconColor.withOpacity(0.2),
                    width: 4,
                  ),
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor ?? textColor,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
