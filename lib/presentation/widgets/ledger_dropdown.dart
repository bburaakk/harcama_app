import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
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
              color: Theme.of(context).scaffoldBackgroundColor,
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
                        fontWeight: ledgerNotifier.selectedLedger?.id == 'default'
                            ? FontWeight.w900
                            : FontWeight.w600,
                      ),
                    ),
                    trailing: ledgerNotifier.selectedLedger?.id == 'default'
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      ledgerNotifier.selectLedger(ledgerNotifier.allLedger);
                      onToggle();
                    },
                  ),
                  const Divider(height: 1),
                  // User Ledgers
                  Expanded(
                    child: ledgerNotifier.ledgers.isEmpty
                        ? const Center(child: Text("Ledger yok"))
                        : ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: ledgerNotifier.ledgers.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
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
                                    fontWeight: isSelected
                                        ? FontWeight.w900
                                        : FontWeight.w600,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline,
                                                color: Colors.red, size: 20),
                                            onPressed: () => _showDeleteDialog(
                                                context, ledger, ledgerNotifier),
                                            constraints:
                                                const BoxConstraints(minWidth: 0),
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      )
                                    : IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.red, size: 20),
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
                  const Divider(height: 1),
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
