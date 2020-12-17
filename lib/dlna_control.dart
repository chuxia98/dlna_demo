import 'package:dlna/dlna.dart';

class DlnaConrol {
  static DlnaConrol shared = DlnaConrol._interal();
  DlnaConrol._interal() {
    _service = DLNAManager();
  }
  DLNAManager _service;
  List<DLNADevice> _devices = [];
  List<DLNADevice> get devices => _devices;

  search({Function hander}) {
    final refresher = DeviceRefresher(
      onDeviceAdd: (dlnaDevice) {
        _devices.add(dlnaDevice);
        print('\n[cx] ${DateTime.now()}\n add ' + dlnaDevice.toString());
        hander?.call();
      },
      onDeviceRemove: (dlnaDevice) {
        _devices.remove(dlnaDevice);
        print('\n[cx] ${DateTime.now()}\n remove ' + dlnaDevice.toString());
        hander?.call();
      },
      onDeviceUpdate: (dlnaDevice) {
        _devices.removeWhere((element) => element.uuid == dlnaDevice.uuid);
        // devices.remove(dlnaDevice);
        print('\n[cx] ${DateTime.now()}\n update ' + dlnaDevice.toString());
        hander?.call();
      },
      onSearchError: (error) {
        print('[cx] $error');
      },
      onPlayProgress: (positionInfo) {
        print('[cx] current play progress ' + positionInfo.relTime);
      },
    );
    _service.setRefresher(refresher);

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

  setVideoUrl(String url) {
    final video = VideoObject('alna title', url, VideoObject.VIDEO_MP4);
    _service.actSetVideoUrl(video);
  }
}
