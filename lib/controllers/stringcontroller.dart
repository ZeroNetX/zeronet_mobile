import '../imports.dart';

final strController = Get.put(StrController());

class StrController extends GetxController {
  var statusStr = 'Status'.obs;
  var statusNotRunningStr = 'Not Running'.obs;
  var statusInitializingStr = 'Initializing..'.obs;
  var statusStartingStr = 'Starting'.obs;
  var statusRunningStr = 'Running'.obs;
  var statusRunningWithTorStr = 'Running with Tor'.obs;
  var statusErrorStr = 'Error'.obs;
  var popularSitesStr = 'Popular Sites'.obs;
  var startZeroNetFirstStr =
      'Please Start ZeroNet First to Browse this Zite'.obs;
  var createStr = 'Create'.obs;
  var openStr = 'OPEN'.obs;
  var downloadStr = 'DOWNLOAD'.obs;
  var addToHomeScreenStr = 'Add to HomeScreen'.obs;
  var showLogStr = 'Show Log'.obs;
  var pauseStr = 'Pause'.obs;
  var resumeStr = 'Resume'.obs;
  var deleteZiteStr = 'Delete Zite'.obs;
  var shrtAddedToHomeScreenStr = 'shortcut added to HomeScreen'.obs;
  var startStr = 'Start'.obs;
  var restartStr = 'Restart'.obs;
  var pleaseWaitStr = 'Please Wait..!'.obs;
  var stopStr = 'Stop'.obs;
  var closeStr = 'Close'.obs;
  var viewLogStr = 'View Log'.obs;
  var aboutStr = 'About'.obs;
  var settingsStr = 'Settings'.obs;
  var browserStr = 'Browser'.obs;
  var logStr = 'Log'.obs;
  var updateStr = 'Update'.obs;
  var downloadingStr = 'Downloading'.obs;
  var downloadedStr = 'Downloaded'.obs;
  var installStr = 'Install'.obs;
  var restoreStr = 'Restore'.obs;
  var installingStr = 'Installing'.obs;
  var installationCompletedStr = 'Installation Completed'.obs;
  var notAvaliableStr = 'Not Available'.obs;
  var aboutAppDesStr = 'ZeroNet Mobile is a full native client for ZeroNet, '
          'a platform for decentralized websites using Bitcoin '
      .obs;
  var aboutAppDes1Str =
      'crypto and the BitTorrent network. you can learn more about ZeroNet at '
          .obs;
  var developersStr = 'Developers'.obs;
  var donationAddrsStr = 'Donation Addresses'.obs;
  var clickAddrToCopyStr = '* Click on Address to copy'.obs;
  var donAddrCopiedStr = 'Donation Address Copied to Clipboard'.obs;
  var donationDes = "* Any Donation can activate all pro-features in app, "
          "these are just an encouragement to me to work more on the app. "
          "Pro-features will be made available to general public after certain time, "
          "thus you don't need to worry about exclusiveness of a feature. "
          "If you donate from any source other than Google Play Purchase, "
          "just send your transaction id to canews.in@gmail.com / ZeroMail: zeromepro, "
          "so than I can send activation code to activate pro-features."
      .obs;
  var contributeStr = 'Contribute'.obs;
  var contributeDesStr = "If you want to support project's further development, "
          "you can contribute your time or money, "
          "If you want to contribute money you can send bitcoin or "
          "other supported crypto currencies to above addresses or buy in-app purchases, "
          "if want to contribute translations or code, visit official GitHub repo."
      .obs;
  var googlePurchasesStr = 'Google Play Purchases'.obs;
  var googleFeeWarningStr = '(30% taken by Google) :'.obs;
  var oneTimeSubStr = 'One Time'.obs;
  var monthlySubStr = 'Monthly Subscriptions'.obs;
  var tipStr = 'Tip'.obs;
  var coffeeStr = 'Coffee'.obs;
  var lunchStr = 'Lunch'.obs;
  var usersFileCopied = 'Users.json content copied to Clipboard'.obs;
  var chkBckUpStr = 'Please check yourself that file back up Successfully.'.obs;
  var zeroNetNotInitTitleStr = 'ZeroNet data folder not Exists.'.obs;
  var zeroNetNotInitDesStr =
      "ZeroNet should be used atleast once (run it from home screen), "
              "before using this option"
          .obs;
  var loadingStr = 'Loading'.obs;
  var switchProfileToStr = 'Switch Profile to'.obs;
  var switchProfileToDesStr = 'this will delete the existing profile, '
          'backup existing profile using backup button below'
      .obs;
  var backupStr = 'Backup'.obs;
  var switchStr = 'Switch'.obs;
  var loadingPageWarningStr = """
    Please Wait! This may take a while, happens 
    only first time, Don't Press Back button.
    If You Accidentally Pressed Back,
    Clean App Storage in Settings or 
    Uninstall and Reinstall The App.
    """
      .obs;
  var appUpdateAvailableStr = 'App Update Available : '.obs;
  var knowMoreStr = 'Know More'.obs;
  var ratingWgtStr = 'Give Your Rating/Feedback'.obs;
  var siteInfoStr = 'SiteInfo'.obs;
  var backupWarningStr =
      'Always remember to backup users.json before doing anything because, '
              'we are not able to tell when a software will fail. '
              'Click Backup below to backup your Existing users.json file.\n'
          .obs;
  var usernameStr = 'Username'.obs;
  var usernamePhraseStr = 'Username Phrase :'.obs;
  var usrnameWarning1Str = 'username can\'t be Empty'.obs;
  var usrnameWarning2Str = 'username can\'t contain spaces'.obs;
  var usrnameWarning3Str = 'username can\'t be less than 6 characters.'.obs;
  var usrnameWarning4Str = 'username already exists, choose different one.'.obs;
  var znNotiRunningTitleStr = 'ZeroNet Mobile is Running'.obs;
  var znNotiRunningDesStr = 'Click Here on this Notification to open app'.obs;
  var znNotiNotRunningTitleStr = 'ZeroNet Mobile is Not Running'.obs;
  var znNotiNotRunningDesStr =
      'Open ZeroNet Mobile App and click start to run ZeroNet'.obs;
  var znPluginInstallingTitleStr = 'Installing Plugin'.obs;
  var znPluginInstallingDesStr =
      'This Dialog will be automatically closed after installation, '
              'After Installation Restart ZeroNet from Home page'
          .obs;
  var zninstallAPluginTitleStr = 'Install A Plugin'.obs;
  var zninstallAPluginDesStr = 'This will load plugin to your ZeroNet repo, '
          '\nWarning : Loading Unknown/Untrusted plugins may compromise ZeroNet Installation.'
      .obs;
  var restoreProfileTitleStr = 'Restore Profile ?'.obs;
  var restoreProfileDesStr = 'this will delete the existing profile, '
          'backup existing profile using backup button below\n\n'
          'Selected Userfile : \n'
      .obs;
  var restoreProfileDes1Str =
      'You can only select users.json file, outside zeronet data folder'.obs;
  var existingProfileTitleStr = 'Provide A Name for Existing Profile'.obs;
  var createNewProfileStr = 'Create New Profile'.obs;
  var importProfileStr = 'Import Profile'.obs;
  var backupProfileStr = 'Backup Profile'.obs;
  var openPluginManagerStr = 'Open Plugin Manager'.obs;
  var loadPluginStr = 'Load Plugin'.obs;
  var zerohelloSiteDesStr = 'Say Hello to ZeroNet, a Dashboard to manage '
          'all your ZeroNet Z(S)ites, You can view feed of other zites like '
          'posts, comments of other users from ZeroTalk as well for your posts '
          'and Stats like Total Requests sent and received from other peers on ZeroNet. '
          'You can also pause, clone or favourite, delete Zites from single page.'
      .obs;
  var zeronetMobileSiteDesStr = 'Forum to report ZeroNet Mobile app issues. '
          'Want a new feature in the app, Request a Feature. '
          'Facing any Bugs while using the app ? '
          'Just report problem here, we will take care of it. '
          'Want to Discuss any topic about app development ? '
          'Just dive into to this Zite.'
      .obs;
  var zeroTalkSiteDesStr = 'Need a forum to discuss something, '
          'we got covered you here. ZeroTalk fits your need, '
          'just post something to get opinion from others on Network. '
          'Have some queries ? don\'t hesitate to ask here.'
          'Tired of Spam ? Who don\'t! You can mute individual users also.'
      .obs;
  var zeroblogSiteDesStr = 'Want to Know Where ZeroNet is Going ? '
          'ZeroBlog gives you latest changes and improvements '
          'made to ZeroNet, including Bug Fixes, '
          'Speed Improvements of ZeroNet Core Software. '
          'Also Provides varies links to ZeroNet Protocol and '
          'how ZeroNet works underhood and much more things to know.'
      .obs;
  var zeromailSiteDesStr = 'So you need a mail service, use ZeroMail, '
          'fully end-to-end encrypted mail service on ZeroNet, '
          'don\'t let others scanning your mailbox for their profits '
          'all your data is encrypted and can only opened by you. '
          'Your all mails are backedup, so you can stay calm for your data.'
      .obs;
  var zeromeSiteDesStr = 'Social Network is everywhere, so we made one here too. '
          'Twitter like, Peer to Peer Social Networking in your hands without data-tracking, '
          'Follow others and post your thoughts, like, comment on others posts, it\'s that easy-peasy. '
          'Find Like minded people and increase your friend circle beyond the borders.'
      .obs;
  var zeroSitesSiteDesStr = 'Want to know more sites on ZeroNet, '
          'visit ZeroSites, listing of community contributed sites under various '
          'categories like Blogs, Services, Forums, Chat, Video, Image, Guides, News and much more. '
          'You can even filter those lists with your preferred language '
          'to get more comprehensive list. Has a New Site to Show, Just Submit here.'
      .obs;
  var themeSwitcherStr = 'Theme'.obs;
  var themeSwitcherDesStr = 'Switch App Theme between Light, Dark, Black'.obs;
  var languageSwitcherStr = 'Language'.obs;
  var languageSwitcherDesStr = 'Change App Language to your Native Speaks'.obs;
  var profileSwitcherStr = 'Profile Switcher'.obs;
  var profileSwitcherDesStr = 'Create and Use different Profiles on ZeroNet, '
          'Import Existing Profiles from other devices, or Backup your Profile. '
          '\nNote: If Backup Profile doesn\'t work. Long Press the "Backup Profile" Button, '
          'it will copy users.json file contents to clipboard, so that you can save the private keys from this option.'
      .obs;
  var debugZeroNetStr = 'Debug ZeroNet Code'.obs;
  var debugZeroNetDesStr =
      'Useful for Developers to find bugs and errors in the code.'.obs;
  var enableZeroNetConsoleStr = 'Enable ZeroNet Console'.obs;
  var enableZeroNetConsoleDesStr =
      'Useful for Developers to see the exec of ZeroNet Python code'.obs;
  var enableZeroNetFiltersStr = 'Enable ZeroNet Filters'.obs;
  var enableZeroNetFiltersDesStr =
      'Enabling ZeroNet Filters blocks known ametuer content sites and spam users.'
          .obs;
  var enableAdditionalTrackersStr = 'Additional BitTorrent Trackers'.obs;
  var enableAdditionalTrackersDesStr =
      'Enabling External/Additional BitTorrent Trackers will give more ZeroNet Site Seeders or Clients.'
          .obs;
  var pluginManagerStr = 'Plugin Manager'.obs;
  var pluginManagerDesStr = 'Enable/Disable ZeroNet Plugins'.obs;
  var vibrateOnZeroNetStartStr = 'Vibrate on ZeroNet Start'.obs;
  var vibrateOnZeroNetStartDesStr = 'Vibrates Phone When ZeroNet Starts'.obs;
  var enableFullScreenOnWebViewStr = 'FullScreen for ZeroNet Zites'.obs;
  var enableFullScreenOnWebViewDesStr =
      'This will Enable Full Screen for in app Webview of ZeroNet'.obs;
  var batteryOptimisationStr = 'Disable Battery Optimisation'.obs;
  var batteryOptimisationDesStr =
      'This will Helps to Run App even App is in Background for long time.'.obs;
  var publicDataFolderStr = 'Public DataFolder'.obs;
  var publicDataFolderDesStr =
      'This Will Make ZeroNet Data Folder Accessible via File Manager.'.obs;
  var autoStartZeroNetStr = 'AutoStart ZeroNet'.obs;
  var autoStartZeroNetDesStr =
      'This Will Make ZeroNet Auto Start on App Start, So you don\'t have to click Start Button Every Time on App Start.'
          .obs;
  var autoStartZeroNetonBootStr = 'AutoStart ZeroNet on Boot'.obs;
  var autoStartZeroNetonBootDesStr =
      'This Will Make ZeroNet Auto Start on Device Boot.'.obs;
  var enableTorLogStr = 'Enable Tor Log'.obs;
  var enableTorLogDesStr =
      'This will Enable Tor Log in ZeroNet Console helpful for debugging.'.obs;

