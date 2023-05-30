import 'state/import.dart';

//コンテンツページ
class Contents {
  Widget consumers(context, index, ref, overlayEntry) {
    Setting().size(context);
    var issue = ref.watch(issueProvider);

    var number = issue["number"]![index];
    var title = issue["title"]![index];
    var body = issue["body"]![index];
    var createdAt = issue["createdAt"]![index];
    var comments = issue["comments"]![index];

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
    return Stack(
    children: [
      // オーバーレイの背景に透明なGestureDetectorを配置
      Positioned.fill(
        child: GestureDetector(
          onTap: () {
            // タップされたときにオーバーレイを閉じる
            overlayEntry.remove();
          },
          child:SingleChildScrollView(
      child: Card(
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
                  const Icon(Icons.info_outline, color: Colors.green),
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
                        ? const Color.fromARGB(255, 81, 107, 125)
                        : const Color.fromARGB(255, 236, 247, 255)),
                child: Padding(
                    padding: EdgeInsets.all(Setting.w! * 0.01),
                    child: Text(
                      body,
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
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: Setting.h! * 0.01),
                  child: Row(
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
                          "${comments.length.toString()} comments",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                if (comments.length != 0)
                for (var i = 0; i < issue["comments"]!.length; i++)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Setting.h! * 0.01),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Setting.w! * 0.01),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Setting.h! * 0.01),
                        child: Text(
                          issue["comments"][i].toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            TextButton(
                onPressed: () {
                  overlayEntry.remove();
                },
                child: Text(
                  "閉じる",
                  style: Theme.of(context).textTheme.labelMedium,
                )),
          ],
        ),
      )),
          )
        )
      )
    ],
    );
  }
}
