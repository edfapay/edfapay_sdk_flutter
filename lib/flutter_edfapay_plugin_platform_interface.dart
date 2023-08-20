import 'dart:async';
import 'dart:ffi';

import 'package:flutter_edfapay_plugin/models/TxnParams.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'callback/callbacks.dart';
import 'enums/payment_scheme.dart';
import 'flutter_edfapay_plugin_platform_channel.dart';

abstract class FlutterEdfapayPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterEdfapayPluginPlatform.
  FlutterEdfapayPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterEdfapayPluginPlatform _instance = PlatformChannelFlutterEdfapayPlugin();

  /// The default instance of [FlutterEdfapayPluginPlatform] to use.
  ///
  /// Defaults to [PlatformChannelFlutterEdfapayPlugin].
  static FlutterEdfapayPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterEdfapayPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterEdfapayPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> initiate(String merchantNameAddress, String interfaceDeviceSerialNumber, List<PaymentScheme> supportedSchemes) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }


  StreamSubscription pay( TxnParams params, {
    required onCardProcessingComplete onCardProcessingComplete,
    required onCardScanTimerEnd onCardScanTimerEnd,
    required onRequestTimerEnd onRequestTimerEnd
  }){
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

}
