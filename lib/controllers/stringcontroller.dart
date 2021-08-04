import '../imports.dart';

final strController = Get.put(StrController());

class StrController extends GetxController {
  get statusStr => 'Status'.obs;

  set statusStr(String str) {
    statusStr.value = str;
  }

  get statusNotRunningStr => 'Not Running'.obs;

  set statusNotRunningStr(String str) {
    statusNotRunningStr.value = str;
  }

  get statusInitializingStr => 'Initializing..'.obs;

  set statusInitializingStr(String str) {
    statusInitializingStr.value = str;
  }

  get statusStartingStr => 'Starting'.obs;

  set statusStartingStr(String str) {
    statusStartingStr.value = str;
  }

  get statusRunningStr => 'Running'.obs;

  set statusRunningStr(String str) {
    statusRunningStr.value = str;
  }

  get statusRunningWithTorStr => 'Running with Tor'.obs;

  set statusRunningWithTorStr(String str) {
    statusRunningStr.value = str;
  }

  get statusErrorStr => 'Error'.obs;

  set statusErrorStr(String str) {
    statusErrorStr.value = str;
  }

  get popularSitesStr => ''.obs;

  set popularSitesStr(String str) {
    popularSitesStr.value = str;
  }

  get startZeroNetFirstStr =>
      'Please Start ZeroNet First to Browse this Zite'.obs;

  set startZeroNetFirstStr(String str) {
    startZeroNetFirstStr.value = str;
  }

  get createStr => 'Create'.obs;

  set createStr(String str) {
    createStr.value = str;
  }

  get openStr => 'OPEN'.obs;

  set openStr(String str) {
    openStr.value = str;
  }

  get downloadStr => 'DOWNLOAD'.obs;

  set downloadStr(String str) {
    downloadStr.value = str;
  }

  get addToHomeScreenStr => 'Add to HomeScreen'.obs;

  set addToHomeScreenStr(String str) {
    addToHomeScreenStr.value = str;
  }

  get showLogStr => 'Show Log'.obs;

  set showLogStr(String str) {
    showLogStr.value = str;
  }

  get pauseStr => 'Pause'.obs;

  set pauseStr(String str) {
    pauseStr.value = str;
  }

  get resumeStr => 'Resume'.obs;

  set resumeStr(String str) {
    resumeStr.value = str;
  }

  get deleteZiteStr => 'Delete Zite'.obs;

  set deleteZiteStr(String str) {
    deleteZiteStr.value = str;
  }

  get shrtAddedToHomeScreenStr => 'shortcut added to HomeScreen'.obs;

  set shrtAddedToHomeScreenStr(String str) {
    shrtAddedToHomeScreenStr.value = str;
  }

  get startStr => 'Start'.obs;

  set startStr(String str) {
    startStr.value = str;
  }

  get restartStr => 'Restart'.obs;

  set restartStr(String str) {
    restartStr.value = str;
  }

  get pleaseWaitStr => 'Please Wait..!'.obs;

  set pleaseWaitStr(String str) {
    pleaseWaitStr.value = str;
  }

  get stopStr => 'Stop'.obs;

  set stopStr(String str) {
    stopStr.value = str;
  }

  get closeStr => 'Close'.obs;

  set closeStr(String str) {
    closeStr.value = str;
  }

  get viewLogStr => 'View Log'.obs;

  set viewLogStr(String str) {
    viewLogStr.value = str;
  }

  get aboutStr => 'About'.obs;

  set aboutStr(String str) {
    aboutStr.value = str;
  }

  get settingsStr => 'Settings'.obs;

  set settingsStr(String str) {
    settingsStr.value = str;
  }

  get browserStr => 'Browser'.obs;

  set browserStr(String str) {
    browserStr.value = str;
  }

  get logStr => 'Log'.obs;

  set logStr(String str) {
    logStr.value = str;
  }

  get updateStr => 'Update'.obs;

  set updateStr(String str) {
    updateStr.value = str;
  }

  get downloadingStr => 'Downloading'.obs;

