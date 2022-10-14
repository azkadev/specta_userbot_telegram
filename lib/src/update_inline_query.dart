// ignore_for_file: unnecessary_brace_in_string_interps
part of specta_userbot_telegram;


Future<dynamic> updateInlineQuery(
  Map msg, {
  required UpdateTd update,
  required Tdlib tg, 
  required Box dbBot, 
  required Map option,
  required String path, 
  required String pathDb, 
  required int bot_user_id,
}) async {
  var from_id = msg["from"]["id"];
  String query = msg["query"];
  if (query.isEmpty) {
    return null;
  }

  if (RegExp(r"^userbot_menu$", caseSensitive: false).hasMatch(query)) {
    return await tg.request(
      "answerInlineQuery",
      parameters: tg.makeParametersApi({
        "@type": "answerInlineQuery",
        "inline_query_id": msg["id"],
        "results": [
          {
            "id": tg.getRandom(10),
            "type": "inputInlineQueryResultArticle",
            "title": "Menu userbot",
            "description": "Menu userbot",
            "input_message_content": {
              "@type": "inputMessageText",
              "text": {"@type": "formattedText", "text": "Silahkan tap menunya kak"}
            },
            "reply_markup": {
              "inline_keyboard": [
                [
                  {
                    "text": "Main Menu",
                    "callback_data": "userbot_${from_id}:main_menu",
                  }
                ]
              ]
            }
          }
        ]
      }),
      clientId: update.client_id,
    );
  }
}
