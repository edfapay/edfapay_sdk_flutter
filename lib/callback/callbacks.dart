import 'dart:ffi';
import 'dart:ui';

import 'package:flutter_edfapay_plugin/models/kernel_response.dart';

typedef _onServerComplete = Function(bool status, VoidCallback statusAcknowlege);
typedef onCardProcessingComplete = Function(KernelResponse kernelResponse, _onServerComplete onServerComplete);
typedef onRequestTimerEnd = VoidCallback;
typedef onCardScanTimerEnd = VoidCallback;


// onCardProcessingComplete = { paymentCard, onServerComplete ->
// Toast.makeText(this, "Card Processing Completed", Toast.LENGTH_SHORT).show()
// delay(10000){ //  Delay for Server Request
// Toast.makeText(this, "Server Response Received", Toast.LENGTH_SHORT).show()
// onServerComplete(true){
// Toast.makeText(this, "Server Status Acknowledged", Toast.LENGTH_SHORT).show()
// }
// }
// },
//
// onRequestTimerEnd = {
// Toast.makeText(this, "Server Request Timeout", Toast.LENGTH_SHORT).show()
// },
//
// onCardScanTimerEnd = {
// Toast.makeText(this, "Card Scan Timeout", Toast.LENGTH_SHORT).show()
// }