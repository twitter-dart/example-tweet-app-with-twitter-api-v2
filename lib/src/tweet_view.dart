import 'package:flutter/material.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';
import 'package:tweet_ui/tweet_ui.dart' as ui;

class TweetView extends StatefulWidget {
  const TweetView({
    Key? key,
    required this.oauthResponse,
  }) : super(key: key);

  final OAuthResponse oauthResponse;

  @override
  State<TweetView> createState() => _TweetViewState();
}

class _TweetViewState extends State<TweetView> {
  final _tweetEditingController = TextEditingController();

  late TwitterApi _twitter;

  TwitterResponse<TweetData, void>? _tweetResponse;

  @override
  void initState() {
    super.initState();

    _twitter = TwitterApi(bearerToken: widget.oauthResponse.accessToken);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_tweetResponse == null)
                TextField(
                  controller: _tweetEditingController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Enter tweet text...',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 3,
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              if (_tweetResponse == null) const SizedBox(height: 20),
              if (_tweetResponse == null)
                ElevatedButton(
                  onPressed: () async {
                    final response = await _twitter.tweetsService.createTweet(
                      text: _tweetEditingController.text,
                    );

                    //! The response after a tweet will not include user data
                    //! or other information. Therefore, detailed tweet data
                    //! must be retrieved again.
                    final tweetResponse =
                        await _twitter.tweetsService.lookupById(
                      tweetId: response.data.id,
                      expansions: [
                        TweetExpansion.authorId,
                      ],
                      userFields: [
                        UserField.profileImageUrl,
                      ],
                    );

                    super.setState(() {
                      _tweetResponse = tweetResponse;
                      _tweetEditingController.clear();
                    });
                  },
                  child: const Text(
                    'Tweet',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              if (_tweetResponse != null)
                ui.TweetView.fromTweetV2(
                  ui.TweetV2Response.fromJson(
                    _tweetResponse!.toJson(),
                  ),
                ),
            ],
          ),
        ),
      );
}
