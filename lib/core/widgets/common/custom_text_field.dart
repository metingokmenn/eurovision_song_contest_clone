import 'package:flutter/material.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';

/// A customized text field widget that follows the app's design system
class CustomTextField extends StatelessWidget {
  /// Controller for the text field
  final TextEditingController? controller;

  /// Called when the text changes
  final ValueChanged<String>? onChanged;

  /// Placeholder text to display when the field is empty
  final String? hintText;

  /// Whether the text field should be in focus
  final bool autofocus;

  /// Icon to display at the start of the text field
  final Widget? prefixIcon;

  /// Icon to display at the end of the text field
  final Widget? suffixIcon;

  /// Optional label text to display above the text field
  final String? labelText;

  /// Optional text style for the label
  final TextStyle? labelStyle;

  /// The corner radius of the text field
  final double borderRadius;

  /// The background color of the text field
  final Color? backgroundColor;

  /// Whether the text field should expand to fill its parent
  final bool expand;

  /// Whether to obscure the text (useful for passwords)
  final bool obscureText;

  /// Maximum number of lines for the text field
  final int? maxLines;

  /// Minimum number of lines for the text field
  final int? minLines;

  const CustomTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.labelText,
    this.labelStyle,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.expand = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );

    final defaultBackgroundColor = Theme.of(context).cardColor;

    final Widget textField = TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      expands: expand,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: backgroundColor ?? defaultBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide.none,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: AppColors.magenta,
            width: 2,
          ),
        ),
      ),
    );

    // If we have a label, wrap in a Column
    if (labelText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText!,
            style: labelStyle ?? defaultLabelStyle,
          ),
          const SizedBox(height: 8),
          textField,
        ],
      );
    }

    return textField;
  }
}
