import 'package:event_app/constants/colors.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback? onTap;
  const ProfileAvatar({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(16.0),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: const DecorationImage(image: AssetImage('assets/profile/avatar.jpg'), fit: BoxFit.cover),
            border: Border.all(color: accentColor, width: 0.5)),
      ),
    );
  }
}
