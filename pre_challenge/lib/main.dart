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
  ]).then((_){
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
      home: const MyStatefulWidget(),
    );
  }
}

//ホーム画面の動的な部分を作成するWidget
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

//ホーム画面の動的な部分の状態を管理するWidget
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBarを生成しない
      extendBodyBehindAppBar: true,
      body: Home(),
    );
  }
}

Widget Home() {
  return Container(
    //縦方向にコンテンツを並べる
    child: Column(children: [
      //横方向にラベルを並べる(ドラッグと選択を可能にする)
      Consumer(builder: (context, ref, child) {
        //ラベルを読み込む(更新されたらウィジェットごと更新する)
        List label_list = ref.watch(labelProvider);
        //ラベルを表示するパーツに受け渡す。
        return parts().label_bar(label_list);
      }),

      //センタぃされたラベルに合わせたコンテンツを表示する。
    ]),
  );
}
