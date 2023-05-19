import 'package:riverpod/riverpod.dart';
import 'import.dart';

//ラベルが格納されているStateProvider
final StateProvider<List> labelProvider = StateProvider((ref) => [
      "全て",
      "p: webview",
      "p: shared_preferences",
      "waiting for customer response",
      "sever: new feature",
      "p: share"
    ]);

final StateProvider<int> labelIndexProvider = StateProvider((ref) => ref.watch(labelProvider).length);
//お気に入りが格納されているStateNotiferProvider

//表示するコンテンツが含まれているFutureProvider