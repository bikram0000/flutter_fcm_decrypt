import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_fcm_decrypt/flutter_fcm_decrypt.dart'
    as flutter_fcm_decrypt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String> sumAsyncResult;

  @override
  void initState() {
    super.initState();
    sumAsyncResult = flutter_fcm_decrypt
        .decryptMessage(
            '{"object":{"id":"B4362F8D","from":"BDOU99-h67HcA6JeFXHbSNMu7e2yNNu3RzoMj8TM4W88jITfq7ZmPvIM1Iv-4_l2LxQcYwhqby2xGpWwzjfAnG4","category":"org.chromium.linux","appData":[{"key":"google.source","value":"webpush"},{"key":"encryption","value":"salt=2-XbF7yVGnxuu6xf2HCWrg=="},{"key":"subtype","value":"wp:receiver.push.com#7c47ef8f-ad1d-45c0-b048-e37b8d95f092"},{"key":"crypto-key","value":"dh=BBchCtcAXtA-ghgjOPK_I9I3JQ6A3Huj58HHwq4ScfLiQWKhWDe7qPinGsNfdV31kNfN3e_-UvX28Wcvpqk0JBg="}],"persistentId":"0:1711623408410794%7031b2e6f9fd7ecd","ttl":2419200,"sent":"1711623408408","rawData":[144,100,24,211,44,137,162,184,201,92,144,234,7,197,77,100,149,56,136,47,103,51,248,229,49,83,203,100,91,191,11,118,151,111,8,55,72,14,228,148,33,72,59,211,84,32,112,20,184,10,11,117,105,172,109,21,163,165,149,84,19,5,18,7,105,183,142,104,117,239,128,161,91,56,75,226,113,36,1,140,53,168,206,233,83,118,186,247,86,217,163,59,57,183,47,194,105,155,78,88,176,203,166,85,189,101,158,207,145,115,178,125,3,150,177,90,107,58,247,207,174,225,24,81,255,198,170,76,88,3,193,213,204,173,241,188,189,165,32,250,205,243,75,195,200,166,63,52,253,199,109,18,21,30,145,50,220,163,34,19,152,148,190,75,234,218,135,238,200,253,113,100,172,46,225,22,189,246,221,5,48,188,238,208,34,145,104,91,225,200,112,59,227,155,184,163,37,103,48,161,164,72,71,49,136,89,218,122,139,20,43,120,163,161,175,136,89,152,67,148,198,7,83,107,134,132,176,203,239,178,247,178,153,110,214,223,237,251,20,184,125,243,18,8,40,105,135,133,51,190,243,0,160,218,12,150,219,10,95,67,37,25,192,43,245]},"keys":{"privateKey":"mxS1cWvYGFxJJS8RTsOFkW5VqRyL4k6mIH0K3V47aHQ","publicKey":"BF4--ivRFQqtqhVlEbK6HoBlznFZu9lcAwpps-IDwTpuzLgxUQkRpMsxTnOUUHdbZK4XmFFo3c4ArvxXOcJHDPc","authSecret":"UG5PMDBLZkw5WHVFWmp0Vw"}}');


  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 25);
    const spacerSmall = SizedBox(height: 10);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Packages'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  'This calls a native function through FFI that is shipped as source in the package. '
                  'The native code is built as part of the Flutter Runner build.',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                Text(
                  'sum(1, 2) =',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
                spacerSmall,
                FutureBuilder<String>(
                  future: sumAsyncResult,
                  builder: (BuildContext context, AsyncSnapshot<String> value) {
                    final displayValue =
                        (value.hasData) ? value.data : 'loading';
                    return Text(
                      'await sumAsync(3, 4) = $displayValue',
                      style: textStyle,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
