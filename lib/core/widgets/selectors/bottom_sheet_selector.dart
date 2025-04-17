import 'package:flutter/material.dart';


class BottomSheetSelector<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final Widget Function(BuildContext context, T item, bool isSelected)
      itemBuilder;
  final Function(T selectedItem) onItemSelected;
  final bool useGrid;
  final int? gridCrossAxisCount;

  const BottomSheetSelector({
    Key? key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.itemBuilder,
    required this.onItemSelected,
    this.useGrid = false,
    this.gridCrossAxisCount = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final handleColor = isDarkMode ? Colors.grey[600] : Colors.grey[300];
    final dividerColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle for drag
          Container(
            height: 5,
            width: 40,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: handleColor,
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(height: 24, color: dividerColor),
          // Content
          Expanded(
            child: useGrid
                ? _buildGridContent(context)
                : _buildListContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGridContent(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCrossAxisCount!,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item == selectedItem;
        return InkWell(
          onTap: () {
            onItemSelected(item);
            Navigator.pop(context);
          },
          child: itemBuilder(context, item, isSelected),
        );
      },
    );
  }

  Widget _buildListContent(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item == selectedItem;
        return InkWell(
          onTap: () {
            onItemSelected(item);
            Navigator.pop(context);
          },
          child: itemBuilder(context, item, isSelected),
        );
      },
    );
  }
}

class SelectionItem extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget child;

  const SelectionItem({
    Key? key,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.margin,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color:
            backgroundColor ?? (isDarkMode ? Colors.grey[800] : Colors.white),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ??
              (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
