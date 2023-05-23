//importするものをまとめているファイルをインポート
import 'package:pre_challenge/state/import.dart';
import 'package:pre_challenge/state/setting.dart';
import "graphql/getInfo.dart";

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
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ライトモード用のテーマ
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(),
      ),
      //ダーク用のテーマ
      darkTheme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
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
    GraphQL().getIssues();
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
        backgroundColor: Color.fromARGB(255, 237, 237, 237),
        //AppBarを生成しない
        extendBodyBehindAppBar: true,
        //タブバーとボタンを重ねる
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          //画面上部にステータスバーを表示させるようにする
          child: Padding(
            padding: EdgeInsets.only(top: y * 0.02),
            //タブバーとボタンを重ねる
            child: Stack(
              children: [
                Consumer(builder: (context, ref, child) {
                  return TabBar(
                    controller: _tabController,
                    tabs: tab,
                    isScrollable: true,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                  );
                }),
                //設定ボタンを右上に表示させる
                Align(
                    alignment: AlignmentDirectional.topEnd,
                    //背景色を設定する
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 237, 237, 237),
                      ),
                      child: IconButton(
                          onPressed: () {
                            //メニューを開く
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                          icon: Icon(Icons.menu)),
                    ))
              ],
            ),
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
                            title: Text(ref.watch(labelProvider)[i]),
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
        body: Home(ref.watch(labelProvider), _tabController),
      ),
    );
  }
}

class Home extends ConsumerWidget {
  final List list;
  final TabController tabCon;
  const Home(this.list, this.tabCon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    return Consumer(builder: (context, watch, child) {
      return TabBarView(controller: tabCon, children: [
        for (int i = 0; i < list.length; i++) Center(child: Text(list[i])),
      ]);
    });
  }
}
