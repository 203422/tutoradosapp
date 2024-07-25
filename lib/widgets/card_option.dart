import 'package:flutter/material.dart';

class CardOption extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const CardOption(
      {super.key,
      required this.title,
      required this.description,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(colors.primaryContainer.value),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Icon(icon, color: Color(colors.secondary.value), size: 50),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: TextStyle(
                color: Color(colors.onPrimaryContainer.value),
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          Text(
            description,
            style: TextStyle(
                fontSize: 16, color: Color(colors.onPrimaryContainer.value)),
          )
        ],
      ),
    );
  }
}
