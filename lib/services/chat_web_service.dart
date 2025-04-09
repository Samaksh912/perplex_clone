import 'dart:async';
import 'dart:convert';
import 'package:web_socket_client/web_socket_client.dart';

class ChatWebService {
  static final ChatWebService _instance = ChatWebService._internal();
  factory ChatWebService() => _instance;
  ChatWebService._internal();
  final _searchresultcontroller = StreamController<Map<String,dynamic>>.broadcast();
  final _contentcontroller = StreamController<Map<String,dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get searchresultstream => _searchresultcontroller.stream;
  Stream<Map<String, dynamic>> get contentstream => _contentcontroller.stream;

  WebSocket? _socket;
  bool _isConnected = false; // Prevent multiple connections

  void connect() {
    if (_isConnected) return; // Prevent reconnecting

    try {
      _socket = WebSocket(Uri.parse("ws://10.3.19.79:8000/ws/chat"));
      _isConnected = true;

      _socket!.messages.listen((message) {
        try {
          final data = json.decode(message);
          if(data['type'] == 'search_results'){
            _searchresultcontroller.add(data);
          }
          else if (data['type'] == 'content'){
            _contentcontroller.add(data);

          }
        } catch (e) {
          print("Error parsing message: $e");
        }
      }, onError: (error) {
        print("WebSocket error: $error");
        _isConnected = false;
      }, onDone: () {
        print("WebSocket connection closed.");
        _isConnected = false;
      });

      print("WebSocket Connected!");
    } catch (e) {
      print("WebSocket connection error: $e");
      _isConnected = false;
    }
  }

  void chat(String query) {
    if (_socket != null && _isConnected) {
      try {
        _socket!.send(jsonEncode({"query": query})); // Fixed JSON format
        print("Sent: $query");
      } catch (e) {
        print("Error sending message: $e");
      }
    } else {
      print("WebSocket is not connected.");
    }
  }
}
