import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:simple_permissions/simple_permissions.dart';
import 'package:flutter/services.dart';
import 'package:mp3_meta_data/mp3_meta_data.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  Uint8List image;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Mp3MetaData.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Get Meta'),
                onPressed: () async {
                  await SimplePermissions.requestPermission(
                      Permission.ReadExternalStorage);
                  await SimplePermissions.requestPermission(
                      Permission.WriteExternalStorage);
                  Uint8List a = await Mp3MetaData.getAlbumArt(
                      '/storage/emulated/0/Music/Music/NF/05 Wake Up.mp3');
                  setState(() {
                    image = a;
                  });

                },
              ),
              image != null ? Image(image: MemoryImage(image)) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
