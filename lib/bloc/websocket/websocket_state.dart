import 'package:equatable/equatable.dart';

abstract class WebsocketState extends Equatable {
  const WebsocketState();
  
  @override
  List<Object> get props => [];
}

class WebsocketConnecting extends WebsocketState {
  @override
  String toString() => 'connecting to server';
}

class WebsocketConnected extends WebsocketState {
  final String result;
  const WebsocketConnected(this.result);

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'connected to server';
}

class WebsocketCannotConnect extends WebsocketState{
  @override
  String toString() => 'can not connect to server';
}
