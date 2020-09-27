import '../imports.dart';

class ShortcutLoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    switch (zeroBrowserTheme) {
      case 'dark':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.blueGrey[900],
            systemNavigationBarColor: Colors.blueGrey[900],
          ),
        );
        break;
      case 'light':
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
          ),
        );
        break;
      default:
    }
    return Container(
      color: zeroBrowserTheme == 'dark' ? Colors.blueGrey[900] : Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset('assets/logo.png'),
            Padding(
              padding: EdgeInsets.all(24.0),
            ),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 24.0,
                fontStyle: FontStyle.italic,
                color: zeroBrowserTheme == 'light'
                    ? Colors.blueGrey[900]
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
