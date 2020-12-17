import 'package:dlna_demo/dlna_control.dart';
import 'package:flutter/material.dart';

class DlnaVideoControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('control'),
      ),
      body: Column(
        children: [
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              DlnaConrol.shared.play();
            },
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              DlnaConrol.shared.pause();
            },
          ),
        ],
      ),
    );
  }
}
