import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:navigator/screens/api_data/api_data.dart';
import 'package:http/http.dart' as http;
import 'package:navigator/screens/components/button_global.dart';
import 'package:navigator/screens/components/text_form_global.dart';
import 'dart:convert';

import 'package:navigator/screens/login_screen/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final Function()? onTap;
  const SignUpScreen({super.key, this.onTap});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController phoneNumberController = TextEditingController();

  void signUpUser() async {
    final String phoneNumber = phoneNumberController.text;

    try {
      const String apiUrl = ApiData.registerUser;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phoneNumber': phoneNumber,
        }),
      );

      final responseData = jsonDecode(response.body);
      final String message = responseData['message'];

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/backg.jpg'), // Путь к вашему изображению
                fit: BoxFit.cover, // Размещение изображения на фоне
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 4, sigmaY: 4), // Adjust the blur intensity as needed
            child: Container(color: Colors.transparent),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 13.0),
                  const Text(
                    'Регистрация нового аккаунта',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(25, 25, 25, 1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    'Пожалуйста,',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(25, 25, 25, 1),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'введите номер мобильного телефона',
                    style: TextStyle(
                      fontSize: 14,
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
                          text: "Зарегистрироваться",
                          onTap: signUpUser,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
