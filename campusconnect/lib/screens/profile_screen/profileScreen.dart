import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class Profilescreen extends StatelessWidget {
  final String uid;
  const Profilescreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(uid),
        leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
