import 'package:flutter/material.dart';
import 'package:tils_app/models/parent-user-data.dart';
import 'package:provider/provider.dart';
import 'package:tils_app/widgets/parent-screens/parent-home.dart';

class ParentBufferScreen extends StatefulWidget {
  const ParentBufferScreen({Key? key}) : super(key: key);

  @override
  State<ParentBufferScreen> createState() => _ParentBufferScreenState();
}

class _ParentBufferScreenState extends State<ParentBufferScreen> {
  @override
  Widget build(BuildContext context) {
    final parentData = Provider.of<ParentUser?>(context);
    bool isActive = false;
    if (parentData != null) {}
    return ParentHome();
  }
}