  set downloadingStr(String str) {
    downloadingStr.value = str;
  }

  get downloadedStr => 'Downloaded'.obs;

  set downloadedStr(String str) {
    downloadedStr.value = str;
  }

  get installStr => 'Install'.obs;

  set installStr(String str) {
    installStr.value = str;
  }

  get restoreStr => 'Restore'.obs;

  set restoreStr(String str) {
    restoreStr.value = str;
  }

  get installingStr => 'Installing'.obs;

  set installingStr(String str) {
    installingStr.value = str;
  }

  get installationCompletedStr => 'Installation Completed'.obs;

  set installationCompletedStr(String str) {
    installationCompletedStr.value = str;
  }

  get notAvaliableStr => 'Not Available'.obs;

  set notAvaliableStr(String str) {
    notAvaliableStr.value = str;
  }

  get aboutAppDesStr => 'ZeroNet Mobile is a full native client for ZeroNet, '
          'a platform for decentralized websites using Bitcoin '
      .obs;

  set aboutAppDesStr(String str) {
    aboutAppDesStr.value = str;
  }

  get aboutAppDes1Str =>
      'crypto and the BitTorrent network. you can learn more about ZeroNet at '
          .obs;

  set aboutAppDes1Str(String str) {
    aboutAppDes1Str.value = str;
  }

  get developersStr => 'Developers'.obs;

  set developersStr(String str) {
    developersStr.value = str;
  }

  get donationAddrsStr => 'Donation Addresses'.obs;

  set donationAddrsStr(String str) {
    donationAddrsStr.value = str;
  }

  get clickAddrToCopyStr => '* Click on Address to copy'.obs;

  set clickAddrToCopyStr(String str) {
    clickAddrToCopyStr.value = str;
  }

  get donAddrCopiedStr => 'Donation Address Copied to Clipboard'.obs;

  set donAddrCopiedStr(String str) {
    donAddrCopiedStr.value = str;
  }

  get donationDes => "* Any Donation can activate all pro-features in app, "
          "these are just an encouragement to me to work more on the app. "
          "Pro-features will be made available to general public after certain time, "
          "thus you don't need to worry about exclusiveness of a feature. "
          "If you donate from any source other than Google Play Purchase, "
          "just send your transaction id to canews.in@gmail.com / ZeroMail: zeromepro, "
          "so than I can send activation code to activate pro-features."
      .obs;

  set donationDes(String str) {
    donationDes.value = str;
  }

  get contributeStr => 'Contribute'.obs;

  set contributeStr(String str) {
    contributeStr.value = str;
  }

  get contributeDesStr => "If you want to support project's further development, "
          "you can contribute your time or money, "
          "If you want to contribute money you can send bitcoin or "
          "other supported crypto currencies to above addresses or buy in-app purchases, "
          "if want to contribute translations or code, visit official GitHub repo."
      .obs;

  set contributeDesStr(String str) {
    contributeDesStr.value = str;
  }

  get googlePurchasesStr => 'Google Play Purchases'.obs;

  set googlePurchasesStr(String str) {
    googlePurchasesStr.value = str;
  }

  get googleFeeWarningStr => '(30% taken by Google) :'.obs;

  set googleFeeWarningStr(String str) {
    googleFeeWarningStr.value = str;
  }

  get oneTimeSubStr => 'One Time'.obs;

  set oneTimeSubStr(String str) {
    oneTimeSubStr.value = str;
  }

  get monthlySubStr => 'Monthly Subscriptions'.obs;

  set monthlySubStr(String str) {
    monthlySubStr.value = str;
  }

  get tipStr => 'Tip'.obs;

  set tipStr(String str) {
    tipStr.value = str;
  }

  get coffeeStr => 'Coffee'.obs;

  set coffeeStr(String str) {
    coffeeStr.value = str;
  }

  get lunchStr => 'Lunch'.obs;

  set lunchStr(String str) {
    lunchStr.value = str;
  }

  get usersFileCopied => 'Users.json content copied to Clipboard'.obs;

  set usersFileCopied(String str) {
    usersFileCopied.value = str;
  }

