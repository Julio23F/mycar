import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'manette.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  // final BlueConnectionManager _connectionManager = BlueConnectionManager();
  late BluetoothConnection connection;

  final String targetMacAddress = "00:23:02:34:DE:91";

  bool isConnected = false;

  final List<String> _humidityHistory = [];
  final StreamController<List<String>> _humidityStreamController = StreamController<List<String>>.broadcast();


  void connectToDevice() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      BluetoothConnection.toAddress(targetMacAddress).then((_connection) {
        print('Connected to device');
        Navigator.pop(context);
        _connection.input!.listen((Uint8List data) {
          String newData = utf8.decode(data);
          _humidityHistory.add(newData);
          _humidityStreamController.add(_humidityHistory);

          // String newData = utf8.decode(data);
          // _humidityHistory.add(newData);
          // _humidityStreamController.add(_humidityHistory.map((humidity) => double.parse(humidity).toStringAsFixed(2)).toList());

        });
        setState(() {
          connection = _connection;
          isConnected = true;
        });

        // Rediriger vers ControllPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JoystickExample()

            // builder: (context) => ControllPage(connection: connection, humidityHistory: _humidityStreamController.stream),
          ),
        );
      }).catchError((error) {
        print('Cannot connect, exception occurred: $error');
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur de connexion'),
              content: Text('Impossible de se connecter à cette appareil.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    } catch (error) {
      print('Cannot connect, exception occurred: $error');
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de connexion'),
            content: Text('Impossible de se connecter à cette appareil.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 35),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff1580c8), Color(0xff2e9fe7)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/manette.png"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Text(
                "Commande la voiture",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: Colors.white70
                ),
              ),
              Text(
                "de ton enfance",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: Colors.white70
                ),
              ),
              SizedBox(height: 15),

              Text(
                "Une application pour contrôler une voiture via Bluetooth : scanne le QR code et connecte-toi.",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Colors.white30
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  connectToDevice();

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => JoystickExample()
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Scanner",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
