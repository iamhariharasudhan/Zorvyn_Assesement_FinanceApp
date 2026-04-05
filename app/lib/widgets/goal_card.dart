import 'package:flutter/material.dart';
import 'package:app/models/goal.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/extensions.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GoalCard({
    Key? key,
    required this.goal,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  String get goalEmoji {
    switch (goal.type) {
      case GoalType.savings:
        return '💰';
      case GoalType.noSpend:
        return '🚫';
      case GoalType.budgetLimit:
        return '📊';
      case GoalType.savingStreak:
        return '🔥';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              goalEmoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    goal.type
                                        .toString()
                                        .split('.')
                                        .last
                                        .replaceAllMapped(
                                          RegExp(r'([A-Z])'),
                                          (match) =>
                                              ' ${match.group(0)}',
                                        )
                                        .trim()
                                        .capitalized,
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: onEdit,
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: onDelete,
                      ),
                    ],
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: LinearProgressIndicator(
                  value: goal.progressPercentage / 100,
                  minHeight: 8,
                  backgroundColor: AppColors.textTertiary.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    goal.isCompleted ? AppColors.success : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${goal.currentAmount.formattedCurrency} / ${goal.targetAmount.formattedCurrency}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${goal.progressPercentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (goal.type == GoalType.savingStreak)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      '🔥 ${goal.streakDays} day streak',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
