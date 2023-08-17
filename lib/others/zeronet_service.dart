import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:zeronet/imports.dart';

class ZeroNetService {
  late FlutterBackgroundService _service;
  late StreamController<Map<String, dynamic>> _streamController;
  ServiceInstance? _serviceInstance;
  final bool isInIsolate;
  ZeroNetService(this.isInIsolate, {ServiceInstance? serviceInstance}) {
    if (Platform.isAndroid) {
      _service = FlutterBackgroundService();
      if (isInIsolate) _serviceInstance = serviceInstance;
    } else {
      _streamController = StreamController<Map<String, dynamic>>();
    }
  }

  Future<bool> get isServiceRunning async =>
      Platform.isAndroid ? await _service.isRunning() : true;

  void sendData(Map<String, dynamic> data) {
    if (Platform.isAndroid) {
      (isInIsolate ? _serviceInstance! : _service).invoke('data', data);
    } else {
      _streamController.add(data);
    }
  }

  Future<bool> configure(
    Function(ServiceInstance) isolate, {
    bool? autoStart = true,
  }) {
    if (Platform.isAndroid) {
      return _service.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: isolate,
          autoStart: autoStart!,
          isForegroundMode: true,
        ),
        iosConfiguration: IosConfiguration(),
        //TODO! Enable this when ios is supported
        // onForeground: isolate,
        // onBackground: isolate,
      );
    } else {
      return Future.value(true);
    }
  }

  Stream<Map<String, dynamic>?> get onDataReceived => Platform.isAndroid
      ? (isInIsolate ? _serviceInstance! : _service).on('data')
      : _streamController.stream;

  void start() {
    if (Platform.isAndroid && !isInIsolate) {
      _service.startService();
    }
  }

  void stop() {
    if (Platform.isAndroid && isInIsolate) {
      _serviceInstance!.stopSelf();
    }
  }

  setNotificationInfo({required String title, required String content}) {
    if (Platform.isAndroid && isInIsolate) {
      (_serviceInstance as AndroidServiceInstance)
          .setForegroundNotificationInfo(title: title, content: content);
    }
  }
}
