## 功能变更

1.参考fluttertoast源码，把js文件变成使用时在进行导入。

#### 发布2.0.0

```yaml
dependencies:
  fingerprintjs:
    git:
      url: "https://github.com/hbolin/my_fingerprintjs-2.0.0"
      ref: "2.0.0"
```

#### 使用方式

```dart
import 'package:fingerprintjs/fingerprintjs.dart';

String fingerprint = await Fingerprint.getHash();

```