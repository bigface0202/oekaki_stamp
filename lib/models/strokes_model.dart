import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './pen_model.dart';
import 'image_model.dart';

class StrokesModel extends ChangeNotifier {
  List<Stroke> _strokes = [];

  get all => _strokes;

  void add(PenModel pen, Offset offset, ImageModel iconProv) {
    _strokes.add(Stroke(pen.color, iconProv.image)..add(offset));
    notifyListeners();
  }

  void update(Offset offset) {
    _strokes.last.add(offset);
    notifyListeners();
  }

  void clear() {
    _strokes = [];
    notifyListeners();
  }
}

class Stroke {
  final List<Offset> points = [];
  final Color color;
  final IconData icon;

  Stroke(this.color, this.icon);

  add(Offset offset) {
    points.add(offset);
  }
}
