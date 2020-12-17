import 'package:dlna/dlna.dart';
import 'package:dlna_demo/dlna_control.dart';
import 'package:flutter/material.dart';

const String url1 =
    'https://cn-photo-wall.oss-cn-shanghai.aliyuncs.com/simple_videos/ForBiggerBlazes.mp4';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  bool isConnecting = false;
  String title = 'dlna';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              if (isConnecting == false) {
                title = 'no device';
                print(title);
                return;
              }
              title = 'connecting success';
              print(title);
              DlnaConrol.share.setVideoUrl(url1);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: DlnaConrol.share.devices.length,
        itemBuilder: (context, index) {
          final device = DlnaConrol.share.devices[index];
          return DeviceItem(
            device: device,
            onTap: () {
              title = 'set device';
              isConnecting = true;
              print(title);
              DlnaConrol.share.setDevice(device);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DlnaConrol.share.clear();
          title = 'searching...';
          print(title);
          DlnaConrol.share.search(hander: () {
            setState(() {});
          });
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
