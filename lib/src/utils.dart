// // ignore_for_file: non_constant_identifier_names

// part of galaxeus_userbot;

// String reasonSpamming(String text) {
//   List<String> datas = ["This account changed sender channel to send spam chat to their bot", "This account serves spam in real time so we are uncomfortable", "He continues to promote in this group, I'm very uncomfortable to see him", "He sent this message over and over again, this is so annoying hope you delete this account", "He spams chats very often, please punish him", "He's so annoying, he's sending this message over and over again this is too much"];
//   return datas[Random().nextInt(datas.length)];
// }

// String reasonSpammingChat(String text) {
//   List<String> datas = [
//     "The owner of this channel uses multiple accounts to subscribe to him, he also spams every group",
//     "This account invites the audience to spam, and use their account to subscribe to this channel",
//     "The channel uploads a photo of a small child, it's not worth showing",
//     "Please this account has been doing various spamming in other groups since 2021 to invite subscribers to their account",
//     "The owner of this account is often spamming in other people's groups, please delete the owner of this telegram account too!",
//     "The owner of this account often exposes minors, he often asks small children to send photos and then he will post them to the channel account",
//   ];
//   return datas[Random().nextInt(datas.length)];
// }

// String parseLink(String text, String links) {
//   return "<a href='$links'>$text</a>";
// }

// String parseCode(String text) {
//   return "<code>$text</code>";
// }

// List<String> splitByLength(String text, int length, {bool ignoreEmpty = false}) {
//   List<String> pieces = [];
//   for (int i = 0; i < text.length; i += length) {
//     int offset = i + length;
//     String piece = text.substring(i, offset >= text.length ? text.length : offset);

//     if (ignoreEmpty) {
//       piece = piece.replaceAll(RegExp(r'\s+'), '');
//     }
//     pieces.add(piece);
//   }
//   return pieces;
// }

// Future<String> qrEncode(String text, {required String path}) async {
//   var qrcode = Encoder.encode(text, ErrorCorrectionLevel.h);
//   var matrix = qrcode.matrix!;
//   var scale = 10;
//   var width = matrix.width * scale;
//   var height = matrix.height * scale;
//   var image = img.Image(width + 200, height + 200);
//   var xs = [];
//   for (var x = 0; x < matrix.width; x++) {
//     for (var y = 0; y < matrix.height; y++) {
//       if (matrix.get(x, y) == 1) {
//         xs.add([x + 10, y + 10]);
//       }
//     }
//   }
//   for (var i = 0; i < xs.length; i++) {
//     var x = xs[i][0];
//     var y = xs[i][1];
//     img.fillRect(image, x * scale, y * scale, x * scale + scale, y * scale + scale, 0xFF000000);
//   }
//   var pngBytes = img.encodePng(image);
//   await File(path).writeAsBytes(pngBytes);
//   return path;
// }

// List prettyPrintJson(var input, {bool is_log = true}) {
//   try {
//     if (input is String) {
//     } else {
//       input = json.encode(input);
//     }
//     const JsonDecoder decoder = JsonDecoder();
//     const JsonEncoder encoder = JsonEncoder.withIndent('  ');
//     final dynamic object = decoder.convert(input);
//     final dynamic prettyString = encoder.convert(object);
//     List result = prettyString.split('\n');
//     if (is_log) {
//       for (var element in result) {
//         print(element);
//       }
//     }
//     return result;
//   } catch (e) {
//     print(e);
//     return ["error"];
//   }
// }

// Map addJson(Map data, {List<Map>? datas}) {
//   try {
//     for (var i = 0; i < datas!.length; i++) {
//       try {
//         var loopData = datas[i];
//         data.addAll(loopData);
//       } catch (e) {}
//     }
//   } catch (e) {}
//   return data;
// }

// Map saveMessage(Map updateMsg, {Map? keyboard, bool force_new_id = false}) {
//   try {
//     String formatHTML(String message, [List? entities]) {
//       entities ??= [];
//       return message;
//     }

//     String generateUuid([int bytesNumber = 10]) {
//       var text = "1234567890qwertyuiopasdfghjklzxcvbnm";
//       List<String> texts = [];
//       for (var i = 0; i < text.length; i++) {
//         texts.add(text[i]);
//       }
//       var message = "";
//       while (true) {
//         String data = texts[Random().nextInt(texts.length)];
//         message += data;
//         if (message.length == bytesNumber) {
//           return message;
//         }
//       }
//     }

//     var msg = {};
//     msg["date"] = updateMsg["date"];
//     msg["can_reply_to_message_id"] = false;
//     msg["can_disable_web_page_preview"] = false;
//     msg["can_allow_sending_without_reply"] = true;
//     msg["can_deep_link"] = false;
//     msg["can_response_callback_data"] = false;
//     msg["can_send_chat_action"] = false;
//     msg["acces_msg"] = "all";
//     if (keyboard != null) {
//       msg["keyboard"] = keyboard;
//     }
//     var regexsimbol = r"[-_=+/.,:;]";

//     if (updateMsg["text"] != null) {
//       msg["request_api"] = "sendMessage";
//       msg["type"] = "text";
//       var message = formatHTML(updateMsg["text"], updateMsg["entities"]);
//       msg["text"] = message;
//     }
//     if (updateMsg["caption"] != null) {
//       var caption = formatHTML(updateMsg["caption"], updateMsg["caption_entities"]);
//       msg["caption"] = caption;
//     }

//     if (updateMsg["photo"] != null) {
//       var type = "photo";
//       var fileId = updateMsg[type][updateMsg[type].length - 1]["file_id"];
//       msg[type] = fileId;
//       msg["request_api"] = "sendPhoto";
//       msg["type"] = "photo";
//       msg["file_id"] = fileId;
//       msg["file_unique_id"] = updateMsg[type][updateMsg[type].length - 1]["file_unique_id"].toString().replaceAll(RegExp(regexsimbol, caseSensitive: false), "");
//       msg["file_size"] = updateMsg[type][updateMsg[type].length - 1]["file_size"];
//     }
//     if (updateMsg["audio"] != null) {
//       var type = "audio";
//       var fileId = updateMsg[type]["file_id"];
//       msg[type] = fileId;
//       msg["request_api"] = "sendAudio";
//       msg["type"] = type;
//       msg["duration"] = updateMsg[type]["duration"];
//       msg["file_name"] = updateMsg[type]["file_name"];
//       msg["file_title"] = updateMsg[type]["title"];
//       msg["file_title"] = updateMsg[type]["file_title"];
//       msg["file_id"] = fileId;
//       msg["file_unique_id"] = updateMsg[type]["file_unique_id"].toString().replaceAll(RegExp(regexsimbol, caseSensitive: false), "");
//       msg["file_size"] = updateMsg[type]["file_size"];
//     }
//     if (updateMsg["document"] != null) {
//       var type = "document";
//       var fileId = updateMsg[type]["file_id"];
//       msg[type] = fileId;
//       msg["request_api"] = "sendDocument";
//       msg["type"] = type;
//       msg["duration"] = updateMsg[type]["duration"];
//       msg["file_name"] = updateMsg[type]["file_name"];
//       msg["file_id"] = fileId;
//       msg["file_unique_id"] = updateMsg[type]["file_unique_id"].toString().replaceAll(RegExp(regexsimbol, caseSensitive: false), "");
//       msg["file_size"] = updateMsg[type]["file_size"];
//     }
//     if (updateMsg["video"] != null) {
//       var type = "video";
//       var fileId = updateMsg[type]["file_id"];
//       msg[type] = fileId;
//       msg["request_api"] = "sendVideo";
//       msg["type"] = type;
//       msg["duration"] = updateMsg[type]["duration"];
//       msg["file_id"] = fileId;
//       msg["file_unique_id"] = updateMsg[type]["file_unique_id"].toString().replaceAll(RegExp(regexsimbol, caseSensitive: false), "");
//       msg["file_size"] = updateMsg[type]["file_size"];
//     }
//     if (updateMsg["voice"] != null) {
//       var type = "voice";
//       var fileId = updateMsg[type]["file_id"];
//       msg[type] = fileId;
//       msg["request_api"] = "sendVoice";
//       msg["type"] = type;
//       msg["duration"] = updateMsg[type]["duration"];
//       msg["file_id"] = fileId;
//       msg["file_unique_id"] = updateMsg[type]["file_unique_id"].toString().replaceAll(RegExp(regexsimbol, caseSensitive: false), "");
//       msg["file_size"] = updateMsg[type]["file_size"];
//     }
//     if (updateMsg["animation"] != null) {
//       var type = "animation";
//       var fileId = updateMsg[type]["file_id"];
//       msg[type] = fileId;
//       msg["request_api"] = "sendAnimation";
//       msg["type"] = type;
//       msg["duration"] = updateMsg[type]["duration"];
//       msg["file_id"] = fileId;
//       msg["file_unique_id"] = updateMsg[type]["file_unique_id"].toString().replaceAll(RegExp(regexsimbol, caseSensitive: false), "");
//       msg["file_size"] = updateMsg[type]["file_size"];
//     }
//     if (updateMsg["video_note"] != null) {
//       var type = "video_note";
//       var fileId = updateMsg[type]["file_id"];
//       msg[type] = fileId;
//       msg["request_api"] = "sendVideoNote";
//       msg["type"] = type;
//       msg["duration"] = updateMsg[type]["duration"];
//       msg["file_id"] = fileId;
//       msg["file_unique_id"] = updateMsg[type]["file_unique_id"].toString().replaceAll(RegExp(regexsimbol, caseSensitive: false), "");
//       msg["file_size"] = updateMsg[type]["file_size"];
//     }
//     if (updateMsg["sticker"] != null) {
//       var type = "sticker";
//       var fileId = updateMsg[type]["file_id"];
//       msg[type] = fileId;
//       msg["request_api"] = "sendSticker";
//       msg["type"] = type;
//       msg["emoji"] = updateMsg[type]["emoji"];
//       msg["set_name"] = updateMsg[type]["set_name"];
//       msg["is_animated"] = updateMsg[type]["is_animated"];
//       msg["file_id"] = fileId;
//       msg["file_unique_id"] = updateMsg[type]["file_unique_id"].toString().replaceAll(RegExp(regexsimbol, caseSensitive: false), "");
//       msg["file_size"] = updateMsg[type]["file_size"];
//     }
//     if (updateMsg["location"] != null) {
//       var type = "location";
//       msg["request_api"] = "sendLocation";
//       msg["type"] = type;
//       msg["latitude"] = updateMsg[type]["latitude"];
//       msg["longitude"] = updateMsg[type]["longitude"];
//     }
//     if (updateMsg["contact"] != null) {
//       var type = "contact";
//       msg["request_api"] = "sendContact";
//       msg["type"] = type;
//       msg["phone_number"] = updateMsg[type]["phone_number"];
//       msg["first_name"] = updateMsg[type]["first_name"];
//       msg["vcard"] = updateMsg[type]["vcard"];
//       msg["user_id"] = updateMsg[type]["user_id"];
//     }
//     if (updateMsg["poll"] != null) {
//       var type = "poll";
//       msg["request_api"] = "sendPoll";
//       msg["type"] = type;
//     }

//     if (msg["file_unique_id"] == null && !force_new_id) {
//       msg["file_unique_id"] = generateUuid(15);
//     }
//     if (force_new_id) {
//       msg["file_unique_id"] = generateUuid(15);
//     }
//     if (updateMsg["from"] is Map) {
//       msg["from_user_id"] = updateMsg["from"]["id"];
//     }
//     msg["from_platform"] = "telegram";
//     return {"status_bool": true, "status_code": 200, "result": msg};
//   } catch (e) {
//     return {"status_bool": false, "status_code": 500, "message": "Error", "result": {}};
//   }
// }

