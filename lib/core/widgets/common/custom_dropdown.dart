import 'package:flutter/material.dart';
import 'package:eurovision_song_contest_clone/core/theme/app_colors.dart';

/// A customized dropdown widget that follows the app's design system
class CustomDropdown<T> extends StatelessWidget {
  /// Current selected value
  final T? value;

  /// List of dropdown items to display
  final List<DropdownMenuItem<T>>? items;

  /// Callback when selection changes
  final ValueChanged<T?>? onChanged;

  /// Hint text to display when no value is selected
  final String? hint;

  /// Optional custom icon for the dropdown
  final Widget? icon;

  /// Width constraint for the dropdown
  final double? width;

  /// Optional label text to display above the dropdown
  final String? labelText;

  /// Optional text style for the label
  final TextStyle? labelStyle;

  /// Allow items to have dynamic height (not fixed)
  final bool dynamicItemHeight;

  /// The corner radius of the dropdown
  final double borderRadius;

  /// The background color of the dropdown
  final Color? backgroundColor;

  /// The color to use for the dropdown icon container
  final Color? iconBackgroundColor;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.icon,
    this.width,
    this.labelText,
    this.labelStyle,
    this.dynamicItemHeight = true,
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );

    final defaultBackgroundColor = Theme.of(context).cardColor;
    const defaultIconBackgroundColor =
        Color.fromARGB(51, 216, 27, 96); // 20% opacity for magenta

    // Default dropdown icon
    final defaultIcon = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconBackgroundColor ?? defaultIconBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.magenta,
      ),
    );

    Widget dropdown = Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(10, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: hint != null ? Text(hint!) : null,
          isExpanded: true,
          itemHeight: dynamicItemHeight ? null : kMinInteractiveDimension,
          icon: icon ?? defaultIcon,
          items: items,
          onChanged: onChanged,
          dropdownColor: backgroundColor ?? defaultBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
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
          dropdown,
        ],
      );
    }

    return dropdown;
  }
}
