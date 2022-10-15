// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names, unused_local_variable

library specta_userbot_telegram;

import 'dart:convert';
import 'dart:io';

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:hive/hive.dart';
import 'package:supabase_client/supabase.dart';
import 'package:telegram_client/telegram_client.dart';
import 'package:path/path.dart' as p;

part 'core/database.dart';

part "scheme/update_callback_query.dart";
part "scheme/update_inline_query.dart";
part "scheme/update_msg.dart";

part "src/update_callback_query.dart";
part "src/update_inline_query.dart";
part "src/update_message.dart";

Future<void> userbot({
  required int api_id,
  required String api_hash,
  required String userbot_path,
  String? pathTdlib,
  String? databaseKey,
  required dynamic owner_chat_id,
  Map? clientOption,
  int? log_chat_id,
  required String token_bot,
  required WebSocketClient webSocketClient,
  required EventEmitter eventEmitter,
  required DatabaseLib databaseLib,
  String event_invoke = "invoke",
  String event_update = "update",
  required void Function(Tdlib tdlib) onInit,
}) async {
  databaseKey ??= "";
  clientOption ??= {};
  pathTdlib ??= "./libtdjson.so";
  String userbot_path_db = p.join(userbot_path, "db");
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
  onInit.call(tg);
  Listener listener_event_invoke = tg.on(tg.event_invoke, (update) {
    if (update.raw.isEmpty) {
      return;
    }
    if (update.raw["@type"] == "error") {
      print(update.raw);
    }
  });

  Listener listener_event_update = tg.on(tg.event_update, (UpdateTd update) async {
    try {
      if (update.raw.isEmpty) {
        return;
      }
      int bot_user_id = parserBotUserIdFromToken(update.client_option["token_bot"]);
      int current_user_id = 0;
      if (update.client_option["id"] is int) {
        current_user_id = update.client_option["id"];
      } 
      /// authorization update
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
      List<String> updateOnly = ["updateNewMessage", "updateNewInlineQuery", "updateNewCallbackQuery", "updateNewInlineCallbackQuery"];
      if (updateOnly.contains(update.raw["@type"])) {
        Box dbBot = await Hive.openBox("${bot_user_id}", path: userbot_path_db);
        DatabaseTg databaseTg = DatabaseTg(
          databaseLib: DatabaseLib(
            databaseType: databaseLib.databaseType,
            supabase_db: databaseLib.supabase_db,
            hive_db: dbBot,
          ),
          path: userbot_path,
        );
        if (update.raw["@type"] == "updateNewInlineQuery") {
          Map? msg = await apiUpdateInlineQuery(update, tg: tg);
          if (msg != null && msg.isNotEmpty) {
            await updateInlineQuery(
              msg,
              update: update,
              tg: tg,
              dbBot: dbBot,
              option: option,
              path: userbot_path,
              pathDb: userbot_path_db,
              bot_user_id: bot_user_id,
            );
          }
        }

        if (update.raw["@type"] == "updateNewCallbackQuery" || update.raw["@type"] == "updateNewInlineCallbackQuery") {
          Map? msg = await apiUpdateCallbackQuery(update, tg: tg);
          if (msg != null && msg.isNotEmpty) {
            await updateCallbackQuery(
              msg,
              update: update,
              tg: tg,
              dbBot: dbBot,
              option: option,
              path: userbot_path,
              pathDb: userbot_path_db,
              bot_user_id: bot_user_id,
            );
          }
        }

        if (update.raw["@type"] == "updateNewMessage") {
          var message = update.raw["message"];
          if (message["@type"] == "message") {
            Map? msg = await apiUpdateMsg(message, update: update, tg: tg);
            if (msg != null) {
              try {
                (msg).remove("last_message");
              } catch (e) {}
              try {
                (msg["from"] as Map).remove("last_message");
              } catch (e) {}
              try {
                (msg["chat"] as Map).remove("last_message");
              } catch (e) {}
              await updateMsg(
                msg,
                update: update,
                tg: tg,
                dbBot: dbBot,
                path: userbot_path,
                pathDb: userbot_path_db,
                bot_user_id: bot_user_id,
              );
            }
          }
        }
      }

      return;
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

List<String> splitByLength(String text, int length, {bool ignoreEmpty = false}) {
  List<String> pieces = [];

  for (int i = 0; i < text.length; i += length) {
    int offset = i + length;
    String piece = text.substring(i, offset >= text.length ? text.length : offset);

    if (ignoreEmpty) {
      piece = piece.replaceAll(RegExp(r'\s+'), '');
    }

    pieces.add(piece);
  }
  return pieces;
}

List prettyPrintJson(var input, {bool is_log = true}) {
  try {
    if (input is String) {
    } else {
      input = json.encode(input);
    }
    const JsonDecoder decoder = JsonDecoder();
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final dynamic object = decoder.convert(input);
    final dynamic prettyString = encoder.convert(object);
    List result = prettyString.split('\n');
    if (is_log) {
      for (var element in result) {
        print(element);
      }
    }
    return result;
  } catch (e) {
    print(e);
    return ["error"];
  }
}
