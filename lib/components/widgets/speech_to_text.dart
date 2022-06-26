import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smartrr/components/screens/user/settings.dart';
import 'package:smartrr/services/database_service.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:ripple_animation/ripple_animation.dart';

class SmartSpeechToText extends StatefulWidget {
  const SmartSpeechToText({Key key}) : super(key: key);

  @override
  State<SmartSpeechToText> createState() => _SmartSpeechToTextState();
}

class _SmartSpeechToTextState extends State<SmartSpeechToText> {
  Key _rippleEffectKey = UniqueKey();

  bool hasSpeech = false;
  final TextEditingController _pauseForController =
      TextEditingController(text: '3');
  final TextEditingController _listenForController =
      TextEditingController(text: '30');
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> localeNames = [];
  final SpeechToText speech = SpeechToText();

  ValueNotifier _recognizedWords = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        hasSpeech = hasSpeech;
      });
    } catch (e) {
      showToast(msg: "Speech recognition failed: ${e.toString()}");
      setState(() {
        hasSpeech = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      child: IconButton(
        tooltip: "Voice assistant",
        icon: Icon(Icons.mic),
        onPressed: () => _startListening(context),
      ),
    );
  }

  void _startListening(BuildContext context) {
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);
    // Note that `listenFor` is the maximum, not the minimun, on some
    // systems recognition will be stopped before this value is reached.
    // Similarly `pauseFor` is a maximum not a minimum and may be ignored
    // on some devices.
    speech
        .listen(
            onResult: resultListener,
            listenFor: Duration(seconds: listenFor ?? 30),
            pauseFor: Duration(seconds: pauseFor ?? 10),
            partialResults: true,
            localeId: _currentLocaleId,
            onSoundLevelChange: soundLevelListener,
            cancelOnError: false,
            listenMode: ListenMode.confirmation)
        .then((_) => showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            context: context,
            builder: (context) => ValueListenableBuilder(
                valueListenable: _recognizedWords,
                builder: (context, _, __) => Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RippleAnimation(
                                repeat: true,
                                key: _rippleEffectKey,
                                color: primaryColor,
                                minRadius: 30,
                                child: Container(
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: Icon(
                                      Icons.mic,
                                    ))),
                            SizedBox(height: 50.0),
                            Text(_recognizedWords.value)
                          ],
                        ),
                      ),
                    ))));
    setState(() {});
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    _recognizedWords.value = result.recognizedWords;
    if (result.finalResult) {
      if (mounted) Navigator.pop(context);

      switch (result.recognizedWords) {
        case "open settings":
          showToast(msg: "Opening settings");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Settings()));
          break;
        case "submit report":
          showToast(msg: "Submitting report");
          DatabaseService().submitQuickReport();
          break;
        case "report case":
          showToast(msg: "Submitting report");
          DatabaseService().submitQuickReport();
          break;
        case "report":
          showToast(msg: "Submitting report");
          DatabaseService().submitQuickReport();
          break;
        case "report a case":
          showToast(msg: "Submitting report");
          DatabaseService().submitQuickReport();
          break;
        default:
          showToast(msg: "Command not recognized");
          break;
      }
    }
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    switch (error.errorMsg) {
      case "error_no_match":
        showToast(msg: "No match", type: "error");
        break;
      case "error_speech_timeout":
        showToast(msg: "Please say something");
        break;
      default:
        showToast(msg: error.errorMsg, type: "error");
        break;
    }
    if (mounted) Navigator.pop(context);
  }

  void statusListener(String status) {
    switch (status) {
      case 'listening':
        _recognizedWords.value = "Listening...";
        break;
      default:
        break;
    }
  }

  void _logEvent(String eventDescription) {
    var eventTime = DateTime.now().toIso8601String();
    print('$eventTime $eventDescription');
  }

  @override
  void dispose() {
    _pauseForController.dispose();
    _listenForController.dispose();
    super.dispose();
  }
}
