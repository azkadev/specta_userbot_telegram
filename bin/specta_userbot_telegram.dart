// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:hive/hive.dart';
import 'package:specta_userbot_telegram/specta_userbot_telegram.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_client/supabase.dart';
import 'package:telegram_client/tdlib/tdlib.dart';

void main(List<String> args) async {
  String path = p.join(Directory.current.path);
  String userbot_path = p.join(path, "specta_userbot_telegram");

  String userbot_path_db = p.join(userbot_path, "db");
  /// environment
  String username = Platform.environment["username"] ?? "admin";
  String password = Platform.environment["password"] ?? "azka123";
  String host_name = Platform.environment["HOST_API"] ?? "wss://specta-apis.up.railway.app/ws";
  int tg_api_id = int.parse(Platform.environment["tg_api_id"] ?? "0");
  String tg_api_hash = Platform.environment["tg_api_hash"] ?? "0";
  String tg_token_bot = Platform.environment["tg_token_bot"] ?? "0";
  int tg_owner_user_id = int.parse(Platform.environment["tg_owner_user_id"] ?? "0");
  String supabase_id = Platform.environment["supabase_id"] ?? "0";
  String supabase_key = Platform.environment["supabase_key"] ?? "0";
  tg_token_bot = "5372119177:AAG604E1Ckiow07Bl506MMn2mpoNTd-SOBk";
  String tg_event_invoke = "tg_invoke";
  String tg_event_update = "tg_update";
  
  late DatabaseType databaseType = DatabaseType.hive;
  EventEmitter eventEmitter = EventEmitter();
  WebSocketClient ws = WebSocketClient(
    host_name,
    eventEmitter: eventEmitter,
    eventNameUpdate: "socket_update",
  );
  Database supabase_db = Database(supabase_id, supabase_key);
  Box hive_db = await Hive.openBox("main", path: userbot_path);
  DatabaseLib databaseLib = DatabaseLib(
    databaseType: databaseType,
    supabase_db: supabase_db,
    hive_db: hive_db,
  );
  late Tdlib tg;
  Listener listener_websocket_update = ws.on(ws.event_name_update, (update) {
    try {
      if (update is Map) {
        if (update["@type"] is String == false) {
          return;
        } 
        String method = (update["@type"] as String);
        late Map jsonRespond = {"@type": "ok"};
        if (update["@extra"] is String) {
          jsonRespond["@extra"] = update["@extra"];
        }
        if (update["@client_id"] is int) {
          jsonRespond["@client_id"] = update["@client_id"];
        }
        try {
          ///
          ///
          ///
          ///
          
        } catch (e) {
          jsonRespond["@type"] = "error";
          jsonRespond["message"] = "${e}";

          return ws.clientSendJson(jsonRespond);
        }
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
    userbot_path: userbot_path,
    userbot_path_db: userbot_path_db,
    owner_chat_id: tg_owner_user_id,
    token_bot: tg_token_bot,
    webSocketClient: ws,
    eventEmitter: eventEmitter,
    event_invoke: tg_event_invoke,
    event_update: tg_event_update,
    databaseLib: databaseLib,
    onInit: (Tdlib tg_callback) {
      tg = tg_callback;
    },
  );
}
