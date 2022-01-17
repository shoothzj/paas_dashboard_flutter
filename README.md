# paas_dashboard_flutter

Flutter Paas Dashboard

# Why do we use flutter
- We don’t want JRE, JDK package is too large
- We can’t use c sharp because having people develop use mac.
- We are not good at frontend. Electron is not friendly to us.
- Golang isn't proper for GUI

# Install
[Install Doc](install.md)

# Prepare to develop environment
## macos
```bash
flutter config --enable-macos-desktop
```
## windows
```bash
flutter config --enable-windows-desktop
```
## others about develop
### sqlite data location
- macos ~/Library/Containers/com.github.shoothzj.paasDashboardFlutter/Data

# run
## web
if you need to run on web mode, need to turn off the `chrome` security switch, refer to https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
```bash
# jump to flutter install location
rm -rf bin/cache/flutter_tools.stamp
```
edit `packages/flutter_tools/lib/src/web/chrome.dart`<br/>
add `'--disable-web-security',` behind `'--disable-extensions',`
### attention
the web mode can only use a part of features
