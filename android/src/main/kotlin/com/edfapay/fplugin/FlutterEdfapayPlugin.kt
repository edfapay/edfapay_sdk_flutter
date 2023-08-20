package com.edfapay.fplugin

import android.app.Activity
import android.content.Context
import android.widget.Toast
import androidx.annotation.NonNull
import com.edfapay.fplugin.helpers.toTxnParams
import com.edfapay.paymentcard.EdfaPayPlugin
import com.edfapay.paymentcard.card.PaymentScheme
import com.edfapay.paymentcard.model.TransactionType
import com.edfapay.paymentcard.model.TxnParams
import com.edfapay.paymentcard.utils.delay
import com.google.gson.Gson

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterEdfapayPlugin */
class FlutterEdfapayPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var eventChannel : EventChannel
  private var eventsChannelSink: EventChannel.EventSink? = null

  private lateinit var methodChannel : MethodChannel
  private var activity: Activity? = null
  private lateinit var context: Context

  private var onServerComplete:((Boolean, () -> Unit) -> Unit)? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.edfapay.fplugin.method")
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "com.edfapay.fplugin.event")
    methodChannel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(this)

    context = flutterPluginBinding.applicationContext
  }


  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")

    }else if (call.method == "serverCompletion") {
      (call.arguments as Boolean?)?.let {status ->
        this.onServerComplete?.let {
          it(status){
            result.success(true)
          }
        }
      }

    }else if (call.method == "initiate") {
      val arguments = call.arguments as List<*>
      when(arguments.size == 3) {
        true -> {
          val schemeNames = (arguments[2] as List<*>)
          EdfaPayPlugin.initiate(context)
            .setMerchantNameAddress(arguments[0] as String)
            .setInterfaceDeviceSerialNumber(arguments[1] as String)
            .setSupportedSchemes(
              PaymentScheme.values().filter {
                schemeNames.contains(it.networkName)
              }
            )

          result.success(true)
        }
        false -> result.error("Invalid Arguments","Invalid or missing argument passed for initialization", call.arguments.toString())
      }


    } else {
      result.notImplemented()
    }
  }


  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventsChannelSink = events
    activity?.let { activity ->
      (arguments as String?)?.let {
        val txnParams = Gson().toTxnParams(it)

        EdfaPayPlugin.pay(
          activity = activity,
          txnParams,
          onCardProcessingComplete = { paymentCard, onServerComplete ->

            val map = Gson().fromJson(Gson().toJson(paymentCard.kernelResponse), Map::class.java)
            this.onServerComplete = onServerComplete
            eventsChannelSink?.success(
              mapOf(
                "event" to "onCardProcessingComplete",
                "parameters" to listOf(map)
              )
            )
          },

          onRequestTimerEnd = {
            Toast.makeText(activity, "Server Request Timeout", Toast.LENGTH_SHORT).show()
            eventsChannelSink?.success(
              mapOf(
                "event" to "onRequestTimerEnd",
                "parameters" to listOf<Any>()
              )
            )
          },

          onCardScanTimerEnd = {
            Toast.makeText(activity, "Card Scan Timeout", Toast.LENGTH_SHORT).show()
            eventsChannelSink?.success(
              mapOf(
                "event" to "onCardScanTimerEnd",
                "parameters" to listOf<Any>()
              )
            )
          })

      } ?: eventsChannelSink?.error("Invalid Argument","Invalid json argument for TxnParams object",Thread.currentThread().stackTrace)
    } ?: eventsChannelSink?.error("Missing activity reference","Missing activity reference in FlutterEdfapayPlugin class",Thread.currentThread().stackTrace)

  }

  override fun onCancel(arguments: Any?) {

  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }
}
