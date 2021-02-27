import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ImageModel extends ChangeNotifier {
  var _image = 'images/sunglass.png';

  get image => _image;
  set image(var image) {
    _image = image;
    notifyListeners();
  }
}
