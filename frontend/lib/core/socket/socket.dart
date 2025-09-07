import 'dart:developer';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static SocketService? _instance;
  static SocketService get instance => _instance ??= SocketService._();

  SocketService._();

  IO.Socket? _socket;
  Function(Map<String, dynamic>)? _onDataUpdate;

  void connect(String serverUrl) {
    try {
      _socket = IO.io(
        serverUrl,
        IO.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .build(),
      );

      _socket?.on('connect', (_) {
        log('Socket connected: ${_socket?.id}');
      });

      _socket?.on('disconnect', (_) {
        log('Socket disconnected');
      });

      _socket?.on('connect_error', (error) {
        log('Socket connection error: $error');
      });

      // Listen for data updates
      _socket?.on('data_update', (data) {
        log('Data update received: $data');
        if (_onDataUpdate != null && data is Map<String, dynamic>) {
          _onDataUpdate!(data);
        }
      });

      _socket?.connect();
    } catch (e) {
      log('Error connecting to socket: $e');
    }
  }

  void setDataUpdateCallback(Function(Map<String, dynamic>) callback) {
    _onDataUpdate = callback;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _onDataUpdate = null;
  }

  bool get isConnected => _socket?.connected ?? false;
}
