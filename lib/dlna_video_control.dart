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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
