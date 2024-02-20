@JS()
library fingerprintjs;

import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:js/js.dart';

part 'src/options.dart';

@JS('Fingerprint2')
class _Fingerprint {
  external static dynamic get(Options? options, Function action);
  external static String x64hash128(String values, int seed);
}

/// Stores the key/value pair of fingerprint properties
@JS()
@anonymous
class FingerprintComponent {
  /// The key for a fingerprint property
  external String get key;

  /// The value for a fingerprint property
  external dynamic get value;
}

/// A wrapper for the fingerprintjs library
class Fingerprint {
  /// Returns an array of `FingerprintComponent` which contains
  /// all the components extracted from the browser
  static Future<List<FingerprintComponent>> get({Options? options}) {
    final completer = Completer<List<FingerprintComponent>>();
    // Timer(Duration(milliseconds: 500), () {
    //   _Fingerprint.get(options, allowInterop((components) {
    //     completer.complete(components.cast<FingerprintComponent>());
    //   }));
    // });
    _Fingerprint.get(options, allowInterop((components) {
      completer.complete(components.cast<FingerprintComponent>());
    }));
    return completer.future;
  }

  /// Used to create a hash fingerprint
  static String x64hash128(String key, int seed) {
    return _Fingerprint.x64hash128(key, seed);
  }

  /// Create a fingerprint hash from the properties extracted
  static Future<String> getHash() async {
    await _loadFingerprint2Js();
    var components = await Fingerprint.get();
    var values = components.map((component) => component.value);
    return Fingerprint.x64hash128(values.join(''), 31);
  }

  static Future<void> _loadFingerprint2Js() async {
    final List<Future<void>> loading = <Future<void>>[];

    // ignore: undefined_prefixed_name
    final jsUrl = ui.assetManager.getAssetUrl(
      'packages/fingerprintjs/assets/js/fingerprint2.min.js',
    );
    final html.ScriptElement script = html.ScriptElement()
      ..async = true
    // ..defer = true
      ..src = jsUrl;
    loading.add(script.onLoad.first);
    html.querySelector('head')!.children.add(script);

    await Future.wait(loading);
  }
}
