import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback? onPressed;
  const LoginWidget(this.title,
      {super.key, this.enable = true, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      height: 45,
      onPressed: enable ? onPressed : null,
      disabledColor: Colors.white60,
      color: Colors.orange,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
