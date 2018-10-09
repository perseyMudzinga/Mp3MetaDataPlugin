package com.mudzinga.mp3metadata;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Build;

import java.io.File;
import java.io.FileOutputStream;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** Mp3MetaDataPlugin */
public class Mp3MetaDataPlugin implements MethodCallHandler {
  private final MethodChannel channel;
  private Activity activity;


  Mp3MetaDataPlugin(Activity activity, MethodChannel channel) {
    this.activity = activity;
    this.channel = channel;
    channel.setMethodCallHandler(this);
  }


  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "mp3_meta_data");
    channel.setMethodCallHandler(new Mp3MetaDataPlugin(registrar.activity(), channel));
  }

  @TargetApi(Build.VERSION_CODES.GINGERBREAD_MR1)
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    byte[] image = null;
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }
    else if (call.method.equals("getAlbumArt")) {
      String path = call.argument("path").toString();
      try {
        MediaMetadataRetriever mmr = new MediaMetadataRetriever();
        mmr.setDataSource(Uri.fromFile(new File(path)).getPath());
        image = mmr.getEmbeddedPicture();
      } catch (Exception e) {
        System.out.println(e);
      }
      result.success(image);
    } else {
      result.notImplemented();
    }
  }
}
