package `in`.canews.zeronet

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private var BATTERY_OPTIMISATION_RESULT_CODE = 0
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine?.dartExecutor, "in.canews.zeronet").setMethodCallHandler { call, result ->
            when(call.method){
                "batteryOptimisations" -> getBatteryOptimizations(result)
                "isBatteryOptimized" -> isBatteryOptimized(result)
                "nativeDir" -> result.success(applicationInfo.nativeLibraryDir)
            }
        }
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
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

    private lateinit var result : MethodChannel.Result;

    private fun getBatteryOptimizations(resultT: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent()
            val packageName = packageName
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                intent.action = Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                intent.data = Uri.parse("package:$packageName")
                startActivityForResult(intent,BATTERY_OPTIMISATION_RESULT_CODE)
                result = resultT
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == BATTERY_OPTIMISATION_RESULT_CODE){
            if (resultCode == Activity.RESULT_OK){
                result.success(true)
            }else{
                result.success(false)
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }
}
