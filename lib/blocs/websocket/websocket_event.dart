import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WsEvent extends Equatable {
  const WsEvent();

  @override
  List<Object> get props => [];
}

class WsEventConnect extends WsEvent{
  const WsEventConnect();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Start connect to server';
}

class WsEventDisconnect extends WsEvent{
  const WsEventDisconnect();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'Disconnect to server';
}

class WsEventSend extends WsEvent{
  final String message;
  const WsEventSend(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Sending Message : '+ message;
}

class WsEventReceive extends WsEvent{
  final String message;
  const WsEventReceive(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'Incomming Message : ' + message ;
}

class WsEventReconnect extends WsEvent{
  const WsEventReconnect();

  @override 
  String toString() => 'try reconnecting to server';
}

