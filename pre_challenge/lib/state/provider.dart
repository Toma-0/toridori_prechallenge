import 'package:riverpod/riverpod.dart';

//ラベルが格納されているStateProvider
final StateProvider<List> labelProvider = StateProvider((ref) => ["webview","shared_preferences","waiting_for_customer_response","share"]);

//以下GraphQLを利用する必要があるProvider
//お気に入りが格納されているStateNotiferProvider

//表示するコンテンツが含まれているFutureProvider