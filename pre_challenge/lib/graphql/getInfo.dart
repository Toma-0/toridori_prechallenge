import 'package:graphql_flutter/graphql_flutter.dart';
import '../state/provider.dart';
import 'accessToken.dart';

class GraphQL {
  void getIssues(ref) async {
    // 1. GitHub GraphQL APIのエンドポイントを指定してHttpLinkを作成
    final HttpLink httpLink = HttpLink(
      'https://api.github.com/graphql',
    );

    // 2. アクセストークンを指定して認証リンクを作成
    String token = Token.token;
    final AuthLink authLink = AuthLink(getToken: () async => 'Bearer $token');

    //後ほど使用するMapを作成
    Map<String, List<dynamic>> mapData = {
      "label": [],
      "number": [],
      "title": [],
      "body": [],
      "createdAt": [],
      "comments": [],
    };

    // 3. 認証リンクとHTTPリンクを連結して最終的なリンクを作成
    final Link link = authLink.concat(httpLink);

    // 4. GraphQLクライアントを作成し、リンクとキャッシュを指定
    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );

    // 5. クエリオプションを作成し、実行するクエリを指定
    final QueryOptions options = QueryOptions(
      document: gql(getIssuesQuery),
    );

    // 6. クエリを実行し、結果を取得
    final QueryResult result = await client.query(options);

    if (result.hasException) {
      // エラーメッセージを表示
      print('GraphQL Error: ${result.exception.toString()}');
    } else {
      // データを解析して表示
      final data = result.data!['repository']['issues']['nodes'];

      for (var issue in data) {
        List labelList = [];
        //先ほど作成したMapにデータを格納
        for (var label in issue['labels']['nodes']) {
          labelList.add(label["name"]);
        }

        mapData["label"]!.add(labelList);
        mapData["number"]!.add(issue['number']);
        mapData["title"]!.add(issue['title']);
        mapData["body"]!.add(issue['body']);
        mapData["createdAt"]!.add(issue['createdAt']);
        mapData["comments"]!.add(issue['comments']['nodes']);
      }
      //取得したデータをProviderに格納
      ref.read(IssueProvider.notifier).addIssues(mapData);
    }
  }

//クエリを指定
  final String getIssuesQuery = '''
    query GetIssues {
      repository(owner: "Toma-0", name: "hakcathon_08") {
        issues(last: 100) {
          nodes {
            number
            title
            body
            createdAt
            labels(first: 100) {
              nodes {
                name
              }
            }
            comments(first: 100) {
              nodes {
                body
              }
            }
          }
        }
      }
    }
  ''';
}
