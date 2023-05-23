import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQL {
  void getIssues() async {
    // 1. GitHub GraphQL APIのエンドポイントを指定してHttpLinkを作成
    final HttpLink httpLink = HttpLink(
      'https://api.github.com/graphql',
    );

    // 2. アクセストークンを指定して認証リンクを作成
    final AuthLink authLink = AuthLink(
        getToken: () async =>
            'Bearer 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'
        );

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
    print(result.data);
    if (result.hasException) {
      // エラーメッセージを表示
      print('GraphQL Error: ${result.exception.toString()}');
    } else {
      // データを解析して表示
      final data = result.data!['repository']['issues']['nodes'];
      for (var issue in data) {
        final number = issue['number'];
        final title = issue['title'];
        final body = issue['body'];
        final author = issue['author']['login'];
        final comments = issue['comments']['nodes'];

        // イシューの情報を出力
        print('Issue Number: $number');
        print('Title: $title');
        print('Body: $body');
        print('Author: $author');

        // コメントを出力
        print('Comments:');
        for (var comment in comments) {
          final commentBody = comment['body'];
          print(commentBody);
        }

        print('----------------------');
      }
    }
  }

  final String getIssuesQuery = '''
    query GetIssues {
      repository(owner: "flutter", name: "flutter") {
        issues(first: 10) {
          nodes {
            number
            title
            body
            author {
              login
            }
            comments(first: 10) {
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
