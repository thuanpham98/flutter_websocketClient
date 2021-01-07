import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WebsocketEvent extends Equatable {
  const WebsocketEvent();

  @override
  List<Object> get props => [];
}

class WebsocketEventConnect extends WebsocketEvent{
  final String url;

  const WebsocketEventConnect(this.url);

  @override
  List<Object> get props => [url];

  @override
  String toString() => 'connect to server';

}

class WebsocketEventSend extends WebsocketEvent{
  final String message;

  const WebsocketEventSend(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Message : ${message}';

}

class WebsocketEventDisconnect extends WebsocketEvent{
  @override
  String toString() => 'disconnect to server';
}

class WebsocketEventConnectSuccess extends WebsocketEvent{
  final String message;

  const WebsocketEventConnectSuccess(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'connected susscessfull';
  
}

class WebsocketEventConnectFail extends WebsocketEvent{}

