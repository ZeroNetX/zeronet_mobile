//package `in`.canews.zeronet
//
//import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin
//import io.flutter.app.FlutterApplication
//import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin
//
//
//internal class MyApplication : FlutterApplication(){
//
//   override fun onCreate() {
//       super.onCreate()
//       FlutterLocalNotificationsPlugin.setPluginRegistrant {
//           registry ->
//           SharedPreferencesPlugin
//                   .registerWith(
//                   registry.registrarFor(
//                           "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"
//                   )
//           )
//       }
//   }
//}
