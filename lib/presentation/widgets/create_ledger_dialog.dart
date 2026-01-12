import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';

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
      backgroundColor: AppColors.card(context),
      title: Text('New Ledger', style: TextStyle(color: AppColors.text(context))),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: AppColors.text(context)),
              decoration: InputDecoration(
                hintText: 'Ledger name',
                hintStyle: TextStyle(color: AppColors.subtitleText(context)),
                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.cardBorder(context))),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.cardBorder(context))),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Select icon', style: TextStyle(color: AppColors.text(context))),
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
                          : AppColors.progressBackground(context),
                      border: Border.all(color: AppColors.cardBorder(context), width: 2),
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
          child: Text('Cancel', style: TextStyle(color: AppColors.subtitleText(context))),
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
          child: Text('Create', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }
}
