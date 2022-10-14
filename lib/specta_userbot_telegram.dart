// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names

library specta_userbot_telegram;

import 'dart:io';

import 'package:galaxeus_lib/galaxeus_lib.dart';
import 'package:telegram_client/telegram_client.dart';
import 'package:path/path.dart' as p;

Future<void> userbot({required int api_id, required String api_hash, required String path, String? pathTdlib, String? databaseKey, required dynamic owner_chat_id, Map? clientOption, int? log_chat_id, required String token_bot}) async {
  databaseKey ??= "";
  clientOption ??= {};
  pathTdlib ??= "./libtdjson.so";
  String userbot_path = p.join(path, "db_specta_userbot");
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
    count_request_loop: 50000,
    delayInvoke: Duration(milliseconds: 100),
  );
  tg.on("update", (UpdateTd update) {
    try {
      if (update.raw.isEmpty) {
        return;
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
