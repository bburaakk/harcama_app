import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/create_ledger_dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

class LedgerDropdown extends StatelessWidget {
  final bool isVisible;
  final LedgerNotifier ledgerNotifier;
  final VoidCallback onToggle;

  const LedgerDropdown({
    super.key,
    required this.isVisible,
    required this.ledgerNotifier,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      top: 60,
      left: 16,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder(context), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // All Ledgers (Default)
            _buildLedgerItem(
              context,
              icon: Symbols.menu_book_rounded,
              name: ledgerNotifier.allLedger.name,
              isSelected: ledgerNotifier.selectedLedger?.id == 'default',
              onTap: () {
                ledgerNotifier.selectLedger(ledgerNotifier.allLedger);
                onToggle();
              },
              color: AppColors.primary,
            ),

            // User Ledgers
            if (ledgerNotifier.ledgers.isNotEmpty) ...[
              const SizedBox(height: 4),
              ...ledgerNotifier.ledgers.map((ledger) {
                final isSelected =
                    ledger.id == ledgerNotifier.selectedLedger?.id;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: _buildLedgerItem(
                    context,
                    icon: _getIconData(ledger.icon),
                    name: ledger.name,
                    isSelected: isSelected,
                    onTap: () {
                      ledgerNotifier.selectLedger(ledger);
                      onToggle();
                    },
                    onDelete: () =>
                        _showDeleteDialog(context, ledger, ledgerNotifier),
                    color: _getLedgerColor(ledger.id),
                  ),
                );
              }),
            ],

            const SizedBox(height: 4),
            Divider(height: 1, color: AppColors.cardBorder(context)),
            const SizedBox(height: 4),

            // New Ledger Button
            InkWell(
              onTap: () async {
                final newLedger = await showDialog(
                  context: context,
                  builder: (ctx) => const CreateLedgerDialog(),
                );
                if (newLedger != null) {
                  await ledgerNotifier.addItem(newLedger);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardBorder(context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Symbols.add_rounded,
                        color: AppColors.subtitleText(context),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "New Ledger",
                      style: TextStyle(
                        color: AppColors.subtitleText(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

  Widget _buildLedgerItem(
    BuildContext context, {
    required IconData icon,
    required String name,
    required bool isSelected,
    required VoidCallback onTap,
    VoidCallback? onDelete,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: color.withOpacity(0.2), width: 2)
              : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.text(context)
                      : AppColors.subtitleText(context),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Icon(
                    Symbols.check_circle_rounded,
                    color: color,
                    fill: 1,
                    size: 24,
                  ),
                if (onDelete != null) ...[
                  if (isSelected) const SizedBox(width: 8),
                  InkWell(
                    onTap: onDelete,
                    child: Icon(
                      Symbols.delete_rounded,
                      color: AppColors.expenseColor(context),
                      size: 20,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconString) {
    switch (iconString) {
      case 'flight':
        return Symbols.flight_rounded;
      case 'pets':
        return Symbols.pets_rounded;
      case 'home':
        return Symbols.home_rounded;
      case 'shopping_cart':
        return Symbols.shopping_cart_rounded;
      case 'school':
        return Symbols.school_rounded;
      case 'fitness_center':
        return Symbols.fitness_center_rounded;
      case 'work':
        return Symbols.work_rounded;
      case 'restaurant':
        return Symbols.restaurant_rounded;
      case 'savings':
        return Symbols.savings_rounded;
      case 'celebration':
        return Symbols.celebration_rounded;
      case 'person':
        return Symbols.person_rounded;
      case 'group':
        return Symbols.group_rounded;
      default:
        return Symbols.menu_book_rounded;
    }
  }

  Color _getLedgerColor(String id) {
    // ID'ye göre veya sıraya göre renk döndürülebilir
    // Şimdilik basit bir mantık
    if (id.hashCode % 3 == 0) return AppColors.secondaryBlue;
    if (id.hashCode % 3 == 1) return AppColors.secondaryYellow;
    return AppColors.primary;
  }

  void _showDeleteDialog(
    BuildContext context,
    var ledger,
    LedgerNotifier ledgerNotifier,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Ledger?'),
        content: Text('Are you sure you want to delete "${ledger.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Check if the ledger being deleted is currently selected
              final isCurrentlySelected =
                  ledger.id == ledgerNotifier.selectedLedger?.id;

              await ledgerNotifier.deleteItem(ledger.id);

              // If the deleted ledger was selected, switch to All Ledger
              if (isCurrentlySelected) {
                ledgerNotifier.selectLedger(ledgerNotifier.allLedger);
              }

              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
