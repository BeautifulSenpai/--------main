import 'package:flutter_tts/flutter_tts.dart';

class SpeakBullDogInfo {
  late FlutterTts _flutterTts;

  SpeakBullDogInfo() {
    _flutterTts = FlutterTts();
  }

  Future<void> speakBullDogInfo() async {
    String bulldogDescription =
        'Шиномонтаж в Донском. Отремонтируем любой прокол или порез за 5 минут недорого с гарантией на все виды работ!';

    await _speak(bulldogDescription);
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
