import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

const ballSize = 20.0;
const step = 10.0;

class JoystickExample extends StatefulWidget {
  const JoystickExample({Key? key}) : super(key: key);

  @override
  State<JoystickExample> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  double _x = 283;
  double _y = 378;
  @override



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.8),
              child: Joystick(
                mode: JoystickMode.horizontal,
                listener: (details) {
                  setState(() {
                    _x = _x + step * details.x;
                    // _y = _y + step * details.y;
                    if(_x < 175) {
                      _x = 175;
                    }
                    else if (_x > 365) {
                      _x = 365;
                    }
                    print(details.x);
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
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  ),

              ),
            ),
            Ball(_x, _y),
            Align(
              alignment: const Alignment(0, 0.8),
              child: Joystick(
                mode: JoystickMode.vertical,
                listener: (details) {
                  setState(() {
                    // _x = _x + step * details.x;
                    _y = _y + step * details.y;
                    if(_y > 469) {
                      _y = 469;
                    }
                    else if (_y < 287) {
                      _y = 287;
                    }
                    print(details.y);

                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
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