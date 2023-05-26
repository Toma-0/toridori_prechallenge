import '../state/import.dart';

//画面やUI全体に関わる設定を行うクラス
class Setting {
  static double? h;
  static double? w;

//レスポンシブデザインのためのサイズを取得する
  void size(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.height;
  }
}
