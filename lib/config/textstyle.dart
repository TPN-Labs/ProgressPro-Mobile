import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static String primaryColorString = '#003CBF';
  static String secondaryColorString = '#F5F7FE';

  static String blackColorString = '#00133D';
  static String greenColorString = '#31D09A';
  static String redColorString = '#FF5C4D';
  static String yellowColorString = '#EBB335';
  static String greyColorString = '#95A0B8';
  static HexColor errorColor = HexColor('#FFF44336');

  static late bool isLightTheme;

  static Color getContourColor(bool inverse) {
    Color blue = const Color(0xff211F32);
    Color white = const Color(0xffFFFFFF);

    if ((AppTheme.isDarkModeActive() == true && inverse == true) || (AppTheme.isDarkModeActive() == false && inverse == false)) {
      return white;
    } else if ((AppTheme.isDarkModeActive() == true && inverse == false) || (AppTheme.isDarkModeActive() == false && inverse == true)) {
      return blue;
    } else {
      return blue;
    }
  }

  static bool isDarkModeActive() {
    return isLightTheme == false;
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline6: GoogleFonts.manrope(
        textStyle: TextStyle(
          color: base.headline6!.color,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle1: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.subtitle1!.color, fontSize: 18),
      ),
      subtitle2: GoogleFonts.manrope(
        textStyle: TextStyle(
          color: base.subtitle2!.color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      bodyText2: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.bodyText2!.color, fontSize: 16),
      ),
      bodyText1: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.bodyText1!.color, fontSize: 14),
      ),
      button: GoogleFonts.manrope(
        textStyle: TextStyle(
          color: base.button!.color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      caption: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.caption!.color, fontSize: 12),
      ),
      headline4: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.headline4!.color, fontSize: 34),
      ),
      headline3: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.headline3!.color, fontSize: 48),
      ),
      headline2: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.headline2!.color, fontSize: 60),
      ),
      headline1: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.headline1!.color, fontSize: 96),
      ),
      headline5: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.headline5!.color, fontSize: 24),
      ),
      overline: GoogleFonts.manrope(
        textStyle: TextStyle(color: base.overline!.color, fontSize: 10),
      ),
    );
  }

  static ThemeData lightTheme() {
    Color primaryColor = HexColor(primaryColorString);
    Color secondaryColor = HexColor(secondaryColorString);
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );

    final ThemeData base = ThemeData.light();
    return base.copyWith(
      appBarTheme: const AppBarTheme(color: Colors.white),
      bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xffd9d6ff)),
      canvasColor: Colors.white,
      cardColor: Colors.white,
      colorScheme: colorScheme.copyWith(background: Colors.white),
      disabledColor: HexColor('#D5D7D8'),
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      indicatorColor: primaryColor,
      platform: TargetPlatform.iOS,
      popupMenuTheme: const PopupMenuThemeData(color: Colors.white),
      primaryColor: primaryColor,
      primaryTextTheme: _buildTextTheme(base.textTheme),
      scaffoldBackgroundColor: const Color(0xfff1efff),
      shadowColor: const Color(0xff211F32),
      splashColor: Colors.white.withOpacity(0.1),
      splashFactory: InkRipple.splashFactory,
      textTheme: _buildTextTheme(base.textTheme),
    );
  }

  static ThemeData darkTheme() {
    Color primaryColor = HexColor(primaryColorString);
    Color secondaryColor = HexColor(secondaryColorString);
    final ColorScheme colorScheme = const ColorScheme.light().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
    );
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      appBarTheme: const AppBarTheme(color: Color(0xff15141F)),
      bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xff211F32)),
      canvasColor: Colors.white,
      cardColor: const Color(0xff211F32),
      colorScheme: colorScheme.copyWith(background: const Color(0xff15141F)),
      indicatorColor: Colors.white,
      platform: TargetPlatform.iOS,
      popupMenuTheme: const PopupMenuThemeData(color: Colors.black),
      primaryColor: primaryColor,
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
      scaffoldBackgroundColor: const Color(0xff363257),
      shadowColor: const Color(0xffF9F9FA),
      splashColor: Colors.white24,
      splashFactory: InkRipple.splashFactory,
      textTheme: _buildTextTheme(base.textTheme),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
