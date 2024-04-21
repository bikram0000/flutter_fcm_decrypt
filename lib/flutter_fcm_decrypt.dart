
import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:ffi/ffi.dart';

import 'flutter_fcm_decrypt_bindings_generated.dart';
import 'dart:ffi' as ffi;

/// A very short-lived native function.
///
/// For very short-lived functions, it is fine to call them on the main isolate.
/// They will block the Dart execution while running the native function, so
/// only do this for native functions which are guaranteed to be short-lived.
void main() {

  decryptMessage(
      '{"object":{"id":"B4362F8D","from":"BDOU99-h67HcA6JeFXHbSNMu7e2yNNu3RzoMj8TM4W88jITfq7ZmPvIM1Iv-4_l2LxQcYwhqby2xGpWwzjfAnG4","category":"org.chromium.linux","appData":[{"key":"google.source","value":"webpush"},{"key":"encryption","value":"salt=2-XbF7yVGnxuu6xf2HCWrg=="},{"key":"subtype","value":"wp:receiver.push.com#7c47ef8f-ad1d-45c0-b048-e37b8d95f092"},{"key":"crypto-key","value":"dh=BBchCtcAXtA-ghgjOPK_I9I3JQ6A3Huj58HHwq4ScfLiQWKhWDe7qPinGsNfdV31kNfN3e_-UvX28Wcvpqk0JBg="}],"persistentId":"0:1711623408410794%7031b2e6f9fd7ecd","ttl":2419200,"sent":"1711623408408","rawData":[144,100,24,211,44,137,162,184,201,92,144,234,7,197,77,100,149,56,136,47,103,51,248,229,49,83,203,100,91,191,11,118,151,111,8,55,72,14,228,148,33,72,59,211,84,32,112,20,184,10,11,117,105,172,109,21,163,165,149,84,19,5,18,7,105,183,142,104,117,239,128,161,91,56,75,226,113,36,1,140,53,168,206,233,83,118,186,247,86,217,163,59,57,183,47,194,105,155,78,88,176,203,166,85,189,101,158,207,145,115,178,125,3,150,177,90,107,58,247,207,174,225,24,81,255,198,170,76,88,3,193,213,204,173,241,188,189,165,32,250,205,243,75,195,200,166,63,52,253,199,109,18,21,30,145,50,220,163,34,19,152,148,190,75,234,218,135,238,200,253,113,100,172,46,225,22,189,246,221,5,48,188,238,208,34,145,104,91,225,200,112,59,227,155,184,163,37,103,48,161,164,72,71,49,136,89,218,122,139,20,43,120,163,161,175,136,89,152,67,148,198,7,83,107,134,132,176,203,239,178,247,178,153,110,214,223,237,251,20,184,125,243,18,8,40,105,135,133,51,190,243,0,160,218,12,150,219,10,95,67,37,25,192,43,245]},"keys":{"privateKey":"mxS1cWvYGFxJJS8RTsOFkW5VqRyL4k6mIH0K3V47aHQ","publicKey":"BF4--ivRFQqtqhVlEbK6HoBlznFZu9lcAwpps-IDwTpuzLgxUQkRpMsxTnOUUHdbZK4XmFFo3c4ArvxXOcJHDPc","authSecret":"UG5PMDBLZkw5WHVFWmp0Vw"}}').then((value) {
        print("resutlt  :: $value");
  });


}
/// A longer lived native function, which occupies the thread calling it.
///
/// Do not call these kind of native functions in the main isolate. They will
/// block Dart execution. This will cause dropped frames in Flutter applications.
/// Instead, call these native functions on a separate isolate.
///
/// Modify this to suit your own use case. Example use cases:
///
/// 1. Reuse a single isolate for various different kinds of requests.
/// 2. Use multiple helper isolates for parallel execution.
Future<String> decryptMessage(String a) async {
  final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
  final int requestId = _nextSumRequestId++;
  final _SumRequest request = _SumRequest(requestId, a);
  final Completer<String> completer = Completer<String>();
  _sumRequests[requestId] = completer;
  helperIsolateSendPort.send(request);
  return completer.future;
}

const String _libName = 'libfcm_decrypt';

/// The dynamic library in which the symbols for [FlutterFcmDecryptBindings] can be found.
final DynamicLibrary _dylib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    if(Platform.version.contains('arm64')) {
      //TODO:: include './lib/' before lib name like  './lib/$_libName.dylib' for dart only run ..
      return DynamicLibrary.open('$_libName'+'_64'+'.dylib');
    } else {
      return DynamicLibrary.open('$_libName.dylib');
    }

  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('$_libName.so');
  }
  if (Platform.isWindows) {
    //TODO:: include '.\\windows\\' before lib name like  './lib/$_libName.dylib' for dart only run ..
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dylib].
final FlutterFcmDecryptBindings _bindings = FlutterFcmDecryptBindings(_dylib);


/// A request to compute `sum`.
///
/// Typically sent from one isolate to another.
class _SumRequest {
  final int id;
  final String a;


  const _SumRequest(this.id, this.a);
}

/// A response with the result of `sum`.
///
/// Typically sent from one isolate to another.
class _SumResponse {
  final int id;
  final String result;

  const _SumResponse(this.id, this.result);
}

/// Counter to identify [_SumRequest]s and [_SumResponse]s.
int _nextSumRequestId = 0;

/// Mapping from [_SumRequest] `id`s to the completers corresponding to the correct future of the pending request.
final Map<int, Completer<String>> _sumRequests = <int, Completer<String>>{};

/// The SendPort belonging to the helper isolate.
Future<SendPort> _helperIsolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final Completer<SendPort> completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        // The helper isolate sent us the port on which we can sent it requests.
        completer.complete(data);
        return;
      }
      if (data is _SumResponse) {
        // The helper isolate sent us a response to a request we sent.
        final Completer<String> completer = _sumRequests[data.id]!;
        _sumRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  // Start the helper isolate.
  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        // On the helper isolate listen to requests and respond to them.
        if (data is _SumRequest) {

          Pointer<Utf8> result = _bindings.decrypt_message(data.a.toNativeUtf8());
          final _SumResponse response = _SumResponse(data.id, result.cast<Utf8>().toDartString());
          sendPort.send(response);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
