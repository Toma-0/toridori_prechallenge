//importするものをまとめているファイルをインポート
import 'package:pre_challenge/state/import.dart';
import 'package:pre_challenge/state/setting.dart';
import "graphql/getInfo.dart";
import 'package:flutter/material.dart';
import "parts/home_parts.dart";

void main() {
  //flutterの初期化
  WidgetsFlutterBinding.ensureInitialized();
  //画面を縦向きに固定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    //Providerに監視させる
    runApp(const ProviderScope(child: MyApp()));
  });
}

//ホーム画面の大まかなテーマなどを作成するWidget
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    GraphQL().getIssues(ref);
    Setting().size(context);
    return MaterialApp(
      // ライトモード用のテーマ
      theme: ThemeData(
        //アプリバーのテーマ
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 237, 237, 237),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),

        //アクセント部分のテーマ
        primaryColor: Colors.blue,

        //背景色のテーマ
        canvasColor: Color.fromARGB(255, 237, 237, 237),
        scaffoldBackgroundColor: Color.fromARGB(255, 237, 237, 237),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Color.fromARGB(255, 237, 237, 237),
        ),

        //カードテーマ
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.black,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.all(Setting.w! * 0.02),
        ),
        textTheme: const TextTheme(
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
        ),
      ),
      //ダーク用のテーマ
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),

        //アクセント部分のテーマ
        primaryColor: Colors.blue,

        //背景色のテーマ
        canvasColor: const Color.fromARGB(255, 106, 106, 106),
        scaffoldBackgroundColor: const Color.fromARGB(255, 106, 106, 106),
        bottomAppBarTheme: BottomAppBarTheme(color: const Color.fromARGB(255, 106, 106, 106)),

        //カードの背景のテーマ
        cardColor: Colors.black,

        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: TextStyle(
            color: Color.fromARGB(255, 245, 245, 245),
            fontSize: 13
          ),
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
        ),
      ),
      // システムのテーマモードに合わせる
      themeMode: ThemeMode.system,
      home: const MyStatefulWidget(),
    );
  }
}

//ホーム画面の動的な部分を作成するWidget
class MyStatefulWidget extends ConsumerStatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<MyStatefulWidget> createState() => MyStatefulWidgetState();
}

//ホーム画面の動的な部分の状態を管理するWidget
class MyStatefulWidgetState extends ConsumerState<MyStatefulWidget>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  //ラベルのリストを読み込む

  final TextEditingController textFieldController = TextEditingController();
  String label = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _tabController =
            TabController(length: ref.watch(labelProvider).length, vsync: this);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Setting().size(context);
    double y = Setting.h!;
    //グラフQLを取得する
    _tabController =
        TabController(length: ref.watch(labelProvider).length, vsync: this);
    //ラベルよりタブのパーツを取得する
    List<Widget> tab = [
      for (var i = 0; i < ref.watch(labelProvider).length; i++)
        Tab(
          text: ref.watch(labelProvider)[i],
        )
    ];

    return DefaultTabController(
      length: tab.length,
      child: Scaffold(
        key: _scaffoldKey,

        //タブバーとボタンを重ねる
        appBar: AppBar(
          titleSpacing: 0,
          title: PreferredSize(
            preferredSize: Size.fromHeight(50),
            //画面上部にステータスバーを表示させるようにする
            child: Consumer(builder: (context, ref, child) {
              return TabBar(
                controller: _tabController,
                tabs: tab,
                isScrollable: true,
                labelColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              );
            }),
          ),
        ),

        endDrawer: Drawer(child: Consumer(
          builder: (context, ref, child) {
            return ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  for (var i = 0; i < ref.watch(labelProvider).length; i++)
                    SizedBox(
                        child: ListTile(
                            title: Text(ref.watch(labelProvider)[i],
                                style: Theme.of(context).textTheme.labelMedium,),
                            onTap: () {
                              _tabController.animateTo(i);
                              //メニューを閉じる
                              _scaffoldKey.currentState?.closeEndDrawer();
                            })),
                  ListTile(
                    title: SizedBox(
                      height: y * 0.1,
                      child: Column(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: textFieldController,
                              decoration: InputDecoration(
                                label: Text(
                                  "ラベルを追加",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: BorderSide(),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter(
                                    RegExp(r'^[a-zA-Z0-9\-_]+$'),
                                    allow: true), // 英数字、ハイフン、アンダースコアのみ許可
                                LengthLimitingTextInputFormatter(
                                    50), // 最大50文字まで入力可
                              ],
                              onChanged: (text) {
                                label = text;
                              },
                            ),
                          )),
                          ElevatedButton(
                              onPressed: () {
                                //Providerの更新
                                ref
                                    .read(labelProvider.notifier)
                                    .addLabel(label);
                                textFieldController.clear();
                              },
                              child: Text("追加")),
                        ],
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                        top: (y * 0.9 -
                            (ref.watch(labelProvider).length + 1) *
                                (y * 0.05))),
                  ),
                ],
              ).toList(),
            );
          },
        )),
        body: Home(ref, _tabController),
      ),
    );
  }
}

class Home extends ConsumerWidget {
  final WidgetRef ref;
  final TabController tabCon;
  Home(this.ref, this.tabCon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    //ラベルに対して表示するインデックスを保存する

    return TabBarView(
      controller: tabCon,
      children: [
        for (int i = 0; i < ref.watch(labelProvider).length; i++)
          SingleChildScrollView(
            child: Column(
              children: [
                //全てのラベルを表示する
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int j = 0; j < ref.watch(IssueProvider)["number"].length; j++)
                    i==0 ?
                      Parts().contentCard(
                          context,
                          j,
                          ref.watch(IssueProvider)["number"][j],
                          ref.watch(IssueProvider)["comments"][j],
                          ref.watch(IssueProvider)["title"][j],
                          ref.watch(IssueProvider)["createdAt"][j],
                          ref.watch(IssueProvider)["body"][j])
                          
                          :ref.watch(IssueProvider)["label"][j].contains(ref.watch(labelProvider)[i])?
                          Parts().contentCard(
                          context,
                          j,
                          ref.watch(IssueProvider)["number"][j],
                          ref.watch(IssueProvider)["comments"][j],
                          ref.watch(IssueProvider)["title"][j],
                          ref.watch(IssueProvider)["createdAt"][j],
                          ref.watch(IssueProvider)["body"][j]):Container()
                  ],
                )),
              ],
            ),
          )
      ],
    );
  }
}
