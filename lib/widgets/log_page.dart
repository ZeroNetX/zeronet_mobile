import '../imports.dart';

class ZeroNetLogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: uiStore.currentTheme.value.primaryColor,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(PlatformExt.isMobile ? 24 : 8)),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Column(
              children: <Widget>[
                ZeroNetAppBar(),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.83,
                  child: SingleChildScrollView(
                    child: Obx(
                      () => Text(
                        varStore.zeroNetLog.value,
                        style: TextStyle(
                          color: uiStore.currentTheme.value.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
