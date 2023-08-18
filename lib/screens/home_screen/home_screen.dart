import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:navigator/screens/bulldog/BullDogHandler.dart';
import 'package:navigator/screens/login_screen/login_screen.dart';
import 'package:navigator/screens/rf_gifts/RfHandler.dart';
import 'package:navigator/screens/ritual_service/RitualHandlre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../voice_assistant/voice_responces.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late SpeechToText _speechToText;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _assistantResponse = "";
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;
  YandexMapController? yandexMapController;
  Point? userLocation;
  PlacemarkMapObject? userPlacemark;
  PlacemarkMapObject? startIconPlacemark; // New: Icon for start location
  PlacemarkMapObject? endIconPlacemark; // New: Icon for end location
  List<MapObject> mapObjects = [];
  bool _isRouteBuilt = false;

  @override
  void initState() {
    super.initState();
    _speechToText = SpeechToText();
    _flutterTts = FlutterTts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _colorAnimation = ColorTween(
      begin: const Color.fromRGBO(42, 76, 113, 1),
      end: const Color.fromRGBO(186, 184, 184, 1),
    ).animate(_animationController);
    _requestMicrophonePermission();
    Geolocator.requestPermission();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      print("Разрешение на использование микрофона получено!");
    } else {
      print("Разрешение на использование микрофона не получено!");
    }
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onError: (error) {},
      );

      if (available) {
        setState(() {
          _isListening = true;
          _assistantResponse = "Говорите...";
        });

        _startListening();
      }
    }
  }

  void _startListening() {
    _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 10),
      partialResults: true,
      localeId: "ru_RU",
    );
  }

  Future<void> _stopListening() async {
    if (_isListening) {
      await Future.delayed(const Duration(seconds: 2));
      _speechToText.stop();
      setState(() {
        _isListening = false;
      });
      _speak(_assistantResponse);
    }
  }

  void _speak(String text) async {
    await _flutterTts.setVoice({
      "name": "ru-ru-x-rud-network",
      "locale": "ru-RU",
      "gender": "male",
    });
    await _flutterTts.speak(text);
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    String command = result.recognizedWords;
    setState(() {
      _assistantResponse = VoiceResponses.getResponseForCommand(command);
    });

    if (command.toLowerCase().contains("ритуальные услуги")) {
      _showRitualServicesOnMap();
    }

    if (command.toLowerCase().contains("памятники")) {
      _showRitualServicesOnMap();
    }

    if (command.toLowerCase().contains("надгробия")) {
      _showRitualServicesOnMap();
    }

    if (command.toLowerCase().contains("стк мемориал")) {
      _showRitualServicesOnMap();
    }

    if (command.toLowerCase().contains("художственная мастерская")) {
      _showRfGiftsOnMap();
    }

    if (command.toLowerCase().contains("дары рф")) {
      _showRfGiftsOnMap();
    }

    if (command.toLowerCase().contains("шиномонтаж")) {
      _showBullDogOnMap();
    }

    if (command.toLowerCase().contains("шиномонтаж бульдог")) {
      _showBullDogOnMap();
    }

    if (command.toLowerCase().contains("бульдог")) {
      _showBullDogOnMap();
    }

    if (command.toLowerCase().contains("построй маршрут до ритуальных услуг")) {
      _routeRitualService();
    }

    if (command
        .toLowerCase()
        .contains("построй маршрут до художественной мастерской")) {
      _routeRfGifts();
    }

    if (command.toLowerCase().contains("построй маршрут до шиномонтаж")) {
      _routeBullDog();
    }

    if (command.toLowerCase().contains("где я")) {
      _updateUserLocation();
    }
  }

  Future<void> _showBullDogOnMap() async {
    const latitude = 53.969617;
    const longitude = 38.315070;

    // Отправляем запрос на сервер Node.js для получения точки по заданным координатам
    final response = await http.get(
      Uri.parse(
          'http://62.217.182.138:3000/getPointPes?latitude=$latitude&longitude=$longitude'),
    );

    if (response.statusCode == 200) {
      // Если точка найдена, продолжаем отображение точки на карте
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // ignore: unused_local_variable
      final String id = responseData['id'] ??
          'Не найдено'; // Используем значение по умолчанию

      // Создаем маркер для ресторана
      var bulldogPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('bulldog_placemark'),
        point: const Point(latitude: latitude, longitude: longitude),
        opacity: 0.8,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/location.png',
            ),
          ),
        ),
      );

      // Добавляем маркер на карту
      mapObjects.add(bulldogPlacemark);

      // Перемещаем камеру к указанной точке (ресторану)
      await yandexMapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: Point(
              latitude: latitude,
              longitude: longitude,
            ),
            zoom: 15.0,
          ),
        ), // Можете настроить зум по своему усмотрению
      );
    } else if (response.statusCode == 404) {
      // Если точка не найдена, обрабатываем ошибку
      // ignore: avoid_print
      print('Point not found.');
    } else {
      // Обработка ошибок при запросе данных с сервера
      // ignore: avoid_print
      print('Error fetching point: ${response.body}');
    }
  }

  void _routeBullDog() async {
    Position position = await Geolocator.getCurrentPosition();

    yandexMapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          zoom: 14.0,
        ),
      ),
    );

    var sessionResult = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          requestPointType: RequestPointType.wayPoint,
        ),
        const RequestPoint(
          point: Point(latitude: 53.969617, longitude: 38.315070),
          requestPointType: RequestPointType.wayPoint,
        ),
      ],
      drivingOptions: const DrivingOptions(
        initialAzimuth: 0,
        routesCount: 1,
        avoidTolls: true,
      ),
    );

    DrivingSessionResult result = await sessionResult.result;

    // Clear previous route and icons
    setState(() {
      mapObjects.clear();
    });

    // Add start and end icons to the map
    setState(() {
      userPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('user_placemark'),
        point: Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        opacity: 0.8,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/user.png',
            ),
          ),
        ),
      );

      mapObjects.add(userPlacemark!);

      startIconPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('start_placemark'),
        point: Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      endIconPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('end_placemark'),
        point: const Point(latitude: 53.969617, longitude: 38.315070),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/location.png',
            ),
          ),
        ),
      );

      mapObjects.add(startIconPlacemark!);
      mapObjects.add(endIconPlacemark!);
    });

    // Draw the route on the map
    setState(() {
      result.routes!.asMap().forEach((i, route) {
        mapObjects.add(
          PolylineMapObject(
            mapId: MapObjectId('route_${i}_polyline'),
            polyline: Polyline(points: route.geometry),
            strokeColor: Colors.green.shade600,
            strokeWidth: 3,
          ),
        );
      });
      _isRouteBuilt = true;
    });
  }

  Future<void> _showRfGiftsOnMap() async {
    const latitude = 53.962625;
    const longitude = 38.354072;

    // Отправляем запрос на сервер Node.js для получения точки по заданным координатам
    final response = await http.get(
      Uri.parse(
          'http://62.217.182.138:3000/getPointPes?latitude=$latitude&longitude=$longitude'),
    );

    if (response.statusCode == 200) {
      // Если точка найдена, продолжаем отображение точки на карте
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // ignore: unused_local_variable
      final String id = responseData['id'] ??
          'Не найдено'; // Используем значение по умолчанию

      // Создаем маркер для ресторана
      var rfPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('rf_placemark'),
        point: const Point(latitude: latitude, longitude: longitude),
        opacity: 0.8,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/location.png',
            ),
          ),
        ),
      );

      // Добавляем маркер на карту
      mapObjects.add(rfPlacemark);

      // Перемещаем камеру к указанной точке (ресторану)
      await yandexMapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: Point(
              latitude: latitude,
              longitude: longitude,
            ),
            zoom: 15.0,
          ),
        ), // Можете настроить зум по своему усмотрению
      );
    } else if (response.statusCode == 404) {
      // Если точка не найдена, обрабатываем ошибку
      // ignore: avoid_print
      print('Point not found.');
    } else {
      // Обработка ошибок при запросе данных с сервера
      // ignore: avoid_print
      print('Error fetching point: ${response.body}');
    }
  }

  void _routeRfGifts() async {
    Position position = await Geolocator.getCurrentPosition();

    yandexMapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          zoom: 14.0,
        ),
      ),
    );

    var sessionResult = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          requestPointType: RequestPointType.wayPoint,
        ),
        const RequestPoint(
          point: Point(latitude: 53.962625, longitude: 38.354072),
          requestPointType: RequestPointType.wayPoint,
        ),
      ],
      drivingOptions: const DrivingOptions(
        initialAzimuth: 0,
        routesCount: 1,
        avoidTolls: true,
      ),
    );

    DrivingSessionResult result = await sessionResult.result;

    // Clear previous route and icons
    setState(() {
      mapObjects.clear();
    });

    // Add start and end icons to the map
    setState(() {
      userPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('user_placemark'),
        point: Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        opacity: 0.8,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/user.png',
            ),
          ),
        ),
      );

      mapObjects.add(userPlacemark!);

      startIconPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('start_placemark'),
        point: Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      endIconPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('end_placemark'),
        point: const Point(latitude: 53.962625, longitude: 38.354072),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/location.png',
            ),
          ),
        ),
      );

      mapObjects.add(startIconPlacemark!);
      mapObjects.add(endIconPlacemark!);
    });

    // Draw the route on the map
    setState(() {
      result.routes!.asMap().forEach((i, route) {
        mapObjects.add(
          PolylineMapObject(
            mapId: MapObjectId('route_${i}_polyline'),
            polyline: Polyline(points: route.geometry),
            strokeColor: Colors.green.shade600,
            strokeWidth: 3,
          ),
        );
      });
      _isRouteBuilt = true;
    });
  }

  Future<void> _showRitualServicesOnMap() async {
    const latitude = 54.018162;
    const longitude = 38.297166;

    // Отправляем запрос на сервер Node.js для получения точки по заданным координатам
    final response = await http.get(
      Uri.parse(
          'http://62.217.182.138:3000/getPointPes?latitude=$latitude&longitude=$longitude'),
    );

    if (response.statusCode == 200) {
      // Если точка найдена, продолжаем отображение точки на карте
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      // ignore: unused_local_variable
      final String id = responseData['id'] ??
          'Не найдено'; // Используем значение по умолчанию

      // Создаем маркер для ресторана
      var ritualPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('ritual_placemark'),
        point: const Point(latitude: latitude, longitude: longitude),
        opacity: 0.8,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/location.png',
            ),
          ),
        ),
      );

      // Добавляем маркер на карту
      mapObjects.add(ritualPlacemark);

      // Перемещаем камеру к указанной точке (ресторану)
      await yandexMapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: Point(
              latitude: latitude,
              longitude: longitude,
            ),
            zoom: 15.0,
          ),
        ), // Можете настроить зум по своему усмотрению
      );
    } else if (response.statusCode == 404) {
      // Если точка не найдена, обрабатываем ошибку
      // ignore: avoid_print
      print('Point not found.');
    } else {
      // Обработка ошибок при запросе данных с сервера
      // ignore: avoid_print
      print('Error fetching point: ${response.body}');
    }
  }

  void _routeRitualService() async {
    Position position = await Geolocator.getCurrentPosition();

    yandexMapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          zoom: 14.0,
        ),
      ),
    );

    var sessionResult = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(
          point: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          requestPointType: RequestPointType.wayPoint,
        ),
        const RequestPoint(
          point: Point(latitude: 54.018162, longitude: 38.297166),
          requestPointType: RequestPointType.wayPoint,
        ),
      ],
      drivingOptions: const DrivingOptions(
        initialAzimuth: 0,
        routesCount: 1,
        avoidTolls: true,
      ),
    );

    DrivingSessionResult result = await sessionResult.result;

    // Clear previous route and icons
    setState(() {
      mapObjects.clear();
    });

    // Add start and end icons to the map
    setState(() {
      userPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('user_placemark'),
        point: Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        opacity: 0.8,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/user.png',
            ),
          ),
        ),
      );

      mapObjects.add(userPlacemark!);

      startIconPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('start_placemark'),
        point: Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      endIconPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('end_placemark'),
        point: const Point(latitude: 54.018162, longitude: 38.297166),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/location.png',
            ),
          ),
        ),
      );

      mapObjects.add(startIconPlacemark!);
      mapObjects.add(endIconPlacemark!);
    });

    // Draw the route on the map
    setState(() {
      result.routes!.asMap().forEach((i, route) {
        mapObjects.add(
          PolylineMapObject(
            mapId: MapObjectId('route_${i}_polyline'),
            polyline: Polyline(points: route.geometry),
            strokeColor: Colors.green.shade600,
            strokeWidth: 3,
          ),
        );
      });
      _isRouteBuilt = true;
    });
  }

  void _updateUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      userPlacemark = PlacemarkMapObject(
        mapId: const MapObjectId('user_placemark'),
        point: Point(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        opacity: 0.8,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage(
              'assets/images/user.png',
            ),
          ),
        ),
      );
    });

    yandexMapController?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
          zoom: 14.0,
        ),
      ),
    );
    mapObjects.add(userPlacemark!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: const Color.fromRGBO(42, 76, 113, 1),
          title: const Text(
            'Карта',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () => logout(),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              yandexMapController = controller;
              yandexMapController?.moveCamera(
                CameraUpdate.newCameraPosition(
                  const CameraPosition(
                    target: Point(
                      latitude: 53.97,
                      longitude: 38.33,
                    ),
                    zoom: 14.0,
                  ),
                ),
              );
            },
            mapObjects: mapObjects,
            onMapTap: (point) {
              RfHandler.handleMapTap(context, point.latitude, point.longitude);
              RitualHandler.handleMapTap(
                  context, point.latitude, point.longitude);
              BullDogHandler.handleMapTap(
                  context, point.latitude, point.longitude);
            },
          ),
          Positioned(
            left: 16.0,
            bottom: 40.0,
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ElevatedButton(
                onPressed: _updateUserLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(42, 76, 113, 1),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(16.0),
                  elevation: 0,
                ),
                child: const Icon(Icons.location_pin),
              ),
            ),
          ),
          if (_isRouteBuilt) // Условие для отображения кнопки
            Positioned(
              right: 16.0,
              bottom: 40.0,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    mapObjects.clear();

                    _isRouteBuilt = false;
                  });
                },
                child: const Icon(Icons.clear),
                backgroundColor: Colors.red,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(42, 76, 113, 1),
        shape: const CircularNotchedRectangle(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _routeRitualService,
                icon: Icon(Icons.route),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTapDown: (details) {
          if (!_isListening) {
            _animationController.forward();
            _listen();
          }
        },
        onTapUp: (details) {
          if (_isListening) {
            _animationController.reverse();
            _stopListening();
          }
        },
        onTapCancel: () {
          if (_isListening) {
            _animationController.reverse();
            _stopListening();
          }
        },
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.mic_rounded),
              backgroundColor: _colorAnimation.value,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Сброс информации о входе
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

class Comment {
  final String username;
  final int rating;
  final String text;

  Comment(this.username, this.rating, this.text);
}