// String convertToAgo(int? timestamp) {
//   try {
//     Duration diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp ?? DateTime.now().millisecondsSinceEpoch));
//     if (diff.inDays >= 1) {
//       return '${diff.inDays} day(s) ago';
//     } else if (diff.inHours >= 1) {
//       return '${diff.inHours} hour(s) ago';
//     } else if (diff.inMinutes >= 1) {
//       return '${diff.inMinutes} minute(s) ago';
//     } else if (diff.inSeconds >= 1) {
//       return '${diff.inSeconds} second(s) ago';
//     } else {
//       return 'just now';
//     }
//   } catch (e) {
//     return 'just now';
//   }
// }

// List<String> emojis = ['😄', '😃', '😀', '😊', '☺', '😉', '😍', '😘', '😚', '😗', '😙', '😜', '😝', '😛', '😳', '😁', '😔', '😌', '😒', '😞', '😣', '😢', '😂', '😭', '😪', '😥', '😰', '😅', '😓', '😩', '😫', '😨', '😱', '😠', '😡', '😤', '😖', '😆', '😋', '😷', '😎', '😴', '😵', '😲', '😟', '😦', '😧', '😈', '👿', '😮', '😬', '😐', '😕', '😯', '😶', '😇', '😏', '😑', '👲', '👳', '👮', '👷', '💂', '👶', '👦', '👧', '👨', '👩', '👴', '👵', '👱', '👼', '👸', '😺', '😸', '😻', '😽', '😼', '🙀', '😿', '😹', '😾', '👹', '👺', '🙈', '🙉', '🙊', '💀', '👽', '💩', '🔥', '✨', '🌟', '💫', '💥', '💢', '💦', '💧', '💤', '💨', '👂', '👀', '👃', '👅', '👄', '👍', '👎', '👌', '👊', '✊', '✌', '👋', '✋', '👐', '👆', '👇', '👉', '👈', '🙌', '🙏', '☝', '👏', '💪', '🚶', '🏃', '💃', '👫', '👪', '👬', '👭', '💏', '💑', '👯', '🙆', '🙅', '💁', '🙋', '💆', '💇', '💅', '👰', '🙎', '🙍', '🙇', '🎩', '👑', '👒', '👟', '👞', '👡', '👠', '👢', '👕', '👔', '👚', '👗', '🎽', '👖', '👘', '👙', '💼', '👜', '👝', '👛', '👓', '🎀', '🌂', '💄', '💛', '💙', '💜', '💚', '❤', '💔', '💗', '💓', '💕', '💖', '💞', '💘', '💌', '💋', '💍', '💎', '👤', '👥', '💬', '👣', '💭', '🐶', '🐺', '🐱', '🐭', '🐹', '🐰', '🐸', '🐯', '🐨', '🐻', '🐷', '🐽', '🐮', '🐗', '🐵', '🐒', '🐴', '🐑', '🐘', '🐼', '🐧', '🐦', '🐤', '🐥', '🐣', '🐔', '🐍', '🐢', '🐛', '🐝', '🐜', '🐞', '🐌', '🐙', '🐚', '🐠', '🐟', '🐬', '🐳', '🐋', '🐄', '🐏', '🐀', '🐃', '🐅', '🐇', '🐉', '🐎', '🐐', '🐓', '🐕', '🐖', '🐁', '🐂', '🐲', '🐡', '🐊', '🐫', '🐪', '🐆', '🐈', '🐩', '🐾', '💐', '🌸', '🌷', '🍀', '🌹', '🌻', '🌺', '🍁', '🍃', '🍂', '🌿', '🌾', '🍄', '🌵', '🌴', '🌲', '🌳', '🌰', '🌱', '🌼', '🌐', '🌞', '🌝', '🌚', '🌑', '🌒', '🌓', '🌔', '🌕', '🌖', '🌗', '🌘', '🌜', '🌛', '🌙', '🌍', '🌎', '🌏', '🌋', '🌌', '🌠', '⭐', '☀', '⛅', '☁', '⚡', '☔', '❄', '⛄', '🌀', '🌁', '🌈', '🌊', '🎍', '💝', '🎎', '🎒', '🎓', '🎏', '🎆', '🎇', '🎐', '🎑', '🎃', '👻', '🎅', '🎄', '🎁', '🎋', '🎉', '🎊', '🎈', '🎌', '🔮', '🎥', '📷', '📹', '📼', '💿', '📀', '💽', '💾', '💻', '📱', '☎', '📞', '📟', '📠', '📡', '📺', '📻', '🔊', '🔉', '🔈', '🔇', '🔔', '🔕', '📢', '📣', '⏳', '⌛', '⏰', '⌚', '🔓', '🔒', '🔏', '🔐', '🔑', '🔎', '💡', '🔦', '🔆', '🔅', '🔌', '🔋', '🔍', '🛁', '🛀', '🚿', '🚽', '🔧', '🔩', '🔨', '🚪', '🚬', '💣', '🔫', '🔪', '💊', '💉', '💰', '💴', '💵', '💷', '💶', '💳', '💸', '📲', '📧', '📥', '📤', '✉', '📩', '📨', '📯', '📫', '📪', '📬', '📭', '📮', '📦', '📝', '📄', '📃', '📑', '📊', '📈', '📉', '📜', '📋', '📅', '📆', '📇', '📁', '📂', '✂', '📌', '📎', '✒', '✏', '📏', '📐', '📕', '📗', '📘', '📙', '📓', '📔', '📒', '📚', '📖', '🔖', '📛', '🔬', '🔭', '📰', '🎨', '🎬', '🎤', '🎧', '🎼', '🎵', '🎶', '🎹', '🎻', '🎺', '🎷', '🎸', '👾', '🎮', '🃏', '🎴', '🀄', '🎲', '🎯', '🏈', '🏀', '⚽', '⚾', '🎾', '🎱', '🏉', '🎳', '⛳', '🚵', '🚴', '🏁', '🏇', '🏆', '🎿', '🏂', '🏊', '🏄', '🎣', '☕', '🍵', '🍶', '🍼', '🍺', '🍻', '🍸', '🍹', '🍷', '🍴', '🍕', '🍔', '🍟', '🍗', '🍖', '🍝', '🍛', '🍤', '🍱', '🍣', '🍥', '🍙', '🍘', '🍚', '🍜', '🍲', '🍢', '🍡', '🍳', '🍞', '🍩', '🍮', '🍦', '🍨', '🍧', '🎂', '🍰', '🍪', '🍫', '🍬', '🍭', '🍯', '🍎', '🍏', '🍊', '🍋', '🍒', '🍇', '🍉', '🍓', '🍑', '🍈', '🍌', '🍐', '🍍', '🍠', '🍆', '🍅', '🌽', '🏠', '🏡', '🏫', '🏢', '🏣', '🏥', '🏦', '🏪', '🏩', '🏨', '💒', '⛪', '🏬', '🏤', '🌇', '🌆', '🏯', '🏰', '⛺', '🏭', '🗼', '🗾', '🗻', '🌄', '🌅', '🌃', '🗽', '🌉', '🎠', '🎡', '⛲', '🎢', '🚢', '⛵', '🚤', '🚣', '⚓', '🚀', '✈', '💺', '🚁', '🚂', '🚊', '🚉', '🚞', '🚆', '🚄', '🚅', '🚈', '🚇', '🚝', '🚋', '🚃', '🚎', '🚌', '🚍', '🚙', '🚘', '🚗', '🚕', '🚖', '🚛', '🚚', '🚨', '🚓', '🚔', '🚒', '🚑', '🚐', '🚲', '🚡', '🚟', '🚠', '🚜', '💈', '🚏', '🎫', '🚦', '🚥', '⚠', '🚧', '🔰', '⛽', '🏮', '🎰', '♨', '🗿', '🎪', '🎭', '📍', '🚩', '⬆', '⬇', '⬅', '➡', '🔠', '🔡', '🔤', '↗', '↖', '↘', '↙', '↔', '↕', '🔄', '◀', '▶', '🔼', '🔽', '↩', '↪', 'ℹ', '⏪', '⏩', '⏫', '⏬', '⤵', '⤴', '🆗', '🔀', '🔁', '🔂', '🆕', '🆙', '🆒', '🆓', '🆖', '📶', '🎦', '🈁', '🈯', '🈳', '🈵', '🈴', '🈲', '🉐', '🈹', '🈺', '🈶', '🈚', '🚻', '🚹', '🚺', '🚼', '🚾', '🚰', '🚮', '🅿', '♿', '🚭', '🈷', '🈸', '🈂', 'Ⓜ', '🛂', '🛄', '🛅', '🛃', '🉑', '㊙', '㊗', '🆑', '🆘', '🆔', '🚫', '🔞', '📵', '🚯', '🚱', '🚳', '🚷', '🚸', '⛔', '✳', '❇', '❎', '✅', '✴', '💟', '🆚', '📳', '📴', '🅰', '🅱', '🆎', '🅾', '💠', '➿', '♻', '♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓', '⛎', '🔯', '🏧', '💹', '💲', '💱', '©', '®', '™', '〽', '〰', '🔝', '🔚', '🔙', '🔛', '🔜', '❌', '⭕', '❗', '❓', '❕', '❔', '🔃', '🕛', '🕧', '🕐', '🕜', '🕑', '🕝', '🕒', '🕞', '🕓', '🕟', '🕔', '🕠', '🕕', '🕖', '🕗', '🕘', '🕙', '🕚', '🕡', '🕢', '🕣', '🕤', '🕥', '🕦', '✖', '➕', '➖', '➗', '♠', '♥', '♣', '♦', '💮', '💯', '✔', '☑', '🔘', '🔗', '➰', '🔱', '🔲', '🔳', '◼', '◻', '◾', '◽', '▪', '▫', '🔺', '⬜', '⬛', '⚫', '⚪', '🔴', '🔵', '🔻', '🔶', '🔷', '🔸', '🔹'];

// sendMessageDatabase(Tdlib tg, {required Map update_message, required Map database, bool is_raw = false, required int? clientId, bool isVoid = false, String? extra, Map? parameterPatch}) async {
//   parameterPatch ??= {};
//   clientId ??= tg.client_id;

//   String convertToAgo(int? timestamp) {
//     try {
//       Duration diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp ?? DateTime.now().millisecondsSinceEpoch));
//       if (diff.inDays >= 1) {
//         return '${diff.inDays} day(s) ago';
//       } else if (diff.inHours >= 1) {
//         return '${diff.inHours} hour(s) ago';
//       } else if (diff.inMinutes >= 1) {
//         return '${diff.inMinutes} minute(s) ago';
//       } else if (diff.inSeconds >= 1) {
//         return '${diff.inSeconds} second(s) ago';
//       } else {
//         return 'just now';
//       }
//     } catch (e) {
//       return 'just now';
//     }
//   }

//   String variableMessage(String message, Map msg) {
//     try {
//       if (RegExp(r"\[new\]", caseSensitive: false).hasMatch(message)) {
//         List texts = message.split(RegExp(r"\[new\]", caseSensitive: false));
//         texts.shuffle();
//         var messages = getRandomElement(texts);
//         late int count_retry = 0;
//         while ((messages == null) || (messages is String && messages.isEmpty)) {
//           count_retry++;
//           messages = getRandomElement(texts);
//           if (count_retry > 1000) {
//             messages = message;
//           }
//         }
//         message = messages;
//       }
//     } catch (e) {}
//     var userId = "";
//     var chatId = "";
//     var chatTitle = "";
//     var fromType = "";
//     var chatType = "";
//     var fromUsername = "";
//     var chatUsername = "";
//     var firstName = "";
//     var lastName = "";
//     var typeContent = "";
//     var fromMention = "";
//     var fromMentionEmoji = "";
//     var randomEmoji = "";
//     var chatMention = "";
//     var time_ago = "just now";
//     var mentionUsers = "";
//     var mentionUser = "";

