import 'package:dio/dio.dart';
import 'dart:convert'; // For base64 encoding

final dio = Dio();

void sendSms(String sms) async {
  const String apiKey = "9e8cdaf3ff79d275";
  const String secretKey =
      "YjliYTI5YWQ3NDlmYjk4MzFiZTliOWQwZWNhMjFjODZlYTEwZjdmNDY3OTNiMjhhNjYzMDQ2YWNhYWNiMDExZA==";
  const String contentType = "application/json";
  const String sourceAddr = "AgriPoa";

  final dio = Dio();

  // Encoding API key and secret to Base64
  String basicAuth = 'Basic ${base64Encode(utf8.encode('$apiKey:$secretKey'))}';

  try {
    // Sending SMS request
    final response = await dio.post(
      "https://apisms.beem.africa/v1/send",
      data: {
        "source_addr": sourceAddr,
        "schedule_time": "",
        "encoding": 0,
        "message": sms,
        "recipients": [
          {
            "recipient_id": 1,
            "dest_addr": "255629593331",
          },
        ],
      },
      options: Options(
        headers: {
          "Content-Type": contentType,
          "Authorization": basicAuth,
        },
      ),
    );

    // Handle the response
    print("Response: ${response.data}");
  } catch (error) {
    // Handle the error
    if (error is DioException) {
      print("Error: ${error.response?.data}");
    } else {
      print("Error: $error");
    }
  }
}
