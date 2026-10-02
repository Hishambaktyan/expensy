import 'package:expense_tracker_app/shared/compenents/compenents.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_cubit.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_states.dart';
import 'package:expense_tracker_app/shared/styles/categories.dart';
import 'package:expense_tracker_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shared/localization/app_localizations.dart';
import '../shared/models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isExpense = true;

  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCategory = 'food_dining';
  DateTime selectedDate = DateTime.now();

  final List<String> _incomeCategoryNames = [
    'salary',
    'investment',
    'business',
    'other',
  ];

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              AppLocalizations.translate('add_transaction', appCubit.language),
              style: TextStyle(
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
                _buildTypeSelector(appCubit),
                SizedBox(height: 20.h),
                _buildSectionTitle(
                  AppLocalizations.translate('amount', appCubit.language),
                  appCubit,
                ),
                SizedBox(height: 10.h),
                _buildAmountField(appCubit),
                SizedBox(height: 20.h),
                _buildSectionTitle(
                  AppLocalizations.translate('category', appCubit.language),
                  appCubit,
                ),
                SizedBox(height: 10.h),
                _buildCategorySelector(appCubit),
                SizedBox(height: 20.h),
                _buildSectionTitle(
                  AppLocalizations.translate('transaction_title', appCubit.language),
                  appCubit,
                ),
                SizedBox(height: 10.h),
                _buildTextField(
                  controller: titleController,
                  hintText: AppLocalizations.translate('eg_restaurant_salary', appCubit.language),
                  appCubit: appCubit,
                  icon: 'assets/icons/pen.svg',
                ),
                SizedBox(height: 20.h),
                _buildSectionTitle(
                  AppLocalizations.translate('date', appCubit.language),
                  appCubit,
                ),
                SizedBox(height: 10.h),
                _buildDateSelector(appCubit),
                SizedBox(height: 20.h),
                _buildSectionTitle(
                  AppLocalizations.translate('note', appCubit.language),
                  appCubit,
                ),
                SizedBox(height: 10.h),
                _buildTextField(
                  controller: noteController,
                  hintText: AppLocalizations.translate('add_note_optional', appCubit.language),
                  icon: 'assets/icons/note.svg',
                  appCubit: appCubit,
                  maxLines: 3,
                ),
                SizedBox(height: 30.h),
                defaultButtonWithIcon(
                  onPressed: () => _addTransaction(appCubit),
                  text: AppLocalizations.translate('add_transaction', appCubit.language),
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  background: isExpense ? mainColor : const Color(0xFF10B981),
                  height: 55,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeSelector(AppCubit appCubit) {
    return Container(
      height: 52.h,
      padding: EdgeInsetsDirectional.all(5.w),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = true;
                  selectedCategory = 'food_dining';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isExpense
                      ? const Color(0xFF1E5BB8)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_downward_rounded,
                        size: 19.r,
                        color: isExpense
                            ? Colors.white
                            : appCubit.isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        AppLocalizations.translate('expense', appCubit.language),
                        style: TextStyle(
                          color: isExpense
                              ? Colors.white
                              : appCubit.isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpense = false;
                  selectedCategory = 'salary';
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isExpense
                      ? const Color(0xFF10B981)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward_rounded,
                        size: 19.r,
                        color: !isExpense
                            ? Colors.white
                            : appCubit.isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        AppLocalizations.translate('income', appCubit.language),
                        style: TextStyle(
                          color: !isExpense
                              ? Colors.white
                              : appCubit.isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(AppCubit appCubit) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: amountController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w800,
          color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixText: '\$ ',
          prefixStyle: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            color: isExpense
                ? const Color(0xFFEF4444)
                : const Color(0xFF10B981),
          ),
          hintText: '0.00',
          hintStyle: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFCBD5E1),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector(AppCubit appCubit) {
    return GestureDetector(
      onTap: () => _showCategoryBottomSheet(appCubit),
      child: Container(
        height: 62.h,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E5BB8).withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              padding: EdgeInsetsDirectional.all(10.w),
              decoration: BoxDecoration(
                color: _selectedCategoryColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: SvgPicture.asset(
                _selectedCategoryIcon,
                colorFilter: ColorFilter.mode(
                  _selectedCategoryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                AppLocalizations.translate(selectedCategory, appCubit.language),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: appCubit.isDark ? Colors.grey.shade400 : const Color(0xFF64748B),
              size: 25.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(AppCubit appCubit) {
    return GestureDetector(
      onTap: () => _selectDate(appCubit),
      child: Container(
        height: 62.h,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          color: appCubit.isDark ? lightDarkColor : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E5BB8).withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              padding: EdgeInsetsDirectional.all(8.w),
              decoration: BoxDecoration(
                color: isExpense ? const Color(0xFF1E5BB8).withOpacity(0.10) : const Color(0xFF10B981).withOpacity(0.10),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: SvgPicture.asset(
                'assets/icons/date.svg',
                color: isExpense ? const Color(0xFF1E5BB8) : const Color(0xFF10B981),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                _formatDate(selectedDate),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: appCubit.isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8),
              size: 16.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
    required AppCubit appCubit,
    int maxLines = 1,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: appCubit.isDark ? lightDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E5BB8).withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          icon: SvgPicture.asset(
            icon,
            color: appCubit.isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: appCubit.isDark ? Colors.grey.shade400 : const Color(0xFF94A3B8),
            fontSize: 13.sp,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppCubit appCubit) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
      ),
    );
  }

  void _showCategoryBottomSheet(AppCubit appCubit) {
    final availableCategories = isExpense
        ? appCategories
        .where((category) =>
    !_incomeCategoryNames.contains(category['name']) ||
        category['name'] == 'other')
        .toList()
        : appCategories
        .where((category) => _incomeCategoryNames.contains(category['name']))
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 15.h,
            bottom: 25.h,
          ),
          decoration: BoxDecoration(
            color: appCubit.isDark ? lightDarkColor : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                AppLocalizations.translate('select_category', appCubit.language),
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w800,
                  color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 15.h),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: availableCategories.length,
                  itemBuilder: (context, index) {
                    final category = availableCategories[index];
                    final bool selected = selectedCategory == category['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category['name'];
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF1E5BB8).withOpacity(0.12)
                              : appCubit.isDark
                              ? Colors.white.withOpacity(0.05)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(17.r),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF1E5BB8)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42.w,
                              height: 42.h,
                              padding: EdgeInsets.all(9.w),
                              decoration: BoxDecoration(
                                color: (category['color'] as Color).withOpacity(0.10),
                                borderRadius: BorderRadius.circular(13.r),
                              ),
                              child: SvgPicture.asset(
                                category['icon'],
                                colorFilter: ColorFilter.mode(
                                  category['color'],
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                AppLocalizations.translate(
                                    category['name'], appCubit.language),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: appCubit.isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check_circle_rounded,
                                color: const Color(0xFF1E5BB8),
                                size: 22.r,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _selectDate(AppCubit appCubit) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:appCubit.isDark? ColorScheme.dark(
              primary: const Color(0xFF1E5BB8),
              onPrimary: Colors.white,
              surface: lightDarkColor,
              onSurface: Colors.white,
            ): const ColorScheme.light(
              primary: Color(0xFF1E5BB8),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String get _selectedCategoryIcon {
    final category = appCategories.firstWhere(
          (category) => category['name'] == selectedCategory,
      orElse: () => appCategories.first,
    );

    return category['icon'];
  }

  Color get _selectedCategoryColor {
    final category = appCategories.firstWhere(
          (category) => category['name'] == selectedCategory,
      orElse: () => appCategories.first,
    );

    return category['color'];
  }

  Future<void> _addTransaction(AppCubit appCubit) async {
    if (amountController.text.trim().isEmpty) {
      _showMessage(AppLocalizations.translate('please_enter_amount', appCubit.language), Colors.red);
      return;
    }

    if (titleController.text.trim().isEmpty) {
      _showMessage(AppLocalizations.translate('please_enter_transaction_title', appCubit.language), Colors.red);
      return;
    }

    final amount = double.tryParse(amountController.text.trim().replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      _showMessage(AppLocalizations.translate('please_enter_amount', appCubit.language), Colors.red);
      return;
    }

    await appCubit.addTransaction(TransactionModel(
      title: titleController.text.trim(),
      amount: amount,
      isExpense: isExpense,
      category: selectedCategory,
      note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
      date: selectedDate,
    ));

    if (!mounted) return;

    _showMessage(
      isExpense
          ? AppLocalizations.translate('expense_added_successfully', appCubit.language)
          : AppLocalizations.translate('income_added_successfully', appCubit.language),
      Colors.green,
    );

    Navigator.pop(context);
  }

  void _showMessage(String message, Color background) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
    );
  }
}