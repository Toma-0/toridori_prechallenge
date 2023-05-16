import 'package:riverpod/riverpod.dart';

//ラベルが格納されているStateProvider
final StateProvider<List> labelProvider = StateProvider((ref) => ["全て","p: webview","p: shared_preferences","waiting for customer response","sever: new feature","p: share"]);

//以下GraphQLを利用する必要があるProvider
//お気に入りが格納されているStateNotiferProvider

//表示するコンテンツが含まれているFutureProvider