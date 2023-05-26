import '../state/import.dart';

class WidgetTheme {
  static AppBarTheme? appBarLightTheme;
  static AppBarTheme? appBarDarkTheme;
  static BottomAppBarTheme? bottomAppBarLightTheme;
  static BottomAppBarTheme? bottomAppBarDarkTheme;
  static CardTheme? cardLightTheme;
  static CardTheme? cardDarkTheme;

  //画面が明るいテーマの時のウィジェットの設定
  void lighteWidgetTheme() {
    //アプリバーの明るい時のテーマ
    appBarLightTheme = const AppBarTheme(
      color: Color.fromARGB(255, 237, 237, 237),
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );

    ///ボトムアプリバーの明るい時のテーマ
    bottomAppBarLightTheme = const BottomAppBarTheme(
      color: Color.fromARGB(255, 237, 237, 237),
    );

    //カードの明るい時のテーマ
    cardLightTheme = CardTheme(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(Setting.w! * 0.02),
    );
  }


  //画面が暗いテーマの時のウィジェットの設定
  void darkWidgetTheme() {
    //アプリバーの暗い時のテーマ
    appBarDarkTheme = const AppBarTheme(
      color: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
    );

    //ボトムアプリバーの暗い時のテーマ
    bottomAppBarDarkTheme = const BottomAppBarTheme(
        color: const Color.fromARGB(255, 106, 106, 106));
    
    //カードの暗い時のテーマ
    cardDarkTheme = CardTheme(
      color: Colors.black,
      shadowColor: Colors.white,
      elevation: 5,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      margin: EdgeInsets.all(Setting.w! * 0.02),
    );
  }
}
