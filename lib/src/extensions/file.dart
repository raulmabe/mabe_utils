import 'dart:io';

/// Extension methods for File types
extension FileExt on File {
  /// Returns the size of the file in MB
  double get sizeMb => lengthSync() / (1024 * 1024);
}
