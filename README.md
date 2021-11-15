# paas_dashboard_flutter

Flutter Paas Dashboard

## 其他语言文档
- [English Doc](README_en.md)

# 运行
## web
如需在Web下运行，需要关闭`chrome`的安全开关,步骤如下,参考链接: https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
```
Step1 跳转到flutter安装目录
Step2 rm -rf bin/cache/flutter_tools.stamp
Step3 vi packages/flutter_tools/lib/src/web/chrome.dart
Step4 add `'--disable-web-security',` behind `'--disable-extensions',`
```
