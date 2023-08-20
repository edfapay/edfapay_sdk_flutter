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
  final _flutterEdfapayPlugin = FlutterEdfapayPlugin();
  var _edfaPluginInitiated = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // builder: FToastBuilder(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(_edfaPluginInitiated)
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: pay,
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll( Colors.green)),
                      child: const Text("Pay 10 SAR")
                  ),
                )
              else
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: initiate,
                      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blueAccent)),
                      child: const Text("Initiate Edfapay")
                  ),
                )
            ],
          )
        ),
      ),
    );
  }



  initiate() async{
    _edfaPluginInitiated = await _flutterEdfapayPlugin.initiate(
        "Edfapay, Riyadh Saudi Arabia",
        "0000000000000001",
        [PaymentScheme.MADA_VISA]
    );

    setState(() {});
  }

  pay() async{
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
          delay(10, () {
            serverCompletion(true, (){
              toast("Server Status Acknowledged");
            });
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
}
