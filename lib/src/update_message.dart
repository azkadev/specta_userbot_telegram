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
  if (msg["chat"]["type"] == "channel") {
    var text = "";
    if (msg["text"] is String) {
      text = msg["text"];
    }
    var isOutgoing = false;
    var chatType = "";
    if (msg["is_outgoing"] is bool) {
      isOutgoing = msg["is_outgoing"];
    }
    if (msg["chat"] is Map) {
      if (msg["chat"]["type"] is String && (msg["chat"]["type"] as String).isNotEmpty) {
        chatType = msg["chat"]["type"];
      } else {
        return null;
      }
      var isAdmin = false;

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

      /// command
      if (text.isNotEmpty) {
        if (RegExp(r"^([!./])", caseSensitive: false).hasMatch(text)) {
          if (RegExp(r"^[/.!]jsondump$", caseSensitive: false).hasMatch(msg["text"])) {
            if (tg.client_id == update.client_id && isOutgoing) {
              return null;
            }
            try {
              (msg["from"] as Map).remove("phone_number");
            } catch (e) {}
            var jsonDump = prettyPrintJson(msg, is_log: false).join("\n");
            List<String> messagesJson = splitByLength(jsonDump, 4096);
            for (var i = 0; i < messagesJson.length; i++) {
              var loopData = messagesJson[i];
              try {
                parameters["text"] = loopData;
                await tg.request(
                  "sendMessage",
                  parameters: parameters,
                  clientId: update.client_id,
                );
              } catch (e) {}
            }
          }

          String textCommand = text.replaceAll(RegExp(r"^([!./])", caseSensitive: false), "");
          if (textCommand.isNotEmpty) {
            if (RegExp(r"^loop ([0-9]+)$", caseSensitive: false).hasMatch(textCommand)) {
              late int count = 0;
              try {
                count = int.parse(RegExp(r"([0-9]+)", caseSensitive: false).stringMatch(textCommand) ?? "0");
              } catch (e) {}
              for (var i = 0; i < count; i++) {
                try {
                  parameters["text"] = "Loop: $i";
                  await tg.request("sendMessage", parameters: parameters, clientId: update.client_id);
                } catch (e) {}
              }
              parameters["text"] = "Completed";
              return await tg.request("sendMessage", parameters: parameters, clientId: update.client_id);
            }
            if (RegExp(r"^deleteMsg", caseSensitive: false).hasMatch(textCommand)) {
              if (msg["reply_to_message"] is Map == false) {
                parameters["text"] = "Tolong reply ke satu pesan";
                return await tg.request(parameters["method"], parameters: parameters, clientId: update.client_id);
              }
              var getMessageFrom = msg["reply_to_message"]["api_message_id"];
              var getMessageId = msg["api_message_id"];

              parameters["text"] = "Procces\nFrom: $getMessageFrom\nTotal: $getMessageId";
              await tg.request(parameters["method"], parameters: parameters, clientId: update.client_id);
              List messageIds = [];
              List array = [];
              for (var i = getMessageFrom; i < getMessageId; i++) {
                try {
                  messageIds.add(tg.getMessageId(i));
                } catch (e) {}
              }
              try {
                await tg.invoke(
                  "deleteMessages",
                  parameters: {
                    "chat_id": msg["chat"]["id"],
                    "message_ids": messageIds,
                    "revoke": true,
                  },
                  clientId: update.client_id,
                );
              } catch (e) {}
              parameters["text"] = "Completed";
              return await tg.request("sendMessage", parameters: parameters, clientId: update.client_id);
            }
          }
        }
      }
    }
  } else {
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

      if (msg["text"] is String && (msg["text"] as String).isNotEmpty) {
        if (RegExp(r"^([!./])", caseSensitive: false).hasMatch(text)) {
          String textCommand = text.replaceAll(RegExp(r"^([!./])([ ]+)?", caseSensitive: false), "");
          if (textCommand.isNotEmpty) {
            bool isCommandSpace = (textCommand.split(" ").length > 1);

            if (RegExp(r"^ping$", caseSensitive: false).hasMatch(textCommand)) {
              DateTime time = DateTime.fromMillisecondsSinceEpoch((msg["date"] * 1000));
              parameters["text"] = "📣️ Pong\n${convertToAgoFromDateTime(time)}";
              return await tg.request(
                parameters["method"],
                parameters: parameters,
                clientId: update.client_id,
              );
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
}
