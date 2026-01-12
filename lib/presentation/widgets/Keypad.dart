import 'package:flutter/material.dart';

class KeyPad extends StatelessWidget {
  final void Function(String) onTap;
  const KeyPad({super.key, required this.onTap});

  static const _keys = [
    "1","2","3","⌫",
    "4","5","6","-",
    "7","8","9","/",
    ".","0","+","="
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      itemCount: _keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final key = _keys[index];

        return GestureDetector(
          onTap: () => onTap(key),
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: key == "⌫"
                ? const Icon(Icons.backspace_outlined)
                : Text(key,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}
