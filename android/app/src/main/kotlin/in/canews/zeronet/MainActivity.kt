package `in`.canews.zeronet

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    MethodChannel(flutterView, "in.canews.zeronet").setMethodCallHandler { call, result ->
      when(call.method){
        "batteryOptimisations" -> getBatteryOptimizations()
        "isBatteryOptimized" -> isBatteryOptimized(result)
      }
    }
    GeneratedPluginRegistrant.registerWith(this)
  }

  private fun isBatteryOptimized(result: MethodChannel.Result) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      val packageName = packageName
      val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
      result.success(!pm.isIgnoringBatteryOptimizations(packageName))
    }else{
      result.success(false)
    }

  }

  private fun getBatteryOptimizations() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
      val intent = Intent()
      val packageName = packageName
      val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
      if (!pm.isIgnoringBatteryOptimizations(packageName)) {
        intent.action = Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
        intent.data = Uri.parse("package:$packageName")
        startActivity(intent)
      }
    }
  }
}
