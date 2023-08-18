import 'package:flutter_tts/flutter_tts.dart';

class SpeakRitualServiceInfo {
  late FlutterTts _flutterTts;

  SpeakRitualServiceInfo() {
    _flutterTts = FlutterTts();
  }

  Future<void> speakRitualInfo() async {
    String ritualDescription =
        'Памятники и надгробия. Художественное оформление. Шрифты, портреты, скульптуры. Мемориальные комплексы.Другие ритуальные услуги.';

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
