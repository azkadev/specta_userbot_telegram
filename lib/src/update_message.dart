// ignore_for_file: non_constant_identifier_names, empty_catches, unnecessary_brace_in_string_interps, unused_local_variable, unused_element
part of specta_userbot_telegram;

List chatIds = [];

Future<dynamic> updateMsg(
  Map msg, {
  required String path,
  required UpdateTd update,
  required Tdlib tg,
  required Box dbBot,
  required String pathDb,
  required int bot_user_id,
}) async {
  String msg_caption = "";
  if (msg["text"] is String) {
    msg_caption = msg["text"];
  }
  if (msg["caption"] is String) {
    msg_caption = msg["caption"];
  }
  var text = "";
  if (msg["text"] is String) {
    text = msg["text"];
  }
  var isOutgoing = false;
  late String chatType = "";
  if (msg["is_outgoing"] is bool) {
    isOutgoing = msg["is_outgoing"];
  }
  if (msg["chat"] is Map == false) {
    return null;
  }
  if (msg["chat"]["type"] is String && (msg["chat"]["type"] as String).isNotEmpty) {
    chatType = msg["chat"]["type"];
    chatType = chatType.replaceAll(RegExp(r"super", caseSensitive: false), "");
  } else {
    return null;
  }
  var isAdmin = false;
  var chat_id = msg["chat"]["id"];
  var from_id = msg["from"]["id"];

  if (tg.client_id != update.client_id) {
    if (isOutgoing) {
      isAdmin = true;
    } else {
      try {
        if (update.client_option["owner_user_id"] == msg["from"]["id"]) {
          isAdmin = true;
        }
      } catch (e) {}
      try {
        if (update.client_option["admin_user_id"] == msg["from"]["id"]) {
          isAdmin = true;
        }
      } catch (e) {}
    }
  }

  // if (creator_user_ids.contains(msg["from"]["id"])) {
  //   isAdmin = true;
  // }

  Map<String, dynamic>? parameters = {
    "method": "sendMessage",
    "chat_id": msg["chat"]["id"],
    "message_id": msg['message_id'],
  };

  if (tg.client_id != update.client_id) {
    if (isOutgoing) {
      parameters["method"] = "editMessageText";
    }
  }
  try {
    late Map parameterPatch = {};
    Future<Map> request({
      required String method,
      Map? parameters,
      bool is_form = false,
      bool is_parse_mode = true,
      int? clientId,
    }) async {
      parameters ??= {};
      clientId ??= update.client_id;
      try {
        parameters.addAll(parameterPatch);
      } catch (e) {}
      if (is_parse_mode) {
        parameters["parse_mode"] = "html";
      } else {}
      parameters["allow_sending_without_reply"] = true;
      if (parameters["text"] is String) {
        String text = parameters["text"];
        if (text.length >= 4096) {
          var messages = "";
          List<String> messagesJson = splitByLength(text, 4096);
          List result = [];
          for (var i = 0; i < messagesJson.length; i++) {
            var loopData = messagesJson[i];
            try {
              await Future.delayed(Duration(seconds: 2));
              parameters["text"] = loopData;
              if (RegExp("(editMessageText)", caseSensitive: false).hasMatch(method)) {
                if (i != 0) {
                  method = "sendMessage";
                }
              }
              var res = await tg.request(
                method,
                parameters: parameters,
                clientId: clientId,
              );
              result.add(res);
            } catch (e) {
              result.add(e);
            }
          }
          return {"result": result};
        }
      }

      if (parameters["caption"] is String) {
        String caption = parameters["caption"];
        if (caption.length >= 1024) {
          var messages = "";

          List<String> messagesJson = splitByLength(caption, 1024);
          List result = [];
          for (var i = 0; i < messagesJson.length; i++) {
            var loopData = messagesJson[i];
            try {
              await Future.delayed(Duration(seconds: 2));
              parameters["caption"] = loopData;
              if (RegExp("(editMessageCaption)", caseSensitive: false).hasMatch(method)) {
                if (i != 0) {
                  parameters["text"] = loopData;
                  method = "sendMessage";
                }
              }
              var res = await tg.request(
                method,
                parameters: parameters,
                clientId: clientId,
              );
              result.add(res);
            } catch (e) {
              result.add(e);
            }
          }
          return {"result": result};
        }
      }

      return await tg.request(
        method,
        parameters: parameters,
        clientId: update.client_id,
      );
    }
    

    /// command
    if (msg_caption.isNotEmpty) {
  
      if (RegExp(r"^([!./])", caseSensitive: false).hasMatch(text)) {
        String textCommand = text.replaceAll(RegExp(r"^([!./])([ ]+)?", caseSensitive: false), "");
        if (textCommand.isNotEmpty) {
          bool isCommandSpace = (textCommand.split(" ").length > 1);

          if (RegExp(r"^test$", caseSensitive: false).hasMatch(textCommand)) {
            return await tg.callApi(
              tdlibFunction: TdlibFunction.sendMessage(
                chat_id: chat_id,
                input_message_content: TdlibFunction.inputMessageText(
                  text: TdlibFunction.formattedText(
                    text: "Hello World",
                  ),
                ),
              ),
              clientId: update.client_id,
            );
          }

          /// ping comand
          if (RegExp(r"^ping$", caseSensitive: false).hasMatch(textCommand)) {
            DateTime time = DateTime.fromMillisecondsSinceEpoch((msg["date"] * 1000));
            parameters["text"] = "📣️ Pong\n${convertToAgoFromDateTime(time)}";
            return await tg.request(
              parameters["method"],
              parameters: parameters,
              clientId: update.client_id,
            );
          }
          // json dump
          if (RegExp(r"^jsondump$", caseSensitive: false).hasMatch(textCommand)) {
            DateTime time = DateTime.fromMillisecondsSinceEpoch((msg["date"] * 1000));
            try {
              (msg["from"] as Map).remove("phone_number");
            } catch (e) {}
            String jsonDump = prettyPrintJson(msg, is_log: false).join("\n");
            parameters["text"] = jsonDump;
            return await request.call(
              method: parameters["method"],
              parameters: parameters,
            );
          }

          if (RegExp(r"^userbot$", caseSensitive: false).hasMatch(textCommand)) {
            if (update.client_option["is_login_bot"] == true) {
              return await request(
                method: "sendMessage",
                parameters: {
                  "chat_id": chat_id,
                  "text": "Silahkan tap menu nya kak",
                  "reply_markup": {
                    "inline_keyboard": [
                      [
                        {"text": "Clone UserBot", "callback_data": "clone_userbot:main_menu"}
                      ]
                    ]
                  }
                },
                clientId: update.client_id,
              );
            }
          }
        }
      }
    }
  } catch (e) {
    parameters["text"] = e.toString();
    return await tg.request(
      parameters["method"],
      parameters: parameters,
      clientId: update.client_id,
    );
  }
}
