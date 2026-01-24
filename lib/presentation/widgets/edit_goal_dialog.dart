import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/goal.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class EditGoalDialog extends StatefulWidget {
  final Goal goal;
  
  const EditGoalDialog({
    super.key,
    required this.goal,
  });

  @override
  State<EditGoalDialog> createState() => _EditGoalDialogState();
}

class _EditGoalDialogState extends State<EditGoalDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController targetAmountController;
  late TextEditingController currentAmountController;
  late String selectedIcon;
  late String selectedColor;

  // Available icons
  final List<String> icons = [
    '🎯',
    '🏖️',
    '🛡️',
    '💻',
    '🚗',
    '🏠',
    '🎮',
    '📚',
    '💍',
    '✈️',
  ];

  // Available colors
  final List<String> colors = [
    'purple',
    'blue',
    'orange',
    'green',
    'red',
    'yellow',
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.goal.title);
    descriptionController = TextEditingController(text: widget.goal.description);
    targetAmountController = TextEditingController(text: widget.goal.targetAmount.toString());
    currentAmountController = TextEditingController(text: widget.goal.currentAmount.toString());
    selectedIcon = widget.goal.icon;
    selectedColor = widget.goal.color;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    targetAmountController.dispose();
    currentAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencySymbol = context.watch<CurrencyNotifier>().currencySymbol;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 360),
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hedefi Düzenle',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text(context),
                      ),
                    ),
                    PressableContainer(
                      onPressed: () => _showDeleteDialog(),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.2), width: 2),
                      ),
                      child: Icon(
                        Symbols.delete_rounded,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Title Field
                Text(
                  'Hedef Adı',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.progressBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tatil, araba, ev vb.',
                      hintStyle: TextStyle(
                        color: AppColors.subtitleText(context),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Amount Fields
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mevcut Tutar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.progressBackground(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.cardBorder(context),
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: currentAmountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: TextStyle(
                                  color: AppColors.subtitleText(context),
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                prefixText: '$currencySymbol ',
                                prefixStyle: TextStyle(
                                  color: AppColors.text(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hedef Tutar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.progressBackground(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.cardBorder(context),
                                width: 2,
                              ),
                            ),
                            child: TextField(
                              controller: targetAmountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: TextStyle(
                                  color: AppColors.subtitleText(context),
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(16),
                                prefixText: '$currencySymbol ',
                                prefixStyle: TextStyle(
                                  color: AppColors.text(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Description Field
                Text(
                  'Açıklama (İsteğe Bağlı)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.progressBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cardBorder(context),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Hedefiniz hakkında kısa bir açıklama',
                      hintStyle: TextStyle(
                        color: AppColors.subtitleText(context),
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Icon Selection
                Text(
                  'İkon Seç',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: icons.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final icon = icons[index];
                      final isSelected = selectedIcon == icon;
                      return PressableContainer(
                        onPressed: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                        },
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppColors.primary.withOpacity(0.2)
                              : AppColors.progressBackground(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.cardBorder(context),
                            width: 2,
                          ),
                        ),
                        child: Text(icon, style: const TextStyle(fontSize: 20)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Color Selection
                Text(
                  'Renk Seç',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final colorName = colors[index];
                      final isSelected = selectedColor == colorName;
                      Color color;
                      switch (colorName) {
                        case 'purple':
                          color = AppColors.primary;
                          break;
                        case 'blue':
                          color = AppColors.secondaryBlue;
                          break;
                        case 'orange':
                          color = AppColors.secondaryYellow;
                          break;
                        case 'green':
                          color = Colors.green;
                          break;
                        case 'red':
                          color = Colors.red;
                          break;
                        case 'yellow':
                          color = AppColors.secondaryYellow;
                          break;
                        default:
                          color = AppColors.primary;
                      }
                      
                      return PressableContainer(
                        onPressed: () {
                          setState(() {
                            selectedColor = colorName;
                          });
                        },
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? color : color.withOpacity(0.3),
                            width: isSelected ? 3 : 2,
                          ),
                        ),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: PressableContainer(
                        onPressed: () => Navigator.of(context).pop(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.progressBackground(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.cardBorder(context),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'İptal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.subtitleText(context),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PressableContainer(
                        onPressed: _updateGoal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryDark,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Güncelle',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
  }

  void _updateGoal() {
    if (titleController.text.trim().isEmpty || 
        targetAmountController.text.trim().isEmpty ||
        currentAmountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm gerekli alanları doldurun')),
      );
      return;
    }

    final targetAmount = double.tryParse(targetAmountController.text.trim());
    final currentAmount = double.tryParse(currentAmountController.text.trim());
    
    if (targetAmount == null || targetAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir hedef tutar girin')),
      );
      return;
    }

    if (currentAmount == null || currentAmount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir mevcut tutar girin')),
      );
      return;
    }

    final updatedGoal = widget.goal.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      icon: selectedIcon,
      color: selectedColor,
      updatedAt: DateTime.now(),
      status: currentAmount >= targetAmount ? GoalStatus.completed : widget.goal.status,
    );

    Navigator.of(context).pop(updatedGoal);
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card(context),
        title: Text(
          'Hedefi Sil',
          style: TextStyle(
            color: AppColors.text(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          '${widget.goal.title} hedefini silmek istediğinizden emin misiniz?',
          style: TextStyle(
            color: AppColors.subtitleText(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'İptal',
              style: TextStyle(
                color: AppColors.subtitleText(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close delete dialog
              Navigator.of(context).pop('delete'); // Close edit dialog with delete result
            },
            child: const Text(
              'Sil',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}