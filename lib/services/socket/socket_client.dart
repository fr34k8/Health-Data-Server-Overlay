import 'package:flutter/foundation.dart';
import 'package:hds_overlay/model/data_source.dart';
import 'package:hds_overlay/model/log_message.dart';
import 'package:hds_overlay/services/socket/socket_base.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketClient extends SocketBase {
  WebSocketChannel? _channel;
  bool _isClosed = false;

  Future<WebSocketChannel> connect(String clientName, String ip) async {
    try {
      Uri uri;
      if (ip.startsWith('ws')) {
        uri = Uri.parse('$ip');
      } else {
        uri = Uri.parse('ws://$ip');
      }
      if (!uri.hasPort) {
        uri = Uri.parse('${uri.toString()}:3476');
      }
      final channel = WebSocketChannel.connect(uri);
      channel.sink.add('clientName:$clientName');
      logStreamController
          .add(LogMessage(LogLevel.good, 'Connecting to server: $ip'));

      _reconnectOnDisconnect(channel, clientName, ip);
      return Future.value(channel);
    } catch (e) {
      print(e.toString());
      logStreamController
          .add(LogMessage(LogLevel.error, 'Unable to connect to server: $ip'));
      Future.delayed(Duration(seconds: 10), () => connect(clientName, ip));
      return Future.error('Unable to connect to server: $ip');
    }
  }

  void _reconnectOnDisconnect(
    WebSocketChannel channel,
    String clientName,
    String ip,
  ) async {
    // This channel is used for sending data on desktop and receiving data on web
    final channelSubscription = channel.stream.listen((message) {
      if (kIsWeb) {
        handleMessage(channel, message, 'watch');
      }
    });
    channelSubscription.onDone(() {
      logStreamController
          .add(LogMessage(LogLevel.warn, 'Disconnected from server: $ip'));
      channelSubscription.cancel();
      // Don't reconnect if we requested this socket to close
      if (_isClosed) return;
      _reconnect(clientName, ip);
    });
    channelSubscription.onError((error) {
      logStreamController
          .add(LogMessage(LogLevel.warn, 'Disconnected from server: $ip'));
      print(error);
      channelSubscription.cancel();
      // Don't reconnect if we requested this socket to close
      if (_isClosed) return;
      _reconnect(clientName, ip);
    });
  }

  void _reconnect(String clientName, String ip) {
    _channel?.sink.close();
    Future.delayed(Duration(seconds: 5), () => connect(clientName, ip));
  }

  @override
  Future<void> start(
    int port,
    String serverIp,
    String clientName,
    List<String> serverIps,
  ) async {
    _channel = await connect(DataSource.browser, 'ws://$serverIp:$port');
  }

  @override
  Future<void> stop() {
    _isClosed = true;
    _channel?.sink.close();
    return Future.value();
  }
}
