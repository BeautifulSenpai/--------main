import 'package:flutter_tts/flutter_tts.dart';

class SpeakRfGiftsInfo {
  late FlutterTts _flutterTts;

  SpeakRfGiftsInfo() {
    _flutterTts = FlutterTts();
  }

  Future<void> speakRfInfo() async {
    String ritualDescription =
        'Художественная мастерская Дары РФ. Выполняем изделия из арт-бетона.';

    await _speak(ritualDescription);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setVoice({
      "name": "ru-ru-x-rud-network",
      "locale": "ru-RU",
      "gender": "male",
    });
    await _flutterTts.speak(text);
  }
}
