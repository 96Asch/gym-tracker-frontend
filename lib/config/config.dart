import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Config {
  static String get serverUrl => dotenv.env['SERVER_URL']!;
  static int get phoneSize => 600;
}
