import 'package:zeronet/imports.dart';

class ZeroNetService {
  late FlutterBackgroundService _service;
  late StreamController<Map<String, dynamic>> _streamController;
  ZeroNetService() {
    if (Platform.isAndroid) {
      _service = FlutterBackgroundService();
    } else {
      _streamController = StreamController<Map<String, dynamic>>();
    }
  }

  Future<bool> get isServiceRunning async =>
      Platform.isAndroid ? await _service.isServiceRunning() : true;

  void sendData(Map<String, dynamic> data) {
    if (Platform.isAndroid) {
      _service.sendData(data);
    } else {
      _streamController.add(data);
    }
  }

  Future<bool> configure(Function isolate, {bool? autoStart = true}) {
    if (Platform.isAndroid) {
      return _service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: isolate,
          autoStart: autoStart!,
          isForegroundMode: true,
        ),
        iosConfiguration: IosConfiguration(
          onForeground: isolate,
          onBackground: isolate,
        ),
      );
    } else {
      return Future.value(true);
    }
  }

  Stream<Map<String, dynamic>?> get onDataReceived =>
      Platform.isAndroid ? _service.onDataReceived : _streamController.stream;

  void stop() {
    if (Platform.isAndroid) {
      _service.stopBackgroundService();
    }
  }

  setNotificationInfo({String? title, String? content}) {
    if (Platform.isAndroid) {
      _service.setNotificationInfo(title: title, content: content);
    }
  }
}