  get chkBckUpStr =>
      'Please check yourself that file back up Successfully.'.obs;

  set chkBckUpStr(String str) {
    chkBckUpStr.value = str;
  }

  get zeroNetNotInitTitleStr => 'ZeroNet data folder not Exists.'.obs;

  set zeroNetNotInitTitleStr(String str) {
    zeroNetNotInitTitleStr.value = str;
  }

  get zeroNetNotInitDesStr =>
      "ZeroNet should be used atleast once (run it from home screen), "
              "before using this option"
          .obs;

  set zeroNetNotInitDesStr(String str) {
    zeroNetNotInitDesStr.value = str;
  }

  get loadingStr => 'Loading'.obs;

  set loadingStr(String str) {
    loadingStr.value = str;
  }

  get switchProfileToStr => 'Switch Profile to'.obs;

  set switchProfileToStr(String str) {
    switchProfileToStr.value = str;
  }

  get switchProfileToDesStr => 'this will delete the existing profile, '
          'backup existing profile using backup button below'
      .obs;

  set switchProfileToDesStr(String str) {
    switchProfileToDesStr.value = str;
  }

  get backupStr => 'Backup'.obs;

  set backupStr(String str) {
    backupStr.value = str;
  }

  get switchStr => 'Switch'.obs;

  set switchStr(String str) {
    switchStr.value = str;
  }

  get loadingPageWarningStr => """
    Please Wait! This may take a while, happens 
    only first time, Don't Press Back button.
    If You Accidentally Pressed Back,
    Clean App Storage in Settings or 
    Uninstall and Reinstall The App.
    """
      .obs;

  set loadingPageWarningStr(String str) {
    loadingPageWarningStr.value = str;
  }

  get appUpdateAvailableStr => 'App Update Available : '.obs;

  set appUpdateAvailableStr(String str) {
    appUpdateAvailableStr.value = str;
  }

  get knowMoreStr => 'Know More'.obs;

  set knowMoreStr(String str) {
    knowMoreStr.value = str;
  }

  get ratingWgtStr => 'Give Your Rating/Feedback'.obs;

  set ratingWgtStr(String str) {
    ratingWgtStr.value = str;
  }

  get siteInfoStr => 'SiteInfo'.obs;

  set siteInfoStr(String str) {
    siteInfoStr.value = str;
  }

  get backupWarningStr =>
      'Always remember to backup users.json before doing anything because, '
              'we are not able to tell when a software will fail. '
              'Click Backup below to backup your Existing users.json file.\n'
          .obs;

  set backupWarningStr(String str) {
    backupWarningStr.value = str;
  }

  get usernameStr => 'Username'.obs;

  set usernameStr(String str) {
    usernameStr.value = str;
  }

  get usernamePhraseStr => 'Username Phrase :'.obs;

  set usernamePhraseStr(String str) {
    usernamePhraseStr.value = str;
  }

  get usrnameWarning1Str => 'username can\'t be Empty'.obs;

  set usrnameWarning1Str(String str) {
    usrnameWarning1Str.value = str;
  }

  get usrnameWarning2Str => 'username can\'t contain spaces'.obs;

  set usrnameWarning2Str(String str) {
    usrnameWarning2Str.value = str;
  }

  get usrnameWarning3Str => 'username can\'t be less than 6 characters.'.obs;

  set usrnameWarning3Str(String str) {
    usrnameWarning3Str.value = str;
  }

  get usrnameWarning4Str =>
      'username already exists, choose different one.'.obs;

  set usrnameWarning4Str(String str) {
    usrnameWarning4Str.value = str;
  }

  get znNotiRunningTitleStr => 'ZeroNet Mobile is Running'.obs;

  set znNotiRunningTitleStr(String str) {
    znNotiRunningTitleStr.value = str;
  }

  get znNotiRunningDesStr => 'Click Here on this Notification to open app'.obs;

  set znNotiRunningDesStr(String str) {
    znNotiRunningDesStr.value = str;
  }

