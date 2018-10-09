import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class Mp3MetaData {
  static const MethodChannel _channel =
      const MethodChannel('mp3_meta_data');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Uint8List> getAlbumArt(String path) async {
    Map<String, dynamic> args = <String, dynamic>{};
    args.putIfAbsent("path", () => path);
    final Uint8List image = Uint8List.fromList(await _channel.invokeMethod('getAlbumArt', args));
    return image;
  }
}
