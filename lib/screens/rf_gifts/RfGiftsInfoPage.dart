import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RfGiftsInfoPage extends StatelessWidget {
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
              'Дары РФ',
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
              'assets/images/rf.png',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: 'Qm1xV_DyhcA',
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
            'Художественная мастерская Дары РФ. Выполняем изделия из арт-бетона.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Адрес: Никольская ул., 9, Донской',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async {
              const url =
                  'https://dary-rf-nikolskaja-ulitsa.clients.site/'; // Замените на ваш URL
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
