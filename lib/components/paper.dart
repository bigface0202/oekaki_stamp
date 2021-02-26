import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/pen_model.dart';
import '../models/strokes_model.dart';
import '../models/icon_model.dart';

class Paper extends StatefulWidget {
  final image;
  // 画像のlocal positionを取得するためのキー

  Paper(this.image);

  @override
  _PaperState createState() => _PaperState();
}

class _PaperState extends State<Paper> {
  final GlobalKey _keyPaper = GlobalKey();
  Offset _offset = Offset(10, 10);
  double _radians = 0.0;
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    // final pen = Provider.of<PenModel>(context);
    // final strokes = Provider.of<StrokesModel>(context);
    // final iconProv = Provider.of<IconModel>(context);
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
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                _offset = Offset(_offset.dx + details.delta.dx,
                    _offset.dy + details.delta.dy);
              });
            },
            child: Container(
              color: Colors.green,
              width: 100,
              height: 100,
              child: Center(
                child: Text(
                    'Pan\nx:${_offset.dx.toInt()}\ny:${_offset.dy.toInt()}'),
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onScaleUpdate: (ScaleUpdateDetails details) {
                    setState(() {
                      _radians = details.rotation;
                      _scale = details.scale;
                    });
                  },
                  child: Transform.rotate(
                    angle: _radians,
                    child: Transform.scale(
                      scale: _scale,
                      child: Container(
                        height: 300,
                        width: 300,
                        color: Colors.amber,
                        child: Center(
                          child: Text('rotation:\n$_radians\nscale:\n$_scale'),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        )
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
