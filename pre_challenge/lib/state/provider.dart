import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'import.dart';

//ラベルが格納されているLabelNotifier
class LabelNotifier extends Notifier<List> {
  @override
  //初期値を設定
  List build() => [
        "全て",
        "p: webview",
        "p: shared_preferences",
        "waiting for customer response",
        "sever: new feature",
        "p: share"
      ];

  //ラベルを追加する
  void addLabel(String label) {
    state = [...state, label];
  }

  //ラベルを削除する
  void removeLabel(String label) {
    state = state.where((element) => element != label).toList();
  }
}

//ラベルが格納されているlabelProvider
final labelProvider =
    NotifierProvider<LabelNotifier, List>(() => LabelNotifier());

//表示すIssueが含まれている Notifierrovider
class IssueNotifier extends Notifier<Map> {

  //初期値を設定
  @override
  Map build() => {
        "label": [],
        "number": [],
        "title": [],
        "body": [],
        "createdAt": [],
        "comments": []
      };

  //Issueを追加する
  void addIssues(Map issues) {
    Map<String, dynamic> newMap = {};

    state.forEach((key, value) {
      newMap[key] = issues[key];
    });

    state = newMap;
  }
}

//Issueが格納されているIssueProvider
final issueProvider =
    NotifierProvider<IssueNotifier, Map>(() => IssueNotifier());


//お気に入りが格納されているStateNotiferProvider

