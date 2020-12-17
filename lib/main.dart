import 'package:dlna/dlna.dart';
import 'package:flutter/material.dart';

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
  final dlnaService = DLNAManager();
  List<DLNADevice> devices = [];

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
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text('DeviceName: ${device.deviceName}'),
                SizedBox(height: 10),
                Text('DeviceUuid: ${device.uuid}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          devices.clear();
          dlnaService.startSearch();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
