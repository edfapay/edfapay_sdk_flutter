import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_edfapay_plugin/enums/TransactionType.dart';
import 'package:flutter_edfapay_plugin/enums/payment_scheme.dart';
import 'package:flutter_edfapay_plugin/flutter_edfapay_plugin.dart';
import 'package:flutter_edfapay_plugin/models/TxnParams.dart';
import 'package:flutter_edfapay_plugin_example/helper_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterEdfapayPlugin = FlutterEdfapayPlugin();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterEdfapayPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }


  initAndPay(){

    _flutterEdfapayPlugin
        .initiate(
        "merchantNameAddress",
        "interfaceDeviceSerialNumber",
        [PaymentScheme.MADA_VISA]
    ).then((value){
      if(value){
        final params = TxnParams(
            txnSeqCounter: "11",
            amount: "10.00",
            floorLimit: "200.00",
            transactionType: TransactionType.purchase,
            countryCode: "SA",
            currencyCode: "SAR"
        );


        toast("Ready to scan card");
        _flutterEdfapayPlugin.pay(
            params,
            onCardProcessingComplete: (kernelResponse, serverCompletion){
              toast("Card Processing Completed");
              serverCompletion(true, (){
                toast("Server Status Acknowledged");
              });
            },
            onCardScanTimerEnd: (){
              toast("Card Scan Timeout");
            },
            onRequestTimerEnd: (){
              toast("Server Request Timeout");
            }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      builder: FToastBuilder(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
              onPressed: initAndPay,
              child: Text("Pay 10 SAR")
          ),
        ),
      ),
    );
  }
}
