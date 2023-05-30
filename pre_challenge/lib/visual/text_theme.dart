import '../state/import.dart';

//画面やUI全体に関わる設定を行うクラス
class ThemaText {
  static TextTheme? light;
  static TextTheme? dark;

  //画面が明るいテーマの時のテキストの設定
  void lightThemeText(context) {
    light = const TextTheme(
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        color: Color.fromARGB(255, 70, 70, 70),
        fontSize: 12,
      ),
      labelSmall: TextStyle(
        color: Colors.black,
        fontSize: 10,
        wordSpacing: 1.5,
      ),
      bodyMedium: TextStyle(
        color: Color.fromARGB(255, 124, 124, 124),
        fontSize: 12,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: Colors.black,
        fontSize: 10,
      ),
    );
  }

  //画面が暗いテーマの時のテキストの設定
  void darkThemeText(context) {
    dark = const TextTheme(
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      labelMedium:
          TextStyle(color: Color.fromARGB(255, 245, 245, 245), fontSize: 13),
      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 10,
        wordSpacing: 1.5,
      ),
      bodyMedium: TextStyle(
        color: Color.fromARGB(255, 248, 248, 248),
        fontSize: 12,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 10,
      ),
    );
  }
}
