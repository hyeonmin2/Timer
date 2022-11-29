import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: _Timer(),
    );
  }
}

class _Timer extends StatefulWidget {
  const _Timer({Key? key}) : super(key: key);
  @override
  State<_Timer> createState() => __TimerState();
}

class Ticker {
  const Ticker();
  Stream<int> tick() {
    return Stream.periodic(Duration(seconds: 1), (x) => x);
  }
}

class __TimerState extends State<_Timer> {
  late StreamSubscription<int> subscription;
  int? _currentTick;
  bool _isPaused = false;
  bool _isFirst = true;

  @override
  initState() {
    super.initState();
    _start();
    _pause();
  }

  void _start() {
    subscription = Ticker().tick().listen((value) {
      setState(() {
        _isPaused = false;
        _currentTick = value;
      });
    });
  }

  void _resume() {
    setState(() {
      _isPaused = false;
    });
    subscription.resume();
  }

  void _pause() {
    setState(() {
      _isPaused = true;
    });
    subscription.pause();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              //color:  Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Text(
              _currentTick == null ? 'start' :
              (int.parse(_currentTick.toString())~/60).toString().padLeft(2,'0') + ' : ' + (int.parse(_currentTick.toString())%60).toString().padLeft(2,'0'),
              style: TextStyle(fontSize: 100, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () {
                  subscription.cancel();
                  _start();
                  _isFirst = false;
                },
                child: Text(_isFirst ? 'Start' : 'ReStart')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(onPressed: () {
                _isPaused ? _resume() : _pause();
              },
                  child: Text(_isPaused ? 'Resume' : 'Stop'))
            ],
          )
        ],
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}