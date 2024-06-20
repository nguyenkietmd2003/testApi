import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ApiCallDemo(),
    );
  }
}

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> postRequest(String endpoint, Map<String, String> headers,
      Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class ApiCallDemo extends StatefulWidget {
  const ApiCallDemo({super.key});

  @override
  _ApiCallDemoState createState() => _ApiCallDemoState();
}

class _ApiCallDemoState extends State<ApiCallDemo> {
  final ApiService apiService =
      ApiService(baseUrl: 'https://movienew.cybersoft.edu.vn');
  String response = 'Waiting for API call...';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final result = await apiService.postRequest(
        '/api/QuanLyNguoiDung/DangNhap',
        {
          'Content-Type': 'application/json',
          'TokenCybersoft':
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0ZW5Mb3AiOiJCb290Y2FtcCA2NCIsIkhldEhhblN0cmluZyI6IjA4LzA5LzIwMjQiLCJIZXRIYW5UaW1lIjoiMTcyNTc1MzYwMDAwMCIsIm5iZiI6MTY5NTkyMDQwMCwiZXhwIjoxNzI1OTAxMjAwfQ.fWIHiHRVx9B7UlCgFCwvvXAlcVc-I-RB603rEDsM_wI',
        },
        {
          'taiKhoan': 'nguyentuankiet',
          'matKhau': 'kiet1234',
        },
      );

      setState(() {
        response = result.toString();
        print(response);
      });
    } catch (e) {
      setState(() {
        response = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter API Call Demo'),
      ),
      body: Center(
        child: Text(response),
      ),
    );
  }
}
