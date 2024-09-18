import 'dart:async';

import 'package:easy_padding/easy_padding.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_and_me/home/album_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime? _startDate; // Fecha y hora de inicio
  Duration _timeTogether = const Duration(); // Duración acumulada
  Timer? _timer;
  bool _isCounting = false; // Para verificar si ya está contando

  @override
  void initState() {
    super.initState();
    _loadStartDate();
  }

  // Cargar la fecha de inicio desde SharedPreferences si existe
  Future<void> _loadStartDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? startTimestamp = prefs.getInt('startDate');

    if (startTimestamp != null) {
      _startDate = DateTime.fromMillisecondsSinceEpoch(startTimestamp);
      _isCounting = true;
      _startTimer();
    }
  }

  // Guardar la fecha de inicio cuando se presiona "Iniciar"
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

  // Cuando el usuario presiona el botón "Iniciar"
  void _onStartPressed() {
    setState(() {
      _startDate = DateTime.now(); // El contador empieza desde cero
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'You and Me',
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fondo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenedor con fondo blanco y ajuste de tamaño
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 70,
              ), // Ajusta el padding si es necesario
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(
                    10.0), // Opcional: Para bordes redondeados
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tiempo juntos y vamos por mas ❤️✨ ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ).only(bottom: 10),
                  Text(
                    '${_timeTogether.inDays} días, ${_timeTogether.inHours % 24} horas, ${_timeTogether.inMinutes % 60} minutos, ${_timeTogether.inSeconds % 60} segundos',
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ).only(bottom: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isCounting ? null : _onStartPressed,
                        child: const Text('Iniciar'),
                      ).only(right: 30),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                          Colors.pink,
                        )),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlbumPage()),
                          );
                        },
                        child: const Text(
                          'Ver Álbum de Fotos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
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
