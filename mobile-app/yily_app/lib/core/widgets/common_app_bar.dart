import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onTokenTap;

  const CommonAppBar({
    super.key,
    required this.title,
    this.onTokenTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600)),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        if (onTokenTap != null)
          IconButton(
            icon: Icon(Icons.vpn_key_rounded, size: 24.w),
            tooltip: 'Mostra codice coppia',
            onPressed: onTokenTap,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}