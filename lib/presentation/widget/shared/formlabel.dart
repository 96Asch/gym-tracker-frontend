import 'package:flutter/widgets.dart';

class FormLabel extends StatelessWidget {
  final TextStyle style;
  final String text;
  final IconData icon;

  const FormLabel({
    required this.style,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 10),
        Text(text, style: style),
      ],
    );
  }
}
