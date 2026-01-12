import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/create_ledger_dialog.dart';

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

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: GestureDetector(
          onTap: () {}, // İçerideki tıklamaları durdur
          child: Container(
            height: 300,
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              child: Column(
                children: [
                  // All Ledger Header
                  ListTile(
                    leading: Text(
                      ledgerNotifier.allLedger.icon,
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(
                      ledgerNotifier.allLedger.name,
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontWeight: ledgerNotifier.selectedLedger?.id == 'default'
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ),
                    ),
                    trailing: ledgerNotifier.selectedLedger?.id == 'default'
                        ? Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      ledgerNotifier.selectLedger(ledgerNotifier.allLedger);
                      onToggle();
                    },
                  ),
                  Divider(height: 1, color: AppColors.cardBorder(context)),
                  // User Ledgers
                  Expanded(
                    child: ledgerNotifier.ledgers.isEmpty
                        ? Center(child: Text("Ledger yok", style: TextStyle(color: AppColors.subtitleText(context))))
                        : ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: ledgerNotifier.ledgers.length,
                            separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.cardBorder(context)),
                            itemBuilder: (context, index) {
                              final ledger = ledgerNotifier.ledgers[index];
                              final isSelected =
                                  ledger.id == ledgerNotifier.selectedLedger?.id;

                              return ListTile(
                                leading: Text(
                                  ledger.icon,
                                  style: const TextStyle(fontSize: 22),
                                ),
                                title: Text(
                                  ledger.name,
                                  style: TextStyle(
                                    color: AppColors.text(context),
                                    fontWeight: isSelected
                                        ? FontWeight.w900
                                        : FontWeight.w600,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check, color: AppColors.primary),
                                          IconButton(
                                            icon: Icon(Icons.delete_outline,
                                                color: AppColors.neonPink, size: 20),
                                            onPressed: () => _showDeleteDialog(
                                                context, ledger, ledgerNotifier),
                                            constraints:
                                                const BoxConstraints(minWidth: 0),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            color: AppColors.neonPink, size: 20),
                                        onPressed: () => _showDeleteDialog(
                                            context, ledger, ledgerNotifier),
                                        constraints:
                                            const BoxConstraints(minWidth: 0),
                                        padding: EdgeInsets.zero,
                                      ),
                                onTap: () {
                                  ledgerNotifier.selectLedger(ledger);
                                  onToggle();
                                },
                              );
                            },
                          ),
                  ),
                  Divider(height: 1, color: AppColors.cardBorder(context)),
                  // New Ledger Button
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          final newLedger = await showDialog(
                            context: context,
                            builder: (ctx) => const CreateLedgerDialog(),
                          );
                          if (newLedger != null) {
                            await ledgerNotifier.addItem(newLedger);
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('New Ledger'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, var ledger, LedgerNotifier ledgerNotifier) {
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
              await ledgerNotifier.deleteItem(ledger.id);
              if (context.mounted) Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
