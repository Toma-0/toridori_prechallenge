import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'import.dart';

//ラベルが格納されているStateProvider

class LabelNotifier extends Notifier<List> {
  @override
  List build() => [
        "全て",
        "p: webview",
        "p: shared_preferences",
        "waiting for customer response",
        "sever: new feature",
        "p: share"
      ];

  void addLabel(String label) {
    state = [...state, label];
  }

  void removeLabel(String label) {
    state = state.where((element) => element != label).toList();
  }
}

final labelProvider =
    NotifierProvider<LabelNotifier, List>(() => LabelNotifier());

//お気に入りが格納されているStateNotiferProvider

//表示するコンテンツが含まれているFutureProvider
class IssueNotifier extends Notifier<Map> {
  @override
  Map build() => {
        "label": [],
        "number": [],
        "title": [],
        "body": [],
        "createdAt": [],
        "comments": []
      };

  void addIssues(Map Issues) {
    Map<String, dynamic> newMap = {};

    state.forEach((key, value) {
      newMap[key] = Issues[key];
    });

    state = newMap;
  }
}

final IssueProvider =
    NotifierProvider<IssueNotifier, Map>(() => IssueNotifier());
