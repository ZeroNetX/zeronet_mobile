# ZeroNet Mobile
[![Codemagic build status](https://api.codemagic.io/apps/5f755f0647fecf7a4f25751a/5f75609747fecf958ea171b0/status_badge.svg)](https://codemagic.io/apps/5f755f0647fecf7a4f25751a/5f75609747fecf958ea171b0/latest_build)

ZeroNet Mobile is an Android Client for [ZeroNet](https://zeronet.io), a platform for decentralized websites using Bitcoin crypto and the BitTorrent network. you can learn more about ZeroNet at https://zeronet.io/.

[<img src="https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png" 
      alt="Download from Google Play" 
      height="80">](https://play.google.com/store/apps/details?id=in.canews.zeronet)

## Installation

### From Google PlayStore :
#### Android (arm, arm64, x86)
 - minimum Android version supported 16 (JellyBean).
 - Google Play Store Link https://play.google.com/store/apps/details?id=in.canews.zeronet

#### Compiling Source : 

You need Flutter Framework to compile this App from Source.

#### Installing Flutter : https://flutter.dev/docs/get-started/install

```
git clone https://github.com/canewsin/zeronet_mobile.git
cd zeronet_mobile
flutter packages get
```

After that create a file named `key.properties` in `android` directory
and fill the below details, which are in capital letters, with your details.
```
storeFile=ANDROID_KEY_STORE_FILE_PATH
storePassword=KEY_STORE_PASSWORD
keyAlias=KEY_ALIAS
keyPassword=KEY_PASSWORD
```

in root folder

to build apk
```
flutter build apk --no-shrink
```

to build appbundle
```
flutter build appbundle --no-shrink
```

to run the app in Android Device / Emulator

```
flutter run
```

## Donate
BTC(Preferred) : 

`35NgjpB3pzkdHkAPrNh2EMERGxnXgwCb6G`

ETH : 

`0xa81a32dcce8e5bcb9792daa19ae7f964699ee536`

UPI(Indian Users) : 

`pramukesh@upi`

Liberapay : 

`https://liberapay.com/canews.in/donate`

## Contribute
If you want to support project's further development, you can contribute your time or money, If you want to contribute money you can send bitcoin or other supported crypto currencies to above addresses or buy in-app purchases, if want to contribute translations or code.
