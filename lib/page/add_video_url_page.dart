import 'package:dlna_demo/const/const.dart';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class AddVideoUrlPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置播放URL'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if (controller.text.isEmpty) {
                MySnackBar.show(context, '请输入播放地址');
                return;
              }
              Navigator.of(context).pop(controller.text);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: '输入url',
              fillColor: Colors.red[100],
              filled: true,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              '默认播放视频URL:\n $kURLSimple',
              style: TextStyle(),
              maxLines: 10,
            ),
          ),
        ],
      ),
    );
  }
}
