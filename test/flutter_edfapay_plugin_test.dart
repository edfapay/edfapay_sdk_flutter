import 'dart:async';
import 'dart:ffi';

import 'package:flutter_edfapay_plugin/callback/callbacks.dart';
import 'package:flutter_edfapay_plugin/enums/payment_scheme.dart';
import 'package:flutter_edfapay_plugin/models/TxnParams.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_edfapay_plugin/flutter_edfapay_plugin.dart';
import 'package:flutter_edfapay_plugin/flutter_edfapay_plugin_platform_interface.dart';
import 'package:flutter_edfapay_plugin/flutter_edfapay_plugin_platform_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterEdfapayPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterEdfapayPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> initiate(String merchantNameAddress, String interfaceDeviceSerialNumber, List<PaymentScheme> supportedSchemes) {
    return Future.value(true);
  }

  @override
  StreamSubscription pay(TxnParams params, {
    required onCardProcessingComplete onCardProcessingComplete,
    required onCardScanTimerEnd onCardScanTimerEnd,
    required onRequestTimerEnd onRequestTimerEnd
  }){
    throw UnimplementedError();
  }

  @override
  Future<bool> serverCompletion(bool status) {
    throw UnimplementedError();
  }

}

void main() {
  final FlutterEdfapayPluginPlatform initialPlatform = FlutterEdfapayPluginPlatform.instance;

  test('$PlatformChannelFlutterEdfapayPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<PlatformChannelFlutterEdfapayPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterEdfapayPlugin flutterEdfapayPlugin = FlutterEdfapayPlugin();
    MockFlutterEdfapayPluginPlatform fakePlatform = MockFlutterEdfapayPluginPlatform();
    FlutterEdfapayPluginPlatform.instance = fakePlatform;

    expect(await flutterEdfapayPlugin.getPlatformVersion(), '42');
  });
}
