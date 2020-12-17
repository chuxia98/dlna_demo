import 'dart:async';

import 'package:dlna/dlna.dart';

class DlnaConrol {
  static DlnaConrol shared = DlnaConrol._interal();
  DlnaConrol._interal() {
    _service = DLNAManager();
    final refresher = DeviceRefresher(
      onDeviceAdd: (dlnaDevice) {
        _devices.add(dlnaDevice);
        print('\n[cx] ${DateTime.now()}\n add ' + dlnaDevice.toString());
        _controller.add(dlnaDevice);
      },
      onDeviceRemove: (dlnaDevice) {
        _devices.remove(dlnaDevice);
        print('\n[cx] ${DateTime.now()}\n remove ' + dlnaDevice.toString());
        _controller.add(dlnaDevice);
      },
      onDeviceUpdate: (dlnaDevice) {
        _devices.removeWhere((element) => element.uuid == dlnaDevice.uuid);
        // devices.remove(dlnaDevice);
        print('\n[cx] ${DateTime.now()}\n update ' + dlnaDevice.toString());
        _controller.add(dlnaDevice);
      },
      onSearchError: (error) {
        print('[cx] $error');
      },
      onPlayProgress: (positionInfo) {
        print('[cx] current play progress ' + positionInfo.relTime);
      },
    );
    _service.setRefresher(refresher);
  }

  final _controller = StreamController.broadcast();
  Stream get stream => _controller.stream;

  DLNAManager _service;
  List<DLNADevice> _devices = [];
  List<DLNADevice> get devices => _devices;

  search() {
    _service.startSearch();
    // Future.delayed(Duration(seconds: 2), () {
    //   final device = DLNADevice();
    //   device.uuid = 'uuid';
    //   device.description = DLNADescription()..friendlyName = 'friendlyName';
    //   _devices.add(device);
    //   hander?.call();
    // });
  }

  clear() {
    _devices.clear();
  }

  setDevice(DLNADevice device) {
    _service.setDevice(device);
  }

  setVideoUrl(String url) async {
    final video = VideoObject('alna title', url, VideoObject.VIDEO_MP4);
    final result = await _service.actSetVideoUrl(video);
    if (result.success) {
      print('connect success');
    } else {
      print('[cx] ${result.errorMessage}');
    }
  }

  void play() {
    _service.actPlay();
  }

  void pause() {
    _service.actPause();
  }

  void dispose() {
    _controller.close();
  }
}
