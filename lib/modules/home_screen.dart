import 'dart:ui';

import 'package:expense_tracker_app/shared/compenents/compenents.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_cubit.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_states.dart';
import 'package:expense_tracker_app/shared/styles/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../shared/localization/app_localizations.dart';
import '../shared/styles/categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isBalanceShowed = false;
  String selectedPeriod = 'This Week';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        final topCategories = appCubit.sortedExpenseCategories.take(3).toList();
        final recent = appCubit.transactions.take(3).toList();
        final chart = appCubit.spendingChart(selectedPeriod);
        final chartMax = appCubit.chartMax(chart.values);

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppLocalizations.translate('dashboard', appCubit.language),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w800,
                fontSize: 24.sp,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                Container(
                  height: 170.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28.r),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF1E5BB8),
                        Color(0xFF0F3E8A),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E5BB8).withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -30.h,
                          right: -30.w,
                          child: Container(
                            width: 150.r,
                            height: 150.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -50.h,
                          right: 40.w,
                          child: Container(
                            width: 140.r,
                            height: 140.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(22.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        AppLocalizations.translate('total_balance', appCubit.language),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      InkWell(
                                        borderRadius: BorderRadius.circular(20.r),
                                        onTap: () => setState(() {
                                          isBalanceShowed = !isBalanceShowed;
                                        }),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.r),
                                          child: SvgPicture.asset(
                                            isBalanceShowed
                                                ? 'assets/icons/eye_dash.svg'
                                                : 'assets/icons/eye.svg',
                                            color: Colors.white.withOpacity(0.8),
                                            width: 18.w,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        height: 42.r,
                                        width: 42.r,
                                        padding: EdgeInsets.all(9.r),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(16.r),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/icons/wallet.svg',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      isBalanceShowed ? '\$${appCubit.balance.toStringAsFixed(2)}' : '••••••••',
                                      key: ValueKey(isBalanceShowed),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: isBalanceShowed ? -0.5 : 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  height: 85.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: appCubit.isDark? lightDarkColor: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow:appCubit.isDark?
                    [
                      BoxShadow(
                        color: mainColor.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                        : [
                      BoxShadow(
                        color: const Color(0xFF1E5BB8).withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 42.r,
                                height: 42.r,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Icon(
                                  Icons.arrow_downward_rounded,
                                  color: const Color(0xFF10B981),
                                  size: 20.r,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.translate('income', appCubit.language),
                                    style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    isBalanceShowed ? '\$${appCubit.totalIncome.toStringAsFixed(2)}' : '••••',
                                    style: TextStyle(
                                      color: appCubit.isDark? Colors.white: Color(0xFF0F172A),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 36.h,
                          width: 1.w,
                          color: appCubit.isDark? Colors.grey.shade700: Color(0xFFE2E8F0),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 42.r,
                                height: 42.r,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  color: const Color(0xFFEF4444),
                                  size: 20.r,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.translate('expenses', appCubit.language),
                                    style: TextStyle(
                                      color: const Color(0xFF64748B),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    isBalanceShowed ? '\$${appCubit.totalExpense.toStringAsFixed(2)}' : '••••',
                                    style: TextStyle(
                                      color: appCubit.isDark? Colors.white: Color(0xFF0F172A),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
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
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate('spending_overview', appCubit.language),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: appCubit.isDark? Colors.white: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPeriod,
                        dropdownColor: appCubit.isDark ? darkBgColor : bgColor,
                        borderRadius: BorderRadius.circular(16.r),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18.r,
                          color: const Color(0xFF1E5BB8),
                        ),
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: const Color(0xFF1E5BB8),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'Today',
                            child: Text(
                              AppLocalizations.translate('today', appCubit.language),
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'This Week',
                            child: Text(
                              AppLocalizations.translate('this_week', appCubit.language),
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'This Month',
                            child: Text(
                              AppLocalizations.translate('this_month', appCubit.language),
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'This Year',
                            child: Text(
                              AppLocalizations.translate('this_year', appCubit.language),
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            selectedPeriod = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsetsDirectional.all(20.w),
                  decoration: BoxDecoration(
                    color:appCubit.isDark?lightDarkColor: Colors.white,
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
                    height: 160.h,
                    child: LineChart(
                      LineChartData(
                        minX: 0, maxX: (chart.values.length - 1).toDouble(),
                        minY: 0,
                        maxY: chartMax,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: chartMax / 3,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: appCubit.isDark? Colors.grey.shade700: Color(0xFFF1F5F9),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        lineTouchData: LineTouchData(
                          handleBuiltInTouches: true,
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (touchedSpot) => const Color(0xFF0F172A),
                            tooltipMargin: 8,
                            tooltipPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            tooltipBorder: BorderSide.none,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  '\$${spot.y.toInt()}',
                                  TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                  ),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 24.h,
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
                                      fontSize: 11.sp,
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
                              checkToShowDot: (spot, barData) => spot.x == chart.values.length - 1,
                              getDotPainter: (spot, percent, barData, index) {
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
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate('top_categories', appCubit.language),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: appCubit.isDark? Colors.white: const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    defaultTextButton(
                      isLined: false,
                      isUpperCase: false,
                      onPressed: () => appCubit.changeIndex(2),
                      text: AppLocalizations.translate('see_all', appCubit.language),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                topCategories.isEmpty? Text(
                  'No Categories',
                  style: TextStyle(color: appCubit.isDark? Colors.grey.shade700:Colors.black),)
                    : Container(
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: appCubit.isDark? lightDarkColor: Colors.white,
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
                    children: List.generate(topCategories.length, (i) {
                      final e = topCategories[i];
                      final cat = appCategories.firstWhere(
                            (c) => c['name'] == e.key,
                        orElse: () => appCategories.first,
                      );
                      return _buildCategoryItem(
                        icon: cat['icon'],
                        title: AppLocalizations.translate(e.key, appCubit.language),
                        amount: '\$${e.value.toStringAsFixed(2)}',
                        progress: appCubit.totalExpense == 0 ? 0 : e.value / appCubit.totalExpense,
                        appCubit: appCubit,
                        color: cat['color'],
                        showDivider: i != topCategories.length - 1,
                      );
                    }),
                  ),
                ),
                SizedBox(height: 22.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate('recent_transactions', appCubit.language),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: appCubit.isDark? Colors.white: const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    defaultTextButton(
                      isLined: false,
                      isUpperCase: false,
                      onPressed: () => appCubit.changeIndex(1),
                      text: AppLocalizations.translate('see_all', appCubit.language),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                appCubit.transactions.isEmpty? Text(AppLocalizations.translate('no_transactions', appCubit.language), style: TextStyle(color: appCubit.isDark ? Colors.grey.shade400 : Colors.black54)):Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: appCubit.isDark? lightDarkColor: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E5BB8).withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(recent.length, (i) {
                      final t = recent[i];
                      final cat = appCategories.firstWhere(
                            (c) => c['name'] == t.category,
                        orElse: () => appCategories.first,
                      );
                      return _buildTransactionItem(
                        icon: cat['icon'],
                        title: t.title,
                        subtitle: DateFormat('d MMM, hh:mm a', appCubit.language).format(t.date),
                        amount: '${t.isExpense ? '-' : '+'}\$${t.amount.toStringAsFixed(2)}',
                        appCubit: appCubit,
                        color: t.isExpense? const Color(0xFFEF4444) : const Color(0xFF10B981),
                        showDivider: i != recent.length - 1,
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem({
    required String icon,
    required String title,
    required String amount,
    required double progress,
    required AppCubit appCubit,
    required Color color,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                padding: EdgeInsetsDirectional.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: SvgPicture.asset(
                  icon,
                  color: color,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color:appCubit.isDark? Colors.white: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          amount,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: appCubit.isDark? Colors.white: const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5.h,
                        backgroundColor:appCubit.isDark? Colors.grey.shade700: const Color(0xFFF1F5F9),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: appCubit.isDark? Colors.grey.shade700: const Color(0xFFF1F5F9),
          ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required String icon,
    required String title,
    required String subtitle,
    required String amount,
    required AppCubit appCubit,
    Color color = const Color(0xFFEF4444),
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                padding: EdgeInsetsDirectional.all(8.w),
                decoration: BoxDecoration(
                  color: appCubit.isDark? Colors.transparent:  const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: appCubit.isDark? Colors.grey.shade700: const Color(0xFFF1F5F9)),
                ),
                child: SvgPicture.asset(
                  icon,
                  color: const Color(0xFF1E5BB8),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: appCubit.isDark? Colors.white: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: appCubit.isDark? Colors.white: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: appCubit.isDark? Colors.grey.shade700: const Color(0xFFF1F5F9),
          ),
      ],
    );
  }
}