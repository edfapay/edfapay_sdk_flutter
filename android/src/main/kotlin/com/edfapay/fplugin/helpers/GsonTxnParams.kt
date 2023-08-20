package com.edfapay.fplugin.helpers

import com.edfapay.paymentcard.model.TransactionType
import com.edfapay.paymentcard.model.TxnParams
import com.google.gson.Gson

fun Gson.toTxnParams(json:String) : TxnParams {
    val map = fromJson(json, Map::class.java)

    val params = TxnParams(
        amount = map["amount"] as String,
        countryCode = map["countryCode"] as String,
        currencyCode = map["currencyCode"] as String,
        floorLimit = map["floorLimit"] as String,
        txnSeqCounter = map["txnSeqCounter"] as String,
        transactionType = TransactionType.values().first{ it.name.equals(map["transactionType"].toString(), true)}
    )

    return params
}