import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RitualServicesInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.center,
            child: Text(
              'СТК мемориал',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/ritualservice.png',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: 'x1woSpMQfVo',
              flags: const YoutubePlayerFlags(
                hideControls: false,
                mute: false,
                autoPlay: false,
                forceHD: true,
                showLiveFullscreenButton: false,
                controlsVisibleAtStart: true,
                hideThumbnail: true,
              ),
            ),
            showVideoProgressIndicator: true,
            progressIndicatorColor: Color.fromRGBO(42, 76, 113, 1),
            progressColors: const ProgressBarColors(
              playedColor: Color.fromRGBO(42, 76, 113, 1),
              handleColor: Color.fromRGBO(42, 76, 113, 1),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Описание:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Памятники и надгробия. Художественное оформление. Шрифты, портреты, скульптуры. Мемориальные комплексы.Другие ритуальные услуги.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Адрес: Новомосковск, Московская, 34',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async {
              const url = 'http://pamyatniki-tula.ru/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: Text('Перейти на сайт'),
          ),
        ],
      ),
    );
  }
}
