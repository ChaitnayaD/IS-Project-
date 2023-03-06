import 'package:flutter/material.dart';

import 'line-chart.dart';


// void main() => runApp(MyApp());

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Different  Properties'),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key = const Key("any_key"), required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(title),
      ),
      backgroundColor: Colors.white,
      body: ListView( padding: const EdgeInsets.all(15),
          children:const <Widget>[
            Text(selectionColor: Colors.black,textAlign: TextAlign.center,"Temperature"),
            StockChartExample(),
            Text(selectionColor: Colors.black,textAlign: TextAlign.center,"Humidity"),
            StockChartExample(),
            Text(selectionColor: Colors.black,textAlign: TextAlign.center,"jjj"),
            StockChartExample(),

          ]


      ),
    );
  }
}

