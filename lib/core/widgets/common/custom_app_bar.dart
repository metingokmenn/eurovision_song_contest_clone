import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Widget? leading;
  final Color? backgroundColor;
  final double elevation;
  final TextStyle? titleStyle;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.leading,
    this.backgroundColor,
    this.elevation = 0,
    this.titleStyle,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/app-bar-bg.png'),
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
          ),
        ),
      ),
      title: Text(
        title ?? '',
        style: titleStyle ?? Theme.of(context).textTheme.headlineSmall,
      ),
      leading: leading ?? (showBackButton ? const BackButton() : null),
      actions: actions,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation,
      centerTitle: true,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
