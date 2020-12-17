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

  @override
  void initState() {
    super.initState();
    final refresher = DeviceRefresher(
      onDeviceAdd: (dlnaDevice) {
        print('\n${DateTime.now()}\nadd ' + dlnaDevice.toString());
      },
      onDeviceRemove: (dlnaDevice) {
        print('\n${DateTime.now()}\nremove ' + dlnaDevice.toString());
      },
      onDeviceUpdate: (dlnaDevice) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '---',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dlnaService.startSearch();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
