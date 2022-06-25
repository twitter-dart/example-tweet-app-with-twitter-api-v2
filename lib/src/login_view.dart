import 'package:example/src/tweet_view.dart';
import 'package:flutter/material.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _oauth2 = TwitterOAuth2Client(
    clientId: 'YOUR_CLIENT_ID',
    clientSecret: 'YOUR_CLIENT_SECRET',
    redirectUri: 'org.example.android.oauth://callback/',
    customUriScheme: 'org.example.android.oauth',
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final response = await _oauth2.executeAuthCodeFlowWithPKCE(
                scopes: [
                  Scope.tweetRead,
                  Scope.tweetWrite,
                  Scope.usersRead,
                ],
              );

              if (!mounted) {
                return;
              }

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TweetView(oauthResponse: response),
                ),
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
}
