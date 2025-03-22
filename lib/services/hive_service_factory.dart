import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveServiceFactory {
  HiveServiceFactory._();

  // Get an opened box, or open it if it doesn't exist
  static Future<Box<T>> getBox<T>(String boxName) async {
    final key = '${T.toString()}_$boxName';
    if (Hive.isBoxOpen(key)) {
      return Hive.box<T>(key);
    }
    return await Hive.openBox<T>(key);
  }

  // Close a specific box
  static Future<bool> closeBox<T>(String boxName) async {
    final key = '${T.toString()}_$boxName';
    if (Hive.isBoxOpen(key)) {
      await Hive.box<T>(key).close();
      return true;
    }
    return false;
  }
}
