import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:smartrr/generated/l10n.dart';

class ImpactOfSmartRR extends StatefulWidget {
  ImpactOfSmartRR({super.key});

  @override
  State<ImpactOfSmartRR> createState() => _ImpactOfSmartRRState();
}

class _ImpactOfSmartRRState extends State<ImpactOfSmartRR> {
  final voaInterviewLink =
      "https://www.voanews.com/a/covid-19-pandemic_nigeria-rape-reporting-app-helps-survivors-avoid-stigma/6202435.html";

  final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'Yp1buaEzrZk',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Consumer<LanguageNotifier>(
        builder: (context, langNotifier, child) => Scaffold(
              appBar: AppBar(
                title: Text(_language.impactOfSmartRR),
                actions: [LanguagePicker()],
              ),
              body: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller,
                  ),
                  builder: (context, player) => Column(
                        children: [
                          YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                          ),
                          SizedBox(height: 20.0),
                          Text(_language.more),
                          Divider(),
                          ListTile(
                            onTap: () async {
                              await launch(voaInterviewLink,
                                  forceWebView: true, enableJavaScript: true);
                            },
                            title: Text("${_language.interviewWith} VOA"),
                            subtitle: Text(_language.clickToRead),
                          )
                        ],
                      )),
            ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
