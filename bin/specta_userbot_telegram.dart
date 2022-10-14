// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:specta_userbot_telegram/specta_userbot_telegram.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  String path = p.join(Directory.current.path);

  /// environment
  String username = Platform.environment["username"] ?? "admin";
  String password = Platform.environment["password"] ?? "azka123";
  String host_name = Platform.environment["HOST_API"] ?? "wss://specta-apis.up.railway.app/ws";
  int tg_api_id = int.parse(Platform.environment["tg_api_id"] ?? "0");
  String tg_api_hash = Platform.environment["tg_api_hash"] ?? "0";
  String tg_token_bot = Platform.environment["tg_token_bot"] ?? "0";
  int tg_owner_user_id = int.parse(Platform.environment["tg_owner_user_id"] ?? "0");

  String tg_event_invoke = "invoke";
  String tg_event_update = "update";
  EventEmitter eventEmitter = EventEmitter();
  WebSocketClient ws = WebSocketClient(
    host_name,
    eventEmitter: eventEmitter,
    eventNameUpdate: "socket_update",
  );
  ws.on(ws.event_name_update, (update) {
    try {
      if (update is Map) {
        if (update["@type"] is String == false) {
          return;
        }
        String method = (update["@type"] as String);
        print(method);
      }
    } catch (e) {
      print(e);
    }
  });
  await ws.connect(
    onDataUpdate: (data) {
      if (data is String && data.isNotEmpty) {
        try {
          return ws.event_emitter.emit(ws.event_name_update, null, json.decode(data));
        } catch (e) {}
      }
    },
    onDataConnection: (data) {
      if (data["@type"] == "connection") {
        print("Status: ${data["status"]}");
      }
    },
  );
  await userbot(
    api_id: tg_api_id,
    api_hash: tg_api_hash,
    path: path,
    owner_chat_id: tg_owner_user_id,
    token_bot: tg_token_bot,
    webSocketClient: ws,
    eventEmitter: eventEmitter,
    event_invoke: tg_event_invoke,
    event_update: tg_event_update,
  );
}