//     var text = "";
//     var random_number = "";
//     var random_word = "";
//     var random_any = "";

//     var date = "";
//     try {
//       date = "${msg["date"]}";
//     } catch (e) {}

//     if (msg["text"] is String) {
//       text = msg["text"];
//     }
//     List numbers = [];
//     List words = ["hleo", "word", "aps", "a", "b", "c", "asa", "Sasa", "Sas", "Rasko", "aowk", "woka", "awok", "aowk", "awk", "as", "kao", "aso", "as", "asa", "Aa", "asa", "v", "ahh", "mpsh", "shh", "uh", "ah", "eh", "nghh", "ahh", "enak", "slebew"];
//     try {
//       randomEmoji = emojis[Random().nextInt(emojis.length)];
//     } catch (e) {}
//     try {
//       random_number = emojis[Random().nextInt(emojis.length)];
//     } catch (e) {}
//     try {
//       random_word = words[Random().nextInt(words.length)];
//     } catch (e) {}
//     try {
//       List randomType = [
//         "emoji",
//         "word",
//       ];
//       var typeRandom = randomType[Random().nextInt(randomType.length)];
//       if (typeRandom == "emoji") {
//         random_any = emojis[Random().nextInt(emojis.length)];
//       } else {
//         random_any = words[Random().nextInt(words.length)];
//       }
//     } catch (e) {}
//     if (msg["from"] is Map) {
//       var from = msg["from"];
//       if (msg["from"]["id"] is int) {
//         userId = msg["from"]["id"].toString();
//       }
//       if (from["first_name"] is String) {
//         firstName = from["first_name"];
//       }
//       if (from["last_name"] is String) {
//         lastName = from["last_name"];
//       }
//       if (from["type"] is String) {
//         fromType = from["type"];
//       }
//       if (from["username"] is String && (from["username"] as String).isNotEmpty) {
//         fromUsername = "@${from["username"].toString()}";
//         fromMention = fromUsername;
//       }
//       try {
//         fromMentionEmoji = parseLink(emojis[Random().nextInt(emojis.length)], "tg://user?id=${userId.toString()}");
//       } catch (e) {}
//       if (fromUsername.isEmpty) {
//         try {
//           fromMention = parseLink("$firstName $lastName", "tg://user?id=${userId.toString()}");
//         } catch (e) {}
//       }
//     }
//     if (msg["chat"] is Map) {
//       var chat = msg["chat"];
//       if (msg["chat"]["id"] is int) {
//         chatId = msg["chat"]["id"].toString();
//       }
//       if (msg["chat"]["title"] is String) {
//         chatTitle = msg["chat"]["title"];
//       }
//       if (chat["first_name"] is String) {
//         chatTitle = chat["first_name"];
//       }
//       if (chat["last_name"] is String) {
//         chatTitle += " ${chat["last_name"]}";
//       }
//       if (chat["username"] is String && (chat["username"] as String).isNotEmpty) {
//         chatUsername = "@${chat["username"].toString()}";
//         chatMention = chatUsername;
//       }

//       if (msg["chat"]["type"] is String) {
//         chatType = msg["chat"]["type"];
//       }
//       if (chatUsername.isEmpty) {
//         try {
//           chatMention = parseLink(chatTitle, "tg://user?id=${chatId.toString()}");
//         } catch (e) {}
//       }
//     }
//     if (database["date"] is int) {
//       try {
//         time_ago = convertToAgo(database["date"] * 1000);
//       } catch (e) {}
//     }
//     if (msg["type_content"] is String) {
//       typeContent = msg["type_content"];
//     }
//     try {
//       if (database["user_ids"] is List) {
//         int countMention = 0;
//         try {
//           countMention = int.parse(RegExp(r"{mention_user_([0-9]+)}", caseSensitive: false).stringMatch(message) ?? "0");
//         } catch (e) {}
//         if (RegExp(r"({mention_users}|{mention_user_([0-9]+)})", caseSensitive: false).hasMatch(message)) {
//           for (var i = 0; i < database["user_ids"].length; i++) {
//             var loop_data = database["user_ids"][i];
//             if (RegExp(r"({mention_user_([0-9]+)})", caseSensitive: false).hasMatch(message)) {
//               if (i <= countMention) {
//                 try {
//                   mentionUser += " ${parseLink(emojis[Random().nextInt(emojis.length)], "tg://user?id=${loop_data.toString()}")}";
//                 } catch (e) {}
//               }
//             } else {
//               if (i <= 5) {
//                 try {
//                   mentionUsers += " ${parseLink(emojis[Random().nextInt(emojis.length)], "tg://user?id=${loop_data.toString()}")}";
//                 } catch (e) {}
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {}
//     List<Map<String, String>> replaceData = [
//       {
//         "origin": "{from_id}",
//         "replace": userId,
//       },
//       {
//         "origin": "{first_name}",
//         "replace": firstName,
//       },
//       {
//         "origin": "{first_name}",
//         "replace": lastName,
//       },
//       {
//         "origin": "{from_type}",
//         "replace": fromType,
//       },
//       {
//         "origin": "{from_mention}",
//         "replace": fromMention,
//       },
//       {
//         "origin": "{from_mention_emoji}",
//         "replace": fromMentionEmoji,
//       },
//       {
//         "origin": "{random_emoji}",
//         "replace": randomEmoji,
//       },
//       {
//         "origin": "{random_number}",
//         "replace": random_number,
//       },
//       {
//         "origin": "{random_any}",
//         "replace": random_any,
//       },
//       {
//         "origin": "{random_word}",
//         "replace": random_word,
//       },
//       {
//         "origin": "{from_username}",
//         "replace": fromUsername,
//       },
//       {
//         "origin": "{chat_id}",
//         "replace": chatId,
//       },
//       {
//         "origin": "{chat_title}",
//         "replace": chatTitle,
//       },
//       {
//         "origin": "{chat_username}",
//         "replace": chatUsername,
//       },
//       {
//         "origin": "{chat_mention}",
//         "replace": chatMention,
//       },
//       {
//         "origin": "{chat_type}",
//         "replace": chatType,
//       },
//       {
//         "origin": "{time_ago}",
//         "replace": time_ago,
//       },
//       {
//         "origin": "{type_content}",
//         "replace": typeContent,
//       },
//       {
//         "origin": "{mention_users}",
//         "replace": mentionUsers,
//       },
//       {
//         "origin": "{date}",
//         "replace": date,
//       },
//       {
//         "origin": "{text}",
//         "replace": text,
//       },
//     ];
//     for (var i = 0; i < replaceData.length; i++) {
//       var loopData = replaceData[i];
//       try {
//         message = message.replaceAll(RegExp(loopData["origin"] ?? "", caseSensitive: false), loopData["replace"] ?? "");
//       } catch (e) {}
//     }
//     return message;
//   }

//   if (update_message["message"] != null) {
//     var msg = update_message["message"];
//     var userId = msg["from"]["id"];
//     var chatId = msg["chat"]["id"];
//     var msgId = msg["message_id"];

//     String? message;
//     if (database["text"] != null) {
//       if (is_raw) {
//         message = database["text"];
//       } else {
//         message = variableMessage(database["text"], msg);
//       }
//     }
//     if (database["caption"] != null) {
//       if (is_raw) {
//         message = database["caption"];
//       } else {
//         message = variableMessage(database["caption"], msg);
//       }
//     }

//     Map option = {"chat_id": chatId, "parse_mode": "html"};
//     if (RegExp(r"^(photo|voice|video|animation|audio|document|sticker|text)$", caseSensitive: false).hasMatch(database["type"])) {
//       if (database["keyboard"] is Map) {
//         option["reply_markup"] = database["keyboard"];
//       }
//       option["parse_mode"] = "html";
//       option["allow_sending_without_reply"] = true;
//       if (database["can_reply_to_message_id"] == true) {
//         option["reply_to_message_id"] = msgId;
//       }
//       if (RegExp(r"^text$", caseSensitive: false).hasMatch(database["type"])) {
//         if (message != null) {
//           option["text"] = message;
//         }
//       } else {
//         option[database["type"]] = database["file_id"];
//         if (message != null) {
//           option["caption"] = message;
//         }
//       }
//       database.forEach((key, value) {
//         if (value is bool) {
//           try {
//             option[key.toString()] = value;
//           } catch (e) {}
//         }
//       });
//       try {
//         option.addAll(parameterPatch);
//       } catch (e) {}

//       return await tg.request(
//         database["request_api"],
//         parameters: option,
//         clientId: clientId,
//         isVoid: isVoid,
//         extra: extra,
//       );
//     }
//   }
// }

