import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  SocketService({required this.baseUrl});

  final String baseUrl;
  io.Socket? _socket;

  /// Connect with the user's JWT access token.
  /// Call once after login.
  void connect(String accessToken) {
    if (_socket?.connected ?? false) return;

    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );

    _socket!.onConnect((_) {
      // ignore: avoid_print
      print('[Socket] Connected');
    });
    _socket!.onDisconnect((_) {
      // ignore: avoid_print
      print('[Socket] Disconnected');
    });
    _socket!.onConnectError((err) {
      // ignore: avoid_print
      print('[Socket] Connection error: $err');
    });

    _socket!.connect();
  }

  /// Register a listener for the `notification` event.
  void onNotification(void Function(Map<String, dynamic> data) handler) {
    _socket?.on('notification', (raw) {
      if (raw is Map<String, dynamic>) handler(raw);
    });
  }

  /// Remove the `notification` listener.
  void offNotification() {
    _socket?.off('notification');
  }

  /// Call on logout.
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  bool get isConnected => _socket?.connected ?? false;
}
