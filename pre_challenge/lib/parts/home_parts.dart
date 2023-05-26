import '../state/import.dart';
import '../contents.dart';

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
  Widget contentCard(
      context, int index, number, List comments, title, createdAt, body) {
    Setting().size(context);
    RegExp regex = RegExp(r'^(\d{4})-(\d{2})-(\d{2})');
    RegExpMatch? match = regex.firstMatch(createdAt);
    late String? year;
    late String? month;
    late String? day;

    if (match != null) {
      year = match.group(1);
      month = match.group(2);
      day = match.group(3);
    }

    return Card(
        child: Padding(
      padding: EdgeInsets.all(Setting.w! * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("No.$number",
                  style: Theme.of(context).textTheme.labelMedium),
              Padding(
                padding: EdgeInsets.all(Setting.w! * 0.01),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.comment,
                    size: Setting.w! * 0.02,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: Setting.w! * 0.01),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green),
                Padding(
                  padding: EdgeInsets.only(left: Setting.w! * 0.01),
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
          DecoratedBox(
              decoration: BoxDecoration(
                  //角丸にする
                  borderRadius: BorderRadius.circular(Setting.w! * 0.01),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Color.fromARGB(255, 81, 107, 125)
                      : Color.fromARGB(255, 236, 247, 255)),
              child: Padding(
                  padding: EdgeInsets.all(Setting.w! * 0.01),
                  child: Text(
                    body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ))),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Contents(index:index)),
                    );
                  },
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
