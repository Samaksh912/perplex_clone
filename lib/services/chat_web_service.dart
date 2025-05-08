import 'dart:async';
import 'dart:convert';
import 'package:web_socket_client/web_socket_client.dart';

class ChatWebService {
  static final ChatWebService _instance = ChatWebService._internal();
  factory ChatWebService() => _instance;
  ChatWebService._internal();

  final _searchresultcontroller = StreamController<Map<String, dynamic>>.broadcast();
  final _contentcontroller = StreamController<Map<String, dynamic>>.broadcast();
  final _factcheckController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get searchresultstream => _searchresultcontroller.stream;
  Stream<Map<String, dynamic>> get contentstream => _contentcontroller.stream;
  Stream<Map<String, dynamic>> get factcheckstream => _factcheckController.stream;

  WebSocket? _chatSocket;
  WebSocket? _factSocket;

  bool _chatConnected = false;
  bool _factConnected = false;

  // Connect to chat WebSocket
  Future<void> connectChat(String query) async {
    if (_chatConnected) return;

    // 🚫 Close factcheck socket if open
    if (_factSocket != null && _factConnected) {
      _factSocket!.close();
      _factConnected = false;
      print("🔌 Closed Fact-check WebSocket before opening Chat.");
    }

    try {
      _chatSocket = WebSocket(Uri.parse("ws://10.9.154.154:8000/ws/chat"));

      _chatSocket!.messages.listen((message) {
        try {
          final data = json.decode(message);
          if (data['type'] == 'search_results') {
            _searchresultcontroller.add(data);
          } else if (data['type'] == 'content') {
            _contentcontroller.add(data);
          }
        } catch (e) {
          print("Error parsing message: $e");
        }
      }, onError: (error) {
        print("WebSocket error: $error");
        _chatConnected = false;
      }, onDone: () {
        print("WebSocket connection closed.");
        _chatConnected = false;
      });

      await _chatSocket!.connection.firstWhere((state) => state is Connected);
      if (_chatSocket != null) {
        _chatSocket!.send(jsonEncode({"query": query}));
        print("📤 Sent Chat Query: $query");
      }

      _chatConnected = true;
      print("✅ Chat WebSocket connected.");
    } catch (e) {
      print("WebSocket connection error: $e");
      _chatConnected = false;
    }
  }

  // Connect to fact-check WebSocket
  void connectFactcheck() async {
    // 🚫 Close chat socket if open
    if (_chatSocket != null && _chatConnected) {
      _chatSocket!.close();
      _chatConnected = false;
      print("🔌 Closed Chat WebSocket before opening Fact-check.");
    }

    // Connect only if not already connected
    if (_factSocket == null || _factSocket!.connection.state is Disconnected) {
      _factSocket = WebSocket(Uri.parse("ws://10.9.154.154:8000/ws/factcheck"));

      _factSocket!.messages.listen((message) {
        final data = json.decode(message);
        if (data['type'] == 'search_results') {
          _searchresultcontroller.add(data);
        } else if (data['type'] == 'factcheck_result') {
          _factcheckController.add(data);
        } else if (data['type'] == 'content') {
          _contentcontroller.add(data);
        }
      }, onError: (error) {
        print("Fact-check WebSocket Error: $error");
        _factConnected = false;
      }, onDone: () {
        print("Fact-check WebSocket closed.");
        _factConnected = false;
      });

      _factConnected = true;
      print("✅ Fact-check WebSocket connected.");
    }
  }

  Future<void> sendFactcheckQuery(String query) async {
    await _factSocket!.connection.firstWhere((state) => state is Connected);
    if (_factSocket != null && _factConnected) {
      _factSocket!.send(jsonEncode({"query": query}));
      print("📤 Sent Factcheck Query: $query");
    } else {
      print("❌ Fact-check WebSocket not connected.");
    }
  }
}
