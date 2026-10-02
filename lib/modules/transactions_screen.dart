import 'package:expense_tracker_app/shared/compenents/compenents.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_cubit.dart';
import 'package:expense_tracker_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../shared/cubits/appCubit/app_states.dart';
import '../shared/localization/app_localizations.dart';
import '../shared/models/transaction_model.dart';
import '../shared/styles/categories.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';

  void _confirmDelete(TransactionModel t, AppCubit appCubit) {
    final ar = appCubit.language == 'ar';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.title),
        content: Text(ar ? 'هل تريد حذف هذه المعاملة؟' : 'Delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(ar ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              appCubit.deleteTransaction(t.id!);
              Navigator.pop(ctx);
            },
            child: Text(ar ? 'حذف' : 'Delete', style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        final all = appCubit.transactions;
        final filteredTransactions = all.where((t) {
          final matchesType = selectedFilter == 'All' || t.isExpense == (selectedFilter == 'Expense');
          final q = searchQuery.toLowerCase();
          final matchesSearch = q.isEmpty ||
              t.title.toLowerCase().contains(q) ||
              AppLocalizations.translate(t.category, appCubit.language).toLowerCase().contains(q);
          return matchesType && matchesSearch;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppLocalizations.translate('transactions', appCubit.language),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: appCubit.isDark ? lightDarkColor : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E5BB8).withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v.trim()),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.translate('search_transactions', appCubit.language),
                      hintStyle: TextStyle(
                        color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                        fontSize: 13.sp,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsetsDirectional.all(10.w),
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsetsDirectional.symmetric(
                        vertical: 15.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    _buildFilterButton('All', appCubit),
                    SizedBox(width: 8.w),
                    _buildFilterButton('Income', appCubit),
                    SizedBox(width: 8.w),
                    _buildFilterButton('Expense', appCubit),
                  ],
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.translate('all_transactions', appCubit.language),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      '${filteredTransactions.length} ${AppLocalizations.translate('transactions', appCubit.language)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                filteredTransactions.isEmpty? Text(AppLocalizations.translate('no_transactions', appCubit.language), style: TextStyle(color: appCubit.isDark ? Colors.grey.shade400 : Colors.black54)):Container(
                  width: double.infinity,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: appCubit.isDark ? lightDarkColor : Colors.white,
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
                    children: filteredTransactions.map((t) {
                      final index = filteredTransactions.indexOf(t);
                      final cat = appCategories.firstWhere(
                            (c) => c['name'] == t.category,
                        orElse: () => appCategories.first,
                      );

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onLongPress: () => _confirmDelete(t, appCubit),
                        child: _buildTransactionItem(
                          icon: cat['icon'],
                          title: t.title,
                          category: AppLocalizations.translate(t.category, appCubit.language),
                          date: DateFormat('d MMM, hh:mm a', appCubit.language).format(t.date),
                          amount: '${t.isExpense ? '-' : '+'}\$${t.amount.toStringAsFixed(2)}',
                          type: t.isExpense ? 'Expense' : 'Income',
                          color: cat['color'],
                          appCubit: appCubit,
                          showDivider: index != filteredTransactions.length - 1,
                        ),
                      );
                    }).toList(),
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

  Widget _buildFilterButton(String title, AppCubit appCubit) {
    final bool isSelected = selectedFilter == title;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedFilter = title;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 42.h,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1E5BB8)
                : appCubit.isDark ? lightDarkColor : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1E5BB8)
                  : appCubit.isDark ? Colors.grey.shade700 : const Color(0xFFE2E8F0),
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: const Color(0xFF1E5BB8).withOpacity(0.20),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ]
                : [],
          ),
          child: Center(
            child: Text(
              AppLocalizations.translate(title.toLowerCase(), appCubit.language),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF64748B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String icon,
    required String title,
    required String category,
    required String date,
    required String amount,
    required String type,
    required Color color,
    required AppCubit appCubit,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 46.r,
                height: 46.r,
                padding: EdgeInsetsDirectional.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: SvgPicture.asset(icon, color: color),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 10.5.sp,
                            color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Container(
                          width: 3.r,
                          height: 3.r,
                          decoration: BoxDecoration(
                            color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFFCBD5E1),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Flexible(
                          child: Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: type == 'Income'
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFFF1F5F9),
          ),
      ],
    );
  }
}