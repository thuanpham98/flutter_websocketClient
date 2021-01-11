import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:ws_app/blocs/websocket/bloc.dart';
import 'package:ws_app/blocs/websocket/websocket_bloc.dart';
import 'package:ws_app/blocs/websocket/websocket_state.dart';

import 'dart:convert';

class WsBlocWidget extends StatefulWidget{ 
  final Widget loading;
  final Widget Function(BuildContext,String) builder;
  WsBlocWidget({Key key ,this.loading,this.builder});

  @override
  _WsBlocWidgetState createState() => _WsBlocWidgetState();
}

class _WsBlocWidgetState extends State<WsBlocWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<WebsocketBloc>()
      ..add(WsEventConnect())
      ..add(WsEventSend(jsonEncode({'action':"onMessage"}))),
      child:BlocBuilder<WebsocketBloc,WsState>(
        builder: (BuildContext context, WsState state) {
          if(state is WsStateReceived && state !=null){
            return widget.builder(context,state.message);
          }else if(state is WsEventDisconnect){
            GetIt.I<WebsocketBloc>().add(WsEventReconnect());
          }
          return widget.loading;
        },
      ),
    );
  }
}