import 'package:flutter/services.dart';
import 'package:salesdocket_mobile/core/theme/app_colors.dart';
import 'package:salesdocket_ui_component/salesdocket_ui_component.dart';
import 'package:salesdocket_ui_component/ui_component_manager.dart';

ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  final appColors = UiComponentManager().appColors;

  return ThemeData(
    extensions: <ThemeExtension<SalesdocketAppColors>>[AppColors.light],
    useMaterial3: false,
    primaryColor: appColors.primary,
    scaffoldBackgroundColor: appColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: appColors.appBarBackground,
      elevation: 2,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: appColors.appBarIconColor),
      actionsIconTheme: IconThemeData(color: appColors.appBarIconColor),
      titleTextStyle: TextStyle(
        color: appColors.appBarTextColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: appColors.primary,
      elevation: 0,
    ),
    textTheme: TextTheme(
      labelSmall: TextStyle(
        fontSize: 12.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
        fontSize: 12.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        fontSize: 12.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: 14.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        fontSize: 16.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontSize: 16.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: TextStyle(
        fontSize: 18.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      headlineLarge: TextStyle(
        fontSize: 18.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: TextStyle(
        fontSize: 20.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
        fontSize: 20.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      displayLarge: TextStyle(
        fontSize: 20.sp,
        color: appColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: appColors.buttonBackground,
      textTheme: ButtonTextTheme.primary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColors.buttonBackground,
        foregroundColor: appColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.w),
          side: BorderSide(color: appColors.primary, width: 1.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
        textStyle: Theme.of(context).textTheme.titleMedium,
        elevation: 0,
      ),
    ),
    cardTheme: CardThemeData(elevation: 2, color: appColors.cardBackground),
    dividerTheme: DividerThemeData(color: appColors.grayLight, thickness: 1),
    chipTheme: ChipThemeData(backgroundColor: appColors.primary),
  );
}
