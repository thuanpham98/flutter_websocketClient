import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'services/logger_service.dart';

import 'package:ws_app/blocs/websocket/websocket_bloc.dart';
import 'package:ws_app/blocs/websocket/websocket_repository_server.dart';

final GetIt locator =GetIt.instance;
Logger log =Logger();

Future setupLocator() async {
  locator.registerSingleton<LoggerService>(LoggerService.getInstance());
  log = locator<LoggerService>().getLog();

  locator.registerLazySingleton(() => WebsocketBloc(repository: WebsocketRepositoryServer()));
}