import 'dart:ui';

import 'package:expense_tracker_app/modules/add_transaction_screen.dart';
import 'package:expense_tracker_app/shared/compenents/compenents.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_cubit.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_states.dart';
import 'package:expense_tracker_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../shared/localization/app_localizations.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit appCubit = AppCubit.get(context);
        return Scaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 50,
                  sigmaY: 50,
                ),
                child: BottomAppBar(
                  color: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 70.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildNavItem(
                            icon: 'assets/icons/home.svg',
                            selectedIcon: 'assets/icons/home_bold.svg',
                            label: AppLocalizations.translate('home', appCubit.language),
                            index: 0,
                            appCubit: appCubit,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            icon: 'assets/icons/transactions.svg',
                            selectedIcon: 'assets/icons/transactions_bold.svg',
                            label: AppLocalizations.translate('transactions', appCubit.language),
                            index: 1,
                            appCubit: appCubit,
                          ),
                        ),
                        SizedBox(
                          width: 70.w,
                          child: Center(
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.circular(50.r),
                              onTap: ()=>move(context, AddTransactionScreen()),
                              child: Container(
                                width: 43.w,
                                height: 43.h,
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 24.r,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            icon: 'assets/icons/chart.svg',
                            selectedIcon: 'assets/icons/chart_bold.svg',
                            label: AppLocalizations.translate('statistics', appCubit.language),
                            index: 2,
                            appCubit: appCubit,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            icon: 'assets/icons/settings.svg',
                            selectedIcon: 'assets/icons/settings_bold.svg',
                            label: AppLocalizations.translate('settings', appCubit.language),
                            index: 3,
                            appCubit: appCubit,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body:appCubit.screens[appCubit.currentIndex],
        );
      },
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String selectedIcon,
    required String label,
    required int index,
    required AppCubit appCubit,
  }) {
    final bool isSelected = appCubit.currentIndex == index;

    final Color color = isSelected
        ? mainColor
        : (appCubit.isDark ? Colors.grey.shade700 : Colors.black54);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        appCubit.changeIndex(index);
      },
      child: SizedBox(
        height: 70.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isSelected ? selectedIcon : icon,
              width: 25.w,
              height: 25.h,
              color: color,
            ),

            SizedBox(height: 3.h),

            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11.sp,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}