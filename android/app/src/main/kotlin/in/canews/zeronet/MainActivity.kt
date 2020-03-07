package `in`.canews.zeronet

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ShareCompat
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.io.IOException
import java.io.InputStream


const val BATTERY_OPTIMISATION_RESULT_CODE = 1
const val PICK_USERJSON_FILE = 2
const val SAVE_USERJSON_FILE = 3
const val TAG = "MainActivity"

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine?.dartExecutor, "in.canews.zeronet").setMethodCallHandler { call, result ->
            when (call.method) {
                "batteryOptimisations" -> getBatteryOptimizations(result)
                "isBatteryOptimized" -> isBatteryOptimized(result)
                "nativeDir" -> result.success(applicationInfo.nativeLibraryDir)
                "openFile" -> openFile(result)
                "readJsonFromUri" -> readJsonFromUri(call.arguments.toString(), result)
                "saveUserJsonFile" -> saveUserJsonFile(this, call.arguments.toString(), result)
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    private fun isBatteryOptimized(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val packageName = packageName
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            result.success(pm.isIgnoringBatteryOptimizations(packageName))
        } else {
            result.success(false)
        }

    }

    private lateinit var result: MethodChannel.Result

    private fun getBatteryOptimizations(resultT: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent()
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                intent.action = Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                intent.data = Uri.parse("package:$packageName")
                startActivityForResult(intent, BATTERY_OPTIMISATION_RESULT_CODE)
                result = resultT
            } else {
                resultT.success(true)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == BATTERY_OPTIMISATION_RESULT_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                result.success(true)
            } else {
                result.success(false)
            }
        } else if (requestCode == SAVE_USERJSON_FILE) {
            if (resultCode == Activity.RESULT_OK) {
                result.success("successfully saved users.json file")
            } else {
                result.success("failed to save file")
            }
        } else if (requestCode == PICK_USERJSON_FILE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data?.data != null) {
                    result.success(data.data.toString())
                }
            } else {
                result.error("526", "Error Picking User Json File", "Error Picking User Json File")
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun openFile(resultT: MethodChannel.Result) {//pickerInitialUri: Uri
        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = "application/json"
            result = resultT
        }
        startActivityForResult(intent, PICK_USERJSON_FILE)
    }

    @Throws(IOException::class)
    private fun readJsonFromUri(path: String, resultT: MethodChannel.Result) {
        var inputstream: InputStream? = null
        if (path.startsWith("content://")) {
            inputstream = contentResolver.openInputStream(Uri.parse(path))
        } else if (path.startsWith("/")) {
            inputstream = File(path).inputStream()
        }
        inputstream.use { inputStream ->
            val tempFilePath = filesDir.path + "/users.json"
            val tempFile = File(tempFilePath)
            if (tempFile.exists()) tempFile.delete()
            tempFile.createNewFile()
            inputStream?.toFile(tempFilePath)
            resultT.success(File(tempFilePath).absoluteFile.absolutePath)
            tempFile.deleteOnExit()
        }
    }

    fun InputStream.toFile(path: String) {
        use { input ->
            File(path).outputStream().use { input.copyTo(it) }
        }
    }

    private fun saveUserJsonFile(context: Activity, path: String, resultT: MethodChannel.Result) {
        Log.d(TAG, "backing up user json file")
        val file = File(path)
        val authority = context.packageName + ".fileprovider"
        Log.d(TAG, "authority: $authority")
        val contentUri: Uri = FileProvider.getUriForFile(context, authority, file)
        val shareIntent: Intent = ShareCompat.IntentBuilder.from(context)
                .setType("application/octet-stream")
                .setStream(contentUri)
                .setText("users.json")
                .intent
        shareIntent.data = contentUri
        shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        shareIntent.putExtra("finishActivityOnSaveCompleted", true)
        context.startActivityForResult(Intent.createChooser(
                shareIntent, "Backup Users.json File"), SAVE_USERJSON_FILE)
        result = resultT
    }
}
