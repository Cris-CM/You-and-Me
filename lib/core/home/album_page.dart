import 'package:flutter/material.dart';
import 'package:you_and_me/core/widgets/texts.dart';

class AlbumPage extends StatelessWidget {
  // final List<Map<String, String>> _photos = [
  //   {'image': 'assets/photo1.jpg', 'message': 'Nuestro primer viaje juntos ❤️'},
  //   {
  //     'image': 'assets/photo2.jpg',
  //     'message': 'Un día muy especial para nosotros 💕'
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuestro Álbum de Fotos',
        ),
      ),
      body: ListView.builder(
        itemCount: 7,
        // itemCount: _photos.length,
        itemBuilder: (context, index) {
          return const Card(
            margin: EdgeInsets.all(10),
            child: const Column(
              children: [
                // Image.asset(
                //     _photos[index]['image']!), // Añade las imágenes a assets
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     _photos[index]['message']!,
                //     style: const TextStyle(
                //         fontSize: 16, fontStyle: FontStyle.italic),
                //   ),
                // ),
                Texts.regular('Te amo <3')
              ],
            ),
          );
        },
      ),
    );
  }
}
