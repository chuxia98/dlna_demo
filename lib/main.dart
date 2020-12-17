import 'package:dlna/dlna.dart';
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

final dlnaService = DLNAManager();

class _MyHomePageState extends State<MyHomePage> {
  List<DLNADevice> devices = [];
  bool isConnecting = false;
  String title = 'dlna';

  @override
  void initState() {
    super.initState();

    devices.clear();
    final refresher = DeviceRefresher(
      onDeviceAdd: (dlnaDevice) {
        devices.add(dlnaDevice);
        setState(() {});
        print('\n${DateTime.now()}\nadd ' + dlnaDevice.toString());
      },
      onDeviceRemove: (dlnaDevice) {
        devices.remove(dlnaDevice);
        setState(() {});
        print('\n${DateTime.now()}\nremove ' + dlnaDevice.toString());
      },
      onDeviceUpdate: (dlnaDevice) {
        devices.removeWhere((element) => element.uuid == dlnaDevice.uuid);
        setState(() {});
        // devices.remove(dlnaDevice);
        print('\n${DateTime.now()}\nupdate ' + dlnaDevice.toString());
      },
      onSearchError: (error) {
        print(error);
      },
      onPlayProgress: (positionInfo) {
        print('current play progress ' + positionInfo.relTime);
      },
    );
    dlnaService.setRefresher(refresher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              if (isConnecting == false) {
                title = 'no device';
                setState(() {});
                return;
              }
              title = 'connecting success';
              final video = VideoObject('title', url1, VideoObject.VIDEO_MP4);
              dlnaService.actSetVideoUrl(video);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return DeviceItem(
            device: device,
            onTap: () {
              title = 'set device';
              isConnecting = true;
              setState(() {});
              dlnaService.setDevice(device);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          devices.clear();
          title = 'searching...';
          setState(() {});
          dlnaService.startSearch();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
