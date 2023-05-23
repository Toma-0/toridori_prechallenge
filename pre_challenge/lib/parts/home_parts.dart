import '../state/import.dart';

class Parts {
//上部にあるスライド選択可能なパーツを作成する
  List<Widget> label_bar(list, context) {
    //タブのリストを作成する
    final List<Widget> tabs = <Tab>[];
    for (var i = 0; i < list.length; i++)
      //ラベルを表示するパーツを作成する
      tabs.add(Tab(
        text: list[i],
      ));

    return tabs;
  }

//コンテンツを表示するパーツを作成する
}
