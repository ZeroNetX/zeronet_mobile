package `in`.canews.zeronet

import android.content.Context
import io.flutter.app.FlutterApplication
import com.google.android.play.core.splitcompat.SplitCompat


internal class MyApplication : FlutterApplication(){
    override fun attachBaseContext(base: Context?) {
        super.attachBaseContext(base)
        SplitCompat.install(base)
    }
}
