

import 'dart:convert';

import '../enums/TransactionType.dart';

class TxnParams{
  String txnSeqCounter;
  String amount;
  String floorLimit;
  TransactionType transactionType;
  String countryCode;
  String currencyCode;

  TxnParams({
    required this.txnSeqCounter,
    required this.amount,
    required this.floorLimit,
    required this.transactionType,
    required this.countryCode,
    required this.currencyCode,
  });

  String toJson(){
    final map = {
      "txnSeqCounter" : txnSeqCounter,
      "amount" : amount,
      "floorLimit" : floorLimit,
      "transactionType" : transactionType.name,
      "countryCode" : countryCode,
      "currencyCode" : currencyCode
    };
    return jsonEncode(map);
  }
}