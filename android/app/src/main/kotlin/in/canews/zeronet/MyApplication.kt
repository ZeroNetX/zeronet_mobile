package `in`.canews.zeronetmobile

import android.app.Activity
import android.content.Context
import com.google.android.play.core.splitcompat.SplitCompat
import com.google.android.play.core.splitcompat.SplitCompatApplication
import io.flutter.FlutterInjector


internal class MyApplication : SplitCompatApplication() {

    override fun onCreate() {
        super.onCreate()
        FlutterInjector.instance().flutterLoader().startInitialization(this)
    }

    private var mCurrentActivity: Activity? = null

    fun getCurrentActivity(): Activity? {
        return mCurrentActivity
    }

    fun setCurrentActivity(mCurrentActivity: Activity?) {
        this.mCurrentActivity = mCurrentActivity
    }

    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        SplitCompat.install(base!!)
    }

}
