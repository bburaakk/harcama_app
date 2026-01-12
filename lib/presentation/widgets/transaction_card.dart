import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/pages/expense_detail.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransactionCard extends StatefulWidget {
  final Transaction t;
  final bool isDark;
  final DateFormat dateFormat;

  const TransactionCard({
    super.key,
    required this.t,
    required this.isDark,
    required this.dateFormat,
  });

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    IconData typeIcon;
    Color typeColor;

    switch (widget.t.type) {
      case TransactionType.income:
        typeIcon = Symbols.arrow_downward_rounded;
        typeColor = Colors.greenAccent;
        break;
      case TransactionType.expense:
        typeIcon = Symbols.arrow_upward_rounded;
        typeColor = Colors.redAccent;
        break;
      case TransactionType.transfer:
        typeIcon = Symbols.swap_horiz_rounded;
        typeColor = Colors.blueAccent;
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 90));

        if (!mounted) return;

        setState(() => _pressed = false);

        await Future.delayed(const Duration(milliseconds: 40));

        if (!mounted) return;

        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => ExpenseDetailPage(transaction: widget.t),
          ),
        );
      },

      onTapCancel: () => setState(() => _pressed = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _pressed ? 6 : 0, 0),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: widget.isDark
              ? Colors.white.withOpacity(0.06)
              : const Color.fromARGB(255, 59, 193, 168),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: const Color.fromARGB(255, 12, 119, 121),
                    offset: const Offset(0, 10),
                  ),
                ],
        ),

        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    widget.t.category?.icon ?? _fallbackIcon(widget.t.type),
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.t.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.dateFormat.format(widget.t.entryDate),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 50,
              child: Center(
                child: Icon(
                  typeIcon,
                  size: 42,
                  weight: 700,
                  opticalSize: 20,
                  grade: 200,
                  color: typeColor,
                ),
              ),
            ),

            SizedBox(
              width: 110,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${widget.t.type == TransactionType.expense ? "-" : "+"}₺${widget.t.amount.toStringAsFixed(2)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fallbackIcon(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return "💸";
      case TransactionType.income:
        return "💰";
      case TransactionType.transfer:
        return "🔁";
    }
  }
}
