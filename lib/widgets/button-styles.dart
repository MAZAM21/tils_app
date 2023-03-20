import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RedButtonMain extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;
  const RedButtonMain({@required this.child, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        '$child',
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Proxima Nova',
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.visible,
        ),
      ),
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xffC54134)),
        minimumSize: MaterialStateProperty.all(Size(107, 25)),
        fixedSize: MaterialStateProperty.all(Size(165, 37)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
        ),
      ),
    );
  }
}

class WhiteButtonMain extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;
  const WhiteButtonMain({@required this.child, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        '$child',
        style: TextStyle(
          fontSize: 14,
          fontFamily: 'Proxima Nova',
          color: Color(0xff000000),
          fontWeight: FontWeight.w400,
          overflow: TextOverflow.visible
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xffffffff)),
          minimumSize: MaterialStateProperty.all(Size(107, 25)),
          fixedSize: MaterialStateProperty.all(Size(165, 37)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          )),
    );
  }
}
