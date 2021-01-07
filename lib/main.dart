import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ws_app/bloc/websocket/websocket_bloc.dart';
import 'package:ws_app/bloc/websocket/websocket_event.dart';
import 'package:ws_app/bloc/websocket/websocket_state.dart';

import 'app_bloc_delegate.dart';
import 'service_locator.dart';

void main() async{
  // Crashlytics.instance.enableInDevMode = true;
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
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
    GetIt.I<WebsocketBloc>().add(WebsocketEventConnect("he"));
    
  }
  int count=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: BlocProvider<WebsocketBloc>(
          create: (context) =>GetIt.I<WebsocketBloc>()..add(WebsocketEventSend("Thuận nek")),
          child: BlocBuilder<WebsocketBloc,WebsocketState>(
            builder: (BuildContext context , WebsocketState state){
              print(state);
              if(state is WebsocketConnected){
                return Container(
                  child: Column(
                    children: [
                      Text(state.result),
                      FloatingActionButton(onPressed: () async{
                        GetIt.I<WebsocketBloc>().add(WebsocketEventSend("đếm ${count}"));
                        // GetIt.I<WebsocketBloc>().add(WebsocketEventConnect("di"));
                        count++;
                      })
                    ],
                  )
                );
              }return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
