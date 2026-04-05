import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/finance_provider.dart';
import 'package:app/models/transaction.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/action_button.dart';
import 'package:app/widgets/custom_text_field.dart';
import 'package:app/widgets/category_selector.dart';
import 'package:uuid/uuid.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionScreen({
    Key? key,
    this.transaction,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late TextEditingController notesController;
  late TextEditingController dateController;

  late TransactionType transactionType;
  late TransactionCategory category;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;

    if (transaction != null) {
      amountController =
          TextEditingController(text: transaction.amount.toString());
      descriptionController =
          TextEditingController(text: transaction.description);
      notesController = TextEditingController(text: transaction.notes ?? '');
      transactionType = transaction.type;
      category = transaction.category;
      selectedDate = transaction.date;
    } else {
      amountController = TextEditingController();
      descriptionController = TextEditingController();
      notesController = TextEditingController();
      transactionType = TransactionType.expense;
      category = TransactionCategory.other;
      selectedDate = DateTime.now();
    }

    dateController = TextEditingController(
      text: selectedDate.toString().split(' ')[0],
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.6),
                        AppColors.accent.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transaction == null
                                  ? '➕ Add Transaction'
                                  : '✏️ Edit Transaction',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Consumer<FinanceProvider>(
                  builder: (context, financeProvider, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Transaction Type Selector
                        Text(
                          'Transaction Type',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => transactionType = TransactionType.expense),
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: transactionType == TransactionType.expense
                                        ? AppColors.expenseRed.withOpacity(0.1)
                                        : AppColors.background,
                                    border: Border.all(
                                      color: transactionType == TransactionType.expense
                                          ? AppColors.expenseRed
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(AppRadius.lg),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Expense',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: transactionType == TransactionType.expense
                                            ? AppColors.expenseRed
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => transactionType = TransactionType.income),
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: transactionType == TransactionType.income
                                        ? AppColors.incomeGreen.withOpacity(0.1)
                                        : AppColors.background,
                                    border: Border.all(
                                      color: transactionType == TransactionType.income
                                          ? AppColors.incomeGreen
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(AppRadius.lg),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Income',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: transactionType == TransactionType.income
                                            ? AppColors.incomeGreen
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Amount
                        CustomTextField(
                          label: 'Amount',
                          hint: '0.00',
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.attach_money,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Description
                        CustomTextField(
                          label: 'Description',
                          hint: 'What is this transaction for?',
                          controller: descriptionController,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Category Selector
                        Text(
                          'Category',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _getCategories().map((cat) {
                              final isSelected = category == cat;
                              return GestureDetector(
                                onTap: () => setState(() => category = cat),
                                child: Container(
                                  margin: const EdgeInsets.only(right: AppSpacing.md),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.md,
                                    vertical: AppSpacing.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (transactionType == TransactionType.income
                                            ? AppColors.incomeGreen
                                            : AppColors.expenseRed)
                                        : AppColors.background,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : AppColors.border,
                                    ),
                                    borderRadius: BorderRadius.circular(AppRadius.lg),
                                  ),
                                  child: Text(
                                    _getCategoryLabel(cat),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Date Picker
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
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
                                      dateController.text,
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

                        // Notes
                        CustomTextField(
                          label: 'Notes (Optional)',
                          hint: 'Add any additional details...',
                          controller: notesController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Save Button
                        ActionButton(
                          label: widget.transaction == null
                              ? 'Add Transaction'
                              : 'Update Transaction',
                          onPressed: () async {
                            if (amountController.text.isEmpty ||
                                descriptionController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all required fields'),
                                ),
                              );
                              return;
                            }

                            try {
                              final amount = double.parse(amountController.text);

                              if (widget.transaction == null) {
                                final transaction = Transaction(
                                  id: const Uuid().v4(),
                                  amount: amount,
                                  type: transactionType,
                                  category: category,
                                  date: selectedDate,
                                  description: descriptionController.text,
                                  notes: notesController.text.isNotEmpty
                                      ? notesController.text
                                      : null,
                                );

                                await financeProvider.addTransaction(transaction);
                              } else {
                                final updatedTransaction =
                                    widget.transaction!.copyWith(
                                  amount: amount,
                                  type: transactionType,
                                  category: category,
                                  date: selectedDate,
                                  description: descriptionController.text,
                                  notes: notesController.text.isNotEmpty
                                      ? notesController.text
                                      : null,
                                );

                                await financeProvider
                                    .updateTransaction(updatedTransaction);
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
          ],
        ),
      ),
    );
  }

  List<TransactionCategory> _getCategories() {
    if (transactionType == TransactionType.income) {
      return [
        TransactionCategory.salary,
        TransactionCategory.freelance,
        TransactionCategory.investment,
        TransactionCategory.bonus,
        TransactionCategory.refund,
        TransactionCategory.gift,
      ];
    } else {
      return [
        TransactionCategory.food,
        TransactionCategory.transport,
        TransactionCategory.entertainment,
        TransactionCategory.shopping,
        TransactionCategory.utilities,
        TransactionCategory.health,
        TransactionCategory.education,
        TransactionCategory.other,
      ];
    }
  }

  String _getCategoryLabel(TransactionCategory category) {
    final labels = {
      TransactionCategory.salary: '💼 Salary',
      TransactionCategory.freelance: '🎯 Freelance',
      TransactionCategory.investment: '📈 Investment',
      TransactionCategory.bonus: '🎁 Bonus',
      TransactionCategory.refund: '↩️ Refund',
      TransactionCategory.gift: '🎉 Gift',
      TransactionCategory.food: '🍔 Food',
      TransactionCategory.transport: '🚗 Transport',
      TransactionCategory.entertainment: '🎬 Entertainment',
      TransactionCategory.shopping: '🛍️ Shopping',
      TransactionCategory.utilities: '💡 Utilities',
      TransactionCategory.health: '⚕️ Health',
      TransactionCategory.education: '📚 Education',
      TransactionCategory.other: '📌 Other',
    };
    return labels[category] ?? category.toString().split('.').last;
  }
}