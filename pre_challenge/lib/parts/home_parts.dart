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

  List<Widget> label_drawer(label_list, context,_tabController) {
    final List<Widget> list = [];
    for (var i = 0; i < label_list.length; i++) {
      list.add(
        ListTile(
        title: Text(label_list[i]),
        onTap: () {
          _tabController.animateTo(i);
        },
      ));
    }
    return list;
  }

  //ラベルを表示するためのパーツの作成
  Widget label(text, context) {
    return Tab(
      text: text,
    );
  }

//コンテンツを表示するパーツを作成する
}
