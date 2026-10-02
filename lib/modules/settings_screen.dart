import 'package:expense_tracker_app/shared/cubits/appCubit/app_cubit.dart';
import 'package:expense_tracker_app/shared/cubits/appCubit/app_states.dart';
import 'package:expense_tracker_app/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../shared/localization/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

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
              AppLocalizations.translate('settings', appCubit.language),
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
                Container(
                  width: double.infinity,
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
                    children: [
                      _buildSettingItem(
                        icon: 'assets/icons/lang.svg',
                        title: AppLocalizations.translate('language', appCubit.language),
                        subtitle: AppLocalizations.translate('english', appCubit.language),
                        trailing: Icons.arrow_forward_ios_rounded,
                        appCubit: appCubit,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final appCubit = AppCubit.get(context);

                              return AlertDialog(
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                surfaceTintColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                title: Text(
                                  AppLocalizations.translate(
                                    'language',
                                    appCubit.language,
                                  ),
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildLanguageOption(
                                      context: context,
                                      title: 'English',
                                      subtitle: 'English',
                                      languageCode: 'en',
                                      appCubit: appCubit,
                                    ),
                                    SizedBox(height: 10.h),
                                    _buildLanguageOption(
                                      context: context,
                                      title: 'العربية',
                                      subtitle: 'العربية',
                                      languageCode: 'ar',
                                      appCubit: appCubit,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      _buildDivider(appCubit),
                      _buildSwitchItem(
                        icon: 'assets/icons/moon.svg',
                        title: AppLocalizations.translate('dark_mode', appCubit.language),
                        subtitle: AppLocalizations.translate('dark_mode_subtitle', appCubit.language),
                        value: appCubit.isDark,
                        appCubit: appCubit,
                        onChanged: (value) {
                          setState(() {});
                          appCubit.changeTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingItem({
    required String icon,
    required String title,
    required String subtitle,
    required IconData trailing,
    required VoidCallback onTap,
    required AppCubit appCubit,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 13.h,
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              padding: EdgeInsetsDirectional.all(10.r),
              decoration: BoxDecoration(
                color: const Color(0xFF1E5BB8).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14.r),
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
                      color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              trailing,
              color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
              size: 15.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required AppCubit appCubit,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 16.w,
        vertical: 13.h,
      ),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            padding: EdgeInsets.all(11.r),
            decoration: BoxDecoration(
              color: const Color(0xFF1E5BB8).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14.r),
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
                    color: appCubit.isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFF94A3B8),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: const Color(0xFF1E5BB8),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(AppCubit appCubit) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
      child: Divider(
        height: 1,
        color: appCubit.isDark ? Colors.grey.shade700 : const Color(0xFFF1F5F9),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String languageCode,
    required AppCubit appCubit,
  }) {
    final bool isSelected = appCubit.language == languageCode;
    final bool isDark = appCubit.isDark;
    final Color unselectedBg = isDark
        ? const Color(0xFF1E293B)
        : Theme.of(context).cardColor;

    final Color unselectedBorder = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    final Color subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    final Color unselectedCheckBorder = isDark
        ? const Color(0xFF475569)
        : const Color(0xFFCBD5E1);

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        appCubit.changeLanguage(languageCode);
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 15.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E5BB8).withOpacity(0.12)
              : unselectedBg,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1E5BB8)
                : unselectedBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: const Color(0xFF1E5BB8).withOpacity(0.12),
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Icon(
                Icons.language_rounded,
                color: const Color(0xFF1E5BB8),
                size: 22.r,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22.r,
              height: 22.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF1E5BB8)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E5BB8)
                      : unselectedCheckBorder,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 14.r,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}