import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:app/providers/finance_provider.dart';
import 'package:app/models/transaction.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/extensions.dart';
import 'package:fl_chart/fl_chart.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late int touchedIndex;

  @override
  void initState() {
    super.initState();
    touchedIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
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
                              '📊 Financial Insights',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Analyze your spending patterns',
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
                    if (financeProvider.transactions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              size: 64,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'No Data Yet',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Add transactions to see insights',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary Cards
                        _buildSummaryCards(context, financeProvider),
                        const SizedBox(height: AppSpacing.lg),

                        // Income vs Expenses Bar Chart
                        _buildSection(
                          context,
                          'Income vs Expenses',
                          _buildIncomeExpensesChart(financeProvider),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Expense Breakdown Pie Chart
                        if (financeProvider.expensesByCategory.isNotEmpty)
                          _buildSection(
                            context,
                            'Expense Breakdown',
                            _buildExpenseBreakdownChart(financeProvider),
                          ),
                        const SizedBox(height: AppSpacing.lg),

                        // Category Wise Breakdown
                        if (financeProvider.expensesByCategory.isNotEmpty)
                          _buildSection(
                            context,
                            'Category Details',
                            _buildCategoryBreakdown(financeProvider),
                          ),
                        const SizedBox(height: AppSpacing.lg),

                        // Spending Trend Line Chart
                        if (financeProvider.transactions.length > 1)
                          _buildSection(
                            context,
                            'Spending Trend',
                            _buildSpendingTrendChart(financeProvider),
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

  Widget _buildSummaryCards(BuildContext context, FinanceProvider provider) {
    final savingsRatio = provider.totalIncome > 0
        ? ((provider.totalIncome - provider.totalExpenses) /
                provider.totalIncome *
                100)
            .toStringAsFixed(1)
        : '0';

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Income',
                provider.totalIncome.formattedCompactCurrency,
                AppColors.incomeGreen,
                Icons.trending_up,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                'Total Expenses',
                provider.totalExpenses.formattedCompactCurrency,
                AppColors.expenseRed,
                Icons.trending_down,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Net Balance',
                provider.totalBalance.formattedCompactCurrency,
                AppColors.savingsBlue,
                Icons.wallet,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                'Savings Ratio',
                '$savingsRatio%',
                AppColors.primary,
                Icons.percent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: const [AppShadow.shadow],
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: content,
        ),
      ],
    );
  }

  Widget _buildIncomeExpensesChart(FinanceProvider provider) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxValue(provider.totalIncome, provider.totalExpenses),
          barTouchData: BarTouchData(
            enabled: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const titles = ['Income', 'Expenses'];
                  return Text(
                    titles[value.toInt()],
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('₹0');
                  return Text(
                    '₹${(value / 1000).toStringAsFixed(0)}K',
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 50,
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: provider.totalIncome,
                  color: AppColors.incomeGreen,
                  width: 40,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: provider.totalExpenses,
                  color: AppColors.expenseRed,
                  width: 40,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseBreakdownChart(FinanceProvider provider) {
    final expenses = provider.expensesByCategory;
    final pieData = expenses.entries
        .map((entry) => PieChartSectionData(
              value: entry.value,
              title: entry.value.formattedCompactCurrency,
              color: _getCategoryColor(entry.key),
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ))
        .toList();

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          sections: pieData,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(FinanceProvider provider) {
    final expenses = provider.expensesByCategory.entries.toList();
    expenses.sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: List.generate(expenses.length, (index) {
        final entry = expenses[index];
        final category = entry.key;
        final amount = entry.value;
        final percentage = provider.totalExpenses > 0
            ? (amount / provider.totalExpenses * 100)
            : 0.0;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Icon(
                            _getCategoryIcon(category),
                            color: _getCategoryColor(category),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(
                          category.toString().split('.').last.replaceFirst(
                              category.toString().split('.').last[0],
                              category
                                  .toString()
                                  .split('.')
                                  .last[0]
                                  .toUpperCase()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        amount.formattedCompactCurrency,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  minHeight: 6,
                  backgroundColor: _getCategoryColor(category).withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      _getCategoryColor(category)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSpendingTrendChart(FinanceProvider provider) {
    final transactions = List<Transaction>.from(provider.transactions);
    transactions.sort((a, b) => a.date.compareTo(b.date));

    // Group by date and sum expenses
    final Map<DateTime, double> dailyExpenses = {};
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        final dateKey = DateTime(transaction.date.year, transaction.date.month,
            transaction.date.day);
        dailyExpenses[dateKey] =
            (dailyExpenses[dateKey] ?? 0) + transaction.amount;
      }
    }

    if (dailyExpenses.isEmpty) {
      return Center(
        child: Text(
          'No expense data available',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    final sortedDates = dailyExpenses.keys.toList()..sort();
    final maxY = dailyExpenses.values.reduce((a, b) => a > b ? a : b);

    final spots = List.generate(
      sortedDates.length,
      (index) => FlSpot(
        index.toDouble(),
        dailyExpenses[sortedDates[index]] ?? 0,
      ),
    );

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.textTertiary.withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: (sortedDates.length / 5).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < sortedDates.length) {
                    return Text(
                      '${sortedDates[index].day}/${sortedDates[index].month}',
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('₹0');
                  return Text(
                    '₹${(value / 1000).toStringAsFixed(0)}K',
                    style: const TextStyle(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
                  );
                },
                reservedSize: 50,
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(
                color: AppColors.textTertiary.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.expenseRed,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.expenseRed,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.expenseRed.withOpacity(0.1),
              ),
            ),
          ],
          minY: 0,
          maxY: maxY * 1.2,
        ),
      ),
    );
  }

  Color _getCategoryColor(TransactionCategory category) {
    const colors = {
      TransactionCategory.food: Color(0xFFFF6B6B),
      TransactionCategory.transport: Color(0xFF4ECDC4),
      TransactionCategory.entertainment: Color(0xFFFFD93D),
      TransactionCategory.shopping: Color(0xFFFF006E),
      TransactionCategory.utilities: Color(0xFF6C5CE7),
      TransactionCategory.health: Color(0xFF00B894),
      TransactionCategory.education: Color(0xFF0984E3),
      TransactionCategory.salary: Color(0xFF10B981),
      TransactionCategory.freelance: Color(0xFF6366F1),
      TransactionCategory.investment: Color(0xFFF59E0B),
      TransactionCategory.other: Color(0xFF95A5A6),
    };
    return colors[category] ?? AppColors.primary;
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    const icons = {
      TransactionCategory.food: Icons.restaurant,
      TransactionCategory.transport: Icons.directions_car,
      TransactionCategory.entertainment: Icons.movie,
      TransactionCategory.shopping: Icons.shopping_bag,
      TransactionCategory.utilities: Icons.bolt,
      TransactionCategory.health: Icons.medical_services,
      TransactionCategory.education: Icons.school,
      TransactionCategory.salary: Icons.work,
      TransactionCategory.freelance: Icons.code,
      TransactionCategory.investment: Icons.trending_up,
      TransactionCategory.other: Icons.category,
    };
    return icons[category] ?? Icons.category;
  }

  double _getMaxValue(double value1, double value2) {
    final max = value1 > value2 ? value1 : value2;
    return max == 0 ? 1000 : max * 1.2;
  }
}
