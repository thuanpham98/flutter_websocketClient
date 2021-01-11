import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:ws_app/blocs/websocket/bloc.dart';
import 'websocket_event.dart';
import 'websocket_state.dart';
import 'websocket_repository.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ws_app/service_locator.dart';
import 'dart:convert';

class WebsocketBloc extends Bloc<WsEvent, WsState> {
  StreamSubscription _subscription;
  final WebsocketRepository _repository;

  WebsocketBloc({@required WebsocketRepository repository}) 
    : _repository = repository,
    super(WsStateConnecting());
  

  @override
  Stream<WsState> mapEventToState(
    WsEvent event,
  ) async* {
    if(event is WsEventConnect) {
      yield* _mapWsConnectToState();
    }else if(event is WsEventSend){
      yield* _mapWsSendToState(event);
    }else if(event is WsEventDisconnect) {
      yield* _mapWSDisconnectToState(event);
    }else if(event is WsEventReconnect) {
      yield* _mapWSReconnectToState(event);
    }else if(event is WsEventReceive) {
      yield* _mapWSReceivedToState(event);
    }
  }

  Stream<WsState> _mapWsConnectToState() async*{
    try{
      _subscription = (await _repository.messages()).listen(
        (message) {
          add(WsEventReceive(message));
        },
        // onError: () async{
        //   await Future.delayed(Duration(seconds: 3));
        //   add(WsEventReconnect());
        // }
      );
    }catch(_){
      yield WsStateConnectFail();
    }
  }

  Stream<WsState> _mapWsSendToState(WsEventSend event) async*{
    _repository.sendMessage(event.message);
  }

  Stream<WsState> _mapWSDisconnectToState(WsEventDisconnect event) async*{
    _subscription?.cancel();
    _repository.disconnect();
  }

  Stream<WsState> _mapWSReconnectToState(WsEventReconnect event) async*{
    locator.resetLazySingleton<WebsocketBloc>(
      instance: GetIt.I<WebsocketBloc>(),
    );
    GetIt.I<WebsocketBloc>()..add(WsEventConnect())
    ..add(WsEventSend(jsonEncode({'action':"connect"})));
  }

  Stream<WsState> _mapWSReceivedToState(WsEventReceive event) async*{
    yield WsStateReceived(event.message);
  }

  @override
  Future<void> close() {

    print("websocket is close");
  }
}
