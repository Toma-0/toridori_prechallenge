//importするものをまとめているファイルをインポート
import 'package:pre_challenge/state/import.dart';
import 'graphql/get_info.dart';
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
    //getinfoが情報を得るまでの間はローディングを表示する
  FutureBuilder
      //グラフQLを取得する
      getinfo = FutureBuilder(
    future: GraphQL().getIssues(ref),
    builder: (context, snapshot) {
      //データが取得できたら
      if (snapshot.hasData) {
        //ホーム画面を表示する
       
      
    GraphQL().getIssues(ref);

    Setting().size(context);
    ThemaText().lightThemeText(context);
    ThemaText().darkThemeText(context);
    WidgetTheme().lighteWidgetTheme();
    WidgetTheme().darkWidgetTheme();
    return MaterialApp(
      // ライトモード用のテーマ
      theme: ThemeData(
        //アプリバーのテーマ
        appBarTheme: WidgetTheme.appBarLightTheme,
        //ボトムアプリバーのテーマ
        bottomAppBarTheme: WidgetTheme.bottomAppBarLightTheme,
        //カードテーマ
        cardTheme: WidgetTheme.cardLightTheme,
        //テキストテーマ
        textTheme: ThemaText.light,

        //アクセント部分の背景色
        primaryColor: Colors.blue,
        //ウィジェットの背景色
        canvasColor: const Color.fromARGB(255, 237, 237, 237),
        //全体の背景色
        scaffoldBackgroundColor: const Color.fromARGB(255, 237, 237, 237),
      ),

      //ダーク用のテーマ
      darkTheme: ThemeData(
        //アプリバーのテーマ
        appBarTheme: WidgetTheme.appBarDarkTheme,
        //ボトムアプリバーのテーマ
        bottomAppBarTheme: WidgetTheme.bottomAppBarDarkTheme,
        //カードののテーマ
        cardTheme: WidgetTheme.cardDarkTheme,
        //テキストのテーマ
        textTheme: ThemaText.dark,
        //アクセント部分のテーマ
        primaryColor: Colors.blue,
        //ウィジェットの背景色
        canvasColor: const Color.fromARGB(255, 106, 106, 106),
        //全体の背景色
        scaffoldBackgroundColor: const Color.fromARGB(255, 106, 106, 106),
      ),
      // システムのテーマモードに合わせる
      themeMode: ThemeMode.system,
      home: const MyStatefulWidget(),
    );

    } else {
        //ローディングを表示する
        return const Center(child: CircularProgressIndicator());
      }

    },
  );
  return getinfo;
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
  //スナックバーを表示するためのキー
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //タブのコントローラー
  late TabController _tabController;
  //テキストの編集のコントローラー
  final TextEditingController textFieldController = TextEditingController();
  //ラベルの初期設定
  String label = "";

  //タブコントローラーの初期設定
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

  //タブコントローラーの破棄
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  //ホーム画面の動的な部分を作成するWidget

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

        //アプリバーの設定
        appBar: AppBar(
          //アプリバーの高さをステータスバーから0の高さに設定
          titleSpacing: 0,

          title: PreferredSize(
            //タブバーの高さを50に設定
            preferredSize: const Size.fromHeight(50),
            //リバーポッドに監視させる
            child: Consumer(builder: (context, ref, child) {
              //タブバーを作成する
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

        //ドロワーを設定する
        endDrawer: Drawer(
            //リバーポッドに監視させる
            child: Consumer(
          builder: (context, ref, child) {
            //リストを生成する
            return ListView(
              //リストの中身を作成する
              children: ListTile.divideTiles(
                context: context,
                tiles: [
                  //ラベルを表示する
                  for (var i = 0; i < ref.watch(labelProvider).length; i++)
                    SizedBox(
                        child: ListTile(
                            //ラベルを表示する
                            title: Text(
                              ref.watch(labelProvider)[i],
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            onTap: () {
                              //ボタンを押すとタブを切り替える
                              _tabController.animateTo(i);
                              //メニューを閉じる
                              _scaffoldKey.currentState?.closeEndDrawer();
                            })),
                  //ラベルを追加する
                  ListTile(
                    title: SizedBox(
                      height: y * 0.1,
                      child: Column(
                        children: [
                          //大きさを指定する
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            //テキストフィールドを作成する
                            child: TextField(
                              controller: textFieldController,
                              decoration: InputDecoration(
                                //ラベルの表示をする
                                label: const Text(
                                  "ラベルを追加",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                //丸角の枠線を作成する
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: const BorderSide(),
                                ),
                                //フォーカス時の枠線を作成する
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              //入力制限を設定する
                              inputFormatters: [
                                // 英数字、ハイフン、アンダースコアのみ許可
                                FilteringTextInputFormatter(
                                    RegExp(r'^[a-zA-Z0-9\-_]+$'),
                                    allow: true),
                                // 最大50文字まで入力可
                                LengthLimitingTextInputFormatter(50),
                              ],
                              onChanged: (text) {
                                label = text;
                              },
                            ),
                          )),

                          //ボタンを押すとラベルを追加する
                          ElevatedButton(
                              onPressed: () {
                                //Providerの更新
                                ref
                                    .read(labelProvider.notifier)
                                    .addLabel(label);
                                textFieldController.clear();
                              },
                              child: const Text("追加")),
                        ],
                      ),
                    ),

                    //余白を設定する
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
  const Home(this.ref, this.tabCon, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    //たぶの中身を作成する
    return TabBarView(
      controller: tabCon,
      children: [
        //全てのラベルに対して以下の動作を行う。
        for (int i = 0; i < ref.watch(labelProvider).length; i++)
          //スクロールをできるようにする
          SingleChildScrollView(
            //縦にコンテンツを並べる
            child: Column(
              children: [
                Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Issueの数だけ以下の動作を行う
                    for (int j = 0;
                        j < ref.watch(issueProvider)["number"].length;
                        j++)
                      //ラベルがすべての時はすべてのIssueを表示する
                      i == 0
                          ? Parts().contentCard(
                              ref,
                              context,
                              j,
                              ref.watch(issueProvider)["number"][j],
                              ref.watch(issueProvider)["comments"][j],
                              ref.watch(issueProvider)["title"][j],
                              ref.watch(issueProvider)["createdAt"][j],
                              ref.watch(issueProvider)["body"][j])
                          : ref
                                  .watch(issueProvider)["label"][j]
                                  .contains(ref.watch(labelProvider)[i])
                              //ラベルが全てではなく一致する時はそのラベルのIssueを表示する
                              ? Parts().contentCard(
                                  ref,
                                  context,
                                  j,
                                  ref.watch(issueProvider)["number"][j],
                                  ref.watch(issueProvider)["comments"][j],
                                  ref.watch(issueProvider)["title"][j],
                                  ref.watch(issueProvider)["createdAt"][j],
                                  ref.watch(issueProvider)["body"][j])
                              : Container()
                  ],
                )),
                ElevatedButton(
                    onPressed: () {
                      ref.read(queryProvider.notifier).push();
                      GraphQL().getIssues(ref);
                    },
                    child: const Text("追加")),
              ],
            ),
          )
      ],
    );
  }
}
