import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/domain/utility/math_helper.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';
import 'package:harcama_app/presentation/widgets/Keypad.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:material_symbols_icons/symbols.dart';

class ExpenseDetailPage extends StatefulWidget {
  final Transaction transaction;

  const ExpenseDetailPage({super.key, required this.transaction});

  @override
  State<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
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

  @override
  void initState() {
    super.initState();
    // Initialize with existing transaction data
    amount.value = widget.transaction.amount.toStringAsFixed(2).replaceAll(RegExp(r"\.00$"), "");
    if (amount.value.isEmpty) amount.value = "0";
    
    note = widget.transaction.title;
    descriptionController.text = note;
    
    selectedDate = widget.transaction.date;
    selectedCategory = widget.transaction.category;
    selectedType = widget.transaction.type;
  }

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

    if (value == ",") {
      final parts = RegExp(r"[^+\-\*/]+").allMatches(a);
      final last = parts.isNotEmpty ? parts.last.group(0)! : a;
      if (last.contains('.')) return;
      value = ".";
    }

    // --- Kuruş Kontrolü (Max 2 basamak) ---
    if (!"+-*/".contains(value) && value != ",") {
      final parts = RegExp(r"[^+\-\*/]+").allMatches(a);
      final last = parts.isNotEmpty ? parts.last.group(0)! : a;
      
      if (last.contains('.')) {
        final decimalPart = last.split('.')[1];
        if (decimalPart.length >= 2) {
          return; // Zaten 2 basamak var, daha fazla ekleme
        }
      }
    }
    // --------------------------------------

    if (a == "0" && value != ".") {
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Header (Kapatma ve Silme ikonu)
                        _buildHeader(context),

                        const SizedBox(height: 10),

                        // 2. Başlık
                        const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Edit Transaction",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // 3. Açıklama ve Tarih
                        SizedBox(
                          height: 50,
                          child: _buildDescriptionDateRow(context),
                        ),

                        const SizedBox(height: 20),

                        // 4. Tutar Göstergesi
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _buildAmountDisplay(context),
                        ),

                        const SizedBox(height: 20),

                        // 5. Gelir/Gider Seçimi
                        SizedBox(
                          height: 45,
                          child: _buildTypeSelector(context),
                        ),

                        const SizedBox(height: 20),

                        // 6. Kategoriler
                        SizedBox(
                          height: 90,
                          child: _buildCategorySection(context),
                        ),

                        // 7. Keypad
                        SizedBox(
                          height: constraints.maxHeight * 0.40,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              height: 300,
                              child: KeyPad(onTap: onKeyTap),
                            ),
                          ),
                        ),

                        // 8. Kaydet Butonu
                        _buildSaveButton(context),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          GestureDetector(
            onTap: _confirmDelete,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                Symbols.delete_rounded,
                color: AppColors.expenseColor(context),
                size: 28,
                weight: 600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionDateRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder(context), width: 2),
            ),
            child: Center(
              child: TextField(
                controller: descriptionController,
                onChanged: (v) => note = v,
                style: TextStyle(
                  color: AppColors.text(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: AppColors.subtitleText(context), fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      const SizedBox(width: 12),
        PressableContainer(
          onPressed: _selectDate,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Symbols.calendar_today_rounded,
                color: AppColors.primary,
                size: 18,
                weight: 600,
              ),
              const SizedBox(width: 8),
              Text(
                _getDateLabel(),
                style: TextStyle(
                  fontSize: 13,
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
    return ValueListenableBuilder<String>(
      valueListenable: amount,
      builder: (_, value, __) {
        String displayValue = CurrencyHelper.formatInput(value);
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "₺",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.subtitleText(context),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                displayValue,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: _getTypeColor(),
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        );
      },
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

    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, isSelected ? 4 : 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.progressBackground(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? darkColor : AppColors.gray300,
            width: 2,
          ),
          boxShadow: isSelected
              ? []
              : [
            BoxShadow(
              color: AppColors.gray300,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : AppColors.subtitleText(context),
                letterSpacing: 0.5,
              ),
            ),
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
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "SELECT CATEGORY",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.subtitleText(context),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight * 0.65;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size,
                height: size,
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(cat.icon, style: TextStyle(fontSize: size * 0.45)),
                  ),
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.05),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  cat.title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isActive ? AppColors.text(context) : AppColors.subtitleText(context),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMoreCategoryButton(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxHeight * 0.65;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size,
              height: size,
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
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                Symbols.grid_view_rounded,
                color: AppColors.subtitleText(context),
                size: size * 0.45,
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.05),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "MORE",
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: AppColors.subtitleText(context),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.05,
        screenHeight * 0.005,
        screenWidth * 0.05,
        screenHeight * 0.015,
      ),
      child: PressableContainer(
        onPressed: _saveChanges,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryDark,
            offset: Offset(0, 4),
          ),
        ],
        child: const Center(
          child: Text(
            "SAVE",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- ACTIONS ----------------

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      final notifier = context.read<TransactionNotifier>();
      await notifier.deleteItem(widget.transaction.id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> _saveChanges() async {
    final notifier = context.read<TransactionNotifier>();
    final parsedAmount = _evaluateAmount();

    final updated = Transaction(
      id: widget.transaction.id,
      ledgerID: widget.transaction.ledgerID,
      accountID: widget.transaction.accountID,
      title: note.isEmpty ? 'Transaction' : note,
      amount: parsedAmount,
      date: selectedDate,
      entryDate: widget.transaction.entryDate,
      category: selectedCategory,
      type: selectedType,
      isRecurring: widget.transaction.isRecurring,
    );

    await notifier.updateItem(updated);
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
