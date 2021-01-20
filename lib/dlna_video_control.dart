import 'dart:async';

import 'package:dlna_demo/dlna_control.dart';
import 'package:flutter/material.dart';

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
            },
          ),
          IconButton(
            icon: Icon(Icons.pause),
            onPressed: () {
              DlnaConrol.shared.pause();
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              DlnaConrol.shared.stop();
            },
          ),
          Container(
            // height: 100,
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
                    _Item(title: 'time', subtitle: '${shared.count}'),
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
