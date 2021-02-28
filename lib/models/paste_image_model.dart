import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasteImage {
  final ui.Image image;
  final double scale;
  final double theta;
  final Offset offset;

  PasteImage({
    @required this.image,
    @required this.scale,
    @required this.theta,
    @required this.offset,
  });
}

class PasteImageModel with ChangeNotifier {
  List<PasteImage> _storedImages = [];

  List<PasteImage> get storedImages {
    return [..._storedImages];
  }

  Future<void> addPasteImage(
      String imageAddress, double scale, double theta, Offset offset) async {
    final ByteData data = await rootBundle.load(imageAddress);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Image image = await decodeImageFromList(bytes);
    _storedImages.add(PasteImage(
      image: image,
      scale: scale,
      theta: theta,
      offset: offset,
    ));
    notifyListeners();
  }

  void clear() {
    _storedImages = [];
    notifyListeners();
  }
}
