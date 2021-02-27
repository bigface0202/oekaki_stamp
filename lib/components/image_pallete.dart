import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/image_model.dart';
import '../models/pen_model.dart';

class IconPalette extends StatelessWidget {
  static const images = [
    'images/sunglass.png',
    'images/arlong.png',
    'images/buggy.png',
    'images/croco.png',
    'images/enel.png',
    'images/lucci.png',
    'images/luffy.png',
    'images/mask.png',
    'images/nami.png',
    'images/taisyo.png',
    'images/zoro.png',
  ];

  @override
  Widget build(BuildContext context) {
    final iconProv = Provider.of<ImageModel>(context);
    final pen = Provider.of<PenModel>(context);
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final i = images[index];
          return GestureDetector(
            onTap: () {
              iconProv.image = i;
            },
            child: imageContainer(
              i,
              i == iconProv.image,
              pen.color,
            ),
          );
        },
      ),
    );
  }

  Widget imageContainer(var image, bool selected, Color color) {
    return Container(
      height: 50,
      width: 45,
      padding: EdgeInsets.all(1.0),
      child: Center(
        child: Container(
          child: CircleAvatar(
            backgroundColor: Colors.blue[200],
            radius: 30,
            child: Image.asset(image),
          ),
          padding: selected ? EdgeInsets.all(2.0) : EdgeInsets.all(0),
          decoration: new BoxDecoration(
            color: Colors.black, // border color
            shape: BoxShape.circle,
            // boxShadow: [
            //   new BoxShadow(
            //     color: Colors.black.withOpacity(0.2),
            //     blurRadius: 5.0,
            //   ),
            // ],
          ),
        ),
      ),
    );
  }
}
