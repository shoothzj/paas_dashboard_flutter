# paas_dashboard_flutter

Flutter Paas Dashboard

## 其他语言文档
- [English Doc](README_en.md)

# 安装
- [Install Doc](install.md)

# 开发环境准备
## macos
```bash
flutter config --enable-macos-desktop
```
## windows
```bash
flutter config --enable-windows-desktop
```
## 开发注意事项
### 数据存储位置
- macos ~/Library/Containers/com.github.shoothzj.paasDashboardFlutter/Data

# 运行
## web
如需在Web下运行，需要关闭`chrome`的安全开关,步骤如下,参考链接: https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
```bash
# 跳转到flutter安装目录
rm -rf bin/cache/flutter_tools.stamp
```
编辑`packages/flutter_tools/lib/src/web/chrome.dart`<br/>
在`'--disable-extensions',`后面添加`'--disable-web-security',`