// Map json_full_media = {
//   "id": "🆔️ Id",
//   "name": "🔤️ Name",
//   "first_name": "🔤️ First Name",
//   "last_name": "🔤️ Last Name",
//   "username": "🆔️ Username",
//   "apps": "🏠️ Apps",
//   "sign_in": "👤️ Sign In",
//   "sign_up": "📝️ Sign Up",
//   "is_bot": "🤖 Bot",
//   "language_code": "🏳️ Origin",
//   "profile_photo": "📸 Photo Profile",
//   "bio": "📄️ Bio",
//   "forward_date": "🎤 Forward",
//   "sender_chat": "🎤 Channel",
//   "text": "📄️ Text",
//   "type": "📄️ Semua",
//   "all": "📄️ Semua",
//   "caption": "📄️ Caption",
//   "text_length": "📄️ Char Text",
//   "all_length": "📄️ Char Semua",
//   "caption_length": "📄️ Char Caption",
//   "animation": "🎥 Gif",
//   "audio": "🎧 Audio",
//   "document": "💾 Berkas",
//   "photo": "📸 Photo",
//   "sticker": "🃏 Sticker",
//   "video": "🎞 Video",
//   "video_note": "👁‍🗨 Video Note",
//   "media_group_id": "🖼 Album",
//   "voice": "🎤 Suara",
//   "reply_to_message": "📄️ Reply",
//   "contact": "🏷 Kontak",
//   "dice": "🎲 Permainan Animasi",
//   "game": "🎮 Permainan",
//   "poll": "📊 Poll",
//   "location": "📍 Lokasi",
//   "invoice": "💶 Pembayaran",
//   "sticker_is_animated": "🎭 Sticker Animasi",
//   "emoji_animate": "😀 Emoji Animasi",
//   "word_uppercase": "🆎 Kapital",
//   "bold": "🆎 Tebal",
//   "italic": "🆎 Miring",
//   "underline": "🆎 Garis Bawah",
//   "strikethrough": "🆎 Garis Text",
//   "new_chat_members": "🔖 Member Baru",
//   "left_chat_member": "🗑 Member Keluar",
//   "new_chat_title": "🆎 Title Baru",
//   "new_chat_photo": "🔖 Photo Baru ",
//   "delete_chat_photo": "🗑 Photo Dihapus",
//   "group_chat_created": "🔖 Group Dibuat",
//   "supergroup_chat_created": "🔖 Supergroup dibuat",
//   "channel_chat_created": "🔖 Channel dibuat",
//   "message_auto_delete_timer_changed": "✉️ Pesan Timer auto Hapus",
//   "successful_payment": "💶 Pembayaran Berhasil",
//   "voice_chat_scheduled": "🎤 Chat Suara Jadwal",
//   "voice_chat_started": "🎤 Chat Suara Dimulai",
//   "voice_chat_ended": "🎤 Chat Suara Berkahir",
//   "voice_chat_participants_invited": "🎤 Chat Suara Invite",
//   "spoiler": "🆎 Spoiler",
//   "pre": "🆎 Code",
//   "word_arab": "☪️ Bahasa Arab",
//   "word_spoiler": "🗯 Spoiler",
//   "bot_inline": "🤖 Bot Inline",
//   "mention": "🔖 Mention",
//   "hashtag": "#️⃣ Hastag",
//   "cashtag": "💰 Uang",
//   "bot_command": "🤖 Bot Command",
//   "email": "✉️ Email",
//   "phone_number": "☎️ Phone Number",
//   "url": "🔗 Link",
//   "link": "🔗 Link",
//   "free": "☑️ Tidak aktif",
//   "warn": "❕ WARN",
//   "kick": "❗️ KICK",
//   "mute": "🔇 MUTE",
//   "ban": "🚷 Ban",
//   "delete": "🗑 Delete",
//   "undefined": "❕ Undefined",
//   "true": "Ya",
//   "false": "Tidak",
//   "language_code_af": "🇦🇫 Afghanistan",
//   "dial_code_af": "+93",
//   "country_af": {"name": "Afghanistan", "flag": "🇦🇫", "code": "AF", "dial_code": "+93"},
//   "language_code_ax": "🇦🇽 Åland Islands",
//   "dial_code_ax": "+358",
//   "country_ax": {"name": "Åland Islands", "flag": "🇦🇽", "code": "AX", "dial_code": "+358"},
//   "language_code_al": "🇦🇱 Albania",
//   "dial_code_al": "+355",
//   "country_al": {"name": "Albania", "flag": "🇦🇱", "code": "AL", "dial_code": "+355"},
//   "language_code_dz": "🇩🇿 Algeria",
//   "dial_code_dz": "+213",
//   "country_dz": {"name": "Algeria", "flag": "🇩🇿", "code": "DZ", "dial_code": "+213"},
//   "language_code_as": "🇦🇸 American Samoa",
//   "dial_code_as": "+1684",
//   "country_as": {"name": "American Samoa", "flag": "🇦🇸", "code": "AS", "dial_code": "+1684"},
//   "language_code_ad": "🇦🇩 Andorra",
//   "dial_code_ad": "+376",
//   "country_ad": {"name": "Andorra", "flag": "🇦🇩", "code": "AD", "dial_code": "+376"},
//   "language_code_ao": "🇦🇴 Angola",
//   "dial_code_ao": "+244",
//   "country_ao": {"name": "Angola", "flag": "🇦🇴", "code": "AO", "dial_code": "+244"},
//   "language_code_ai": "🇦🇮 Anguilla",
//   "dial_code_ai": "+1264",
//   "country_ai": {"name": "Anguilla", "flag": "🇦🇮", "code": "AI", "dial_code": "+1264"},
//   "language_code_aq": "🇦🇶 Antarctica",
//   "dial_code_aq": "+672",
//   "country_aq": {"name": "Antarctica", "flag": "🇦🇶", "code": "AQ", "dial_code": "+672"},
//   "language_code_ag": "🇦🇬 Antigua and Barbuda",
//   "dial_code_ag": "+1268",
//   "country_ag": {"name": "Antigua and Barbuda", "flag": "🇦🇬", "code": "AG", "dial_code": "+1268"},
//   "language_code_ar": "🇦🇷 Argentina",
//   "dial_code_ar": "+54",
//   "country_ar": {"name": "Argentina", "flag": "🇦🇷", "code": "AR", "dial_code": "+54"},
//   "language_code_am": "🇦🇲 Armenia",
//   "dial_code_am": "+374",
//   "country_am": {"name": "Armenia", "flag": "🇦🇲", "code": "AM", "dial_code": "+374"},
//   "language_code_aw": "🇦🇼 Aruba",
//   "dial_code_aw": "+297",
//   "country_aw": {"name": "Aruba", "flag": "🇦🇼", "code": "AW", "dial_code": "+297"},
//   "language_code_au": "🇦🇺 Australia",
//   "dial_code_au": "+61",
//   "country_au": {"name": "Australia", "flag": "🇦🇺", "code": "AU", "dial_code": "+61"},
//   "language_code_at": "🇦🇹 Austria",
//   "dial_code_at": "+43",
//   "country_at": {"name": "Austria", "flag": "🇦🇹", "code": "AT", "dial_code": "+43"},
//   "language_code_az": "🇦🇿 Azerbaijan",
//   "dial_code_az": "+994",
//   "country_az": {"name": "Azerbaijan", "flag": "🇦🇿", "code": "AZ", "dial_code": "+994"},
//   "language_code_bs": "🇧🇸 Bahamas",
//   "dial_code_bs": "+1242",
//   "country_bs": {"name": "Bahamas", "flag": "🇧🇸", "code": "BS", "dial_code": "+1242"},
//   "language_code_bh": "🇧🇭 Bahrain",
//   "dial_code_bh": "+973",
//   "country_bh": {"name": "Bahrain", "flag": "🇧🇭", "code": "BH", "dial_code": "+973"},
//   "language_code_bd": "🇧🇩 Bangladesh",
//   "dial_code_bd": "+880",
//   "country_bd": {"name": "Bangladesh", "flag": "🇧🇩", "code": "BD", "dial_code": "+880"},
//   "language_code_bb": "🇧🇧 Barbados",
//   "dial_code_bb": "+1246",
//   "country_bb": {"name": "Barbados", "flag": "🇧🇧", "code": "BB", "dial_code": "+1246"},
//   "language_code_by": "🇧🇾 Belarus",
//   "dial_code_by": "+375",
//   "country_by": {"name": "Belarus", "flag": "🇧🇾", "code": "BY", "dial_code": "+375"},
//   "language_code_be": "🇧🇪 Belgium",
//   "dial_code_be": "+32",
//   "country_be": {"name": "Belgium", "flag": "🇧🇪", "code": "BE", "dial_code": "+32"},
//   "language_code_bz": "🇧🇿 Belize",
//   "dial_code_bz": "+501",
//   "country_bz": {"name": "Belize", "flag": "🇧🇿", "code": "BZ", "dial_code": "+501"},
//   "language_code_bj": "🇧🇯 Benin",
//   "dial_code_bj": "+229",
//   "country_bj": {"name": "Benin", "flag": "🇧🇯", "code": "BJ", "dial_code": "+229"},
//   "language_code_bm": "🇧🇲 Bermuda",
//   "dial_code_bm": "+1441",
//   "country_bm": {"name": "Bermuda", "flag": "🇧🇲", "code": "BM", "dial_code": "+1441"},
//   "language_code_bt": "🇧🇹 Bhutan",
//   "dial_code_bt": "+975",
//   "country_bt": {"name": "Bhutan", "flag": "🇧🇹", "code": "BT", "dial_code": "+975"},
//   "language_code_bo": "🇧🇴 Bolivia, Plurinational State of bolivia",
//   "dial_code_bo": "+591",
//   "country_bo": {"name": "Bolivia, Plurinational State of bolivia", "flag": "🇧🇴", "code": "BO", "dial_code": "+591"},
//   "language_code_ba": "🇧🇦 Bosnia and Herzegovina",
//   "dial_code_ba": "+387",
//   "country_ba": {"name": "Bosnia and Herzegovina", "flag": "🇧🇦", "code": "BA", "dial_code": "+387"},
//   "language_code_bw": "🇧🇼 Botswana",
//   "dial_code_bw": "+267",
//   "country_bw": {"name": "Botswana", "flag": "🇧🇼", "code": "BW", "dial_code": "+267"},
//   "language_code_bv": "🇧🇻 Bouvet Island",
//   "dial_code_bv": "+47",
//   "country_bv": {"name": "Bouvet Island", "flag": "🇧🇻", "code": "BV", "dial_code": "+47"},
//   "language_code_br": "🇧🇷 Brazil",
//   "dial_code_br": "+55",
//   "country_br": {"name": "Brazil", "flag": "🇧🇷", "code": "BR", "dial_code": "+55"},
//   "language_code_io": "🇮🇴 British Indian Ocean Territory",
//   "dial_code_io": "+246",
//   "country_io": {"name": "British Indian Ocean Territory", "flag": "🇮🇴", "code": "IO", "dial_code": "+246"},
//   "language_code_bn": "🇧🇳 Brunei Darussalam",
//   "dial_code_bn": "+673",
//   "country_bn": {"name": "Brunei Darussalam", "flag": "🇧🇳", "code": "BN", "dial_code": "+673"},
//   "language_code_bg": "🇧🇬 Bulgaria",
//   "dial_code_bg": "+359",
//   "country_bg": {"name": "Bulgaria", "flag": "🇧🇬", "code": "BG", "dial_code": "+359"},
//   "language_code_bf": "🇧🇫 Burkina Faso",
//   "dial_code_bf": "+226",
//   "country_bf": {"name": "Burkina Faso", "flag": "🇧🇫", "code": "BF", "dial_code": "+226"},
//   "language_code_bi": "🇧🇮 Burundi",
//   "dial_code_bi": "+257",
//   "country_bi": {"name": "Burundi", "flag": "🇧🇮", "code": "BI", "dial_code": "+257"},
//   "language_code_kh": "🇰🇭 Cambodia",
//   "dial_code_kh": "+855",
//   "country_kh": {"name": "Cambodia", "flag": "🇰🇭", "code": "KH", "dial_code": "+855"},
//   "language_code_cm": "🇨🇲 Cameroon",
//   "dial_code_cm": "+237",
//   "country_cm": {"name": "Cameroon", "flag": "🇨🇲", "code": "CM", "dial_code": "+237"},
//   "language_code_ca": "🇨🇦 Canada",
//   "dial_code_ca": "+1",
//   "country_ca": {"name": "Canada", "flag": "🇨🇦", "code": "CA", "dial_code": "+1"},
//   "language_code_cv": "🇨🇻 Cape Verde",
//   "dial_code_cv": "+238",
//   "country_cv": {"name": "Cape Verde", "flag": "🇨🇻", "code": "CV", "dial_code": "+238"},
//   "language_code_ky": "🇰🇾 Cayman Islands",
//   "dial_code_ky": "+345",
//   "country_ky": {"name": "Cayman Islands", "flag": "🇰🇾", "code": "KY", "dial_code": "+345"},
//   "language_code_cf": "🇨🇫 Central African Republic",
//   "dial_code_cf": "+236",
//   "country_cf": {"name": "Central African Republic", "flag": "🇨🇫", "code": "CF", "dial_code": "+236"},
//   "language_code_td": "🇹🇩 Chad",
//   "dial_code_td": "+235",
//   "country_td": {"name": "Chad", "flag": "🇹🇩", "code": "TD", "dial_code": "+235"},
//   "language_code_cl": "🇨🇱 Chile",
//   "dial_code_cl": "+56",
//   "country_cl": {"name": "Chile", "flag": "🇨🇱", "code": "CL", "dial_code": "+56"},
//   "language_code_cn": "🇨🇳 China",
//   "dial_code_cn": "+86",
//   "country_cn": {"name": "China", "flag": "🇨🇳", "code": "CN", "dial_code": "+86"},
//   "language_code_cx": "🇨🇽 Christmas Island",
//   "dial_code_cx": "+61",
//   "country_cx": {"name": "Christmas Island", "flag": "🇨🇽", "code": "CX", "dial_code": "+61"},
//   "language_code_cc": "🇨🇨 Cocos (Keeling) Islands",
//   "dial_code_cc": "+61",
//   "country_cc": {"name": "Cocos (Keeling) Islands", "flag": "🇨🇨", "code": "CC", "dial_code": "+61"},
//   "language_code_co": "🇨🇴 Colombia",
//   "dial_code_co": "+57",
//   "country_co": {"name": "Colombia", "flag": "🇨🇴", "code": "CO", "dial_code": "+57"},
//   "language_code_km": "🇰🇲 Comoros",
//   "dial_code_km": "+269",
//   "country_km": {"name": "Comoros", "flag": "🇰🇲", "code": "KM", "dial_code": "+269"},
//   "language_code_cg": "🇨🇬 Congo",
//   "dial_code_cg": "+242",
//   "country_cg": {"name": "Congo", "flag": "🇨🇬", "code": "CG", "dial_code": "+242"},
//   "language_code_cd": "🇨🇩 Congo, The Democratic Republic of the Congo",
//   "dial_code_cd": "+243",
//   "country_cd": {"name": "Congo, The Democratic Republic of the Congo", "flag": "🇨🇩", "code": "CD", "dial_code": "+243"},
//   "language_code_ck": "🇨🇰 Cook Islands",
//   "dial_code_ck": "+682",
//   "country_ck": {"name": "Cook Islands", "flag": "🇨🇰", "code": "CK", "dial_code": "+682"},
//   "language_code_cr": "🇨🇷 Costa Rica",
//   "dial_code_cr": "+506",
//   "country_cr": {"name": "Costa Rica", "flag": "🇨🇷", "code": "CR", "dial_code": "+506"},
//   "language_code_ci": "🇨🇮 Cote d'Ivoire",
//   "dial_code_ci": "+225",
//   "country_ci": {"name": "Cote d'Ivoire", "flag": "🇨🇮", "code": "CI", "dial_code": "+225"},
//   "language_code_hr": "🇭🇷 Croatia",
//   "dial_code_hr": "+385",
//   "country_hr": {"name": "Croatia", "flag": "🇭🇷", "code": "HR", "dial_code": "+385"},
//   "language_code_cu": "🇨🇺 Cuba",
//   "dial_code_cu": "+53",
//   "country_cu": {"name": "Cuba", "flag": "🇨🇺", "code": "CU", "dial_code": "+53"},
//   "language_code_cy": "🇨🇾 Cyprus",
//   "dial_code_cy": "+357",
//   "country_cy": {"name": "Cyprus", "flag": "🇨🇾", "code": "CY", "dial_code": "+357"},
//   "language_code_cz": "🇨🇿 Czech Republic",
//   "dial_code_cz": "+420",
//   "country_cz": {"name": "Czech Republic", "flag": "🇨🇿", "code": "CZ", "dial_code": "+420"},
//   "language_code_dk": "🇩🇰 Denmark",
//   "dial_code_dk": "+45",
//   "country_dk": {"name": "Denmark", "flag": "🇩🇰", "code": "DK", "dial_code": "+45"},
//   "language_code_dj": "🇩🇯 Djibouti",
//   "dial_code_dj": "+253",
//   "country_dj": {"name": "Djibouti", "flag": "🇩🇯", "code": "DJ", "dial_code": "+253"},
//   "language_code_dm": "🇩🇲 Dominica",
//   "dial_code_dm": "+1767",
//   "country_dm": {"name": "Dominica", "flag": "🇩🇲", "code": "DM", "dial_code": "+1767"},
//   "language_code_do": "🇩🇴 Dominican Republic",
//   "dial_code_do": "+1849",
//   "country_do": {"name": "Dominican Republic", "flag": "🇩🇴", "code": "DO", "dial_code": "+1849"},
//   "language_code_ec": "🇪🇨 Ecuador",
//   "dial_code_ec": "+593",
//   "country_ec": {"name": "Ecuador", "flag": "🇪🇨", "code": "EC", "dial_code": "+593"},
//   "language_code_eg": "🇪🇬 Egypt",
//   "dial_code_eg": "+20",
//   "country_eg": {"name": "Egypt", "flag": "🇪🇬", "code": "EG", "dial_code": "+20"},
//   "language_code_sv": "🇸🇻 El Salvador",
//   "dial_code_sv": "+503",
//   "country_sv": {"name": "El Salvador", "flag": "🇸🇻", "code": "SV", "dial_code": "+503"},
//   "language_code_gq": "🇬🇶 Equatorial Guinea",
//   "dial_code_gq": "+240",
//   "country_gq": {"name": "Equatorial Guinea", "flag": "🇬🇶", "code": "GQ", "dial_code": "+240"},
//   "language_code_en": "🇺🇸 Inggris",
//   "dial_code_en": "+1",
//   "country_en": {"name": "Inggris", "flag": "🇺🇸", "code": "EN", "dial_code": "+1"},
//   "language_code_er": "🇪🇷 Eritrea",
//   "dial_code_er": "+291",
//   "country_er": {"name": "Eritrea", "flag": "🇪🇷", "code": "ER", "dial_code": "+291"},
//   "language_code_ee": "🇪🇪 Estonia",
//   "dial_code_ee": "+372",
//   "country_ee": {"name": "Estonia", "flag": "🇪🇪", "code": "EE", "dial_code": "+372"},
//   "language_code_et": "🇪🇹 Ethiopia",
//   "dial_code_et": "+251",
//   "country_et": {"name": "Ethiopia", "flag": "🇪🇹", "code": "ET", "dial_code": "+251"},
//   "language_code_fk": "🇫🇰 Falkland Islands (Malvinas)",
//   "dial_code_fk": "+500",
//   "country_fk": {"name": "Falkland Islands (Malvinas)", "flag": "🇫🇰", "code": "FK", "dial_code": "+500"},
//   "language_code_fo": "🇫🇴 Faroe Islands",
//   "dial_code_fo": "+298",
//   "country_fo": {"name": "Faroe Islands", "flag": "🇫🇴", "code": "FO", "dial_code": "+298"},
//   "language_code_fj": "🇫🇯 Fiji",
//   "dial_code_fj": "+679",
//   "country_fj": {"name": "Fiji", "flag": "🇫🇯", "code": "FJ", "dial_code": "+679"},
//   "language_code_fi": "🇫🇮 Finland",
//   "dial_code_fi": "+358",
//   "country_fi": {"name": "Finland", "flag": "🇫🇮", "code": "FI", "dial_code": "+358"},
//   "language_code_fr": "🇫🇷 France",
//   "dial_code_fr": "+33",
//   "country_fr": {"name": "France", "flag": "🇫🇷", "code": "FR", "dial_code": "+33"},
//   "language_code_gf": "🇬🇫 French Guiana",
//   "dial_code_gf": "+594",
//   "country_gf": {"name": "French Guiana", "flag": "🇬🇫", "code": "GF", "dial_code": "+594"},
//   "language_code_pf": "🇵🇫 French Polynesia",
//   "dial_code_pf": "+689",
//   "country_pf": {"name": "French Polynesia", "flag": "🇵🇫", "code": "PF", "dial_code": "+689"},
//   "language_code_tf": "🇹🇫 French Southern Territories",
//   "dial_code_tf": "+262",
//   "country_tf": {"name": "French Southern Territories", "flag": "🇹🇫", "code": "TF", "dial_code": "+262"},
//   "language_code_ga": "🇬🇦 Gabon",
//   "dial_code_ga": "+241",
//   "country_ga": {"name": "Gabon", "flag": "🇬🇦", "code": "GA", "dial_code": "+241"},
//   "language_code_gm": "🇬🇲 Gambia",
//   "dial_code_gm": "+220",
//   "country_gm": {"name": "Gambia", "flag": "🇬🇲", "code": "GM", "dial_code": "+220"},
//   "language_code_ge": "🇬🇪 Georgia",
//   "dial_code_ge": "+995",
//   "country_ge": {"name": "Georgia", "flag": "🇬🇪", "code": "GE", "dial_code": "+995"},
//   "language_code_de": "🇩🇪 Germany",
//   "dial_code_de": "+49",
//   "country_de": {"name": "Germany", "flag": "🇩🇪", "code": "DE", "dial_code": "+49"},
//   "language_code_gh": "🇬🇭 Ghana",
//   "dial_code_gh": "+233",
//   "country_gh": {"name": "Ghana", "flag": "🇬🇭", "code": "GH", "dial_code": "+233"},
//   "language_code_gi": "🇬🇮 Gibraltar",
//   "dial_code_gi": "+350",
//   "country_gi": {"name": "Gibraltar", "flag": "🇬🇮", "code": "GI", "dial_code": "+350"},
//   "language_code_gr": "🇬🇷 Greece",
//   "dial_code_gr": "+30",
//   "country_gr": {"name": "Greece", "flag": "🇬🇷", "code": "GR", "dial_code": "+30"},
//   "language_code_gl": "🇬🇱 Greenland",
//   "dial_code_gl": "+299",
//   "country_gl": {"name": "Greenland", "flag": "🇬🇱", "code": "GL", "dial_code": "+299"},
//   "language_code_gd": "🇬🇩 Grenada",
//   "dial_code_gd": "+1473",
//   "country_gd": {"name": "Grenada", "flag": "🇬🇩", "code": "GD", "dial_code": "+1473"},
//   "language_code_gp": "🇬🇵 Guadeloupe",
//   "dial_code_gp": "+590",
//   "country_gp": {"name": "Guadeloupe", "flag": "🇬🇵", "code": "GP", "dial_code": "+590"},
//   "language_code_gu": "🇬🇺 Guam",
//   "dial_code_gu": "+1671",
//   "country_gu": {"name": "Guam", "flag": "🇬🇺", "code": "GU", "dial_code": "+1671"},
//   "language_code_gt": "🇬🇹 Guatemala",
//   "dial_code_gt": "+502",
//   "country_gt": {"name": "Guatemala", "flag": "🇬🇹", "code": "GT", "dial_code": "+502"},
//   "language_code_gg": "🇬🇬 Guernsey",
//   "dial_code_gg": "+44",
//   "country_gg": {"name": "Guernsey", "flag": "🇬🇬", "code": "GG", "dial_code": "+44"},
//   "language_code_gn": "🇬🇳 Guinea",
//   "dial_code_gn": "+224",
//   "country_gn": {"name": "Guinea", "flag": "🇬🇳", "code": "GN", "dial_code": "+224"},
//   "language_code_gw": "🇬🇼 Guinea-Bissau",
//   "dial_code_gw": "+245",
//   "country_gw": {"name": "Guinea-Bissau", "flag": "🇬🇼", "code": "GW", "dial_code": "+245"},
//   "language_code_gy": "🇬🇾 Guyana",
//   "dial_code_gy": "+592",
//   "country_gy": {"name": "Guyana", "flag": "🇬🇾", "code": "GY", "dial_code": "+592"},
//   "language_code_ht": "🇭🇹 Haiti",
//   "dial_code_ht": "+509",
//   "country_ht": {"name": "Haiti", "flag": "🇭🇹", "code": "HT", "dial_code": "+509"},
//   "language_code_hm": "🇭🇲 Heard Island and Mcdonald Islands",
//   "dial_code_hm": "+672",
//   "country_hm": {"name": "Heard Island and Mcdonald Islands", "flag": "🇭🇲", "code": "HM", "dial_code": "+672"},
//   "language_code_va": "🇻🇦 Holy See (Vatican City State)",
//   "dial_code_va": "+379",
//   "country_va": {"name": "Holy See (Vatican City State)", "flag": "🇻🇦", "code": "VA", "dial_code": "+379"},
//   "language_code_hn": "🇭🇳 Honduras",
//   "dial_code_hn": "+504",
//   "country_hn": {"name": "Honduras", "flag": "🇭🇳", "code": "HN", "dial_code": "+504"},
//   "language_code_hk": "🇭🇰 Hong Kong",
//   "dial_code_hk": "+852",
//   "country_hk": {"name": "Hong Kong", "flag": "🇭🇰", "code": "HK", "dial_code": "+852"},
//   "language_code_hu": "🇭🇺 Hungary",
//   "dial_code_hu": "+36",
//   "country_hu": {"name": "Hungary", "flag": "🇭🇺", "code": "HU", "dial_code": "+36"},
//   "language_code_is": "🇮🇸 Iceland",
//   "dial_code_is": "+354",
//   "country_is": {"name": "Iceland", "flag": "🇮🇸", "code": "IS", "dial_code": "+354"},
//   "language_code_in": "🇮🇳 India",
//   "dial_code_in": "+91",
//   "country_in": {"name": "India", "flag": "🇮🇳", "code": "IN", "dial_code": "+91"},
//   "language_code_id": "🇮🇩 Indonesia",
//   "dial_code_id": "+62",
//   "country_id": {"name": "Indonesia", "flag": "🇮🇩", "code": "ID", "dial_code": "+62"},
//   "language_code_ir": "🇮🇷 Iran, Islamic Republic of Persian Gulf",
//   "dial_code_ir": "+98",
//   "country_ir": {"name": "Iran, Islamic Republic of Persian Gulf", "flag": "🇮🇷", "code": "IR", "dial_code": "+98"},
//   "language_code_iq": "🇮🇶 Iraq",
//   "dial_code_iq": "+964",
//   "country_iq": {"name": "Iraq", "flag": "🇮🇶", "code": "IQ", "dial_code": "+964"},
//   "language_code_ie": "🇮🇪 Ireland",
//   "dial_code_ie": "+353",
//   "country_ie": {"name": "Ireland", "flag": "🇮🇪", "code": "IE", "dial_code": "+353"},
//   "language_code_im": "🇮🇲 Isle of Man",
//   "dial_code_im": "+44",
//   "country_im": {"name": "Isle of Man", "flag": "🇮🇲", "code": "IM", "dial_code": "+44"},
//   "language_code_il": "🇮🇱 Israel",
//   "dial_code_il": "+972",
//   "country_il": {"name": "Israel", "flag": "🇮🇱", "code": "IL", "dial_code": "+972"},
//   "language_code_it": "🇮🇹 Italy",
//   "dial_code_it": "+39",
//   "country_it": {"name": "Italy", "flag": "🇮🇹", "code": "IT", "dial_code": "+39"},
//   "language_code_jm": "🇯🇲 Jamaica",
//   "dial_code_jm": "+1876",
//   "country_jm": {"name": "Jamaica", "flag": "🇯🇲", "code": "JM", "dial_code": "+1876"},
//   "language_code_jp": "🇯🇵 Japan",
//   "dial_code_jp": "+81",
//   "country_jp": {"name": "Japan", "flag": "🇯🇵", "code": "JP", "dial_code": "+81"},
//   "language_code_je": "🇯🇪 Jersey",
//   "dial_code_je": "+44",
//   "country_je": {"name": "Jersey", "flag": "🇯🇪", "code": "JE", "dial_code": "+44"},
//   "language_code_jo": "🇯🇴 Jordan",
//   "dial_code_jo": "+962",
//   "country_jo": {"name": "Jordan", "flag": "🇯🇴", "code": "JO", "dial_code": "+962"},
//   "language_code_kz": "🇰🇿 Kazakhstan",
//   "dial_code_kz": "+7",
//   "country_kz": {"name": "Kazakhstan", "flag": "🇰🇿", "code": "KZ", "dial_code": "+7"},
//   "language_code_ke": "🇰🇪 Kenya",
//   "dial_code_ke": "+254",
//   "country_ke": {"name": "Kenya", "flag": "🇰🇪", "code": "KE", "dial_code": "+254"},
//   "language_code_ki": "🇰🇮 Kiribati",
//   "dial_code_ki": "+686",
//   "country_ki": {"name": "Kiribati", "flag": "🇰🇮", "code": "KI", "dial_code": "+686"},
//   "language_code_kp": "🇰🇵 Korea, Democratic People's Republic of Korea",
//   "dial_code_kp": "+850",
//   "country_kp": {"name": "Korea, Democratic People's Republic of Korea", "flag": "🇰🇵", "code": "KP", "dial_code": "+850"},
//   "language_code_kr": "🇰🇷 Korea, Republic of South Korea",
//   "dial_code_kr": "+82",
//   "country_kr": {"name": "Korea, Republic of South Korea", "flag": "🇰🇷", "code": "KR", "dial_code": "+82"},
//   "language_code_xk": "🇽🇰 Kosovo",
//   "dial_code_xk": "+383",
//   "country_xk": {"name": "Kosovo", "flag": "🇽🇰", "code": "XK", "dial_code": "+383"},
//   "language_code_kw": "🇰🇼 Kuwait",
//   "dial_code_kw": "+965",
//   "country_kw": {"name": "Kuwait", "flag": "🇰🇼", "code": "KW", "dial_code": "+965"},
//   "language_code_kg": "🇰🇬 Kyrgyzstan",
//   "dial_code_kg": "+996",
//   "country_kg": {"name": "Kyrgyzstan", "flag": "🇰🇬", "code": "KG", "dial_code": "+996"},
//   "language_code_la": "🇱🇦 Laos",
//   "dial_code_la": "+856",
//   "country_la": {"name": "Laos", "flag": "🇱🇦", "code": "LA", "dial_code": "+856"},
//   "language_code_lv": "🇱🇻 Latvia",
//   "dial_code_lv": "+371",
//   "country_lv": {"name": "Latvia", "flag": "🇱🇻", "code": "LV", "dial_code": "+371"},
//   "language_code_lb": "🇱🇧 Lebanon",
//   "dial_code_lb": "+961",
//   "country_lb": {"name": "Lebanon", "flag": "🇱🇧", "code": "LB", "dial_code": "+961"},
//   "language_code_ls": "🇱🇸 Lesotho",
//   "dial_code_ls": "+266",
//   "country_ls": {"name": "Lesotho", "flag": "🇱🇸", "code": "LS", "dial_code": "+266"},
//   "language_code_lr": "🇱🇷 Liberia",
//   "dial_code_lr": "+231",
//   "country_lr": {"name": "Liberia", "flag": "🇱🇷", "code": "LR", "dial_code": "+231"},
//   "language_code_ly": "🇱🇾 Libyan Arab Jamahiriya",
//   "dial_code_ly": "+218",
//   "country_ly": {"name": "Libyan Arab Jamahiriya", "flag": "🇱🇾", "code": "LY", "dial_code": "+218"},
//   "language_code_li": "🇱🇮 Liechtenstein",
//   "dial_code_li": "+423",
//   "country_li": {"name": "Liechtenstein", "flag": "🇱🇮", "code": "LI", "dial_code": "+423"},
//   "language_code_lt": "🇱🇹 Lithuania",
//   "dial_code_lt": "+370",
//   "country_lt": {"name": "Lithuania", "flag": "🇱🇹", "code": "LT", "dial_code": "+370"},
//   "language_code_lu": "🇱🇺 Luxembourg",
//   "dial_code_lu": "+352",
//   "country_lu": {"name": "Luxembourg", "flag": "🇱🇺", "code": "LU", "dial_code": "+352"},
//   "language_code_mo": "🇲🇴 Macao",
//   "dial_code_mo": "+853",
//   "country_mo": {"name": "Macao", "flag": "🇲🇴", "code": "MO", "dial_code": "+853"},
//   "language_code_mk": "🇲🇰 Macedonia",
//   "dial_code_mk": "+389",
//   "country_mk": {"name": "Macedonia", "flag": "🇲🇰", "code": "MK", "dial_code": "+389"},
//   "language_code_mg": "🇲🇬 Madagascar",
//   "dial_code_mg": "+261",
//   "country_mg": {"name": "Madagascar", "flag": "🇲🇬", "code": "MG", "dial_code": "+261"},
//   "language_code_mw": "🇲🇼 Malawi",
//   "dial_code_mw": "+265",
//   "country_mw": {"name": "Malawi", "flag": "🇲🇼", "code": "MW", "dial_code": "+265"},
//   "language_code_my": "🇲🇾 Malaysia",
//   "dial_code_my": "+60",
//   "country_my": {"name": "Malaysia", "flag": "🇲🇾", "code": "MY", "dial_code": "+60"},
//   "language_code_mv": "🇲🇻 Maldives",
//   "dial_code_mv": "+960",
//   "country_mv": {"name": "Maldives", "flag": "🇲🇻", "code": "MV", "dial_code": "+960"},
//   "language_code_ml": "🇲🇱 Mali",
//   "dial_code_ml": "+223",
//   "country_ml": {"name": "Mali", "flag": "🇲🇱", "code": "ML", "dial_code": "+223"},
//   "language_code_mt": "🇲🇹 Malta",
//   "dial_code_mt": "+356",
//   "country_mt": {"name": "Malta", "flag": "🇲🇹", "code": "MT", "dial_code": "+356"},
//   "language_code_mh": "🇲🇭 Marshall Islands",
//   "dial_code_mh": "+692",
//   "country_mh": {"name": "Marshall Islands", "flag": "🇲🇭", "code": "MH", "dial_code": "+692"},
//   "language_code_mq": "🇲🇶 Martinique",
//   "dial_code_mq": "+596",
//   "country_mq": {"name": "Martinique", "flag": "🇲🇶", "code": "MQ", "dial_code": "+596"},
//   "language_code_mr": "🇲🇷 Mauritania",
//   "dial_code_mr": "+222",
//   "country_mr": {"name": "Mauritania", "flag": "🇲🇷", "code": "MR", "dial_code": "+222"},
//   "language_code_mu": "🇲🇺 Mauritius",
//   "dial_code_mu": "+230",
//   "country_mu": {"name": "Mauritius", "flag": "🇲🇺", "code": "MU", "dial_code": "+230"},
//   "language_code_yt": "🇾🇹 Mayotte",
//   "dial_code_yt": "+262",
//   "country_yt": {"name": "Mayotte", "flag": "🇾🇹", "code": "YT", "dial_code": "+262"},
//   "language_code_mx": "🇲🇽 Mexico",
//   "dial_code_mx": "+52",
//   "country_mx": {"name": "Mexico", "flag": "🇲🇽", "code": "MX", "dial_code": "+52"},
//   "language_code_fm": "🇫🇲 Micronesia, Federated States of Micronesia",
//   "dial_code_fm": "+691",
//   "country_fm": {"name": "Micronesia, Federated States of Micronesia", "flag": "🇫🇲", "code": "FM", "dial_code": "+691"},
//   "language_code_md": "🇲🇩 Moldova",
//   "dial_code_md": "+373",
//   "country_md": {"name": "Moldova", "flag": "🇲🇩", "code": "MD", "dial_code": "+373"},
//   "language_code_mc": "🇲🇨 Monaco",
//   "dial_code_mc": "+377",
//   "country_mc": {"name": "Monaco", "flag": "🇲🇨", "code": "MC", "dial_code": "+377"},
//   "language_code_mn": "🇲🇳 Mongolia",
//   "dial_code_mn": "+976",
//   "country_mn": {"name": "Mongolia", "flag": "🇲🇳", "code": "MN", "dial_code": "+976"},
//   "language_code_me": "🇲🇪 Montenegro",
//   "dial_code_me": "+382",
//   "country_me": {"name": "Montenegro", "flag": "🇲🇪", "code": "ME", "dial_code": "+382"},
//   "language_code_ms": "🇲🇸 Montserrat",
//   "dial_code_ms": "+1664",
//   "country_ms": {"name": "Montserrat", "flag": "🇲🇸", "code": "MS", "dial_code": "+1664"},
//   "language_code_ma": "🇲🇦 Morocco",
//   "dial_code_ma": "+212",
//   "country_ma": {"name": "Morocco", "flag": "🇲🇦", "code": "MA", "dial_code": "+212"},
//   "language_code_mz": "🇲🇿 Mozambique",
//   "dial_code_mz": "+258",
//   "country_mz": {"name": "Mozambique", "flag": "🇲🇿", "code": "MZ", "dial_code": "+258"},
//   "language_code_mm": "🇲🇲 Myanmar",
//   "dial_code_mm": "+95",
//   "country_mm": {"name": "Myanmar", "flag": "🇲🇲", "code": "MM", "dial_code": "+95"},
//   "language_code_na": "🇳🇦 Namibia",
//   "dial_code_na": "+264",
//   "country_na": {"name": "Namibia", "flag": "🇳🇦", "code": "NA", "dial_code": "+264"},
//   "language_code_nr": "🇳🇷 Nauru",
//   "dial_code_nr": "+674",
//   "country_nr": {"name": "Nauru", "flag": "🇳🇷", "code": "NR", "dial_code": "+674"},
//   "language_code_np": "🇳🇵 Nepal",
//   "dial_code_np": "+977",
//   "country_np": {"name": "Nepal", "flag": "🇳🇵", "code": "NP", "dial_code": "+977"},
//   "language_code_nl": "🇳🇱 Netherlands",
//   "dial_code_nl": "+31",
//   "country_nl": {"name": "Netherlands", "flag": "🇳🇱", "code": "NL", "dial_code": "+31"},
//   "language_code_an": " Netherlands Antilles",
//   "dial_code_an": "+599",
//   "country_an": {"name": "Netherlands Antilles", "flag": "", "code": "AN", "dial_code": "+599"},
//   "language_code_nc": "🇳🇨 New Caledonia",
//   "dial_code_nc": "+687",
//   "country_nc": {"name": "New Caledonia", "flag": "🇳🇨", "code": "NC", "dial_code": "+687"},
//   "language_code_nz": "🇳🇿 New Zealand",
//   "dial_code_nz": "+64",
//   "country_nz": {"name": "New Zealand", "flag": "🇳🇿", "code": "NZ", "dial_code": "+64"},
//   "language_code_ni": "🇳🇮 Nicaragua",
//   "dial_code_ni": "+505",
//   "country_ni": {"name": "Nicaragua", "flag": "🇳🇮", "code": "NI", "dial_code": "+505"},
//   "language_code_ne": "🇳🇪 Niger",
//   "dial_code_ne": "+227",
//   "country_ne": {"name": "Niger", "flag": "🇳🇪", "code": "NE", "dial_code": "+227"},
//   "language_code_ng": "🇳🇬 Nigeria",
//   "dial_code_ng": "+234",
//   "country_ng": {"name": "Nigeria", "flag": "🇳🇬", "code": "NG", "dial_code": "+234"},
//   "language_code_nu": "🇳🇺 Niue",
//   "dial_code_nu": "+683",
//   "country_nu": {"name": "Niue", "flag": "🇳🇺", "code": "NU", "dial_code": "+683"},
//   "language_code_nf": "🇳🇫 Norfolk Island",
//   "dial_code_nf": "+672",
//   "country_nf": {"name": "Norfolk Island", "flag": "🇳🇫", "code": "NF", "dial_code": "+672"},
//   "language_code_mp": "🇲🇵 Northern Mariana Islands",
//   "dial_code_mp": "+1670",
//   "country_mp": {"name": "Northern Mariana Islands", "flag": "🇲🇵", "code": "MP", "dial_code": "+1670"},
//   "language_code_no": "🇳🇴 Norway",
//   "dial_code_no": "+47",
//   "country_no": {"name": "Norway", "flag": "🇳🇴", "code": "NO", "dial_code": "+47"},
//   "language_code_om": "🇴🇲 Oman",
//   "dial_code_om": "+968",
//   "country_om": {"name": "Oman", "flag": "🇴🇲", "code": "OM", "dial_code": "+968"},
//   "language_code_pk": "🇵🇰 Pakistan",
//   "dial_code_pk": "+92",
//   "country_pk": {"name": "Pakistan", "flag": "🇵🇰", "code": "PK", "dial_code": "+92"},
//   "language_code_pw": "🇵🇼 Palau",
//   "dial_code_pw": "+680",
//   "country_pw": {"name": "Palau", "flag": "🇵🇼", "code": "PW", "dial_code": "+680"},
//   "language_code_ps": "🇵🇸 Palestinian Territory, Occupied",
//   "dial_code_ps": "+970",
//   "country_ps": {"name": "Palestinian Territory, Occupied", "flag": "🇵🇸", "code": "PS", "dial_code": "+970"},
//   "language_code_pa": "🇵🇦 Panama",
//   "dial_code_pa": "+507",
//   "country_pa": {"name": "Panama", "flag": "🇵🇦", "code": "PA", "dial_code": "+507"},
//   "language_code_pg": "🇵🇬 Papua New Guinea",
//   "dial_code_pg": "+675",
//   "country_pg": {"name": "Papua New Guinea", "flag": "🇵🇬", "code": "PG", "dial_code": "+675"},
//   "language_code_py": "🇵🇾 Paraguay",
//   "dial_code_py": "+595",
//   "country_py": {"name": "Paraguay", "flag": "🇵🇾", "code": "PY", "dial_code": "+595"},
//   "language_code_pe": "🇵🇪 Peru",
//   "dial_code_pe": "+51",
//   "country_pe": {"name": "Peru", "flag": "🇵🇪", "code": "PE", "dial_code": "+51"},
//   "language_code_ph": "🇵🇭 Philippines",
//   "dial_code_ph": "+63",
//   "country_ph": {"name": "Philippines", "flag": "🇵🇭", "code": "PH", "dial_code": "+63"},
//   "language_code_pn": "🇵🇳 Pitcairn",
//   "dial_code_pn": "+64",
//   "country_pn": {"name": "Pitcairn", "flag": "🇵🇳", "code": "PN", "dial_code": "+64"},
//   "language_code_pl": "🇵🇱 Poland",
//   "dial_code_pl": "+48",
//   "country_pl": {"name": "Poland", "flag": "🇵🇱", "code": "PL", "dial_code": "+48"},
//   "language_code_pt": "🇵🇹 Portugal",
//   "dial_code_pt": "+351",
//   "country_pt": {"name": "Portugal", "flag": "🇵🇹", "code": "PT", "dial_code": "+351"},
//   "language_code_pr": "🇵🇷 Puerto Rico",
//   "dial_code_pr": "+1939",
//   "country_pr": {"name": "Puerto Rico", "flag": "🇵🇷", "code": "PR", "dial_code": "+1939"},
//   "language_code_qa": "🇶🇦 Qatar",
//   "dial_code_qa": "+974",
//   "country_qa": {"name": "Qatar", "flag": "🇶🇦", "code": "QA", "dial_code": "+974"},
//   "language_code_ro": "🇷🇴 Romania",
//   "dial_code_ro": "+40",
//   "country_ro": {"name": "Romania", "flag": "🇷🇴", "code": "RO", "dial_code": "+40"},
//   "language_code_ru": "🇷🇺 Russia",
//   "dial_code_ru": "+7",
//   "country_ru": {"name": "Russia", "flag": "🇷🇺", "code": "RU", "dial_code": "+7"},
//   "language_code_rw": "🇷🇼 Rwanda",
//   "dial_code_rw": "+250",
//   "country_rw": {"name": "Rwanda", "flag": "🇷🇼", "code": "RW", "dial_code": "+250"},
//   "language_code_re": "🇷🇪 Reunion",
//   "dial_code_re": "+262",
//   "country_re": {"name": "Reunion", "flag": "🇷🇪", "code": "RE", "dial_code": "+262"},
//   "language_code_bl": "🇧🇱 Saint Barthelemy",
//   "dial_code_bl": "+590",
//   "country_bl": {"name": "Saint Barthelemy", "flag": "🇧🇱", "code": "BL", "dial_code": "+590"},
//   "language_code_sh": "🇸🇭 Saint Helena, Ascension and Tristan Da Cunha",
//   "dial_code_sh": "+290",
//   "country_sh": {"name": "Saint Helena, Ascension and Tristan Da Cunha", "flag": "🇸🇭", "code": "SH", "dial_code": "+290"},
//   "language_code_kn": "🇰🇳 Saint Kitts and Nevis",
//   "dial_code_kn": "+1869",
//   "country_kn": {"name": "Saint Kitts and Nevis", "flag": "🇰🇳", "code": "KN", "dial_code": "+1869"},
//   "language_code_lc": "🇱🇨 Saint Lucia",
//   "dial_code_lc": "+1758",
//   "country_lc": {"name": "Saint Lucia", "flag": "🇱🇨", "code": "LC", "dial_code": "+1758"},
//   "language_code_mf": "🇲🇫 Saint Martin",
//   "dial_code_mf": "+590",
//   "country_mf": {"name": "Saint Martin", "flag": "🇲🇫", "code": "MF", "dial_code": "+590"},
//   "language_code_pm": "🇵🇲 Saint Pierre and Miquelon",
//   "dial_code_pm": "+508",
//   "country_pm": {"name": "Saint Pierre and Miquelon", "flag": "🇵🇲", "code": "PM", "dial_code": "+508"},
//   "language_code_vc": "🇻🇨 Saint Vincent and the Grenadines",
//   "dial_code_vc": "+1784",
//   "country_vc": {"name": "Saint Vincent and the Grenadines", "flag": "🇻🇨", "code": "VC", "dial_code": "+1784"},
//   "language_code_ws": "🇼🇸 Samoa",
//   "dial_code_ws": "+685",
//   "country_ws": {"name": "Samoa", "flag": "🇼🇸", "code": "WS", "dial_code": "+685"},
//   "language_code_sm": "🇸🇲 San Marino",
//   "dial_code_sm": "+378",
//   "country_sm": {"name": "San Marino", "flag": "🇸🇲", "code": "SM", "dial_code": "+378"},
//   "language_code_st": "🇸🇹 Sao Tome and Principe",
//   "dial_code_st": "+239",
//   "country_st": {"name": "Sao Tome and Principe", "flag": "🇸🇹", "code": "ST", "dial_code": "+239"},
//   "language_code_sa": "🇸🇦 Saudi Arabia",
//   "dial_code_sa": "+966",
//   "country_sa": {"name": "Saudi Arabia", "flag": "🇸🇦", "code": "SA", "dial_code": "+966"},
//   "language_code_sn": "🇸🇳 Senegal",
//   "dial_code_sn": "+221",
//   "country_sn": {"name": "Senegal", "flag": "🇸🇳", "code": "SN", "dial_code": "+221"},
//   "language_code_rs": "🇷🇸 Serbia",
//   "dial_code_rs": "+381",
//   "country_rs": {"name": "Serbia", "flag": "🇷🇸", "code": "RS", "dial_code": "+381"},
//   "language_code_sc": "🇸🇨 Seychelles",
//   "dial_code_sc": "+248",
//   "country_sc": {"name": "Seychelles", "flag": "🇸🇨", "code": "SC", "dial_code": "+248"},
//   "language_code_sl": "🇸🇱 Sierra Leone",
//   "dial_code_sl": "+232",
//   "country_sl": {"name": "Sierra Leone", "flag": "🇸🇱", "code": "SL", "dial_code": "+232"},
//   "language_code_sg": "🇸🇬 Singapore",
//   "dial_code_sg": "+65",
//   "country_sg": {"name": "Singapore", "flag": "🇸🇬", "code": "SG", "dial_code": "+65"},
//   "language_code_sk": "🇸🇰 Slovakia",
//   "dial_code_sk": "+421",
//   "country_sk": {"name": "Slovakia", "flag": "🇸🇰", "code": "SK", "dial_code": "+421"},
//   "language_code_si": "🇸🇮 Slovenia",
//   "dial_code_si": "+386",
//   "country_si": {"name": "Slovenia", "flag": "🇸🇮", "code": "SI", "dial_code": "+386"},
//   "language_code_sb": "🇸🇧 Solomon Islands",
//   "dial_code_sb": "+677",
//   "country_sb": {"name": "Solomon Islands", "flag": "🇸🇧", "code": "SB", "dial_code": "+677"},
//   "language_code_so": "🇸🇴 Somalia",
//   "dial_code_so": "+252",
//   "country_so": {"name": "Somalia", "flag": "🇸🇴", "code": "SO", "dial_code": "+252"},
//   "language_code_za": "🇿🇦 South Africa",
//   "dial_code_za": "+27",
//   "country_za": {"name": "South Africa", "flag": "🇿🇦", "code": "ZA", "dial_code": "+27"},
//   "language_code_ss": "🇸🇸 South Sudan",
//   "dial_code_ss": "+211",
//   "country_ss": {"name": "South Sudan", "flag": "🇸🇸", "code": "SS", "dial_code": "+211"},
//   "language_code_gs": "🇬🇸 South Georgia and the South Sandwich Islands",
//   "dial_code_gs": "+500",
//   "country_gs": {"name": "South Georgia and the South Sandwich Islands", "flag": "🇬🇸", "code": "GS", "dial_code": "+500"},
//   "language_code_es": "🇪🇸 Spain",
//   "dial_code_es": "+34",
//   "country_es": {"name": "Spain", "flag": "🇪🇸", "code": "ES", "dial_code": "+34"},
//   "language_code_lk": "🇱🇰 Sri Lanka",
//   "dial_code_lk": "+94",
//   "country_lk": {"name": "Sri Lanka", "flag": "🇱🇰", "code": "LK", "dial_code": "+94"},
//   "language_code_sd": "🇸🇩 Sudan",
//   "dial_code_sd": "+249",
//   "country_sd": {"name": "Sudan", "flag": "🇸🇩", "code": "SD", "dial_code": "+249"},
//   "language_code_sr": "🇸🇷 Suriname",
//   "dial_code_sr": "+597",
//   "country_sr": {"name": "Suriname", "flag": "🇸🇷", "code": "SR", "dial_code": "+597"},
//   "language_code_sj": "🇸🇯 Svalbard and Jan Mayen",
//   "dial_code_sj": "+47",
//   "country_sj": {"name": "Svalbard and Jan Mayen", "flag": "🇸🇯", "code": "SJ", "dial_code": "+47"},
//   "language_code_sz": "🇸🇿 Swaziland",
//   "dial_code_sz": "+268",
//   "country_sz": {"name": "Swaziland", "flag": "🇸🇿", "code": "SZ", "dial_code": "+268"},
//   "language_code_se": "🇸🇪 Sweden",
//   "dial_code_se": "+46",
//   "country_se": {"name": "Sweden", "flag": "🇸🇪", "code": "SE", "dial_code": "+46"},
//   "language_code_ch": "🇨🇭 Switzerland",
//   "dial_code_ch": "+41",
//   "country_ch": {"name": "Switzerland", "flag": "🇨🇭", "code": "CH", "dial_code": "+41"},
//   "language_code_sy": "🇸🇾 Syrian Arab Republic",
//   "dial_code_sy": "+963",
//   "country_sy": {"name": "Syrian Arab Republic", "flag": "🇸🇾", "code": "SY", "dial_code": "+963"},
//   "language_code_tw": "🇹🇼 Taiwan",
//   "dial_code_tw": "+886",
//   "country_tw": {"name": "Taiwan", "flag": "🇹🇼", "code": "TW", "dial_code": "+886"},
//   "language_code_tj": "🇹🇯 Tajikistan",
//   "dial_code_tj": "+992",
//   "country_tj": {"name": "Tajikistan", "flag": "🇹🇯", "code": "TJ", "dial_code": "+992"},
//   "language_code_tz": "🇹🇿 Tanzania, United Republic of Tanzania",
//   "dial_code_tz": "+255",
//   "country_tz": {"name": "Tanzania, United Republic of Tanzania", "flag": "🇹🇿", "code": "TZ", "dial_code": "+255"},
//   "language_code_th": "🇹🇭 Thailand",
//   "dial_code_th": "+66",
//   "country_th": {"name": "Thailand", "flag": "🇹🇭", "code": "TH", "dial_code": "+66"},
//   "language_code_tl": "🇹🇱 Timor-Leste",
//   "dial_code_tl": "+670",
//   "country_tl": {"name": "Timor-Leste", "flag": "🇹🇱", "code": "TL", "dial_code": "+670"},
//   "language_code_tg": "🇹🇬 Togo",
//   "dial_code_tg": "+228",
//   "country_tg": {"name": "Togo", "flag": "🇹🇬", "code": "TG", "dial_code": "+228"},
//   "language_code_tk": "🇹🇰 Tokelau",
//   "dial_code_tk": "+690",
//   "country_tk": {"name": "Tokelau", "flag": "🇹🇰", "code": "TK", "dial_code": "+690"},
//   "language_code_to": "🇹🇴 Tonga",
//   "dial_code_to": "+676",
//   "country_to": {"name": "Tonga", "flag": "🇹🇴", "code": "TO", "dial_code": "+676"},
//   "language_code_tt": "🇹🇹 Trinidad and Tobago",
//   "dial_code_tt": "+1868",
//   "country_tt": {"name": "Trinidad and Tobago", "flag": "🇹🇹", "code": "TT", "dial_code": "+1868"},
//   "language_code_tn": "🇹🇳 Tunisia",
//   "dial_code_tn": "+216",
//   "country_tn": {"name": "Tunisia", "flag": "🇹🇳", "code": "TN", "dial_code": "+216"},
//   "language_code_tr": "🇹🇷 Turkey",
//   "dial_code_tr": "+90",
//   "country_tr": {"name": "Turkey", "flag": "🇹🇷", "code": "TR", "dial_code": "+90"},
//   "language_code_tm": "🇹🇲 Turkmenistan",
//   "dial_code_tm": "+993",
//   "country_tm": {"name": "Turkmenistan", "flag": "🇹🇲", "code": "TM", "dial_code": "+993"},
//   "language_code_tc": "🇹🇨 Turks and Caicos Islands",
//   "dial_code_tc": "+1649",
//   "country_tc": {"name": "Turks and Caicos Islands", "flag": "🇹🇨", "code": "TC", "dial_code": "+1649"},
//   "language_code_tv": "🇹🇻 Tuvalu",
//   "dial_code_tv": "+688",
//   "country_tv": {"name": "Tuvalu", "flag": "🇹🇻", "code": "TV", "dial_code": "+688"},
//   "language_code_ug": "🇺🇬 Uganda",
//   "dial_code_ug": "+256",
//   "country_ug": {"name": "Uganda", "flag": "🇺🇬", "code": "UG", "dial_code": "+256"},
//   "language_code_ua": "🇺🇦 Ukraine",
//   "dial_code_ua": "+380",
//   "country_ua": {"name": "Ukraine", "flag": "🇺🇦", "code": "UA", "dial_code": "+380"},
//   "language_code_ae": "🇦🇪 United Arab Emirates",
//   "dial_code_ae": "+971",
//   "country_ae": {"name": "United Arab Emirates", "flag": "🇦🇪", "code": "AE", "dial_code": "+971"},
//   "language_code_gb": "🇬🇧 United Kingdom",
//   "dial_code_gb": "+44",
//   "country_gb": {"name": "United Kingdom", "flag": "🇬🇧", "code": "GB", "dial_code": "+44"},
//   "language_code_us": "🇺🇸 United States",
//   "dial_code_us": "+1",
//   "country_us": {"name": "United States", "flag": "🇺🇸", "code": "US", "dial_code": "+1"},
//   "language_code_uy": "🇺🇾 Uruguay",
//   "dial_code_uy": "+598",
//   "country_uy": {"name": "Uruguay", "flag": "🇺🇾", "code": "UY", "dial_code": "+598"},
//   "language_code_uz": "🇺🇿 Uzbekistan",
//   "dial_code_uz": "+998",
//   "country_uz": {"name": "Uzbekistan", "flag": "🇺🇿", "code": "UZ", "dial_code": "+998"},
//   "language_code_vu": "🇻🇺 Vanuatu",
//   "dial_code_vu": "+678",
//   "country_vu": {"name": "Vanuatu", "flag": "🇻🇺", "code": "VU", "dial_code": "+678"},
//   "language_code_ve": "🇻🇪 Venezuela, Bolivarian Republic of Venezuela",
//   "dial_code_ve": "+58",
//   "country_ve": {"name": "Venezuela, Bolivarian Republic of Venezuela", "flag": "🇻🇪", "code": "VE", "dial_code": "+58"},
//   "language_code_vn": "🇻🇳 Vietnam",
//   "dial_code_vn": "+84",
//   "country_vn": {"name": "Vietnam", "flag": "🇻🇳", "code": "VN", "dial_code": "+84"},
//   "language_code_vg": "🇻🇬 Virgin Islands, British",
//   "dial_code_vg": "+1284",
//   "country_vg": {"name": "Virgin Islands, British", "flag": "🇻🇬", "code": "VG", "dial_code": "+1284"},
//   "language_code_vi": "🇻🇮 Virgin Islands, U.S.",
//   "dial_code_vi": "+1340",
//   "country_vi": {"name": "Virgin Islands, U.S.", "flag": "🇻🇮", "code": "VI", "dial_code": "+1340"},
//   "language_code_wf": "🇼🇫 Wallis and Futuna",
//   "dial_code_wf": "+681",
//   "country_wf": {"name": "Wallis and Futuna", "flag": "🇼🇫", "code": "WF", "dial_code": "+681"},
//   "language_code_ye": "🇾🇪 Yemen",
//   "dial_code_ye": "+967",
//   "country_ye": {"name": "Yemen", "flag": "🇾🇪", "code": "YE", "dial_code": "+967"},
//   "language_code_zm": "🇿🇲 Zambia",
//   "dial_code_zm": "+260",
//   "country_zm": {"name": "Zambia", "flag": "🇿🇲", "code": "ZM", "dial_code": "+260"},
//   "language_code_zw": "🇿🇼 Zimbabwe",
//   "dial_code_zw": "+263",
//   "country_zw": {"name": "Zimbabwe", "flag": "🇿🇼", "code": "ZW", "dial_code": "+263"}
// };

