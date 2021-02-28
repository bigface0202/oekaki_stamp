import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/strokes_model.dart';
import './screens/index_screen.dart';
import './screens/paper_screen.dart';
import 'models/paste_image_model.dart';
import 'models/pen_model.dart';
import 'models/image_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => PenModel(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => StrokesModel(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ImageModel(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => PasteImageModel(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
        ),
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('お絵描きApp'),
            ),
            body: IndexScreen(),
          ),
        ),
        routes: {
          PaperScreen.routeName: (ctx) => PaperScreen(),
        },
      ),
    );
  }
}