  void updatestatusStr(String str) => statusStr.value = str;
  void updatestatusNotRunningStr(String str) => statusNotRunningStr.value = str;
  void updatestatusInitializingStr(String str) =>
      statusInitializingStr.value = str;
  void updatestatusStartingStr(String str) => statusStartingStr.value = str;
  void updatestatusRunningStr(String str) => statusRunningStr.value = str;
  void updatestatusRunningWithTorStr(String str) =>
      statusRunningStr.value = str;
  void updatestatusErrorStr(String str) => statusErrorStr.value = str;
  void updatepopularSitesStr(String str) => popularSitesStr.value = str;
  void updatestartZeroNetFirstStr(String str) =>
      startZeroNetFirstStr.value = str;
  void updatecreateStr(String str) => createStr.value = str;
  void updateopenStr(String str) => openStr.value = str;
  void updatedownloadStr(String str) => downloadStr.value = str;
  void updateaddToHomeScreenStr(String str) => addToHomeScreenStr.value = str;
  void updateshowLogStr(String str) => showLogStr.value = str;
  void updatepauseStr(String str) => pauseStr.value = str;
  void updateresumeStr(String str) => resumeStr.value = str;
  void updatedeleteZiteStr(String str) => deleteZiteStr.value = str;
  void updateshrtAddedToHomeScreenStr(String str) =>
      shrtAddedToHomeScreenStr.value = str;
  void updatestartStr(String str) => startStr.value = str;
  void updaterestartStr(String str) => restartStr.value = str;
  void updatepleaseWaitStr(String str) => pleaseWaitStr.value = str;
  void updatestopStr(String str) => stopStr.value = str;
  void updatecloseStr(String str) => closeStr.value = str;
  void updateviewLogStr(String str) => viewLogStr.value = str;
  void updateaboutStr(String str) => aboutStr.value = str;
  void updatesettingsStr(String str) => settingsStr.value = str;
  void updatebrowserStr(String str) => browserStr.value = str;
  void updatelogStr(String str) => logStr.value = str;
  void updateupdateStr(String str) => updateStr.value = str;
  void updatedownloadingStr(String str) => downloadingStr.value = str;
  void updatedownloadedStr(String str) => downloadedStr.value = str;
  void updateinstallStr(String str) => installStr.value = str;
  void updaterestoreStr(String str) => restoreStr.value = str;
  void updateinstallingStr(String str) => installingStr.value = str;
  void updateinstallationCompletedStr(String str) =>
      installationCompletedStr.value = str;
  void updatenotAvaliableStr(String str) => notAvaliableStr.value = str;
  void updateaboutAppDesStr(String str) => aboutAppDesStr.value = str;
  void updateaboutAppDes1Str(String str) => aboutAppDes1Str.value = str;
  void updatedevelopersStr(String str) => developersStr.value = str;
  void updatedonationAddrsStr(String str) => donationAddrsStr.value = str;
  void updateclickAddrToCopyStr(String str) => clickAddrToCopyStr.value = str;
  void updatedonAddrCopiedStr(String str) => donAddrCopiedStr.value = str;
  void updatedonationDes(String str) => donationDes.value = str;
  void updatecontributeStr(String str) => contributeStr.value = str;
  void updatecontributeDesStr(String str) => contributeDesStr.value = str;
  void updategooglePurchasesStr(String str) => googlePurchasesStr.value = str;
  void updategoogleFeeWarningStr(String str) => googleFeeWarningStr.value = str;
  void updateoneTimeSubStr(String str) => oneTimeSubStr.value = str;
  void updatemonthlySubStr(String str) => monthlySubStr.value = str;
  void updatetipStr(String str) => tipStr.value = str;
  void updatecoffeeStr(String str) => coffeeStr.value = str;
  void updatelunchStr(String str) => lunchStr.value = str;
  void updateusersFileCopied(String str) => usersFileCopied.value = str;
  void updatechkBckUpStr(String str) => chkBckUpStr.value = str;
  void updatezeroNetNotInitTitleStr(String str) =>
      zeroNetNotInitTitleStr.value = str;
  void updatezeroNetNotInitDesStr(String str) =>
      zeroNetNotInitDesStr.value = str;
  void updateloadingStr(String str) => loadingStr.value = str;
  void updateswitchProfileToStr(String str) => switchProfileToStr.value = str;
  void updateswitchProfileToDesStr(String str) =>
      switchProfileToDesStr.value = str;
  void updatebackupStr(String str) => backupStr.value = str;
  void updateswitchStr(String str) => switchStr.value = str;
  void updateloadingPageWarningStr(String str) =>
      loadingPageWarningStr.value = str;
  void updateappUpdateAvailableStr(String str) =>
      appUpdateAvailableStr.value = str;
  void updateknowMoreStr(String str) => knowMoreStr.value = str;
  void updateratingWgtStr(String str) => ratingWgtStr.value = str;
  void updatesiteInfoStr(String str) => siteInfoStr.value = str;
  void updatebackupWarningStr(String str) => backupWarningStr.value = str;
  void updateusernameStr(String str) => usernameStr.value = str;
  void updateusernamePhraseStr(String str) => usernamePhraseStr.value = str;
  void updateusrnameWarning1Str(String str) => usrnameWarning1Str.value = str;
  void updateusrnameWarning2Str(String str) => usrnameWarning2Str.value = str;
  void updateusrnameWarning3Str(String str) => usrnameWarning3Str.value = str;
  void updateusrnameWarning4Str(String str) => usrnameWarning4Str.value = str;
  void updateznNotiRunningTitleStr(String str) =>
      znNotiRunningTitleStr.value = str;
  void updateznNotiRunningDesStr(String str) => znNotiRunningDesStr.value = str;
  void updateznNotiNotRunningTitleStr(String str) =>
      znNotiNotRunningTitleStr.value = str;
  void updateznNotiNotRunningDesStr(String str) =>
      znNotiNotRunningDesStr.value = str;
  void updateznPluginInstallingTitleStr(String str) =>
      znPluginInstallingTitleStr.value = str;
  void updateznPluginInstallingDesStr(String str) =>
      znPluginInstallingDesStr.value = str;
  void updatezninstallAPluginTitleStr(String str) =>
      zninstallAPluginTitleStr.value = str;
  void updatezninstallAPluginDesStr(String str) =>
      zninstallAPluginDesStr.value = str;
  void updaterestoreProfileTitleStr(String str) =>
      restoreProfileTitleStr.value = str;
  void updaterestoreProfileDesStr(String str) =>
      restoreProfileDesStr.value = str;
  void updaterestoreProfileDes1Str(String str) =>
      restoreProfileDesStr.value = str;
  void updateexistingProfileTitleStr(String str) =>
      existingProfileTitleStr.value = str;
  void updatecreateNewProfileStr(String str) => createNewProfileStr.value = str;
  void updateimportProfileStr(String str) => importProfileStr.value = str;
  void updatebackupProfileStr(String str) => backupProfileStr.value = str;
  void updateopenPluginManagerStr(String str) =>
      openPluginManagerStr.value = str;
  void updateloadPluginStr(String str) => loadPluginStr.value = str;
  void updatezerohelloSiteDesStr(String str) => zerohelloSiteDesStr.value = str;
  void updatezeronetMobileSiteDesStr(String str) =>
      zeronetMobileSiteDesStr.value = str;
  void updatezeroTalkSiteDesStr(String str) => zeroTalkSiteDesStr.value = str;
  void updatezeroblogSiteDesStr(String str) => zeroblogSiteDesStr.value = str;
  void updatezeromailSiteDesStr(String str) => zeromailSiteDesStr.value = str;
  void updatezeromeSiteDesStr(String str) => zeromeSiteDesStr.value = str;
  void updatezeroSitesSiteDesStr(String str) => zeroSitesSiteDesStr.value = str;
  void updatethemeSwitcherStr(String str) => themeSwitcherStr.value = str;
  void updatethemeSwitcherDesStr(String str) => themeSwitcherDesStr.value = str;
  void updatelanguageSwitcherStr(String str) => languageSwitcherStr.value = str;
  void updatelanguageSwitcherDesStr(String str) =>
      languageSwitcherDesStr.value = str;
  void updateprofileSwitcherStr(String str) => profileSwitcherStr.value = str;
  void updateprofileSwitcherDesStr(String str) =>
      profileSwitcherDesStr.value = str;
  void updatedebugZeroNetStr(String str) => debugZeroNetStr.value = str;
  void updatedebugZeroNetDesStr(String str) => debugZeroNetDesStr.value = str;
  void updateenableZeroNetConsoleStr(String str) =>
      enableZeroNetConsoleStr.value = str;
  void updateenableZeroNetConsoleDesStr(String str) =>
      enableZeroNetConsoleDesStr.value = str;
  void updateenableZeroNetFiltersStr(String str) =>
      enableZeroNetFiltersStr.value = str;
  void updateenableZeroNetFiltersDesStr(String str) =>
      enableZeroNetFiltersDesStr.value = str;
  void updateenableAdditionalTrackersStr(String str) =>
      enableAdditionalTrackersStr.value = str;
  void updateenableAdditionalTrackersDesStr(String str) =>
      enableAdditionalTrackersDesStr.value = str;
  void updatepluginManagerStr(String str) => pluginManagerStr.value = str;
  void updatepluginManagerDesStr(String str) => pluginManagerDesStr.value = str;
  void updatevibrateOnZeroNetStartStr(String str) =>
      vibrateOnZeroNetStartStr.value = str;
  void updatevibrateOnZeroNetStartDesStr(String str) =>
      vibrateOnZeroNetStartDesStr.value = str;
  void updateenableFullScreenOnWebViewStr(String str) =>
      enableFullScreenOnWebViewStr.value = str;
  void updateenableFullScreenOnWebViewDesStr(String str) =>
      enableFullScreenOnWebViewDesStr.value = str;
  void updatebatteryOptimisationStr(String str) =>
      batteryOptimisationStr.value = str;
  void updatebatteryOptimisationDesStr(String str) =>
      batteryOptimisationDesStr.value = str;
  void updatepublicDataFolderStr(String str) => publicDataFolderStr.value = str;
  void updatepublicDataFolderDesStr(String str) =>
      publicDataFolderDesStr.value = str;
  void updateautoStartZeroNetStr(String str) => autoStartZeroNetStr.value = str;
  void updateautoStartZeroNetDesStr(String str) =>
      autoStartZeroNetDesStr.value = str;
  void updateautoStartZeroNetonBootStr(String str) =>
      autoStartZeroNetonBootStr.value = str;
  void updateautoStartZeroNetonBootDesStr(String str) =>
      autoStartZeroNetonBootDesStr.value = str;
  void updateenableTorLogStr(String str) => enableTorLogStr.value = str;
  void updateenableTorLogDesStr(String str) => enableTorLogDesStr.value = str;

