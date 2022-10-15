// import 'package:specta_userbot_telegram/specta_userbot_telegram.dart';
// import 'package:test/test.dart';

// void main() {
//   test('calculate', () {
//     expect(calculate(), 42);
//   });
// }

import 'package:telegram_client/telegram_client.dart';

void main() {
 print(TdlibFunction.sendMessage(
    chat_id: 0,
    input_message_content: TdlibFunction.inputMessageText(
      text: TdlibFunction.formattedText(
        text: "Hello World",
      ),
    ),
  ).toJson());
}
