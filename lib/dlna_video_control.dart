import 'dart:async';

import 'package:dlna_demo/dlna_control.dart';
import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

class DlnaVideoControl extends StatefulWidget {
  @override
  _DlnaVideoControlState createState() => _DlnaVideoControlState();
}

class _DlnaVideoControlState extends State<DlnaVideoControl> {
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = DlnaConrol.shared.stream.listen(streamListener);
  }

  void streamListener(event) {
    print('object -- ');
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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
              MySnackBar.show(context, '点击播放');
            },
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              DlnaConrol.shared.pause();
              MySnackBar.show(context, '点击暂停');
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              DlnaConrol.shared.stop();
              MySnackBar.show(context, '点击停止');
              Navigator.of(context).pop();
            },
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: StreamBuilder(
              stream: DlnaConrol.shared.stream,
              builder: (context, snap) {
                final shared = DlnaConrol.shared;
                final info = shared.info;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Item(title: 'title', subtitle: info?.title ?? '-'),
                    _Item(title: 'track', subtitle: info?.track ?? '-'),
                    _Item(
                      title: 'trackDuration',
                      subtitle: info?.trackDuration ?? '-',
                    ),
                    _Item(title: 'absCount', subtitle: info?.absCount ?? '-'),
                    _Item(title: 'absTime', subtitle: info?.absTime ?? '-'),
                    _Item(title: 'relCount', subtitle: info?.relCount ?? '-'),
                    _Item(title: 'relTime', subtitle: info?.relTime ?? '-'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String title;
  final String subtitle;

  _Item({
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(subtitle),
        ],
      ),
    );
  }
}
