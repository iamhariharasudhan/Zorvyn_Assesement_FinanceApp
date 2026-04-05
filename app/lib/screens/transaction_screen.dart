import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/finance_provider.dart';
import 'package:app/models/transaction.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/transaction_item.dart';
import 'package:app/screens/add_transaction_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final searchController = TextEditingController();
  TransactionCategory? selectedCategory;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Transaction> _getFilteredTransactions(FinanceProvider provider) {
    List<Transaction> filtered = provider.transactions;

    if (selectedCategory != null) {
      filtered = filtered.where((t) => t.category == selectedCategory).toList();
    }

    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where((t) =>
              t.description
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              (t.notes?.toLowerCase() ?? '')
                  .contains(searchController.text.toLowerCase()))
          .toList();
    }

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
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
                              'Transactions',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'View and manage all your transactions',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
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
                    final filtered = _getFilteredTransactions(financeProvider);
                    return Column(
                      children: [
                        // Search Bar
                        TextField(
                          controller: searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search transactions...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FilterChip(
                                label: const Text('All'),
                                selected: selectedCategory == null,
                                onSelected: (_) {
                                  setState(() => selectedCategory = null);
                                },
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: selectedCategory == null
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              ...TransactionCategory.values.map((category) {
                                final isSelected = selectedCategory == category;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: AppSpacing.sm),
                                  child: FilterChip(
                                    label: Text(
                                      category.toString().split('.').last,
                                    ),
                                    selected: isSelected,
                                    onSelected: (_) {
                                      setState(() {
                                        selectedCategory =
                                            isSelected ? null : category;
                                      });
                                    },
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.1),
                                    selectedColor: AppColors.primary,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.primary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        // Transactions List
                        filtered.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 64,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    'No transactions found',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(AppSpacing.md),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final transaction = filtered[index];
                                  return TransactionItem(
                                    transaction: transaction,
                                    onEdit: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddTransactionScreen(
                                            transaction: transaction,
                                          ),
                                        ),
                                      );
                                      if (result == true) setState(() {});
                                    },
                                    onDelete: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('Delete Transaction'),
                                          content: const Text(
                                              'Are you sure you want to delete this transaction?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                financeProvider
                                                    .deleteTransaction(
                                                        transaction.id);
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                        const SizedBox(height: AppSpacing.xl),
                        // Add Transaction Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddTransactionScreen(),
                                ),
                              );
                              if (result == true) setState(() {});
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Add Transaction',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.lg),
                              ),
                            ),
                          ),
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
}