  get znNotiNotRunningTitleStr => 'ZeroNet Mobile is Not Running'.obs;

  set znNotiNotRunningTitleStr(String str) {
    znNotiNotRunningTitleStr.value = str;
  }

  get znNotiNotRunningDesStr =>
      'Open ZeroNet Mobile App and click start to run ZeroNet'.obs;

  set znNotiNotRunningDesStr(String str) {
    znNotiNotRunningDesStr.value = str;
  }

  get znPluginInstallingTitleStr => 'Installing Plugin'.obs;

  set znPluginInstallingTitleStr(String str) {
    znPluginInstallingTitleStr.value = str;
  }

  get znPluginInstallingDesStr =>
      'This Dialog will be automatically closed after installation, '
              'After Installation Restart ZeroNet from Home page'
          .obs;

  set znPluginInstallingDesStr(String str) {
    znPluginInstallingDesStr.value = str;
  }

  get zninstallAPluginTitleStr => 'Install A Plugin'.obs;

  set zninstallAPluginTitleStr(String str) {
    zninstallAPluginTitleStr.value = str;
  }

  get zninstallAPluginDesStr => 'This will load plugin to your ZeroNet repo, '
          '\nWarning : Loading Unknown/Untrusted plugins may compromise ZeroNet Installation.'
      .obs;

  set zninstallAPluginDesStr(String str) {
    zninstallAPluginDesStr.value = str;
  }

  get restoreProfileTitleStr => 'Restore Profile ?'.obs;

  set restoreProfileTitleStr(String str) {
    restoreProfileTitleStr.value = str;
  }

  get restoreProfileDesStr => 'this will delete the existing profile, '
          'backup existing profile using backup button below\n\n'
          'Selected Userfile : \n'
      .obs;

  set restoreProfileDesStr(String str) {
    restoreProfileDesStr.value = str;
  }

  get restoreProfileDes1Str =>
      'You can only select users.json file, outside zeronet data folder'.obs;

  set restoreProfileDes1Str(String str) {
    restoreProfileDesStr.value = str;
  }

  get existingProfileTitleStr => 'Provide A Name for Existing Profile'.obs;

  set existingProfileTitleStr(String str) {
    existingProfileTitleStr.value = str;
  }

  get createNewProfileStr => 'Create New Profile'.obs;

  set createNewProfileStr(String str) {
    createNewProfileStr.value = str;
  }

  get importProfileStr => 'Import Profile'.obs;

  set importProfileStr(String str) {
    importProfileStr.value = str;
  }

  get backupProfileStr => 'Backup Profile'.obs;

  set backupProfileStr(String str) {
    backupProfileStr.value = str;
  }

  get openPluginManagerStr => 'Open Plugin Manager'.obs;

  set openPluginManagerStr(String str) {
    openPluginManagerStr.value = str;
  }

  get loadPluginStr => 'Load Plugin'.obs;

  set loadPluginStr(String str) {
    loadPluginStr.value = str;
  }

  get zerohelloSiteDesStr => 'Say Hello to ZeroNet, a Dashboard to manage '
          'all your ZeroNet Z(S)ites, You can view feed of other zites like '
          'posts, comments of other users from ZeroTalk as well for your posts '
          'and Stats like Total Requests sent and received from other peers on ZeroNet. '
          'You can also pause, clone or favourite, delete Zites from single page.'
      .obs;

  set zerohelloSiteDesStr(String str) {
    zerohelloSiteDesStr.value = str;
  }

  get zeronetMobileSiteDesStr => 'Forum to report ZeroNet Mobile app issues. '
          'Want a new feature in the app, Request a Feature. '
          'Facing any Bugs while using the app ? '
          'Just report problem here, we will take care of it. '
          'Want to Discuss any topic about app development ? '
          'Just dive into to this Zite.'
      .obs;

  set zeronetMobileSiteDesStr(String str) {
    zeronetMobileSiteDesStr.value = str;
  }

