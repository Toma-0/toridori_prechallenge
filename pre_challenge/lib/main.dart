//importするものをまとめているファイルをインポート
import 'package:pre_challenge/state/import.dart';
import 'package:pre_challenge/state/setting.dart';
import 'parts/home_parts.dart';

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
  ConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

//ホーム画面の動的な部分の状態を管理するWidget
class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  //ラベルのリストを読み込む
  late List list;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final labelList = ref.read(labelProvider);
      setState(() {
        list = labelList;
        _tabController = TabController(length: list.length, vsync: this);
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
    list = ref.watch(labelProvider);
    _tabController = TabController(length: list.length, vsync: this);
    //ラベルよりタブのパーツを取得する
    List<Widget> tab = parts().label_bar(list, context);
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
                TabBar(
                  controller: _tabController,
                  tabs: tab,
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                ),
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
        endDrawer: Drawer(
            child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              for (var i = 0; i < list.length; i++)
                ListTile(
                  title: Text(list[i]),
                  onTap: () {},
                ),
            ],
          ).toList(),
        )),
        body: Home(list, _tabController),
      ),
    );
  }
}

Widget Home(list, tabCon) {
  return TabBarView(controller: tabCon, children: [
    for (int i = 0; i < list.length; i++) Center(child: Text(list[i])),
  ]);
}
