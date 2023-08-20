
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_edfapay_plugin/models/TxnParams.dart';
import 'package:flutter_edfapay_plugin/models/event_channel.dart';
import 'package:flutter_edfapay_plugin/models/kernel_response.dart';

import 'callback/callbacks.dart';
import 'enums/payment_scheme.dart';
import 'flutter_edfapay_plugin_platform_interface.dart';

class PlatformChannelFlutterEdfapayPlugin extends FlutterEdfapayPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.edfapay.fplugin.method');

  @visibleForTesting
  final eventChannel = const EventChannel('com.edfapay.fplugin.event');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> initiate(String merchantNameAddress, String interfaceDeviceSerialNumber, List<PaymentScheme> supportedSchemes) async{
    final res =  await methodChannel.invokeMethod<bool>('initiate', [merchantNameAddress, interfaceDeviceSerialNumber, supportedSchemes.map((e) => e.name).toList()]);
    return Future.value(res ?? false);
  }



  @override
  StreamSubscription pay(TxnParams params, {
    required onCardProcessingComplete onCardProcessingComplete,
    required onCardScanTimerEnd onCardScanTimerEnd,
    required onRequestTimerEnd onRequestTimerEnd
  }){

    return
      eventChannel
          .receiveBroadcastStream(params.toJson())
          .listen((event) {
            if(event is Map){
              final e = Event.fromMap(event);
              if(e.event == Event.OnCardProcessingComplete){
                final kernelResponse = KernelResponse.from(e.parameters?.first);
                onCardProcessingComplete(kernelResponse, (status, statusAck) async {
                  final res =  await methodChannel.invokeMethod<bool>('serverCompletion', status);
                  if(res ?? false){
                    statusAck();
                  }
                });

              }else if(e.event == Event.OnCardScanTimerEnd){
                onCardScanTimerEnd();
              }else if(e.event == Event.OnRequestTimerEnd){
                onRequestTimerEnd();
              }
            }

        print("pay.event: ${event.toString()}");
      })
        ..onError((e){
          print("pay.onError");
        })
        ..onDone(() {
          print("pay.onDone");
        });

  }
}
