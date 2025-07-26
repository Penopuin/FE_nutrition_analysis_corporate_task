import 'package:flutter/material.dart';

class CommonInputField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? unit;

  const CommonInputField({
    super.key,
    this.hintText,
    this.controller,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        if (unit != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              unit!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ],
    );
  }
}
