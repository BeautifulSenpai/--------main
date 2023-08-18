import 'package:flutter/material.dart';
import 'package:navigator/screens/ritual_service/RitualServicesInfoPage.dart';

class ShowRitualServicesInfo {
  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(42, 76, 113, 1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: SizedBox(
              height: 650,
              child: PageView(
                children: [
                  RitualServicesInfoPage(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
