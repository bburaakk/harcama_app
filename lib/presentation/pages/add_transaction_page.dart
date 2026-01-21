import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/category_notifier.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/domain/utility/math_helper.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';
import 'package:harcama_app/presentation/widgets/Keypad.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

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
      // Eğer son karakter operatör ise yeni sayıya başlıyoruz demektir, kontrol etme.
      if (!RegExp(r'[+\-\*/]$').hasMatch(a)) {
        final parts = RegExp(r"[^+\-\*/]+").allMatches(a);
        final last = parts.isNotEmpty ? parts.last.group(0)! : a;
        
        if (last.contains('.')) {
          final decimalPart = last.split('.')[1];
          if (decimalPart.length >= 2) {
            return; // Zaten 2 basamak var, daha fazla ekleme
          }
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
    final l10n = AppLocalizations.of(context)!;
    
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
                        _buildHeader(context),
                        const SizedBox(height: 10),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            l10n.howMuchDidYouSpend,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 50,
                          child: _buildDescriptionDateRow(context),
                        ),
                        const SizedBox(height: 20),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _buildAmountDisplay(context),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 45,
                          child: _buildTypeSelector(context),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 90,
                          child: _buildCategorySection(context),
                        ),
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
    final l10n = AppLocalizations.of(context)!;
    
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
                  hintText: l10n.description,
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
                _getDateLabel(context),
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

  String _getDateLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    
    if (selected == today) return l10n.today;
    if (selected == today.subtract(const Duration(days: 1))) return l10n.yesterday;
    return DateFormat("MMM d", Localizations.localeOf(context).toString()).format(selectedDate);
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
        // Formatlama işlemi burada yapılıyor
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
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _buildTypeButton(
              type: TransactionType.income,
              label: l10n.income,
              color: AppColors.primary,
              darkColor: AppColors.primaryDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildTypeButton(
              type: TransactionType.expense,
              label: l10n.expense,
              color: const Color(0xFFFF4B4B),
              darkColor: const Color(0xFFD33131),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildTypeButton(
              type: TransactionType.transfer,
              label: l10n.transfer,
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
    final l10n = AppLocalizations.of(context)!;
    final categoryNotifier = context.watch<CategoryNotifier>();
    final categories = categoryNotifier.categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l10n.selectCategory,
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

  String _getCategoryTitle(BuildContext context, Category cat) {
    final l10n = AppLocalizations.of(context)!;
    if (cat.id.startsWith('def_')) {
      switch (cat.title) {
        case 'Supermarket': return l10n.catSupermarket;
        case 'Transport': return l10n.catTransport;
        case 'Food': return l10n.catFood;
        case 'Bills': return l10n.catBills;
        case 'Fun': return l10n.catFun;
        case 'Health': return l10n.catHealth;
        case 'Clothing': return l10n.catClothing;
        case 'Salary': return l10n.catSalary;
        case 'Rent': return l10n.catRent;
        case 'Education': return l10n.catEducation;
        default: return cat.title;
      }
    }
    return cat.title;
  }

  Widget _buildCategoryItem(BuildContext context, Category cat, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => selectedCategory = cat),
      onLongPress: () => _handleCategoryLongPress(cat),
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
                  _getCategoryTitle(context, cat),
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

  void _handleCategoryLongPress(Category cat) {
    final l10n = AppLocalizations.of(context)!;
    if (cat.id.startsWith('def_')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.defaultCategoryError),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    _showEditCategoryDialog(cat);
  }

  Widget _buildMoreCategoryButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: _showAddCategoryDialog,
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
                  Symbols.add_rounded,
                  color: AppColors.subtitleText(context),
                  size: size * 0.45,
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.05),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  l10n.more,
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
      ),
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final nameController = TextEditingController();
    final iconController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 340),
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
                  Center(
                    child: Text(
                      l10n.addCategory,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text(context),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Icon Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.iconEmoji,
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
                      controller: iconController,
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: "🍕",
                        hintStyle: TextStyle(
                          color: AppColors.subtitleText(context).withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      maxLength: 1,
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Name Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.categoryName,
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
                        hintText: "Food",
                        hintStyle: TextStyle(
                          color: AppColors.subtitleText(context).withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  PressableContainer(
                    onPressed: () {
                      if (nameController.text.isNotEmpty && iconController.text.isNotEmpty) {
                        final newCategory = Category(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: nameController.text,
                          icon: iconController.text,
                        );
                        context.read<CategoryNotifier>().addItem(newCategory);
                        Navigator.pop(ctx);
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                        l10n.save,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PressableContainer(
                    onPressed: () => Navigator.pop(ctx),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditCategoryDialog(Category category) async {
    final nameController = TextEditingController(text: category.title);
    final iconController = TextEditingController(text: category.icon);
    final l10n = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 340),
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
                  Center(
                    child: Text(
                      l10n.editCategory,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text(context),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Icon Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.iconEmoji,
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
                      controller: iconController,
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: "🍕",
                        hintStyle: TextStyle(
                          color: AppColors.subtitleText(context).withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      maxLength: 1,
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Name Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      l10n.categoryName,
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
                        hintText: "Food",
                        hintStyle: TextStyle(
                          color: AppColors.subtitleText(context).withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  PressableContainer(
                    onPressed: () {
                      if (nameController.text.isNotEmpty && iconController.text.isNotEmpty) {
                        final updatedCategory = Category(
                          id: category.id,
                          title: nameController.text,
                          icon: iconController.text,
                          monthlyBudget: category.monthlyBudget,
                        );
                        context.read<CategoryNotifier>().updateItem(updatedCategory);
                        if (selectedCategory?.id == category.id) {
                          setState(() => selectedCategory = updatedCategory);
                        }
                        Navigator.pop(ctx);
                      }
                    },
                    padding: const EdgeInsets.symmetric(vertical: 16),
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
                        l10n.save,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Delete Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: PressableContainer(
                      onPressed: () {
                        // Delete Confirmation
                        showDialog(
                          context: context,
                          builder: (deleteCtx) => AlertDialog(
                            backgroundColor: AppColors.card(context),
                            title: Text(l10n.deleteCategory, style: TextStyle(color: AppColors.text(context))),
                            content: Text(
                              l10n.deleteCategoryConfirm,
                              style: TextStyle(color: AppColors.subtitleText(context)),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(deleteCtx),
                                child: Text(l10n.cancel, style: TextStyle(color: AppColors.subtitleText(context))),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<CategoryNotifier>().deleteItem(category.id);
                                  if (selectedCategory?.id == category.id) {
                                    setState(() => selectedCategory = null);
                                  }
                                  Navigator.pop(deleteCtx); // Close confirm
                                  Navigator.pop(ctx); // Close edit
                                },
                                child: Text(l10n.delete, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4B4B),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFD33131),
                            offset: Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          l10n.delete,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  PressableContainer(
                    onPressed: () => Navigator.pop(ctx),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        onPressed: _saveNewTransaction,
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
        child: Center(
          child: Text(
            l10n.save,
            style: const TextStyle(
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

  // ---------------- SAVE ----------------

  Future<void> _saveNewTransaction() async {
    final l10n = AppLocalizations.of(context)!;
    final txNotifier = context.read<TransactionNotifier>();
    final ledgerNotifier = context.read<LedgerNotifier>();
    
    final selectedLedgerId = ledgerNotifier.selectedLedger?.id ?? 'default';

    final tx = Transaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      ledgerID: selectedLedgerId,
      accountID: "",
      title: note.isEmpty ? l10n.transaction : note,
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
