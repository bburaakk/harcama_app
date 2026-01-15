import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harcama_app/domain/entities/goal.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateGoalDialog extends StatefulWidget {
  const CreateGoalDialog({super.key});

  @override
  State<CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends State<CreateGoalDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController targetAmountController;
  late TextEditingController currentAmountController;
  String selectedIcon = '🎯'; // Default icon
  String selectedColor = 'purple'; // Default color
  DateTime? selectedDeadline;

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
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    targetAmountController = TextEditingController();
    currentAmountController = TextEditingController(text: '0');
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
                Center(
                  child: Text(
                    'New Goal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.text(context),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Goal Title
                _buildInputSection(
                  'GOAL TITLE',
                  TextField(
                    controller: titleController,
                    style: _inputTextStyle(context),
                    decoration: _inputDecoration(context, 'e.g. Vacation Trip'),
                  ),
                ),

                const SizedBox(height: 20),

                // Goal Description
                _buildInputSection(
                  'DESCRIPTION (OPTIONAL)',
                  TextField(
                    controller: descriptionController,
                    style: _inputTextStyle(context),
                    decoration: _inputDecoration(
                      context,
                      'What are you saving for?',
                    ),
                    maxLines: 2,
                  ),
                ),

                const SizedBox(height: 20),

                // Target Amount
                _buildInputSection(
                  'TARGET AMOUNT',
                  TextField(
                    controller: targetAmountController,
                    style: _inputTextStyle(context),
                    decoration: _inputDecoration(
                      context,
                      'e.g. 5000',
                    ).copyWith(prefixText: '₺ '),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),

                const SizedBox(height: 20),

                // Current Amount
                _buildInputSection(
                  'CURRENT AMOUNT',
                  TextField(
                    controller: currentAmountController,
                    style: _inputTextStyle(context),
                    decoration: _inputDecoration(
                      context,
                      'How much do you have?',
                    ).copyWith(prefixText: '₺ '),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),

                const SizedBox(height: 20),

                // Deadline
                _buildInputSection(
                  'DEADLINE (OPTIONAL)',
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.progressBackground(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.cardBorder(context),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Symbols.calendar_today_rounded,
                            color: AppColors.subtitleText(context),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            selectedDeadline == null
                                ? 'Select a deadline'
                                : '${selectedDeadline!.day}/${selectedDeadline!.month}/${selectedDeadline!.year}',
                            style: TextStyle(
                              color: selectedDeadline == null
                                  ? AppColors.subtitleText(
                                      context,
                                    ).withOpacity(0.5)
                                  : AppColors.text(context),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Icon Selection
                _buildInputSection(
                  'CHOOSE ICON',
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: icons.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final icon = icons[index];
                        final isSelected = icon == selectedIcon;

                        return GestureDetector(
                          onTap: () => setState(() => selectedIcon = icon),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.progressBackground(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.cardBorder(context),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                icon,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Color Selection
                _buildInputSection(
                  'CHOOSE COLOR',
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final colorName = colors[index];
                        final isSelected = colorName == selectedColor;
                        final color = _getColor(colorName);

                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedColor = colorName),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : AppColors.cardBorder(context),
                                width: isSelected ? 3 : 2,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Action Buttons
                PressableContainer(
                  onPressed: _createGoal,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark,
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
                  child: Container(
                    height: 56,
                    child: const Center(
                      child: Text(
                        'CREATE',
                        style: TextStyle(
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
                        'CANCEL',
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

  Widget _buildInputSection(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.subtitleText(context),
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  TextStyle _inputTextStyle(BuildContext context) {
    return TextStyle(
      color: AppColors.text(context),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.subtitleText(context).withOpacity(0.5),
        fontWeight: FontWeight.bold,
      ),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: AppColors.progressBackground(context),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.cardBorder(context), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'purple':
        return AppColors.primary;
      case 'blue':
        return AppColors.secondaryBlue;
      case 'orange':
        return AppColors.secondaryYellow;
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.amber;
      default:
        return AppColors.primary;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDeadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDeadline) {
      setState(() {
        selectedDeadline = picked;
      });
    }
  }

  void _createGoal() {
    if (titleController.text.isEmpty || targetAmountController.text.isEmpty) {
      // Show error - title and target amount are required
      return;
    }

    final targetAmount = double.tryParse(targetAmountController.text);
    final currentAmount = double.tryParse(currentAmountController.text);

    if (targetAmount == null || targetAmount <= 0) {
      // Show error - invalid target amount
      return;
    }

    if (currentAmount == null || currentAmount < 0) {
      // Show error - invalid current amount
      return;
    }

    final newGoal = Goal(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: titleController.text,
      description: descriptionController.text.isEmpty
          ? ''
          : descriptionController.text,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      startDate: DateTime.now(),
      targetDate: selectedDeadline,
      icon: selectedIcon,
      color: selectedColor,
      status: GoalStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      ledgerID: 'default',
      accountID: 'default',
    );

    Navigator.pop(context, newGoal);
  }
}