  get zeroTalkSiteDesStr => 'Need a forum to discuss something, '
          'we got covered you here. ZeroTalk fits your need, '
          'just post something to get opinion from others on Network. '
          'Have some queries ? don\'t hesitate to ask here.'
          'Tired of Spam ? Who don\'t! You can mute individual users also.'
      .obs;

  set zeroTalkSiteDesStr(String str) {
    zeroTalkSiteDesStr.value = str;
  }

  get zeroblogSiteDesStr => 'Want to Know Where ZeroNet is Going ? '
          'ZeroBlog gives you latest changes and improvements '
          'made to ZeroNet, including Bug Fixes, '
          'Speed Improvements of ZeroNet Core Software. '
          'Also Provides varies links to ZeroNet Protocol and '
          'how ZeroNet works underhood and much more things to know.'
      .obs;

  set zeroblogSiteDesStr(String str) {
    zeroblogSiteDesStr.value = str;
  }

  get zeromailSiteDesStr => 'So you need a mail service, use ZeroMail, '
          'fully end-to-end encrypted mail service on ZeroNet, '
          'don\'t let others scanning your mailbox for their profits '
          'all your data is encrypted and can only opened by you. '
          'Your all mails are backedup, so you can stay calm for your data.'
      .obs;

  set zeromailSiteDesStr(String str) {
    zeromailSiteDesStr.value = str;
  }

  get zeromeSiteDesStr => 'Social Network is everywhere, so we made one here too. '
          'Twitter like, Peer to Peer Social Networking in your hands without data-tracking, '
          'Follow others and post your thoughts, like, comment on others posts, it\'s that easy-peasy. '
          'Find Like minded people and increase your friend circle beyond the borders.'
      .obs;

  set zeromeSiteDesStr(String str) {
    zeromeSiteDesStr.value = str;
  }

  get zeroSitesSiteDesStr => 'Want to know more sites on ZeroNet, '
          'visit ZeroSites, listing of community contributed sites under various '
          'categories like Blogs, Services, Forums, Chat, Video, Image, Guides, News and much more. '
          'You can even filter those lists with your preferred language '
          'to get more comprehensive list. Has a New Site to Show, Just Submit here.'
      .obs;

  set zeroSitesSiteDesStr(String str) {
    zeroSitesSiteDesStr.value = str;
  }

  get themeSwitcherStr => 'Theme'.obs;

  set themeSwitcherStr(String str) {
    themeSwitcherStr.value = str;
  }

  get themeSwitcherDesStr => 'Switch App Theme between Light, Dark, Black'.obs;

  set themeSwitcherDesStr(String str) {
    themeSwitcherDesStr.value = str;
  }

  get profileSwitcherStr => 'Profile Switcher'.obs;

  set profileSwitcherStr(String str) {
    profileSwitcherStr.value = str;
  }

  get profileSwitcherDesStr =>
      'Create and Use different Profiles on ZeroNet'.obs;

  set profileSwitcherDesStr(String str) {
    profileSwitcherDesStr.value = str;
  }

  get debugZeroNetStr => 'Debug ZeroNet Code'.obs;

  set debugZeroNetStr(String str) {
    debugZeroNetStr.value = str;
  }

  get debugZeroNetDesStr =>
      'Useful for Developers to find bugs and errors in the code.'.obs;

  set debugZeroNetDesStr(String str) {
    debugZeroNetDesStr.value = str;
  }

  get enableZeroNetConsoleStr => 'Enable ZeroNet Console'.obs;

  set enableZeroNetConsoleStr(String str) {
    enableZeroNetConsoleStr.value = str;
  }

  get enableZeroNetConsoleDesStr =>
      'Useful for Developers to see the exec of ZeroNet Python code'.obs;

  set enableZeroNetConsoleDesStr(String str) {
    enableZeroNetConsoleDesStr.value = str;
  }

  get enableZeroNetFiltersStr => 'Enable ZeroNet Filters'.obs;

  set enableZeroNetFiltersStr(String str) {
    enableZeroNetFiltersStr.value = str;
  }

  get enableZeroNetFiltersDesStr =>
      'Enabling ZeroNet Filters blocks known ametuer content sites and spam users.'
          .obs;

