import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class CreateLedgerDialog extends StatefulWidget {
  const CreateLedgerDialog({super.key});

  @override
  State<CreateLedgerDialog> createState() => _CreateLedgerDialogState();
}

class _CreateLedgerDialogState extends State<CreateLedgerDialog> {
  late TextEditingController nameController;
  String selectedIcon = 'flight'; // Default icon name

  // Material Symbols icon names mapped to display
  final List<String> icons = [
    'flight',
    'pets',
    'home',
    'shopping_cart',
    'school',
    'fitness_center',
    'work',
    'restaurant',
    'savings',
    'celebration',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 340),
        // padding: const EdgeInsets.all(24), // <--- Padding'i buradan kaldırdık
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(32),
          border: Border(
            top: BorderSide(color: AppColors.cardBorder(context), width: 2),
            left: BorderSide(color: AppColors.cardBorder(context), width: 2),
            right: BorderSide(color: AppColors.cardBorder(context), width: 2),
            bottom: BorderSide(color: AppColors.cardBorder(context), width: 6),
          ),
        ),
        // ÇÖZÜM BURADA: Column'ı SingleChildScrollView içine alıyoruz
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // Yaylanma efekti
          child: Padding(
            padding: const EdgeInsets.all(24), // Padding'i buraya taşıdık (Scroll içeriğiyle birlikte kaysın diye)
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Center(
                  child: Text(
                    l10n.newLedger,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Name Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    l10n.ledgerName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.subtitleText(context),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.progressBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder(context), width: 2),
                  ),
                  child: TextField(
                    controller: nameController,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.ledgerNameHint,
                      hintStyle: TextStyle(
                        color: AppColors.subtitleText(context).withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Icon Selection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    l10n.chooseIcon,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.subtitleText(context),
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: icons.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final iconName = icons[index];
                      final isSelected = iconName == selectedIcon;

                      return GestureDetector(
                        onTap: () => setState(() => selectedIcon = iconName),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.progressBackground(context),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.cardBorder(context),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            _getIconData(iconName),
                            color: isSelected ? AppColors.primary : AppColors.subtitleText(context),
                            size: 24,
                            weight: 700,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                GestureDetector(
                  onTap: _createLedger,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark,
                          offset: const Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        l10n.create,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        l10n.cancel.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.subtitleText(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createLedger() {
    if (nameController.text.isEmpty) {
      // Basit bir shake animasyonu veya hata mesajı eklenebilir
      return;
    }

    final newLedger = Ledger(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      accountID: '',
      name: nameController.text,
      balance: 0,
      icon: selectedIcon, // İkon ismini string olarak kaydediyoruz
    );

    Navigator.pop(context, newLedger);
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'flight': return Symbols.flight_rounded;
      case 'pets': return Symbols.pets_rounded;
      case 'home': return Symbols.home_rounded;
      case 'shopping_cart': return Symbols.shopping_cart_rounded;
      case 'school': return Symbols.school_rounded;
      case 'fitness_center': return Symbols.fitness_center_rounded;
      case 'work': return Symbols.work_rounded;
      case 'restaurant': return Symbols.restaurant_rounded;
      case 'savings': return Symbols.savings_rounded;
      case 'celebration': return Symbols.celebration_rounded;
      default: return Symbols.circle;
    }
  }
}
