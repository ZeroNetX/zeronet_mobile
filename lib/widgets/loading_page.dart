import '../imports.dart';

class Loading extends StatelessWidget {
  // String data = 'Loading';
  final String warning = """
    Please Wait! This may take a while, happens 
    only first time, Don't Press Back button.
    If You Accidentally Pressed Back,
    Clean App Storage in Settings or 
    Uninstall and Reinstall The App.
    """;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    check();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png'),
            Padding(
              padding: EdgeInsets.all(24.0),
            ),
            Observer(
              builder: (context) {
                var status = varStore.loadingStatus;
                return Text(
                  status,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                  ),
                );
              },
            ),
            Observer(builder: (context) {
              var percent = varStore.loadingPercent;
              return (percent < 1)
                  ? CircularProgressIndicator()
                  : Text(
                      '($percent%)',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                      ),
                    );
            }),
            Text(
              warning,
              style: TextStyle(
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
