import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

const ballSize = 20.0;
const step = 10.0;

class JoystickExample extends StatefulWidget {
  final BluetoothConnection connection;
  JoystickExample({required this.connection});

  @override
  State<JoystickExample> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  double _x = 283;
  double _y = 378;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ElevatedButton(
                onPressed: (){
                  sendData("on");
                },
                child: Text("Roule")
            ),
            // ElevatedButton(
            //     onPressed: (){
            //       sendData("off");
            //     },
            //     child: Text("Stop")
            // ),
            Align(
              alignment: Alignment(0, -0.8),
              child: Joystick(
                mode: JoystickMode.horizontal,
                listener: (details) {
                  setState(() {
                    _x = _x + step * details.x;
                    if (_x < 175) {
                      _x = 175;
                    } else if (_x > 365) {
                      _x = 365;
                    }
                  });
                },
              ),
            ),

            Center(
              child: Container(
                margin: EdgeInsets.only(left: 150),
                padding: EdgeInsets.all(25),
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
              ),
            ),
            Ball(_x, _y),
            Align(
              alignment: Alignment(0, 0.8),
              child: Joystick(
                mode: JoystickMode.vertical,
                listener: (details) {
                  setState(() {
                    _y = _y + step * details.y;
                    if (_y > 469) {
                      _y = 469;
                    } else if (_y < 287) {
                      _y = 287;
                    }
                  });

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> sendData(String data) async {
  //   data = data.trim();
  //   try {
  //     List<int> list = data.codeUnits;
  //     Uint8List bytes = Uint8List.fromList(list);
  //     widget.connection.output.add(bytes);
  //     await widget.connection.output.allSent;
  //   } catch (e) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Erreur"),
  //           content: Text("On et Off"),
  //         );
  //       },
  //     );
  //   }
  // }
  void sendData(String data) async {
    data = data.trim();
    if (widget.connection != null) {
      widget.connection.output.add(utf8.encode(data));
      await widget.connection.output.allSent;
      print('Data sent: $data');
    } else {
      print('Not connected to any device');
    }
  }
}

class Ball extends StatelessWidget {
  final double x;
  final double y;

  const Ball(this.x, this.y, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: ballSize,
        height: ballSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}
