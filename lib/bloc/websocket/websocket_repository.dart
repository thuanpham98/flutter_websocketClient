import 'dart:async';

// import 'device_model.dart';

abstract class WebsocketRepository {
  Future<void> sendMessage(String message);

  // Future<void> deleteDevice(Device device);

  Future<Stream<dynamic>> messages();

  // Future<void> updateDevice(Device device);

}