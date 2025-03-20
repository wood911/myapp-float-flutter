import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LongPrettyPrinter extends PrettyPrinter {
  final int warpLen;

  @override
  LongPrettyPrinter({
    this.warpLen = 1000,
    stackTraceBeginIndex = 0,
    methodCount = 2,
    errorMethodCount = 8,
    lineLength = 120,
    colors = true,
    printEmojis = true,
    printTime = false,
    noBoxingByDefault = false,
  }) : super(
    stackTraceBeginIndex: stackTraceBeginIndex,
    methodCount: methodCount,
    errorMethodCount: errorMethodCount,
    lineLength: lineLength,
    colors: colors,
    printEmojis: printEmojis,
    printTime: printTime,
    noBoxingByDefault: noBoxingByDefault,
  );

  @override
  String stringifyMessage(message) {
    var msg = super.stringifyMessage(message);
    var i = 0;
    var len = warpLen;
    var newStr = "";
    while (msg.length > i + len) {
      var next = i + len;
      var last = msg.indexOf("\n", i);
      if (last < i + 1 || last > next) {
        newStr += "${msg.substring(i, next)}\n";
        i = next;
      } else {
        newStr += msg.substring(i, last);
        i = last;
      }
    }
    if (i + len > msg.length) {
      newStr += msg.substring(i);
    }
    return newStr;
  }
}

class Log {

  static final Logger _logger = Logger(printer: LongPrettyPrinter());

  static void d(dynamic message) {
    if (!kReleaseMode) {
      _logger.d(message);
    }
  }

  static void i(dynamic message) {
    if (!kReleaseMode) {
      _logger.i(message);
    }
  }

  static void w(dynamic message) {
    if (!kReleaseMode) {
      _logger.w(message);
    }
  }

  static void e(dynamic message) {
    if (!kReleaseMode) {
      _logger.e(message);
    }
  }

}