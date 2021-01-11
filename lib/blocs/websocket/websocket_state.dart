import 'package:equatable/equatable.dart';

abstract class WsState extends Equatable {
  const WsState();
  
  @override
  List<Object> get props => [];
}

class WsStateConnecting extends WsState {
  @override
  String toString() => 'Try connecting to server';
}

class WsStateConnected extends WsState{
  final String result;
  const WsStateConnected(this.result);

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'Connected to server';
}

class WsStateReceived extends WsState{
  final String message;
  const WsStateReceived(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Received message' + message;
}

class WsStateConnectFail extends WsState{
  @override
  String toString() => 'Can not connect to server';
}

class WsStateDisconnected extends WsState{
  @override
  String toString() => 'Disconnected from Server';
}
