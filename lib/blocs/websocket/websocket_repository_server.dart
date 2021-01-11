import 'dart:async';
import 'websocket_repository.dart';

import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;

class WebsocketRepositoryServer implements WebsocketRepository{
  
  final IOWebSocketChannel channel = IOWebSocketChannel.connect("wss://tnjqqhs9o8.execute-api.ap-southeast-1.amazonaws.com/gate_mobile");

  @override
  Future<void> sendMessage(String message) async{
    return channel.sink.add(message);
  }

  @override
  Future<Stream<dynamic>> messages() async{
    return channel.stream;
  }

  @override
  Future<void> disconnect() async{
    return channel.sink.close();
  }
}