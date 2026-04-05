import 'package:flutter/material.dart';
import 'package:app/utils/constants.dart';

class CategorySelector extends StatelessWidget {
  final String label;
  final dynamic selectedCategory;
  final List<dynamic> categories;
  final Function(dynamic) onChanged;
  final String Function(dynamic) categoryLabel;

  const CategorySelector({
    Key? key,
    required this.label,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
    required this.categoryLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: DropdownButton<dynamic>(
            isExpanded: true,
            underline: const SizedBox.shrink(),
            value: selectedCategory,
            items: categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(categoryLabel(category)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
