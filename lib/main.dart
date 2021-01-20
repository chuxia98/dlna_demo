import 'dart:async';

import 'package:dlna/dlna.dart';
import 'package:dlna_demo/const.dart';
import 'package:dlna_demo/dlna_control.dart';
import 'package:dlna_demo/dlna_video_control.dart';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = DlnaConrol.shared.stream.listen(listener);
  }

  void listener(event) {
    setState(() {});
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    DlnaConrol.shared.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DLNA'),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () {
          //     final page = DlnaVideoControl();
          //     final route = MaterialPageRoute(builder: (_) => page);
          //     Navigator.of(context).push(route);
          //   },
          // ),
        ],
      ),
      body: ListView.builder(
        itemCount: DlnaConrol.shared.devices.length,
        itemBuilder: (context, index) {
          final device = DlnaConrol.shared.devices[index];
          return DeviceItem(
            device: device,
            onTap: () {
              if (DlnaConrol.shared.device?.uuid != device.uuid) {
                DlnaConrol.shared.setDevice(device);
                DlnaConrol.shared.setVideoUrl(kURLSimple);
                MySnackBar.show(context, 'connecting success');
              } else {
                MySnackBar.show(context, 'already connected');
              }
              final page = DlnaVideoControl();
              final route = MaterialPageRoute(builder: (_) => page);
              Navigator.of(context).push(route);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MySnackBar.show(context, 'searching...');
          DlnaConrol.shared.clear();
          DlnaConrol.shared.search();
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class DeviceItem extends StatelessWidget {
  final DLNADevice device;
  final Function onTap;

  DeviceItem({
    this.device,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.red[100],
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text('DeviceName: ${device.deviceName}'),
            ),
            SizedBox(height: 10),
            Flexible(
              child: Text('DeviceUuid: ${device.uuid}'),
            ),
          ],
        ),
      ),
    );
  }
}
