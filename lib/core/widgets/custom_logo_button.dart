import 'package:flutter/material.dart';

class CustomLogoButton extends StatelessWidget {
  const CustomLogoButton({super.key, required this.image, this.onPressed});

  final String image;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ?? () {},
      child: Image(
        image: AssetImage('assets/images/$image'),
        width: 28,
        height: 35,
      ),
    );
  }
}