import 'package:expense_tracker_app/shared/cubits/appCubit/app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../styles/colors.dart';

void move(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 10),
      reverseTransitionDuration: const Duration(milliseconds: 10),
    ),
  );
}

void moveAndReplace(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 10),
      reverseTransitionDuration: const Duration(milliseconds: 10),
    ),
        (route) => false,
  );
}

/////////////////////////////////////////////
Widget defaultButton({
  double height = 50,
  double textSize = 17,
  double width = double.infinity,
  Color background = mainColor,
  required Function? onPressed,
  required String? text,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadiusDirectional.circular(17.r),
      ),
      child: MaterialButton(
        onPressed: () => onPressed!(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text(
          text!,
          style: TextStyle(fontSize: textSize.sp, color: Colors.white),
        ),
      ),
    );
////////////////////////////////////////////
Widget defaultButtonWithIcon(
    {double height = 50,
      double textSize = 17,
      double width = double.infinity,
      Color background = mainColor,
      required Function? onPressed,
      required String? text,
      required Widget icon}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadiusDirectional.circular(17.r),
      ),
      child: MaterialButton(
        onPressed: () => onPressed!(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 7.w,
            ),
            Text(
              text!,
              style: TextStyle(fontSize: textSize.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
////////////////////////////////////////////
Widget defaultOutlinedButton({
  double height = 50,
  Color border = mainColor,
  Color textColor = mainColor,
  Color bgColor = Colors.transparent,
  required Function? onPressed,
  required String? text,
  double fontSize = 15,
}) =>
    Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: border),
        borderRadius: BorderRadiusDirectional.circular(17.r),
      ),
      child: MaterialButton(
        onPressed: () => onPressed!(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text(
          text!,
          style: TextStyle(fontSize: fontSize.sp, color: textColor),
        ),
      ),
    );
////////////////////////////////////////////
Widget defaultOutlinedButtonWithIcon(
    {double height = 50,
      Color border = mainColor,
      Color textColor = mainColor,
      Color bgColor = Colors.transparent,
      required Function? onPressed,
      required String? text,
      double fontSize = 17,
      required Widget icon}) =>
    Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: border),
        borderRadius: BorderRadiusDirectional.circular(17.r),
      ),
      child: MaterialButton(
        onPressed: () => onPressed!(),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: 7.w,
            ),
            Text(
              text!,
              style: TextStyle(fontSize: fontSize.sp, color: textColor),
            ),
          ],
        ),
      ),
    );
////////////////////////////////////////////
Widget defaultTextFormField(
    {required String? text,
      required String? prefixIcon,
      required String? errorMes,
      required TextEditingController? controller,
      bool isPassword = false,
      bool isSuffixIcon = false,
      String? suffixIcon,
      Function? suffixPressed,
      required TextInputType? type,
      double? fontSize,
      required AppCubit cubit,
      bool isCovered = false,
      bool isReadOnly = false,
      TextDirection textDirection = TextDirection.rtl,
      TextAlign textAlign = TextAlign.start,
      List<TextInputFormatter>? inputFormatters,
      String? Function(String?)? validator,
      Function(String)? onChanged,
      Widget? suffixWidget}) =>
    TextFormField(
      style: TextStyle(
        fontSize: 14.sp,
        color: cubit.isDark ? Colors.white : Colors.black,
      ),
      readOnly: isReadOnly,
      keyboardType: type,
      textDirection: textDirection,
      textAlign: textAlign,
      inputFormatters: inputFormatters,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
      },
      validator: validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return errorMes;
            }
            return null;
          },
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: cubit.isDark ? lightDarkColor : Colors.white,
        labelText: text,
        labelStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.r),
          child: SvgPicture.asset(
            prefixIcon!,
            width: 18.w,
            height: 18.h,
            color: mainColor,
          ),
        ),
        suffixIcon: isSuffixIcon
            ? IconButton(
          onPressed: () {
            suffixPressed!();
          },
          icon: SvgPicture.asset(
            suffixIcon!,
            width: 20.w,
            height: 20.h,
            color: Colors.grey,
          ),
          highlightColor: Colors.transparent,
        )
            : suffixWidget,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(
            color:
            cubit.isDark ? const Color(0xFF30363D) : Colors.grey.shade100,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: mainColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
/////////////////////////////////////////////
Widget defaultTextButton({
  required Function onPressed,
  required String text,
  bool isUpperCase = true,
  Color color = mainColor,
  bool isLined = true,
  bool isBold = false,
}) =>
    TextButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            decoration: isLined ? TextDecoration.underline : null,
            decorationColor: mainColor,
          ),
        ));
/////////////////////////////////////////////
Widget buildButton({
  required BuildContext context,
  required bool isDark,
  required IconData icon,
  required VoidCallback onTap,
  Color? iconColor,
  Color? backgroundColor,
}) {
  return InkWell(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: Container(
      width: 42.r,
      height: 42.r,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark
                ? darkBgColor.withOpacity(0.8)
                : Colors.white.withOpacity(0.8)),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: backgroundColor ??
              (isDark
                  ? Colors.white.withOpacity(0.8)
                  : darkBgColor.withOpacity(0.8)),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
        size: 23.r,
      ),
    ),
  );
}