  set enableZeroNetFiltersDesStr(String str) {
    enableZeroNetFiltersDesStr.value = str;
  }

  get enableAdditionalTrackersStr => 'Additional BitTorrent Trackers'.obs;

  set enableAdditionalTrackersStr(String str) {
    enableAdditionalTrackersStr.value = str;
  }

  get enableAdditionalTrackersDesStr =>
      'Enabling External/Additional BitTorrent Trackers will give more ZeroNet Site Seeders or Clients.'
          .obs;

  set enableAdditionalTrackersDesStr(String str) {
    enableAdditionalTrackersDesStr.value = str;
  }

  get pluginManagerStr => 'Plugin Manager'.obs;

  set pluginManagerStr(String str) {
    pluginManagerStr.value = str;
  }

  get pluginManagerDesStr => 'Enable/Disable ZeroNet Plugins'.obs;

  set pluginManagerDesStr(String str) {
    pluginManagerDesStr.value = str;
  }

  get vibrateOnZeroNetStartStr => 'Vibrate on ZeroNet Start'.obs;

  set vibrateOnZeroNetStartStr(String str) {
    vibrateOnZeroNetStartStr.value = str;
  }

  get vibrateOnZeroNetStartDesStr => 'Vibrates Phone When ZeroNet Starts'.obs;

  set vibrateOnZeroNetStartDesStr(String str) {
    vibrateOnZeroNetStartDesStr.value = str;
  }

  get enableFullScreenOnWebViewStr => 'FullScreen for ZeroNet Zites'.obs;

  set enableFullScreenOnWebViewStr(String str) {
    enableFullScreenOnWebViewStr.value = str;
  }

  get enableFullScreenOnWebViewDesStr =>
      'This will Enable Full Screen for in app Webview of ZeroNet'.obs;

  set enableFullScreenOnWebViewDesStr(String str) {
    enableFullScreenOnWebViewDesStr.value = str;
  }

  get batteryOptimisationStr => 'Disable Battery Optimisation'.obs;

  set batteryOptimisationStr(String str) {
    batteryOptimisationStr.value = str;
  }

  get batteryOptimisationDesStr =>
      'This will Helps to Run App even App is in Background for long time.'.obs;

  set batteryOptimisationDesStr(String str) {
    batteryOptimisationDesStr.value = str;
  }

  get publicDataFolderStr => 'Public DataFolder'.obs;

  set publicDataFolderStr(String str) {
    publicDataFolderStr.value = str;
  }

  get publicDataFolderDesStr =>
      'This Will Make ZeroNet Data Folder Accessible via File Manager.'.obs;

  set publicDataFolderDesStr(String str) {
    publicDataFolderDesStr.value = str;
  }

  get autoStartZeroNetStr => 'AutoStart ZeroNet'.obs;

  set autoStartZeroNetStr(String str) {
    autoStartZeroNetStr.value = str;
  }

  get autoStartZeroNetDesStr =>
      'This Will Make ZeroNet Auto Start on App Start, So you don\'t have to click Start Button Every Time on App Start.'
          .obs;

  set autoStartZeroNetDesStr(String str) {
    autoStartZeroNetDesStr.value = str;
  }

  get autoStartZeroNetonBootStr => 'AutoStart ZeroNet on Boot'.obs;

  set autoStartZeroNetonBootStr(String str) {
    autoStartZeroNetonBootStr.value = str;
  }

  get autoStartZeroNetonBootDesStr =>
      'This Will Make ZeroNet Auto Start on Device Boot.'.obs;

  set autoStartZeroNetonBootDesStr(String str) {
    autoStartZeroNetonBootDesStr.value = str;
  }

  get enableTorLogStr => 'Enable Tor Log'.obs;

  set enableTorLogStr(String str) {
    enableTorLogStr.value = str;
  }

  get enableTorLogDesStr =>
      'This will Enable Tor Log in ZeroNet Console helpful for debugging.'.obs;

  set enableTorLogDesStr(String str) {
    enableTorLogDesStr.value = str;
  }
}
