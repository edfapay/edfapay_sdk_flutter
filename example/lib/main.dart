import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_edfapay_plugin/enums/TransactionType.dart';
import 'package:flutter_edfapay_plugin/enums/payment_scheme.dart';
import 'package:flutter_edfapay_plugin/flutter_edfapay_plugin.dart';
import 'package:flutter_edfapay_plugin/models/TxnParams.dart';
import 'package:flutter_edfapay_plugin_example/helper_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

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
    initiate();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // builder: FToastBuilder(),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.3,
                        child: Image.asset("assets/images/edfa_logo.png")
                    ),
                    SizedBox(height: 30),
                    const Text(
                        "SDK",
                        style: TextStyle(fontSize: 65, fontWeight: FontWeight.w700), textAlign: TextAlign.center
                    ),
                    SizedBox(height: 10),
                    const Text(
                        "v0.0.1",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center
                    ),
                  ],
                ),
              ),

              const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      "You\'re on your way to enabling your Android App to allow your customers to pay in a very easy and simple way just click the payment button and tap your payment card on NFC enabled Android phone.",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black45),
                      textAlign: TextAlign.center
                  ),
                ),
              ),

              ElevatedButton(
                  onPressed: pay,
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(HexColor("06E59F"))),
                  child: const Text("Pay 10 SAR", style: TextStyle(color: Colors.black))
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    "Click on button above to test the card processing with 10.00 SAR",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.center
                ),
              ),
            ],
          ),
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
    if(!_edfaPluginInitiated){
      toast("Edfapay plugin not initialized.");
      return;
    }

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
