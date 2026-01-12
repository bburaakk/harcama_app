import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/domain/utility/math_helper.dart';
import 'package:harcama_app/presentation/widgets/keypad.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final ValueNotifier<String> amount = ValueNotifier("0");
  final TextEditingController descriptionController = TextEditingController();

  String note = "";
  DateTime selectedDate = DateTime.now();
  Category? selectedCategory;
  TransactionType selectedType = TransactionType.expense;

  final categories = const [
    Category(id: "1", title: "Food", icon: "🍕"),
    Category(id: "2", title: "Transport", icon: "🚌"),
    Category(id: "3", title: "Shopping", icon: "🛍️"),
    Category(id: "4", title: "Rent", icon: "🏠"),
    Category(id: "5", title: "Fun", icon: "🎮"),
    Category(id: "6", title: "Health", icon: "💊"),
  ];

  // ---------------- KEYPAD LOGIC ----------------

  void onKeyTap(String value) {
    var a = amount.value;

    if (value == "⌫") {
      if (a.isNotEmpty) a = a.substring(0, a.length - 1);
      if (a.isEmpty) a = "0";
      amount.value = a;
      return;
    }

    if (value == "=") {
      try {
        final expr = _sanitizeExpression(a);
        final res = calculate(expr);
        amount.value = res.toString().replaceAll(RegExp(r"\.0+$"), "");
      } catch (_) {}
      return;
    }

    if ("+-*/".contains(value)) {
      if (RegExp(r'[+\-\*/]$').hasMatch(a)) {
        a = a.substring(0, a.length - 1) + value;
      } else {
        a += value;
      }
      amount.value = a;
      return;
    }

    if (value == ".") {
      final parts = RegExp(r"[^+\-\*/]+").allMatches(a);
      final last = parts.isNotEmpty ? parts.last.group(0)! : a;
      if (last.contains('.')) return;
    }

    if (a == "0") {
      a = value;
    } else {
      a += value;
    }

    amount.value = a;
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    
                    // Title
                    Text(
                      "How much did you spend?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.text(context),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description + Date Row
                    _buildDescriptionDateRow(context),
                    
                    const SizedBox(height: 16),
                    
                    // Amount Display
                    _buildAmountDisplay(context),
                    
                    const SizedBox(height: 16),
                    
                    // Type Selector
                    _buildTypeSelector(context),
                    
                    const SizedBox(height: 16),
                    
                    // Category Section
                    _buildCategorySection(context),
                    
                    const SizedBox(height: 12),
                    
                    // Keypad
                    KeyPad(onTap: onKeyTap),
                  ],
                ),
              ),
            ),
            
            // Save Button
            _buildSaveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                Symbols.close_rounded,
                color: AppColors.text(context),
                size: 28,
                weight: 600,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildDescriptionDateRow(BuildContext context) {
    return Row(
      children: [
        // Description Input
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder(context), width: 2),
            ),
            child: TextField(
              controller: descriptionController,
              onChanged: (v) => note = v,
              style: TextStyle(
                color: AppColors.text(context),
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: "Description (e.g. Lunch)",
                hintStyle: TextStyle(color: AppColors.subtitleText(context)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Date Button
        PressableContainer(
          onPressed: _selectDate,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder(context), width: 2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardBorder(context),
              offset: const Offset(0, 3),
            ),
          ],
          child: Row(
            children: [
              Icon(
                Symbols.calendar_today_rounded,
                color: AppColors.primary,
                size: 20,
                weight: 600,
              ),
              const SizedBox(width: 8),
              Text(
                _getDateLabel(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getDateLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    
    if (selected == today) return "Today";
    if (selected == today.subtract(const Duration(days: 1))) return "Yesterday";
    return DateFormat("MMM d").format(selectedDate);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Widget _buildAmountDisplay(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ValueListenableBuilder<String>(
        valueListenable: amount,
        builder: (_, value, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "₺",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.subtitleText(context),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: _getTypeColor(),
                  letterSpacing: -2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getTypeColor() {
    switch (selectedType) {
      case TransactionType.income:
        return AppColors.primary;
      case TransactionType.expense:
        return const Color(0xFFFF4B4B);
      case TransactionType.transfer:
        return AppColors.secondaryBlue;
    }
  }

  Widget _buildTypeSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTypeButton(
            type: TransactionType.income,
            label: "INCOME",
            color: AppColors.primary,
            darkColor: AppColors.primaryDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTypeButton(
            type: TransactionType.expense,
            label: "EXPENSE",
            color: const Color(0xFFFF4B4B),
            darkColor: const Color(0xFFD33131),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTypeButton(
            type: TransactionType.transfer,
            label: "TRANSFER",
            color: AppColors.secondaryBlue,
            darkColor: AppColors.secondaryBlueDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required TransactionType type,
    required String label,
    required Color color,
    required Color darkColor,
  }) {
    final isSelected = selectedType == type;

    return PressableContainer(
      onPressed: () => setState(() => selectedType = type),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: isSelected
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
      boxShadow: [
        BoxShadow(
          color: darkColor,
          offset: const Offset(0, 4),
        ),
      ],
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            "SELECT CATEGORY",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.subtitleText(context),
              letterSpacing: 1.5,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return _buildMoreCategoryButton(context);
              }
              
              final cat = categories[index];
              final isActive = selectedCategory?.id == cat.id;
              
              return _buildCategoryItem(context, cat, isActive);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category cat, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = cat),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.card(context),
              border: Border.all(
                color: isActive ? AppColors.primary : AppColors.cardBorder(context),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isActive ? AppColors.primaryDark : AppColors.cardBorder(context),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(cat.icon, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cat.title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isActive ? AppColors.text(context) : AppColors.subtitleText(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreCategoryButton(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.progressBackground(context),
            border: Border.all(
              color: AppColors.cardBorder(context),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardBorder(context),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Symbols.grid_view_rounded,
            color: AppColors.subtitleText(context),
            size: 28,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "MORE",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.subtitleText(context),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: PressableContainer(
        onPressed: _saveNewTransaction,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(0, 6),
          ),
        ],
        child: const Center(
          child: Text(
            "SAVE",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- SAVE ----------------

  Future<void> _saveNewTransaction() async {
    final txNotifier = context.read<TransactionNotifier>();
    final ledgerNotifier = context.read<LedgerNotifier>();
    
    final selectedLedgerId = ledgerNotifier.selectedLedger?.id ?? 'default';

    final tx = Transaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      ledgerID: selectedLedgerId,
      accountID: "",
      title: note.isEmpty ? "Transaction" : note,
      amount: _evaluateAmount(),
      date: selectedDate,
      entryDate: DateTime.now(),
      category: selectedCategory,
      type: selectedType,
    );

    await txNotifier.addItem(tx);
    if (context.mounted) Navigator.pop(context);
  }

  String _sanitizeExpression(String expr) {
    var e = expr;
    while (e.isNotEmpty && RegExp(r'[+\-\*/]$').hasMatch(e)) {
      e = e.substring(0, e.length - 1);
    }
    return e.isEmpty ? '0' : e;
  }

  double _evaluateAmount() {
    try {
      if (amount.value.contains(RegExp(r'[+\-\*/]'))) {
        return calculate(_sanitizeExpression(amount.value));
      }
      return double.tryParse(amount.value) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  void dispose() {
    amount.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
