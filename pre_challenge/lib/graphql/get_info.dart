import '../state/import.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'access_token.dart';

class GraphQL {
  Future<String> getIssues(ref) async {
    String owner = ref.read(queryProvider)["owner"] ?? "flutter";
    String repoName = ref.read(queryProvider)["repoName"] ?? "flutter";

    //最初のクエリ
    final String getFirstIssuesQuery = '''
    query {
      repository(owner:"$owner", name:"$repoName") {
        issues(first: 100,) {
          nodes {
            number
            title
            body
            createdAt
            labels(first:100) {
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
          pageInfo{
            hasNextPage
            endCursor
          }
        }
      }
    }
  ''';

    //二回目以降のクエリ
    final String getIssuesQuery = '''
    query {
      repository(owner:"$owner", name:"$repoName") {
        issues(first: 100, after: "${ref.read(queryProvider)["issueCursor"]}") {
          nodes {
            number
            title
            body
            createdAt
            labels(first:100) {
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
          pageInfo{
            hasNextPage
            endCursor
          }
        }
      }
    }
  ''';

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
    final QueryOptions options = ref.watch(queryProvider)["first"]
        ? QueryOptions(document: gql(getFirstIssuesQuery))
        : QueryOptions(document: gql(getIssuesQuery));

    // 6. クエリを実行し、結果を取得
    if (ref.watch(queryProvider)["push"]) {
      final QueryResult result = await client.query(options);

      if (result.hasException) {
        // エラーメッセージを表示
        //ロガーを後程使用
        Logger().v('GraphQL Error: ${result.exception.toString()}');
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

        ref.read(issueProvider.notifier).addIssues(mapData);
        ref.read(queryProvider.notifier).infoQuery(
            result.data!['repository']['issues']['pageInfo']['endCursor'],
            result.data!['repository']['issues']['pageInfo']['hasNextPage']); 
      }
    }
  return "ok";
  }
}
