import 'dart:async';

// import 'device_model.dart';

abstract class WebsocketRepository {
  Future<void> sendMessage(String message);

  Future<Stream<dynamic>> messages();

  Future<void> disconnect();
}