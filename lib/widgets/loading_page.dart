import '../imports.dart';

class Loading extends StatelessWidget {
  // String data = 'Loading';
  final String warning = strController.loadingPageWarningStr.value;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    check();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: PlatformExt.isMobile
                  ? null
                  : BoxConstraints(maxHeight: Get.height * 0.60),
              child: Image.asset('assets/logo.png'),
            ),
            Padding(padding: EdgeInsets.all(24.0)),
            Obx(() {
              var status = varStore.loadingStatus;
              return Text(
                status.value,
                style: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
              );
            }),
            Obx(() {
              var percent = varStore.loadingPercent;
              if (percent < 1) return CircularProgressIndicator();
              return Text(
                '($percent%)',
                style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
              );
            }),
            Text(
              warning,
              style: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
