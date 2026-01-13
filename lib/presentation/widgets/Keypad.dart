import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';

class KeyPad extends StatelessWidget {
  final void Function(String) onTap;
  const KeyPad({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: 1, 2, 3, <-- (backspace spans 2)
        _buildRow(context, [
          _KeyItem("1"),
          _KeyItem("2"),
          _KeyItem("3"),
          _KeyItem("⌫", flex: 2),
        ]),
        const SizedBox(height: 12),

        // Row 2: 4, 5, 6, +, -
        _buildRow(context, [
          _KeyItem("4"),
          _KeyItem("5"),
          _KeyItem("6"),
          _KeyItem("+", isOperator: true),
          _KeyItem("-", isOperator: true),
        ]),
        const SizedBox(height: 12),

        // Row 3: 7, 8, 9, ×, ÷
        _buildRow(context, [
          _KeyItem("7"),
          _KeyItem("8"),
          _KeyItem("9"),
          _KeyItem("*", isOperator: true),
          _KeyItem("/", isOperator: true),
        ]),
        const SizedBox(height: 12),

        // Row 4: ,, 0, = (spans 3)
        _buildRow(context, [
          _KeyItem(","), // Nokta yerine virgül
          _KeyItem("0"),
          _KeyItem("=", flex: 3, isEquals: true),
        ]),
      ],
    );
  }

  Widget _buildRow(BuildContext context, List<_KeyItem> items) {
    return Row(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return Expanded(
          flex: item.flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildKey(context, item),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKey(BuildContext context, _KeyItem item) {
    final isBackspace = item.key == "⌫";

    Color bgColor;
    Color borderColor;
    Color shadowColor;

    if (item.isEquals) {
      bgColor = AppColors.secondaryBlue;
      borderColor = AppColors.secondaryBlueDark;
      shadowColor = AppColors.secondaryBlueDark;
    } else if (item.isOperator) {
      bgColor = AppColors.progressBackground(context);
      borderColor = AppColors.gray300;
      shadowColor = AppColors.gray300;
    } else {
      bgColor = AppColors.card(context);
      borderColor = AppColors.cardBorder(context);
      shadowColor = AppColors.cardBorder(context);
    }

    return PressableContainer(
      onPressed: () => onTap(item.key),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(0, 4))],
      child: Center(
        child: isBackspace
            ? Icon(
                Icons.backspace_outlined,
                color: AppColors.text(context),
                size: 24,
              )
            : SizedBox(
                width: double.infinity,
                child: Text(
                  item.key == "*"
                      ? "×"
                      : item.key == "/"
                      ? "÷"
                      : item.key,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: item.isEquals ? 28 : 22,
                    fontWeight: FontWeight.w800,
                    color: item.isEquals
                        ? Colors.white
                        : item.isOperator
                        ? AppColors.subtitleText(context)
                        : AppColors.text(context),
                  ),
                ),
              ),
      ),
    );
  }
}

class _KeyItem {
  final String key;
  final int flex;
  final bool isOperator;
  final bool isEquals;

  _KeyItem(
    this.key, {
    this.flex = 1,
    this.isOperator = false,
    this.isEquals = false,
  });
}
