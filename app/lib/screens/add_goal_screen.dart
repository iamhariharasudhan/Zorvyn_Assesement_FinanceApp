import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/finance_provider.dart';
import 'package:app/models/goal.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/action_button.dart';
import 'package:app/widgets/custom_text_field.dart';
import 'package:app/widgets/category_selector.dart';
import 'package:uuid/uuid.dart';

class AddGoalScreen extends StatefulWidget {
  final Goal? goal;

  const AddGoalScreen({
    Key? key,
    this.goal,
  }) : super(key: key);

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  late TextEditingController nameController;
  late TextEditingController targetAmountController;
  late TextEditingController descriptionController;
  late TextEditingController targetDateController;

  late GoalType goalType;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final goal = widget.goal;

    if (goal != null) {
      nameController = TextEditingController(text: goal.name);
      targetAmountController =
          TextEditingController(text: goal.targetAmount.toString());
      descriptionController =
          TextEditingController(text: goal.description);
      goalType = goal.type;
      selectedDate = goal.targetDate;
    } else {
      nameController = TextEditingController();
      targetAmountController = TextEditingController();
      descriptionController = TextEditingController();
      goalType = GoalType.savings;
      selectedDate = DateTime.now().add(const Duration(days: 30));
    }

    targetDateController = TextEditingController(
      text: selectedDate.toString().split(' ')[0],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    targetAmountController.dispose();
    descriptionController.dispose();
    targetDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        targetDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  String get goalTypeDescription {
    switch (goalType) {
      case GoalType.savings:
        return 'Save money towards a target amount';
      case GoalType.noSpend:
        return 'Challenge yourself to spend less';
      case GoalType.budgetLimit:
        return 'Limit spending in a category';
      case GoalType.savingStreak:
        return 'Maintain a daily saving streak';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goal == null ? 'Add Goal' : 'Edit Goal'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Consumer<FinanceProvider>(
            builder: (context, financeProvider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal Type Selector
                  Text(
                    'Goal Type',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: DropdownButton<GoalType>(
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      value: goalType,
                      items: GoalType.values
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(
                                type.toString().split('.').last.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (newType) {
                        if (newType != null) {
                          setState(() => goalType = newType);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    goalTypeDescription,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Goal Name
                  CustomTextField(
                    label: 'Goal Name',
                    hint: 'e.g., Emergency Fund',
                    controller: nameController,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Target Amount
                  CustomTextField(
                    label: 'Target Amount',
                    hint: '0.00',
                    controller: targetAmountController,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.attach_money,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Target Date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Date',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: AppColors.primary),
                              const SizedBox(width: AppSpacing.md),
                              Text(
                                targetDateController.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Description
                  CustomTextField(
                    label: 'Description',
                    hint: 'Why is this goal important to you?',
                    controller: descriptionController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Save Button
                  ActionButton(
                    label: widget.goal == null ? 'Create Goal' : 'Update Goal',
                    onPressed: () async {
                      if (nameController.text.isEmpty ||
                          targetAmountController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all required fields'),
                          ),
                        );
                        return;
                      }

                      try {
                        final amount =
                            double.parse(targetAmountController.text);

                        if (widget.goal == null) {
                          final goal = Goal(
                            id: const Uuid().v4(),
                            name: nameController.text,
                            type: goalType,
                            targetAmount: amount,
                            currentAmount: 0,
                            createdDate: DateTime.now(),
                            targetDate: selectedDate,
                            description: descriptionController.text,
                            isActive: true,
                          );

                          await financeProvider.addGoal(goal);
                        } else {
                          final updatedGoal = widget.goal!.copyWith(
                            name: nameController.text,
                            type: goalType,
                            targetAmount: amount,
                            targetDate: selectedDate,
                            description: descriptionController.text,
                          );

                          await financeProvider.updateGoal(updatedGoal);
                        }

                        if (!mounted) return;
                        Navigator.pop(context, true);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
