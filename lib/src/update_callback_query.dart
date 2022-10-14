// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps
part of specta_userbot_telegram;

Future<dynamic> updateCallbackQuery(
  Map msg, {
  required UpdateTd update,
  required Tdlib tg,
  required Box db,
  required Box dbBot,
  required List user_ids,
  required String pathDb,
  required Map option,
  required String path,
  required List skip_bot_user_ids,
  required List<Map<String, dynamic>> types,
  required int bot_user_id,
}) async {
  var cb = msg;
  var cbm = msg["message"];
  var text = cb["data"];
  var chatId = cb["chat"]["id"];
  var fromId = cb["from"]["id"];
  var chat_id = cb["chat"]["id"];
  var from_id = cb["from"]["id"];
  var subMenu = text.toString().replaceAll(RegExp(r".*:|=.*", caseSensitive: false), "");
  var subSubMenu = text.toString().replaceAll(RegExp(r".*=", caseSensitive: false), "");
  if (RegExp(r"userbot_[0-9]+:.*", caseSensitive: false).hasMatch(text)) {
    String rootMenu = text.toString().replaceAll(RegExp(r":.*", caseSensitive: false), "");
    int getUserIdData = int.parse(RegExp(r"([0-9]+)", caseSensitive: false).stringMatch(rootMenu) ?? "0");
    late bool isAdmin = false;

    if (getUserIdData == from_id) {
      isAdmin = true;
    }

    if (!isAdmin) {
      return await tg.answerCallbackQuery(
        cb["id"],
        text: "Maaf Menu ini bukan untuk anda",
        show_alert: true,
        clientId: update.client_id,
      );
    }

    Box dbUser = await Hive.openBox("user_${from_id}", path: pathDb);
  }
}
