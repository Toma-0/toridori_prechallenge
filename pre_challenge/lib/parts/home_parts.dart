import '../state/import.dart';
import '../contents.dart';

class Parts {
//上部にあるスライド選択可能なパーツを作成する
  List<Widget> labelBar(list, context) {
    //タブのリストを作成する
    final List<Widget> tabs = <Tab>[];
    for (var i = 0; i < list.length; i++) {
      //ラベルを表示するパーツを作成する
      tabs.add(Tab(
        text: list[i],
      ));
    }

    return tabs;
  }

//コンテンツを表示するパーツを作成する
  Widget contentCard(
      ref, context, int index, number, List comments, title, createdAt, body) {
    Setting().size(context);

    ///日付を取得する
    RegExp regex = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');
    RegExpMatch? match = regex.firstMatch(createdAt);
    late String? year;
    late String? month;
    late String? day;
    late OverlayEntry overlayEntry;

    if (match != null) {
      year = match.group(1);
      month = match.group(2);
      day = match.group(3);
    }

    //カードを作成する
    return Card(
        child: Padding(
      padding: EdgeInsets.all(Setting.w! * 0.01),
      child: Column(
        //左寄せにする
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //番号を表示する
              Text("No.$number",
                  style: Theme.of(context).textTheme.labelMedium),
              Padding(
                padding: EdgeInsets.all(Setting.w! * 0.01),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //コメントのアイコンを表示する
                  Icon(
                    Icons.comment,
                    size: Setting.w! * 0.02,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  //コメントの数を表示する
                  Padding(
                    padding: EdgeInsets.only(left: Setting.w! * 0.01),
                    child: Text(
                      comments.length.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
          //タイトルを表示する
          Padding(
            padding: EdgeInsets.symmetric(vertical: Setting.w! * 0.01),
            child: Row(
              children: [
                //アイコンを表示する
                const Icon(Icons.info_outline, color: Colors.green),
                Padding(
                  padding: EdgeInsets.only(left: Setting.w! * 0.01),
                  //テキストを幅を指定して表示する
                  child: SizedBox(
                    width: Setting.w! * 0.45,
                    child: Text(
                      title,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          //本文を表示する場所を作成する
          DecoratedBox(
              decoration: BoxDecoration(
                  //角丸にする
                  borderRadius: BorderRadius.circular(Setting.w! * 0.01),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color.fromARGB(255, 81, 107, 125)
                      : const Color.fromARGB(255, 236, 247, 255)),
              //本文を表示する
              child: Padding(
                  padding: EdgeInsets.all(Setting.w! * 0.01),
                  child: Text(
                    body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ))),
          //日付を表示する
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Setting.h! * 0.01),
                child: Text(
                  "$year年$month月$day日",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              //コンテンツを広げるためのボタンを表示する
              Align(
                alignment: Alignment.bottomRight,
                child: OutlinedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  onPressed: () {

                    Overlay.of(context).insert(
                       overlayEntry = OverlayEntry(builder: (context) {
                        return Contents().consumers(
                            context,index,ref,overlayEntry);
                      }),
                    );
                  },
                  //ボタンのテキストを表示す
                  child: Text(
                    "View full issue",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
