import 'package:dlna/dlna.dart';

class DlnaConrol {
  static DlnaConrol share = DlnaConrol._interal();
  DlnaConrol._interal();

  final _service = DLNAManager();
  List<DLNADevice> _devices = [];
  List<DLNADevice> get devices => _devices;

  search({Function hander}) {
    final refresher = DeviceRefresher(
      onDeviceAdd: (dlnaDevice) {
        devices.add(dlnaDevice);
        print('\n${DateTime.now()}\nadd ' + dlnaDevice.toString());
        hander?.call();
      },
      onDeviceRemove: (dlnaDevice) {
        devices.remove(dlnaDevice);
        print('\n${DateTime.now()}\nremove ' + dlnaDevice.toString());
        hander?.call();
      },
      onDeviceUpdate: (dlnaDevice) {
        devices.removeWhere((element) => element.uuid == dlnaDevice.uuid);
        // devices.remove(dlnaDevice);
        print('\n${DateTime.now()}\nupdate ' + dlnaDevice.toString());
        hander?.call();
      },
      onSearchError: (error) {
        print(error);
      },
      onPlayProgress: (positionInfo) {
        print('current play progress ' + positionInfo.relTime);
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
    final video = VideoObject('title', url, VideoObject.VIDEO_MP4);
    _service.actSetVideoUrl(video);
  }
}
