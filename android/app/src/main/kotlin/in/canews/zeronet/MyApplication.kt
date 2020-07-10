package `in`.canews.zeronet

import android.content.Context
import io.flutter.app.FlutterApplication
import com.google.android.play.core.splitcompat.SplitCompat
import com.google.android.play.core.splitcompat.SplitCompatApplication


internal class MyApplication : SplitCompatApplication(){
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        SplitCompat.install(base)
    }
}
