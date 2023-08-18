import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:navigator/screens/api_data/api_data.dart';
import 'package:navigator/screens/components/button_global.dart';
import 'package:navigator/screens/components/text_form_global.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:navigator/screens/home_screen/home_screen.dart';
import 'package:navigator/screens/signup_screen/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  bool shouldShowLogin = false;

  @override
  void initState() {
    super.initState();
    shouldShowLogin = true;
    checkLoggedInStatus(); // Проверка информации о входе
  }

  void loginUser() async {
    final String phoneNumberLogin = phoneNumberController.text;

    try {
      const String apiUrl = ApiData.loginUser;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': phoneNumberLogin,
        }),
      );

      final responseData = jsonDecode(response.body);
      final String message = responseData['message'];

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(
            'isLoggedIn', true); // Сохранение информации о входе
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false, // Закрыть все предыдущие экраны
        );
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color.fromRGBO(62, 51, 41, 1),
              title: Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      showErrorMessage('Ошибка при отправке запроса');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(62, 51, 41, 1),
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void signUpUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/backg.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 4, sigmaY: 4), // Adjust the blur intensity as needed
            child: Container(color: Colors.transparent),
          ),
          shouldShowLogin
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 15.0),
                        Image.asset(
                          'assets/images/splash1.png',
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                        const SizedBox(height: 13.0),
                        const Text(
                          'Пожалуйста,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(25, 25, 25, 1),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'введите номер мобильного телефона',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(25, 25, 25, 1),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormGlobal(
                          controller: phoneNumberController,
                          text: '7XXXXXXXXXX',
                          obscure: false,
                          textInputType: TextInputType.phone,
                          inputFormatters: [PhoneNumberFormatter()],
                        ),
                        const SizedBox(height: 10.0),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 20.0),
                          ),
                        ),
                        const SizedBox(height: 50.0),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              ButtonGlobal(
                                text: "Войти",
                                onTap: loginUser,
                              ),
                              const SizedBox(height: 20.0),
                              ButtonGlobal(
                                text: "Зарегистрироваться",
                                onTap: signUpUser,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void checkLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      if (mounted) {
        setState(() {
          shouldShowLogin = false; // Скрыть страницу авторизации
        });
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      if (mounted) {
        setState(() {
          shouldShowLogin = true; // Показать страницу авторизации
        });
      }
    }
    (Route<dynamic> route) => false;
  }
}
