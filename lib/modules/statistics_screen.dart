import 'package:expense_tracker_app/shared/cubits/appCubit/app_cubit.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_states.dart';
import 'package:expense_tracker_app/shared/styles/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shared/localization/app_localizations.dart';
import '../shared/styles/categories.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String selectedPeriod = 'this_week';

  List<Map<String, dynamic>> get categories {
    final appCubit = AppCubit.get(context);
    final list = appCubit.sortedExpenseCategoriesIn(selectedPeriod);
    final total = list.fold(0.0, (s, e) => s + e.value);
    if (total == 0) return [];

    return list.map((e) {
      final cat = appCategories.firstWhere(
            (c) => c['name'] == e.key,
        orElse: () => appCategories.first,
      );
      return {
        'name': e.key,
        'amount': e.value,
        'percentage': double.parse((e.value / total * 100).toStringAsFixed(1)),
        'icon': cat['icon'],
        'color': cat['color'],
      };
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppLocalizations.translate('statistics', appCubit.language),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24.sp,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPeriodSelector(appCubit),
                SizedBox(height: 20.h),
                _buildSummaryCard(appCubit),
                SizedBox(height: 20.h),
                Text(
                  AppLocalizations.translate('spending_overview', appCubit.language),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildSpendingChart(appCubit),
                SizedBox(height: 20.h),
                Text(
                  AppLocalizations.translate('income_vs_expenses', appCubit.language),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildIncomeExpenseChart(appCubit),
                SizedBox(height: 20.h),
                Text(
                  AppLocalizations.translate('spending_by_category', appCubit.language),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildCategoryCard(appCubit),
                SizedBox(height: 20.h),
                Text(
                  AppLocalizations.translate('category_breakdown', appCubit.language),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 10.h),
                _buildBreakdownCard(appCubit),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodSelector(AppCubit appCubit) {
    return Container(
      height: 45.h,
      padding: EdgeInsetsDirectional.all(4.w),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(17.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildPeriodItem('today', appCubit),
          _buildPeriodItem('this_week', appCubit),
          _buildPeriodItem('this_month', appCubit),
          _buildPeriodItem('this_year', appCubit),
        ],
      ),
    );
  }

  Widget _buildPeriodItem(String periodKey, AppCubit appCubit) {
    final bool selected = selectedPeriod == periodKey;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPeriod = periodKey;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF1E5BB8)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Center(
            child: Text(
              AppLocalizations.translate(periodKey, appCubit.language),
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w700,
                color: selected
                    ? Colors.white
                    : appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(AppCubit appCubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF1E5BB8),
            Color(0xFF0F3E8A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.translate('financial_summary', appCubit.language),
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
    '\$${(appCubit.incomeIn(selectedPeriod) - appCubit.expenseIn(selectedPeriod)).toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.arrow_downward_rounded,
                  title: AppLocalizations.translate('income', appCubit.language),
                  amount: '\$${appCubit.incomeIn(selectedPeriod).toStringAsFixed(2)}',
                  color: const Color(0xFF34D399),
                  appCubit: appCubit,
                ),
              ),
              Container(
                width: 1.w,
                height: 38.h,
                color: Colors.white.withOpacity(0.18),
              ),
              Expanded(
                child: _buildSummaryItem(
                  icon: Icons.arrow_upward_rounded,
                  title: AppLocalizations.translate('expenses', appCubit.language),
                  amount: '\$${appCubit.expenseIn(selectedPeriod).toStringAsFixed(2)}',
                  color: const Color(0xFFF87171),
                  appCubit: appCubit,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
    required AppCubit appCubit,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 19.r,
            ),
          ),
          SizedBox(width: 9.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingChart(AppCubit appCubit) {
    final chart = appCubit.spendingChart(selectedPeriod);
    final chartMax = appCubit.chartMax(chart.values);
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(15.w),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.translate('daily_spending', appCubit.language),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              Container(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 9.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E5BB8).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '-\$${appCubit.expenseIn(selectedPeriod).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1E5BB8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 210.h,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (chart.values.length - 1).toDouble(),
                minY: 0,
                maxY: chartMax,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: chartMax / 3,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFFF1F5F9),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) {
                      return const Color(0xFF0F172A);
                    },
                    tooltipMargin: 8,
                    tooltipPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          '\$${spot.y.toInt()}',
                          TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 28.h,
                      getTitlesWidget: (value, meta) {
                        final labels = chart.labels;
                        final index = value.toInt();
                        if (index < 0 || index >= labels.length || (labels.length > 8 && index % 2 != 0)) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w600,
                              color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      chart.values.length,
                          (i) => FlSpot(i.toDouble(), chart.values[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    barWidth: 3.5,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF1E5BB8),
                      ],
                    ),
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) {
                        return spot.x == chart.values.length - 1;
                      },
                      getDotPainter: (
                          spot,
                          percent,
                          barData,
                          index,
                          ) {
                        return FlDotCirclePainter(
                          radius: 5.r,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: const Color(0xFF1E5BB8),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF1E5BB8).withOpacity(0.25),
                          const Color(0xFF1E5BB8).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseChart(AppCubit appCubit) {
    final monthly = appCubit.monthlyIncomeExpense();
    final barMax = appCubit.chartMax(monthly.expand((m) => [m.income, m.expense]));
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(18.w),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                color: const Color(0xFF10B981),
                title: AppLocalizations.translate('income', appCubit.language),
                appCubit: appCubit,
              ),
              SizedBox(width: 25.w),
              _buildLegendItem(
                color: const Color(0xFFEF4444),
                title: AppLocalizations.translate('expenses', appCubit.language),
                appCubit: appCubit,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                maxY: barMax,
                minY: 0,
                alignment: BarChartAlignment.spaceAround,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: barMax / 3,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFFF1F5F9),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) {
                      return appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF0F172A);
                    },
                    getTooltipItem: (
                        group,
                        groupIndex,
                        rod,
                        rodIndex,
                        ) {
                      return BarTooltipItem(
                        '\$${rod.toY.toInt()}',
                        TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28.h,
                      getTitlesWidget: (value, meta) {

                        final index = value.toInt();

                        if (index >= monthly.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: EdgeInsetsDirectional.only(top: 8.h),
                          child: Text(
                            monthly[index].label,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  monthly.length,
                      (i) => _buildBarGroup(i, monthly[i].income, monthly[i].expense),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(
      int x,
      double income,
      double expense,
      ) {
    return BarChartGroupData(
      x: x,
      barsSpace: 5.w,
      barRods: [
        BarChartRodData(
          toY: income,
          width: 8.w,
          borderRadius: BorderRadius.circular(5.r),
          color: const Color(0xFF10B981),
        ),
        BarChartRodData(
          toY: expense,
          width: 8.w,
          borderRadius: BorderRadius.circular(5.r),
          color: const Color(0xFFEF4444),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String title,
    required AppCubit appCubit,
  }) {
    return Row(
      children: [
        Container(
          width: 9.r,
          height: 9.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(AppCubit appCubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SizedBox(
        height: 230.h,
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 48.r,
            sectionsSpace: 3,
            sections: categories.map((category) {
              return PieChartSectionData(
                value: category['amount'],
                color: category['color'],
                radius: 55.r,
                showTitle: false,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(AppCubit appCubit) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 7.h,
      ),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: List.generate(
          categories.length,
              (index) {
            final category = categories[index];

            return _buildCategoryItem(
              category: category,
              showDivider: index != categories.length - 1,
              appCubit: appCubit,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required Map<String, dynamic> category,
    required bool showDivider,
    required AppCubit appCubit,
  }) {
    final Color color = category['color'];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: SvgPicture.asset(
                  category['icon'],
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.translate(category['name'], appCubit.language),
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '\$${category['amount'].toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w800,
                            color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.h),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(10.r),
                            child: LinearProgressIndicator(
                              value:
                              category['percentage'] / 100,
                              minHeight: 5.h,
                              backgroundColor: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFFF1F5F9),
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                color,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          '${category['percentage']}%',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            color: Color(0xFFF1F5F9),
          ),
      ],
    );
  }
}