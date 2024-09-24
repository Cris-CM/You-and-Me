import 'dart:io';
import 'package:easy_padding/easy_padding.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:you_and_me/core/colors/palette.dart';
import 'package:you_and_me/core/widgets/texts.dart';

class AlbumPage extends StatefulWidget {
  final int maxImages;

  const AlbumPage({
    super.key,
    this.maxImages = 5, // Máximo de imágenes que se pueden seleccionar
  });

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final List<XFile> _pickedImages = [];
  final List<TextEditingController> _descriptionControllers = [];
  final ImagePicker _picker = ImagePicker();

  // Función para seleccionar imágenes desde la galería
  Future<void> _pickImageFromGallery() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        final int availableSlots = widget.maxImages - _pickedImages.length;
        final imagesToAdd = pickedImages.take(availableSlots);
        _pickedImages.addAll(imagesToAdd);
        _descriptionControllers.addAll(List.generate(
            imagesToAdd.length, (index) => TextEditingController()));
      });
    }
  }

  // Función para tomar una foto desde la cámara
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        if (_pickedImages.length < widget.maxImages) {
          _pickedImages.add(pickedImage);
          _descriptionControllers.add(TextEditingController());
        }
      });
    }
  }

  // Mostrar opciones para seleccionar imágenes
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Cámara'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Galería'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Texts.bold(
          'Recuerdos amorosos juntos ',
          fontSize: 18,
          color: Palette.white,
        ),
        iconTheme: const IconThemeData(
          color: Palette.white,
        ),
        backgroundColor: Palette.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _pickedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.file(
                        File(_pickedImages[index].path),
                        width: 40.w,
                        height: 23.h,
                        fit: BoxFit.cover,
                      ).only(right: 3.w),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          controller: _descriptionControllers[index],
                          decoration: InputDecoration(
                            hintText: 'Añade un recuerdo',
                            counterText:
                                'fecha puesta', //colocar fecha de cuando se coloco la imagen
                            counterStyle: const TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Palette.purple,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Palette.purple,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Palette.purple,
                                width: 2.0,
                              ),
                            ),
                          ),
                          maxLines: 7,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Botón para agregar imágenes
            if (_pickedImages.length < widget.maxImages)
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Container(
                  width: 40.w,
                  height: 20.h,
                  color: Palette.grey200,
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Palette.grey,
                  ),
                ),
              ),
          ],
        ).all(10),
      ),
    );
  }
}
