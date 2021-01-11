import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_bloc_delegate.dart';
import 'service_locator.dart';

import 'package:ws_app/blocs/websocket/websocket_widget.dart';
import 'package:ws_app/blocs/websocket/websocket_event.dart';
import 'package:ws_app/blocs/websocket/websocket_bloc.dart';

import 'dart:convert';

void main() async{
  Bloc.observer = AppBlocDelegate();

  try {
    await setupLocator();
  } catch (error) {
    print('Locator setup has failed');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState(){
    super.initState();
  }
  bool count=false;

  @override
  Widget build(BuildContext context) {

    String test = jsonEncode({'action':"onMessage", 'data':{"pin" : count}, 'id': "flutter"});

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: WsBlocWidget(
          builder: (BuildContext context , String message){
            return Container(
              child: Column(
                children: [
                  Text(message),
                  SizedBox(height: 50,),
                  FloatingActionButton(
                    onPressed: () async{
                      count=!count;
                      test = jsonEncode({'action':"onMessage", 'data':{"pin" : count}, 'id': "flutter"});
                      GetIt.I<WebsocketBloc>().add(WsEventSend(test));
                    }
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () async{
                      // count=!count;
                      // test = jsonEncode({'action':"onMessage", 'data':{"pin" : count}, 'id': "flutter"});
                      GetIt.I<WebsocketBloc>().add(WsEventDisconnect());
                    }
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.green,
                    onPressed: () async{ 

                      locator.resetLazySingleton<WebsocketBloc>(
                        instance: GetIt.I<WebsocketBloc>(),
                      );
                      GetIt.I<WebsocketBloc>()..add(WsEventConnect())
                      ..add(WsEventSend(jsonEncode({'action':"connect"})));
                    }
                  ),
                ],
              ),
            );
          },
          loading: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
