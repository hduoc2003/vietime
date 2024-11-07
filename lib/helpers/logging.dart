import 'package:logging/logging.dart';
import 'package:logging_to_logcat/logging_to_logcat.dart';


Future initLogging() async {
  Logger.root.activateLogcat();
  Logger.root.level = Level.ALL;
}