// String json_to_message(Map data) {
//   var message = "";
//   data.forEach((key, loopData) {
//     try {
//       if (loopData is Map) {
//       } else if (loopData is List) {
//       } else {
//         if (loopData is bool) {
//           loopData = (json_full_media[loopData] ?? loopData);
//         }
//         if (loopData is int) {
//           loopData = parseHtmlCode(loopData.toString());
//         }
//         if (key == "id") {
//           loopData = parseHtmlCode(loopData.toString());
//         }
//         if (key == "username") {
//           loopData = ("@$loopData");
//         }
//         if (key == "first_name") {
//           if (data["last_name"] is String) {
//             loopData = (loopData + " " + loopData);
//           }
//           loopData = (parseHtmlLink(loopData.toString(), "tg://user?id=${data["id"].toString()}"));
//         }
//         if (key == "language_code") {
//           loopData = (json_full_media["language_code_$loopData"] ?? loopData.toString());
//         }
//         message += "\n${(json_full_media[key] != null) ? json_full_media[key] : key}: $loopData";
//       }
//     } catch (e) {}
//   });
//   return message;
// }

// String parseHtmlLink(String text, String links) {
//   return "<a href='$links'>$text</a>";
// }

// String parseHtmlCode(String text) {
//   return "<code>$text</code>";
// }

// class Word {
//   final String words;
//   RegExp regexHastag = RegExp(r"(#[a-z0-9]+)", caseSensitive: false);
//   RegExp regexUsername = RegExp(r"(@[a-z0-9]+(_)?[a-z0-9]+)", caseSensitive: false);
//   Word(this.words);

//   List<String> getHastags() {
//     return regexHastag.allMatches(words).toList().map((e) => e.group(1)!.toLowerCase()).toSet().toList();
//   }

//   List<String> getUsernames() {
//     return regexUsername.allMatches(words).toList().map((e) => e.group(1)!.toLowerCase()).toSet().toList();
//   }
// }

// int parserBotUserIdFromToken(dynamic token_bot) {
//   try {
//     return int.parse(token_bot.split(":")[0]);
//   } catch (e) {
//     return 0;
//   }
// }
