import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/ledger.dart';

class CreateLedgerDialog extends StatefulWidget {
  const CreateLedgerDialog({super.key});

  @override
  State<CreateLedgerDialog> createState() => _CreateLedgerDialogState();
}

class _CreateLedgerDialogState extends State<CreateLedgerDialog> {
  late TextEditingController nameController;
  String selectedIcon = '💰';

  final icons = ['💰', '🏦', '🏪', '💳', '📊', '🪙', '📈', '🎯'];

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
    return AlertDialog(
      title: const Text('New Ledger'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Ledger name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select icon'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: icons.map((icon) {
                final isSelected = icon == selectedIcon;
                return GestureDetector(
                  onTap: () => setState(() => selectedIcon = icon),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).cardColor,
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a name')),
              );
              return;
            }

            final newLedger = Ledger(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              accountID: '',
              name: nameController.text,
              balance: 0,
              icon: selectedIcon,
            );

            Navigator.pop(context, newLedger);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
