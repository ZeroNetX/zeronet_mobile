package `in`.canews.zeronetmobile

import android.annotation.SuppressLint
import android.app.Activity
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ShareCompat
import androidx.core.content.FileProvider
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
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
const val CHANNEL = "in.canews.zeronetmobile"
const val EVENT_CHANNEL = "in.canews.zeronetmobile/installModules"

class MainActivity : FlutterActivity() {

    private var archName = ""
    private var splitInstallManager: SplitInstallManager? = null
    private lateinit var result: MethodChannel.Result
    private var mSessionId = -1
    private var mLaunchShortcutUrl = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if(intent.getStringExtra("LAUNCH_SHORTCUT_URL") != null) {
            mLaunchShortcutUrl = intent.getStringExtra("LAUNCH_SHORTCUT_URL")!!
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "addToHomeScreen" -> addShortcutToHomeScreen(context, result,
                        call.argument("title"),call.argument("url"),
                        call.argument("logoPath")
                )
                "batteryOptimisations" -> getBatteryOptimizations(result)
                "copyAssetsToCache" -> result.success(copyAssetsToCache())
                "getAppInstallTime" -> getAppInstallTime(result)
                "getAppLastUpdateTime" -> getAppLastUpdateTime(result)
                "isBatteryOptimized" -> isBatteryOptimized(result)
                "isPlayStoreInstall" -> result.success(isPlayStoreInstall(this))
                "initSplitInstall" -> {
                    if (splitInstallManager == null)
                        splitInstallManager = LocallyDynamicSplitInstallManagerFactory.create(this)
                    result.success(true)
                }
                "isModuleInstallSupported" -> result.success(isModuleInstallSupported())
                "isRequiredModulesInstalled" -> result.success(isRequiredModulesInstalled())
                "launchZiteUrl" -> result.success(mLaunchShortcutUrl)
                "moveTaskToBack" -> {
                    moveTaskToBack(true)
                    result.success(true)
                }
                "nativeDir" -> result.success(applicationInfo.nativeLibraryDir)
                "nativePrint" -> {
                    Log.e("Flutter>nativePrint()","TODO!: call.arguments()!")
                }
                "openJsonFile" -> openJsonFile(result)
                "openZipFile" -> openZipFile(result)
                "readJsonFromUri" -> readJsonFromUri(call.arguments.toString(), result)
                "readZipFromUri" -> readZipFromUri(call.arguments.toString(), result)
                "saveUserJsonFile" -> saveUserJsonFile(this, call.arguments.toString(), result)
                "uninstallModules" -> uninstallModules()
            }
        }
        EventChannel(flutterEngine.dartExecutor, EVENT_CHANNEL).setStreamHandler(
                object : StreamHandler {
                    lateinit var events: EventChannel.EventSink
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

    private fun addShortcutToHomeScreen(context: Context,mResult: MethodChannel.Result,
                                        title:String?,url:String?,logoPath:String?) {
        if (ShortcutManagerCompat.isRequestPinShortcutSupported(context)) {
            val shortcutInfoBuilder: ShortcutInfoCompat.Builder = ShortcutInfoCompat.Builder(context, title.toString())
                    .setIntent(
                            Intent(context, MainActivity::class.java)
                                    .setAction(Intent.ACTION_MAIN)
                                    .putExtra(
                                            "LAUNCH_SHORTCUT_URL",
                                            url
                                    )
                    )
                    .setShortLabel(title.toString())
            if (logoPath.toString().isNotEmpty()){
                val image = File(logoPath.toString())
                val bmOptions: BitmapFactory.Options = BitmapFactory.Options()
                val bitmap: Bitmap = BitmapFactory.decodeFile(image.absolutePath, bmOptions)
                shortcutInfoBuilder.setIcon(IconCompat.createWithBitmap(bitmap))
            } else {
                shortcutInfoBuilder.setIcon(IconCompat.createWithResource(context, R.drawable.logo))
            }
            val shortcutInfo: ShortcutInfoCompat = shortcutInfoBuilder.build()
            val shortcutCallbackIntent: PendingIntent = PendingIntent.getBroadcast(context,
                    0,
                    Intent(context, MainActivity::class.java)
                            .putExtra("SHORTCUT_ADDED",true),
                    PendingIntent.FLAG_UPDATE_CURRENT)
            ShortcutManagerCompat.requestPinShortcut(context, shortcutInfo, shortcutCallbackIntent.intentSender)
            mResult.success(true)
        } else {
            // Shortcut is not supported by your launcher
        }
    }

    private fun getAppInstallTime(result: MethodChannel.Result) {
        val info = context.packageManager.getPackageInfo(context.packageName,0);
        val field = PackageInfo::class.java.getField("firstInstallTime")
        val timeStamp = field.getLong(info)
        result.success(timeStamp.toString())
    }

    private fun getAppLastUpdateTime(result: MethodChannel.Result) {
        val info = context.packageManager.getPackageInfo(context.packageName,0);
        val field = PackageInfo::class.java.getField("lastUpdateTime")
        val timeStamp = field.getLong(info)
        result.success(timeStamp.toString())
    }

    private fun isPlayStoreInstall(context: Context): Boolean {
        val validInstallers: List<String> = listOf("com.android.vending", "com.google.android.feedback")
        val installer = context.packageManager.getInstallerPackageName(context.packageName)

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
        result.runCatching {
            success(msg)
        }.onFailure {
            if (it is IllegalStateException) {
                Log.e("MainActivity>resultSuc>", it.message!!)
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
            Log.e("copyFileToTempPath: ", filename + " copied to " + tempFilePath)
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
        shareIntent.putExtra(Intent.EXTRA_TEXT,"Save this file to a Safe place.")
        shareIntent.action = Intent.ACTION_SEND
        shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri)
        shareIntent.putExtra("finishActivityOnSaveCompleted", true)
        context.startActivityForResult(Intent.createChooser(
                shareIntent, "Backup Users.json File"), SAVE_USERJSON_FILE)
        result = resultT
    }

    private fun copyAssetsToCache(): Boolean {
        getArchName()
        try {
            if (splitInstallManager?.installedModules!!.contains("common")) {
                getAssetFiles("zeronet_py3.zip")
            }
            if (archName != "arm64" && splitInstallManager?.installedModules!!.contains("common_python")) {
                getAssetFiles("site_packages_common.zip")
            }
            if (splitInstallManager?.installedModules!!.contains(archName)) {
                getAssetFiles("site_packages_$archName.zip")
            }
            if (splitInstallManager?.installedModules!!.contains(archName + "_python")) {
                getAssetFiles("python38_$archName.zip")
            }
            if (splitInstallManager?.installedModules!!.contains(archName + "_tor")) {
                getAssetFiles("tor_$archName.zip")
            }
        } catch (e: IOException) {
            Log.e("copyAssetsToCache", e.toString())
            return false
        }
        return true
    }

    private fun getAssetFiles(fileName: String) {
        val assetManager = createPackageContext(packageName, 0).assets
        val assistContent = assetManager.open(fileName)
        Log.e("getAssetFiles: ", fileName)
        copyFileToTempPath(inputStreamA = assistContent, filename = fileName, path = null)
    }

    private fun isModuleInstallSupported(): Boolean =
            Build.VERSION.SDK_INT <= 30 && isGooglePlayServicesAvailable(this)

    private fun isGooglePlayServicesAvailable(activity: Activity?): Boolean {
        val googleApiAvailability: GoogleApiAvailability = GoogleApiAvailability.getInstance()
        val status: Int = googleApiAvailability.isGooglePlayServicesAvailable(applicationContext)
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
        val builder = SplitInstallRequest.newBuilder()
                .addModule("common")
                .addModule(name)
                .addModule(name + "_python")
                .addModule(name + "_tor")
        if (name != "arm64") {
            builder.addModule("common_python")
        }
        val request = builder.build();
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
            ((archName == "arm64") ||  isModuleInstalled("common_python") == true)&&
            isModuleInstalled(archName) == true &&
            isModuleInstalled(archName + "_python") == true &&
            isModuleInstalled(archName + "_tor") == true

    private fun uninstallModules() {
        val installedModules = splitInstallManager?.installedModules?.toList()
        splitInstallManager?.deferredUninstall(listOf("common",archName))?.addOnSuccessListener {
            Log.d("SplitModuleUninstall:>:","Uninstalling $installedModules")
        }
        context.cacheDir.deleteRecursively()
    }
}
