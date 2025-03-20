package com.sayegh.move_to_background;

import android.app.Activity;
import android.content.Context;
import android.util.Log;
import android.content.Intent;
import android.view.KeyEvent;
import android.app.PendingIntent;
import android.os.Handler;
import android.os.Looper;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

/** MoveToBackgroundPlugin */
public class MoveToBackgroundPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private static final String CHANNEL_NAME = "move_to_background";
  private MethodChannel channel;
  private static Activity activity;


  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    if (registrar.activity() != null) {
      MoveToBackgroundPlugin.activity = registrar.activity();
    }
    MoveToBackgroundPlugin plugin = new MoveToBackgroundPlugin();
    plugin.setupChannel(registrar.messenger(), registrar.context());
  }

  @Override
  @SuppressWarnings("deprecation")
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    setupChannel(binding.getFlutterEngine().getDartExecutor(), binding.getApplicationContext());
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    teardownChannel();
  }


  private void setupChannel(BinaryMessenger messenger, Context context) {
    channel = new MethodChannel(messenger, CHANNEL_NAME);
    channel.setMethodCallHandler(this);

  }

  private void teardownChannel() {
    channel.setMethodCallHandler(null);
    channel = null;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (MoveToBackgroundPlugin.activity == null) {
      Log.e("MoveToBackgroundPlugin", call.method + " failed: activity=null");
    }
    if (call.method.equals("moveTaskToBack")) {
      if (MoveToBackgroundPlugin.activity != null) {
        MoveToBackgroundPlugin.activity.moveTaskToBack(true);
      }
      result.success(true);
    } if (call.method.equals("goHome")) {
      if (MoveToBackgroundPlugin.activity != null) {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        MoveToBackgroundPlugin.activity.startActivity(intent);
      }
      result.success(true);
    } if (call.method.equals("appSwitch")) {
      if (MoveToBackgroundPlugin.activity != null) {
        MoveToBackgroundPlugin.activity.runOnUiThread(() -> {
          MoveToBackgroundPlugin.activity.dispatchKeyEvent(new KeyEvent(KeyEvent.ACTION_DOWN, KeyEvent.KEYCODE_APP_SWITCH));
        });
      }
      result.success(true);
    } if (call.method.equals("bringAppToFront")) {
      if (MoveToBackgroundPlugin.activity != null) {
        Activity activity = MoveToBackgroundPlugin.activity;
        Intent intent = new Intent(activity, activity.getClass());
        intent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT | Intent.FLAG_ACTIVITY_NEW_TASK);
        activity.startActivity(intent);
      }
      result.success(true);
    } else {
      result.notImplemented();
    }
  }


  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding)
  {
    MoveToBackgroundPlugin.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    MoveToBackgroundPlugin.activity = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    MoveToBackgroundPlugin.activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    MoveToBackgroundPlugin.activity = null;
  }

}
