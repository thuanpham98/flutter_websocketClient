import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:ws_app/bloc/websocket/bloc.dart';
import 'websocket_event.dart';
import 'websocket_state.dart';

import 'websocket_repository.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebsocketBloc extends Bloc<WebsocketEvent, WebsocketState> {
  StreamSubscription _wsSubscription;
  final WebsocketRepository _repository;

  WebsocketBloc({@required WebsocketRepository repository}) 
    : _repository = repository,
    super(WebsocketConnecting());
  

  @override
  Stream<WebsocketState> mapEventToState(
    WebsocketEvent event,
  ) async* {
    if(event is WebsocketEventConnect) {
      yield* _mapConnectWStoState();
    }else if(event is WebsocketEventSend){
      yield* _mapSendWStoState(event);
    }else if(event is WebsocketEventConnectSuccess) {
      yield* _mapWSConnectedtoState(event);
    }
  }

  Stream<WebsocketState> _mapConnectWStoState() async*{
    // _wsSubscription?.cancel();
    try{
      _wsSubscription = (await _repository.messages()).listen(
        (message) {
          print(message);
          add(WebsocketEventConnectSuccess(message));
      });
    }catch(_){
      yield WebsocketCannotConnect();
    }
  }

  Stream<WebsocketState> _mapSendWStoState(WebsocketEventSend event) async*{
    _repository.sendMessage(event.message);
    // add(WebsocketEventConnect("hel"));
  }

  Stream<WebsocketState>_mapWSConnectedtoState(WebsocketEventConnectSuccess event) async*{
    yield WebsocketConnected(event.message);
  }

  @override
  Future<void> close() {

    print("websocket is close");
  }
}
