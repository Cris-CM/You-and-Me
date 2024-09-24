import 'dart:async';

import 'package:easy_padding/easy_padding.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:you_and_me/core/colors/palette.dart';
import 'package:you_and_me/core/home/album_page.dart';
import 'package:you_and_me/core/widgets/texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _startDate;
  Duration _timeTogether = const Duration();
  Timer? _timer;
  bool _isCounting = false;

  @override
  void initState() {
    super.initState();
    _loadStartDate();
  }

  Future<void> _loadStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? startTimestamp = prefs.getInt('startDate');

    if (startTimestamp != null) {
      _startDate = DateTime.fromMillisecondsSinceEpoch(startTimestamp);
      _isCounting = true;
      _startTimer();
    }
  }

  // Guardar la fecha de inicio cuando se presiona Iniciar
  Future<void> _saveStartDate(DateTime startDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startDate', startDate.millisecondsSinceEpoch);
  }

  void _startTimer() {
    if (_startDate == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeTogether = DateTime.now().difference(_startDate!);
      });
    });
  }

  void _onStartPressed() {
    setState(() {
      _startDate = DateTime.now();
      _isCounting = true;
      _saveStartDate(_startDate!);
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenuItem<String> buildMenuItem(String text) {
      return PopupMenuItem<String>(
        value: text.toLowerCase(),
        child: MaterialButton(
          onPressed: () async {
            await EasyLauncher.sendToWhatsApp(
                phone: 'https://chat.whatsapp.com/JqF1hUajzafFcyc1HP0IaE',
                message: 'Te extraño'
                // url: "https://youtu.be/7d0TuT6sLNc?si=71t02a9TuyuwqW5p",
                // mode: Mode.platformDefault,
                );
          },
          child: Texts.bold(
            text,
            fontSize: 16,
          ),
        ),

        //       SizedBox(
        //   width: 30.w,
        //   height: 2.h,

        // ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.purple,
        title: const Texts.bold(
          'You and Me',
          fontSize: 18,
          color: Palette.white,
        ),
        actions: [
          PopupMenuButton(
            color: Palette.white,
            iconColor: Palette.white,
            iconSize: 35,
            onSelected: (String value) {
              HapticFeedback.lightImpact();
              print('opcion seleccionada: $value');
            },
            itemBuilder: (context) {
              return [
                buildMenuItem('Te extraño 💕'),
                buildMenuItem('Quiero verte 🥺'),
              ];
            },
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              height: 28.h,
              width: 95.w,
              decoration: BoxDecoration(
                color: Palette.white70,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Texts.bold(
                    'Tiempo juntos y vamos por mas ❤️✨',
                    fontSize: 17,
                  ).only(bottom: 2.h),
                  Texts.regular(
                    '${_timeTogether.inDays} días, ${_timeTogether.inHours % 24} horas, ${_timeTogether.inMinutes % 60} minutos, ${_timeTogether.inSeconds % 60} segundos',
                    fontSize: 17,
                  ).only(bottom: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isCounting ? null : _onStartPressed,
                        child: const Texts.bold(
                          'Iniciar',
                          fontSize: 15,
                        ),
                      ).only(right: 5.w),
                      ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Palette.pink,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AlbumPage(),
                            ),
                          );
                        },
                        child: const Texts.bold(
                          'Ver Álbum de Fotos',
                          color: Palette.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
