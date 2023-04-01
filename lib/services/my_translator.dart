import 'package:translator/translator.dart';

abstract class MyTranslator {
  static Future<String> translate({
    required String text,
    String from = "en",
    String languageCode = "ha",
  }) async {
    if (from == languageCode) return text;
    final translator = GoogleTranslator();

    final translation =
        await translator.translate(text, from: from, to: languageCode);

    return translation.text;
  }
}
