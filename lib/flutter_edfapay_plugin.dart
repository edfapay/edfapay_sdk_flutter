
import 'dart:async';
import 'dart:ffi';

import 'package:flutter_edfapay_plugin/models/TxnParams.dart';

import 'callback/callbacks.dart';
import 'enums/payment_scheme.dart';
import 'flutter_edfapay_plugin_platform_interface.dart';

class FlutterEdfapayPlugin {
  Future<String?> getPlatformVersion() {
    return FlutterEdfapayPluginPlatform.instance.getPlatformVersion();
  }

  Future<bool> initiate(String merchantNameAddress, String interfaceDeviceSerialNumber, List<PaymentScheme> supportedSchemes) {
    return FlutterEdfapayPluginPlatform.instance.initiate(merchantNameAddress, interfaceDeviceSerialNumber, supportedSchemes);
  }

  StreamSubscription pay( TxnParams params, {
    required onCardProcessingComplete onCardProcessingComplete,
    required onCardScanTimerEnd onCardScanTimerEnd,
    required onRequestTimerEnd onRequestTimerEnd
  }){
    return
      FlutterEdfapayPluginPlatform.instance.pay(
          params,
          onCardProcessingComplete: onCardProcessingComplete,
          onCardScanTimerEnd: onCardScanTimerEnd,
          onRequestTimerEnd: onRequestTimerEnd
      );
  }

}
