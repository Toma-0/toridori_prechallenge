import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQL {
  void getIssues() async {
    final HttpLink httpLink = HttpLink(
      'https://api.github.com/graphql', // GitHub GraphQL APIのエンドポイント
    );

    final AuthLink authLink = AuthLink(
        getToken: () async =>
            'Bearer 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' // GitHubアクセストークンを指定
        );

    final Link link = authLink.concat(httpLink); // AuthLinkとHttpLinkを連結

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: link, // 修正: linkを指定する
    );

    final QueryOptions options = QueryOptions(
      document: gql(getIssuesQuery),
    );

    final QueryResult result = await client.query(options);
    print(result.data);
    if (result.hasException) {
      print('GraphQL Error: ${result.exception.toString()}');
    } else {
      final data = result.data!['repository']['issues']['nodes'];
      for (var issue in data) {
        final number = issue['number'];
        final title = issue['title'];
        final body = issue['body'];
        final author = issue['author']['login'];
        final comments = issue['comments']['nodes'];

        print('Issue Number: $number');
        print('Title: $title');
        print('Body: $body');
        print('Author: $author');

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
