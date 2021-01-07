import 'dart:convert';

import 'package:logger/logger.dart';

class MyPrinter extends LogPrinter {
  static final levelPrefixes = {
    Level.verbose: '[V]',
    Level.debug: '[D]',
    Level.info: '[I]',
    Level.warning: '[W]',
    Level.error: '[E]',
    Level.wtf: '[WTF]',
  };

  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  final bool printTime;
  final bool colors;

  MyPrinter({this.printTime = false, this.colors = false});

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    var timeStr = printTime ? 'TIME: ${DateTime.now().toIso8601String()}' : '';
    String stackTraceStr = '';
    stackTraceStr = formatStackTrace(StackTrace.current);
    return [stackTraceStr, '${_labelFor(event.level)} $timeStr $messageStr$errorStr'];
  }

  String _labelFor(Level level) {
    var prefix = levelPrefixes[level];
    var color = levelColors[level];

    return colors ? color(prefix) : prefix;
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }

  String formatStackTrace(StackTrace stackTrace) {
    int methodCount = 4;
    int methodCountSkip = 4;
    var lines = stackTrace.toString().split('\n');
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {

      if (count == methodCount) {
        break;
      }
      count ++;
      if (count < methodCountSkip) {
        continue;
      }

      formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }
}

class LoggerService {
  static LoggerService _instance;
  static Logger _logger;

  static LoggerService getInstance() {
    if (_instance == null) {
      _instance = LoggerService();
    }

    if (_logger == null) {
      _logger = Logger(
          printer: MyPrinter());
    }
    return _instance;
  }

  Logger getLog() {
    return _logger;
  }
}
