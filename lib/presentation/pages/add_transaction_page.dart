import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/domain/utility/math_helper.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String amount = "0";
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
  ];

  void onKeyTap(String value) {
    setState(() {
      if (value == "⌫") {
        if (amount.isNotEmpty) {
          amount = amount.substring(0, amount.length - 1);
        }
        if (amount.isEmpty) amount = "0";
        return;
      }

      if (value == "=") {
        try {
          final expr = _sanitizeExpression(amount);
          final res = calculate(expr);
          var out = res.toString();
          out = out.replaceAll(RegExp(r"\.0+$"), "");
          amount = out;
        } catch (_) {
          // ignore parse errors
        }
        return;
      }

      if ("+-/".contains(value)) {
        if (amount.isEmpty) {
          amount = "0$value";
        } else {
          // replace trailing operator if present
          if (RegExp(r'[+\-\/]$').hasMatch(amount)) {
            amount = amount.substring(0, amount.length - 1) + value;
          } else {
            amount += value;
          }
        }
        return;
      }

      // handle dot
      if (value == ".") {
        final matches = RegExp(r"[^+\-\/]+").allMatches(amount);
        final last = matches.isNotEmpty ? matches.last.group(0) ?? '' : amount;
        if (last.contains('.')) return;
      }

      // digits
      if (amount == "0") {
        amount = value;
      } else {
        amount += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final notifier = context.watch<TransactionNotifier>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Builder(builder: (ctx) { try { return Column(
            children: [
              const SizedBox(height: 36),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _iconButton(context, Icons.close, () {
                      Navigator.pop(context);
                    }),
                    const Text(
                      "New Expense",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _iconButton(context, Icons.check, _saveNewTransaction),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _typeButton(TransactionType.expense, 'Expense', Icons.arrow_downward),
                    const SizedBox(width: 12),
                    _typeButton(TransactionType.income, 'Income', Icons.arrow_upward),
                    const SizedBox(width: 12),
                    _typeButton(TransactionType.transfer, 'Transfer', Icons.swap_horiz),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Column(
                children: [
                  const Text(
                    "ENTER AMOUNT",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₺",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.58),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            amount,
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 96,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isActive = selectedCategory == cat;

                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = cat),
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : theme.cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : Colors.grey.withOpacity(0.2),
                                width: 2,
                              ),
                              boxShadow: [
                                if (isActive)
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3),
                                    blurRadius: 12,
                                  ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                cat.icon,
                                style: TextStyle(
                                  fontSize: 26,
                                  color:
                                      isActive ? Colors.white : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isActive
                                  ? theme.colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemCount: categories.length,
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _inputRow(
                        context,
                        icon: Icons.edit_note,
                        hint: "What is this for?",
                        onChanged: (v) => note = v,
                      ),
                      _divider(),
                      _selectRow(
                        context,
                        icon: Icons.calendar_today,
                        title: "Date",
                        value:
                            DateFormat("EEE, MMM d").format(selectedDate),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                      _divider(),
                      _selectRow(
                        context,
                        icon: Icons.account_balance_wallet,
                        title: "Payment",
                        value: "VISA 4242",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  itemCount: 16,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final keys = [
                      "1","2","3","⌫",
                      "4","5","6","-",
                      "7","8","9","/",
                      ".","0","+","="
                    ];
                    final key = keys[index];

                    return GestureDetector(
                      onTap: () => onKeyTap(key),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: key == "⌫"
                            ? const Icon(Icons.backspace_outlined)
                            : Text(
                                key,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ); } catch (e, st) { print('AddTransactionPage build error: $e\n$st'); return Container( padding: const EdgeInsets.all(24), child: Center(child: Text('Error building page: $e'))); } },),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _typeButton(TransactionType type, String label, IconData icon) {
    final isSelected = selectedType == type;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.grey.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(
      BuildContext context, IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.withOpacity(0.15));
  }

  Widget _inputRow(
    BuildContext context, {
    required IconData icon,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Text(title),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNewTransaction() async {
    final notifier = context.read<TransactionNotifier>();
    if (notifier.isLoading) return;

    final tx = Transaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      ledgerID: "",
      accountID: "",
      title: note.isEmpty ? "Expense" : note,
      amount: _evaluateAmount(),
      date: selectedDate,
      entryDate: DateTime.now(),
      category: selectedCategory,
      type: selectedType,
    );

    await notifier.addItem(tx);
    if (context.mounted) Navigator.pop(context);
  }

  String _sanitizeExpression(String expr) {
    var e = expr;
    while (e.isNotEmpty && RegExp(r'[+\-\/]$').hasMatch(e)) {
      e = e.substring(0, e.length - 1);
    }
    return e.isEmpty ? '0' : e;
  }

  double _evaluateAmount() {
    try {
      if (amount.contains(RegExp(r'[+\-\/]'))) {
        final expr = _sanitizeExpression(amount);
        return calculate(expr);
      }
      return double.tryParse(amount) ?? 0;
    } catch (_) {
      return double.tryParse(RegExp(r'[\d\.]+').stringMatch(amount) ?? '0') ?? 0;
    }
  }

}
