package `in`.canews.zeronet

import android.annotation.SuppressLint
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
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.play.core.splitinstall.SplitInstallManager
import com.google.android.play.core.splitinstall.SplitInstallRequest
import com.google.android.play.core.splitinstall.model.SplitInstallSessionStatus
import com.jeppeman.locallydynamic.LocallyDynamicSplitInstallManagerFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.io.IOException
import java.io.InputStream


const val BATTERY_OPTIMISATION_RESULT_CODE = 1001
const val PICK_USERJSON_FILE = 1002
const val SAVE_USERJSON_FILE = 1003
const val PICK_ZIP_FILE = 1004
const val TAG = "MainActivity"
const val CHANNEL = "in.canews.zeronet"
const val EVENT_CHANNEL = "in.canews.zeronet/installModules"

class MainActivity : FlutterActivity() {

    private var archName = ""
    private var splitInstallManager: SplitInstallManager? = null
    private lateinit var result: MethodChannel.Result
    private var mSessionId = -1;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "batteryOptimisations" -> getBatteryOptimizations(result)
                "isBatteryOptimized" -> isBatteryOptimized(result)
                "isPlayStoreInstall" -> result.success(isPlayStoreInstall(this))
                "initSplitInstall" -> {
                    if (splitInstallManager == null)
                        splitInstallManager = LocallyDynamicSplitInstallManagerFactory.create(this)
                    result.success(true)
                }
                "uninstallModules" -> uninstallModules()
                "isModuleInstallSupported" -> result.success(isModuleInstallSupported())
                "isRequiredModulesInstalled" -> result.success(isRequiredModulesInstalled())
                "copyAssetsToCache" -> result.success(copyAssetsToCache())
                "nativeDir" -> result.success(applicationInfo.nativeLibraryDir)
                "openJsonFile" -> openJsonFile(result)
                "openZipFile" -> openZipFile(result)
                "readJsonFromUri" -> readJsonFromUri(call.arguments.toString(), result)
                "readZipFromUri" -> readZipFromUri(call.arguments.toString(), result)
                "saveUserJsonFile" -> saveUserJsonFile(this, call.arguments.toString(), result)
                "nativePrint" -> {
                    Log.e("Flutter>nativePrint()",call.arguments())
                }
                "moveTaskToBack" -> {
                    moveTaskToBack(true)
                    result.success(true)
                }
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        EventChannel(flutterEngine.dartExecutor, EVENT_CHANNEL).setStreamHandler(
                object : StreamHandler {
                    lateinit var events: EventChannel.EventSink;
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                        getArchName()
                        loadAndLaunchModule(archName, events)
                    }

                    override fun onCancel(arguments: Any?) {
                        events.endOfStream()
                    }
                }
        )
    }

    private fun isPlayStoreInstall(context: Context): Boolean {
        // A list with valid installers package name
        val validInstallers: List<String> = listOf("com.android.vending", "com.google.android.feedback")

        // The package name of the app that has installed your app
        val installer = context.packageManager.getInstallerPackageName(context.packageName)

        // true if your app has been downloaded from Play Store
        return installer != null && validInstallers.contains(installer)
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

    @SuppressLint("BatteryLife")
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

    override fun onActivityResult(
            requestCode: Int,
            resultCode: Int,
            data: Intent?
    ) {
        if (requestCode == BATTERY_OPTIMISATION_RESULT_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                resultSuccess(true)
            } else {
                resultSuccess(false)
            }
        } else if (requestCode == SAVE_USERJSON_FILE) {
            if (resultCode == Activity.RESULT_OK) {
                resultSuccess("successfully saved users.json file")
            } else {
                resultSuccess("failed to save file")
            }
        } else if (requestCode == PICK_USERJSON_FILE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data?.data != null) {
                    resultSuccess(data.data.toString())
                }
            } else {
                result.error("526", "Error Picking User Json File", "Error Picking User Json File")
            }
        } else if (requestCode == PICK_ZIP_FILE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data?.data != null) {
                    resultSuccess(data.data.toString())
                }
            } else {
                result.error("527", "Error Picking Plugin File", "Error Picking Plugin File")
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun resultSuccess(msg : Any) {
        result.success(msg).runCatching{}.onFailure {
            if (it is IllegalStateException) {
                Log.e("MainActivity>resultSuc>", it.message)
            }
        }
    }

    private fun openZipFile(
            resultT: MethodChannel.Result
    ) =
            openFileIntent(
                    resultT,
                    Intent.ACTION_OPEN_DOCUMENT,
                    "application/zip",
                    PICK_ZIP_FILE
            )

    private fun openJsonFile(
            resultT: MethodChannel.Result
    ) =
            openFileIntent(
                    resultT,
                    Intent.ACTION_OPEN_DOCUMENT,
                    "application/json",
                    PICK_USERJSON_FILE
            )

    private fun openFileIntent(
            resultT: MethodChannel.Result,
            intentAction: String,
            intentType: String,
            intentCode: Int
    ) {
        val intent = Intent(intentAction).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = intentType
            result = resultT
        }
        startActivityForResult(intent, intentCode)
    }

    private fun readJsonFromUri(path: String, resultT: MethodChannel.Result) = copyFileToTempPath(path, resultT, "/users.json")

    private fun readZipFromUri(path: String, resultT: MethodChannel.Result) = copyFileToTempPath(path, resultT, "/plugin.zip")

    @Throws(IOException::class)
    private fun copyFileToTempPath(
            path: String?,
            resultT: MethodChannel.Result? = null,
            filename: String,
            inputStreamA: InputStream? = null
    ) {
        var inputstream: InputStream? = null
        if (inputStreamA != null) {
            inputstream = inputStreamA
        } else {
            if (path != null)
                if (path.startsWith("content://")) {
                    inputstream = contentResolver.openInputStream(Uri.parse(path))
                } else if (path.startsWith("/")) {
                    inputstream = File(path).inputStream()
                }
        }
        inputstream.use { inputStream ->
            val tempFilePath = cacheDir.path + "/" + filename
            val tempFile = File(tempFilePath)
            if (tempFile.exists()) tempFile.delete()
            tempFile.createNewFile()
            inputStream?.toFile(tempFilePath)
            resultT?.success(File(tempFilePath).absoluteFile.absolutePath)
            tempFile.deleteOnExit()
        }
    }

    private fun InputStream.toFile(path: String) {
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

    private fun copyAssetsToCache(): Boolean {
        getArchName()
        try {
            if (splitInstallManager?.installedModules!!.contains("common")) {
                val list = listOf("zeronet_py3.zip", "site_packages_common.zip")
                for (item in list) {
                    getAssetFiles(item)
                }
            }
            if (splitInstallManager?.installedModules!!.contains(archName)) {
                val list = listOf("python38_$archName.zip", "site_packages_$archName.zip", "tor_$archName.zip")
                for (item in list) {
                    getAssetFiles(item)
                }
            }
        } catch (e: IOException) {
            return false
        }
        return true
    }

    private fun getAssetFiles(fileName: String) {
        val assetManager = createPackageContext(packageName, 0).assets
        val assistContent = assetManager.open(fileName)
        copyFileToTempPath(inputStreamA = assistContent, filename = fileName, path = null)
    }

    private fun isModuleInstallSupported(): Boolean =
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP
                    && isGooglePlayServicesAvailable(this)

    private fun isGooglePlayServicesAvailable(activity: Activity?): Boolean {
        val googleApiAvailability: GoogleApiAvailability = GoogleApiAvailability.getInstance()
        val status: Int = googleApiAvailability.isGooglePlayServicesAvailable(activity)
        if (status != ConnectionResult.SUCCESS) {
            // if (googleApiAvailability.isUserResolvableError(status)) {
            //     googleApiAvailability.getErrorDialog(activity, status, 2404).show()
            // }
            return false
        }
        return true
    }

    private fun getArchName() {
        val arch = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Build.SUPPORTED_ABIS
        } else {
            TODO("VERSION.SDK_INT < LOLLIPOP")
        }
        if (archName.isEmpty())
            archName = if (arch.contains("arm64-v8a")) {
                "arm64"
            } else if (arch.contains("armeabi-v7a")) {
                "arm"
            } else if (arch.contains("x86_64")) {
                "x86_64"
            } else {
                "x86"
            }
    }

    /**
     * Load a feature by module name.
     * @param name The name of the feature module to load.
     */
    private fun loadAndLaunchModule(name: String, eventSink: EventChannel.EventSink?) {
        if (isModuleInstalled(name) == true)
            return
        val request = SplitInstallRequest.newBuilder()
                .addModule("common")
                .addModule("nativelibs")
                .addModule(name)
                .build()
        splitInstallManager?.startInstall(request)?.addOnSuccessListener { sessionId ->
            mSessionId = sessionId
        }
        splitInstallManager?.registerListener { state ->
            if (state.sessionId() == mSessionId) {
                when (state.status()) {
                    SplitInstallSessionStatus.DOWNLOADING -> {
                        val msg = """
                            {
                                "status" : ${state.status()},
                                "downloaded" : ${state.bytesDownloaded()},
                                "total" : ${state.totalBytesToDownload()}
                            }
                            """.trimIndent()
                        eventSink?.success(msg)
                    }
                    SplitInstallSessionStatus.REQUIRES_USER_CONFIRMATION -> {
                        startIntentSender(state.resolutionIntent()?.intentSender, null, 0, 0, 0)
                    }
                    else -> {
                        val msg = """
                            {
                                "status" : ${state.status()}
                            }
                            """.trimIndent()
                        eventSink?.success(msg)
                    }
                }
            }
        }
    }

    private fun isModuleInstalled(name: String): Boolean? =
            splitInstallManager?.installedModules?.contains(name)

    private fun isRequiredModulesInstalled(): Boolean = isModuleInstalled("common") == true &&
            isModuleInstalled("nativelibs") == true &&
            isModuleInstalled(archName) == true

    private fun uninstallModules() {
        val installedModules = splitInstallManager?.installedModules?.toList()
        splitInstallManager?.deferredUninstall(listOf("common",archName))?.addOnSuccessListener {
            Log.d("SplitModuleUninstall:>:","Uninstalling $installedModules")
        }
        context.cacheDir.deleteRecursively()
    }
}