  void loadTranslationsFromFile(String path) {
    File translationsFile = File(path);
    Map map = json.decode(translationsFile.readAsStringSync());
    updatestatusStr(map['statusStr']);
    updatestatusNotRunningStr(map['statusNotRunningStr']);
    updatestatusInitializingStr(map['statusInitializingStr']);
    updatestatusStartingStr(map['statusStartingStr']);
    updatestatusRunningStr(map['statusRunningStr']);
    updatestatusRunningWithTorStr(map['statusRunningWithTorStr']);
    updatestatusErrorStr(map['statusErrorStr']);
    updatepopularSitesStr(map['popularSitesStr']);
    updatestartZeroNetFirstStr(map['startZeroNetFirstStr']);
    updatecreateStr(map['createStr']);
    updateopenStr(map['openStr']);
    updatedownloadStr(map['downloadStr']);
    updateaddToHomeScreenStr(map['addToHomeScreenStr']);
    updateshowLogStr(map['showLogStr']);
    updatepauseStr(map['pauseStr']);
    updateresumeStr(map['resumeStr']);
    updatedeleteZiteStr(map['deleteZiteStr']);
    updateshrtAddedToHomeScreenStr(map['shrtAddedToHomeScreenStr']);
    updatestartStr(map['startStr']);
    updaterestartStr(map['restartStr']);
    updatepleaseWaitStr(map['pleaseWaitStr']);
    updatestopStr(map['stopStr']);
    updatecloseStr(map['closeStr']);
    updateviewLogStr(map['viewLogStr']);
    updateaboutStr(map['aboutStr']);
    updatesettingsStr(map['settingsStr']);
    updatebrowserStr(map['browserStr']);
    updatelogStr(map['logStr']);
    updateupdateStr(map['updateStr']);
    updatedownloadingStr(map['downloadingStr']);
    updatedownloadedStr(map['downloadedStr']);
    updateinstallStr(map['installStr']);
    updaterestoreStr(map['restoreStr']);
    updateinstallingStr(map['installingStr']);
    updateinstallationCompletedStr(map['installationCompletedStr']);
    updatenotAvaliableStr(map['notAvaliableStr']);
    updateaboutAppDesStr(map['aboutAppDesStr']);
    updateaboutAppDes1Str(map['aboutAppDes1Str']);
    updatedevelopersStr(map['developersStr']);
    updatedonationAddrsStr(map['donationAddrsStr']);
    updateclickAddrToCopyStr(map['clickAddrToCopyStr']);
    updatedonAddrCopiedStr(map['donAddrCopiedStr']);
    updatedonationDes(map['donationDes']);
    updatecontributeStr(map['contributeStr']);
    updatecontributeDesStr(map['contributeDesStr']);
    updategooglePurchasesStr(map['googlePurchasesStr']);
    updategoogleFeeWarningStr(map['googleFeeWarningStr']);
    updateoneTimeSubStr(map['oneTimeSubStr']);
    updatemonthlySubStr(map['monthlySubStr']);
    updatetipStr(map['tipStr']);
    updatecoffeeStr(map['coffeeStr']);
    updatelunchStr(map['lunchStr']);
    updateusersFileCopied(map['usersFileCopied']);
    updatechkBckUpStr(map['chkBckUpStr']);
    updatezeroNetNotInitTitleStr(map['zeroNetNotInitTitleStr']);
    updatezeroNetNotInitDesStr(map['zeroNetNotInitDesStr']);
    updateloadingStr(map['loadingStr']);
    updateswitchProfileToStr(map['switchProfileToStr']);
    updateswitchProfileToDesStr(map['switchProfileToDesStr']);
    updatebackupStr(map['backupStr']);
    updateswitchStr(map['switchStr']);
    updateloadingPageWarningStr(map['loadingPageWarningStr']);
    updateappUpdateAvailableStr(map['appUpdateAvailableStr']);
    updateknowMoreStr(map['knowMoreStr']);
    updateratingWgtStr(map['ratingWgtStr']);
    updatesiteInfoStr(map['siteInfoStr']);
    updatebackupWarningStr(map['backupWarningStr']);
    updateusernameStr(map['usernameStr']);
    updateusernamePhraseStr(map['usernamePhraseStr']);
    updateusrnameWarning1Str(map['usrnameWarning1Str']);
    updateusrnameWarning2Str(map['usrnameWarning2Str']);
    updateusrnameWarning3Str(map['usrnameWarning3Str']);
    updateusrnameWarning4Str(map['usrnameWarning4Str']);
    updateznNotiRunningTitleStr(map['znNotiRunningTitleStr']);
    updateznNotiRunningDesStr(map['znNotiRunningDesStr']);
    updateznNotiNotRunningTitleStr(map['znNotiNotRunningTitleStr']);
    updateznNotiNotRunningDesStr(map['znNotiNotRunningDesStr']);
    updateznPluginInstallingTitleStr(map['znPluginInstallingTitleStr']);
    updateznPluginInstallingDesStr(map['znPluginInstallingDesStr']);
    updatezninstallAPluginTitleStr(map['zninstallAPluginTitleStr']);
    updatezninstallAPluginDesStr(map['zninstallAPluginDesStr']);
    updaterestoreProfileTitleStr(map['restoreProfileTitleStr']);
    updaterestoreProfileDesStr(map['restoreProfileDesStr']);
    updaterestoreProfileDes1Str(map['restoreProfileDes1Str']);
    updateexistingProfileTitleStr(map['existingProfileTitleStr']);
    updatecreateNewProfileStr(map['createNewProfileStr']);
    updateimportProfileStr(map['importProfileStr']);
    updatebackupProfileStr(map['backupProfileStr']);
    updateopenPluginManagerStr(map['openPluginManagerStr']);
    updateloadPluginStr(map['loadPluginStr']);
    updatezerohelloSiteDesStr(map['zerohelloSiteDesStr']);
    updatezeronetMobileSiteDesStr(map['zeronetMobileSiteDesStr']);
    updatezeroTalkSiteDesStr(map['zeroTalkSiteDesStr']);
    updatezeroblogSiteDesStr(map['zeroblogSiteDesStr']);
    updatezeromailSiteDesStr(map['zeromailSiteDesStr']);
    updatezeromeSiteDesStr(map['zeromeSiteDesStr']);
    updatezeroSitesSiteDesStr(map['zeroSitesSiteDesStr']);
    updatethemeSwitcherStr(map['themeSwitcherStr']);
    updatethemeSwitcherDesStr(map['themeSwitcherDesStr']);
    updatelanguageSwitcherStr(map['languageSwitcherStr']);
    updatelanguageSwitcherDesStr(map['languageSwitcherDesStr']);
    updateprofileSwitcherStr(map['profileSwitcherStr']);
    updateprofileSwitcherDesStr(map['profileSwitcherDesStr']);
    updatedebugZeroNetStr(map['debugZeroNetStr']);
    updatedebugZeroNetDesStr(map['debugZeroNetDesStr']);
    updateenableZeroNetConsoleStr(map['enableZeroNetConsoleStr']);
    updateenableZeroNetConsoleDesStr(map['enableZeroNetConsoleDesStr']);
    updateenableZeroNetFiltersStr(map['enableZeroNetFiltersStr']);
    updateenableZeroNetFiltersDesStr(map['enableZeroNetFiltersDesStr']);
    updateenableAdditionalTrackersStr(map['enableAdditionalTrackersStr']);
    updateenableAdditionalTrackersDesStr(map['enableAdditionalTrackersDesStr']);
    updatepluginManagerStr(map['pluginManagerStr']);
    updatepluginManagerDesStr(map['pluginManagerDesStr']);
    updatevibrateOnZeroNetStartStr(map['vibrateOnZeroNetStartStr']);
    updatevibrateOnZeroNetStartDesStr(map['vibrateOnZeroNetStartDesStr']);
    updateenableFullScreenOnWebViewStr(map['enableFullScreenOnWebViewStr']);
    updateenableFullScreenOnWebViewDesStr(
        map['enableFullScreenOnWebViewDesStr']);
    updatebatteryOptimisationStr(map['batteryOptimisationStr']);
    updatebatteryOptimisationDesStr(map['batteryOptimisationDesStr']);
    updatepublicDataFolderStr(map['publicDataFolderStr']);
    updatepublicDataFolderDesStr(map['publicDataFolderDesStr']);
    updateautoStartZeroNetStr(map['autoStartZeroNetStr']);
    updateautoStartZeroNetDesStr(map['autoStartZeroNetDesStr']);
    updateautoStartZeroNetonBootStr(map['autoStartZeroNetonBootStr']);
    updateautoStartZeroNetonBootDesStr(map['autoStartZeroNetonBootDesStr']);
    updateenableTorLogStr(map['enableTorLogStr']);
    updateenableTorLogDesStr(map['enableTorLogDesStr']);
  }
}
