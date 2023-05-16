import 'package:pre_challenge/state/setting.dart';

import '../state/import.dart';

class parts {
//上部にあるスライド選択可能なパーツを作成する
  List<Widget> label_bar(list, context) {
    //タブのリストを作成する
    final List<Widget> tabs = <Tab>[];
    for (var i = 0; i < list.length; i++)
      //ラベルを表示するパーツを作成する
      tabs.add(label(list[i], context));
      
    return tabs;
  }

  //ラベルを表示するためのパーツの作成
  Widget label(text, context) {
    Setting().size(context);
    double x = Setting.w!;
    double y = Setting.h!;

    return Tab(
      text: text,
      
    );
  }

//コンテンツを表示するパーツを作成する
}
