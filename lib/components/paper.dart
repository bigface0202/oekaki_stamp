import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/pen_model.dart';
import '../models/strokes_model.dart';
import '../models/image_model.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class Paper extends StatefulWidget {
  final image;
  // 画像のlocal positionを取得するためのキー

  Paper(this.image);

  @override
  _PaperState createState() => _PaperState();
}

class _PaperState extends State<Paper> {
  final GlobalKey _keyPaper = GlobalKey();
  Offset _offset = Offset(200, 200);
  Offset _rotateCircleOffset = Offset(0, 0);
  Offset _scaleCircleOffset = Offset(0, 0);
  double _scale = 1.0;
  double _theta = 0.0;
  double _distance = 0;

  @override
  Widget build(BuildContext context) {
    final imageProv = Provider.of<ImageModel>(context);
    return
        // return Listener(
        //   // onPointerDownは画面に指が触れた時にコールされる
        //   onPointerDown: (details) {
        //     final RenderBox box = _keyPaper.currentContext.findRenderObject();
        //     Offset localPaper = box.globalToLocal(details.position);
        //     strokes.add(pen, localPaper, iconProv);
        //   },
        //   // タッチでお絵かきしたいときは以下を使う
        //   onPointerMove: (details) {
        //     final RenderBox box = _keyPaper.currentContext.findRenderObject();
        //     Offset localPaper = box.globalToLocal(details.position);
        //     strokes.update(localPaper);
        //   },
        //   onPointerUp: (details) {
        //     final RenderBox box = _keyPaper.currentContext.findRenderObject();
        //     Offset localPaper = box.globalToLocal(details.position);
        //     strokes.update(localPaper);
        //   },
        //   child:
        Stack(
      children: [
        FittedBox(
          child: SizedBox(
            width: widget.image.width.toDouble(),
            height: widget.image.height.toDouble(),
            child: CustomPaint(
              painter: _ImagePainter(widget.image),
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
              ),
            ),
          ),
        ),
        // CustomPaint(
        //   key: _keyPaper,
        //   painter: _Painter(strokes),
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints.expand(),
        //   ),
        // ),
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails transformDetails) {
              setState(() {
                _offset = Offset(_offset.dx + transformDetails.delta.dx,
                    _offset.dy + transformDetails.delta.dy);
              });
            },
            child: FittedBox(
              child: SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: _theta,
                      child: Transform.scale(
                        scale: _scale,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(imageProv.image),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onPanUpdate: (DragUpdateDetails rotateDetails) {
                        setState(() {
                          _theta = math.atan(rotateDetails.localPosition.dy /
                              (rotateDetails.localPosition.dx));
                          _rotateCircleOffset = Offset(
                              rotateDetails.globalPosition.dx,
                              rotateDetails.globalPosition.dy);
                          // _offset = Offset(rotateDetails.localPosition.dx,
                          //     rotateDetails.localPosition.dy);
                        });
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                            // color: Color(0xFFe0f2f1),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onPanUpdate: (DragUpdateDetails scaleDetails) {
                        setState(() {
                          _distance = math.sqrt(
                              math.pow(scaleDetails.localPosition.dx, 2) +
                                  math.pow(scaleDetails.localPosition.dy, 2));
                          _scale = _distance / 200;
                          _scaleCircleOffset = Offset(
                              scaleDetails.globalPosition.dx,
                              scaleDetails.globalPosition.dy);
                          // _offset = Offset(scaleDetails.localPosition.dx,
                          //     scaleDetails.localPosition.dy);
                        });
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: HexColor('ffaec0'),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image _image;

  _ImagePainter(this._image);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImage(_image, Offset(0, 0), paint);
  }

  @override
  bool shouldRepaint(_ImagePainter oldDelegate) {
    return false;
  }
}

class _Painter extends CustomPainter {
  final StrokesModel strokes;

  _Painter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    strokes.all.forEach((stroke) {
      final icon = stroke.icon;
      final textStyle = ui.TextStyle(
        fontFamily: icon.fontFamily,
        color: stroke.color,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      );
      var builder = ui.ParagraphBuilder(ui.ParagraphStyle())
        ..pushStyle(textStyle)
        ..addText(String.fromCharCode(icon.codePoint));
      var para = builder.build();
      para.layout(ui.ParagraphConstraints(width: size.width));
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 3;
      canvas.drawParagraph(
          para, Offset(stroke.points[0].dx, stroke.points[0].dy));
    });
  }

  @override
  bool shouldRepaint(_Painter oldDelegate) {
    return true;
  }
}
