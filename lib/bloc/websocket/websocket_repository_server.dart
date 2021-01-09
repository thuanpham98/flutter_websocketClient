import 'dart:async';
import 'websocket_repository.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebsocketRepositoryServer implements WebsocketRepository{
  
  final IOWebSocketChannel channel = IOWebSocketChannel.connect("ws://192.168.1.10:1000/iot_mobile");

  @override
  Future<void> sendMessage(String message) async{
    print("this is start send");
    return channel.sink.add(message);
  }

  @override
  Future<Stream<dynamic>> messages() async{
    return channel.stream;
  }
}