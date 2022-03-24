import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;
import 'package:flutter_svg/flutter_svg.dart';

enum TtsState { playing, stopped, paused, continued }

class MyTts extends StatefulWidget {
  const MyTts({Key key, @required this.text, this.language = "en"})
      : super(key: key);

  final String text, language;

  @override
  State<MyTts> createState() => _MyTtsState();
}

class _MyTtsState extends State<MyTts> {
  FlutterTts flutterTts;
  String language;
  String engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          ttsState = TtsState.continued;
        });
      });

      flutterTts.setErrorHandler((msg) {
        setState(() {
          print("error: $msg");
          ttsState = TtsState.stopped;
        });
      });
    }
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _setLanguage(String language) async {
    await flutterTts.setLanguage(language);
  }

  Future _speak() async {
    await _setLanguage(widget.language);
    var result = await flutterTts.speak(widget.text);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void initState() {
    super.initState();
    initTts();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ttsState.name == "stopped"
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
              onTap: () => _speak(),
              child: SvgPicture.asset("assets/icons/tts_icon.svg",
                  semanticsLabel: "Read aloud"),
            ),
          )
        : IconButton(
            onPressed: () => _stop(), icon: Icon(Icons.stop_circle_rounded));
  }
}
