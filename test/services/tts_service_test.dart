// ====================================================
// test/services/tts_service_test.dart
// اختبارات وحدة لـ TtsService
// ====================================================

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arabi_fasih/services/tts_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (MethodCall methodCall) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async => 1,
    );
  });

  test('should be a singleton', () {
    final tts1 = TtsService();
    final tts2 = TtsService();
    expect(identical(tts1, tts2), true);
  });
}
