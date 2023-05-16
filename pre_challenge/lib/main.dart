//importするものをまとめているファイルをインポート
import 'package:pre_challenge/state/import.dart';
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
class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    //ラベルのリストを読み込む
    List list = ref.watch(labelProvider);

    //ラベルよりタブのパーツを取得する
    List<Widget> tab = parts().label_bar(list, context);
    return SafeArea(
      child: DefaultTabController(
        length: tab.length,
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 237, 237, 237),
          //AppBarを生成しない
          extendBodyBehindAppBar: true,
          //タブバーとボタンを重ねる
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            //タブバーとボタンを重ねる
            child: Stack(
              children: [
                TabBar(
              tabs: tab,
              isScrollable: true,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(onPressed: (){}, icon: Icon(Icons.settings)),
            )
              ],
            )
            
          ),
          body: Home(),
        ),
      ),
    );
  }
}

Widget Home() {
  return Container(
    //縦方向にコンテンツを並べる
    child: Column(children: [
      //横方向にラベルを並べる(ドラッグと選択を可能にする)

      //センタぃされたラベルに合わせたコンテンツを表示する。
    ]),
  );
}
