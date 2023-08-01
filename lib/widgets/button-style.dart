import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RedButtonMobile extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;
  const RedButtonMobile({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        '$child',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Proxima Nova',
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xffC54134)),
        minimumSize: MaterialStateProperty.all(Size(107, 25)),
        fixedSize: MaterialStateProperty.all(Size(117, 27)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
        ),
      ),
    );
  }
}

class WhiteButtonMobile extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;
  const WhiteButtonMobile({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        '$child',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Proxima Nova',
          color: Color(0xff000000),
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xffffffff)),
          minimumSize: MaterialStateProperty.all(Size(107, 25)),
          fixedSize: MaterialStateProperty.all(Size(117, 27)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
          )),
    );
  }
}

class WhiteSubjectButtonMobile extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;
  const WhiteSubjectButtonMobile(
      {required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        '$child',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Proxima Nova',
          fontWeight: FontWeight.w600,
          color: Color(0xff161616),
        ),
      ),
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        minimumSize: MaterialStateProperty.all(Size(40, 25)),
        fixedSize: MaterialStateProperty.all(Size(107, 38)),
        backgroundColor: MaterialStateProperty.all(Color(0xfff4f6f9)),
      ),
    );
  }
}

class RedSubjectButtonMobile extends StatelessWidget {
  final String child;
  final VoidCallback onPressed;
  const RedSubjectButtonMobile({required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        '$child',
        style: TextStyle(
          fontSize: 16,
          fontFamily: 'Proxima Nova',
          fontWeight: FontWeight.w600,
          color: Color(0xffffffff),
        ),
      ),
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        minimumSize: MaterialStateProperty.all(Size(40, 25)),
        fixedSize: MaterialStateProperty.all(Size(107, 38)),
        backgroundColor: MaterialStateProperty.all(Color(0xffc54134)),
      ),
    );
  }
}
