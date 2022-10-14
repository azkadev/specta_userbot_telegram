// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names

library specta_userbot_telegram;

import 'dart:io';

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_client/telegram_client.dart';
import 'package:path/path.dart' as p;

Future<void> userbot({
  required int api_id,
  required String api_hash,
  required String path,
  String? pathTdlib,
  String? databaseKey,
  required dynamic owner_chat_id,
  Map? clientOption,
  int? log_chat_id,
  required String token_bot,
  required WebSocketClient webSocketClient,
  EventEmitter? eventEmitter,
  String event_invoke = "invoke",
  String event_update = "update",
}) async {
  databaseKey ??= "";
  clientOption ??= {};
  pathTdlib ??= "./libtdjson.so";
  String userbot_path = p.join(path, "db_specta_userbot");
  Directory userbot_dir = Directory(userbot_path);
  if (!userbot_dir.existsSync()) {
    userbot_dir.createSync(recursive: true);
  }
  String files_directory = p.join(userbot_path, "database");
  Map option = {
    'api_id': api_id,
    'api_hash': api_hash,
    "use_file_database": false,
    "use_chat_info_database": false,
    "use_message_database": false,
    "use_secret_chats": false,
    'database_directory': "${userbot_path}/${token_bot}/",
    'files_directory': files_directory,
    "new_verbosity_level": 0,
    "database_key": databaseKey,
    "is_login_bot": true,
    "token_bot": token_bot,
    "from_bot_type": "core",
    "bot_user_id": parserBotUserIdFromToken(token_bot),
    ...clientOption,
  };
  Tdlib tg = Tdlib(
    pathTdlib,
    clientOption: option,
    delayInvoke: Duration(milliseconds: 100),
    eventEmitter: eventEmitter,
    event_invoke: event_invoke,
    event_update: event_update,
  );
  tg.on(tg.event_invoke, (update) {
    print(update.raw);
  });
  tg.on(tg.event_update, (UpdateTd update) async {
    try {
      if (update.raw.isEmpty) {
        return;
      }
      if (update.raw["@type"] == "updateAuthorizationState") {
        if (update.raw["authorization_state"] is Map) {
          var authStateType = update.raw["authorization_state"]["@type"];
          if (tg.client_id != update.client_id) {
            update.client_option["database_key"] = databaseKey;
            await tg.initClient(update, clientId: update.client_id, tdlibParameters: update.client_option, isVoid: true);
          } else {
            await tg.initClient(update, clientId: update.client_id, tdlibParameters: update.client_option, isVoid: true);
          }
          if (authStateType == "authorizationStateLoggingOut") {}
          if (authStateType == "authorizationStateClosed") {
            print("close: ${update.client_id}");
            tg.exitClient(update.client_id);
          }
          if (authStateType == "authorizationStateWaitPhoneNumber") {
            print("wait number or token bot");
            if (update.client_option["is_login_bot"] == true) {
              await tg.request(
                "checkAuthenticationBotToken",
                parameters: {
                  "token": update.client_option["token_bot"],
                },
                clientId: update.client_id,
              );
            } else {
              await tg.request(
                "requestQrCodeAuthentication",
                parameters: {
                  "other_user_ids": [],
                },
                clientId: update.client_id,
              );
            }
          }
          if (authStateType == "authorizationStateWaitCode") {}
          if (authStateType == "authorizationStateWaitPassword") {}
        }
      }

      print(update.raw);
    } catch (e) {
      print(e);
    }
  });
  await tg.initIsolate();
}

int parserBotUserIdFromToken(dynamic token_bot) {
  try {
    return int.parse(token_bot.split(":")[0]);
  } catch (e) {
    return 0;
  }
}
