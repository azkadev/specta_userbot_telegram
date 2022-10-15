// ignore_for_file: non_constant_identifier_names, empty_catches

part of specta_userbot_telegram;

extension TelegramTdlibExtension on Tdlib {
  List<int> getAllClientIds() {
    return state_data
        .map((e) {
          if (e["client_id"] is int) {
            return e["client_id"] as int;
          }
        })
        .toList()
        .cast<int>();
  }

  Future<Map> getMeClient({required int clientId}) async {
    return await getMe(clientId: clientId);
  }

  Future<List<Map>> getMeClients() async {
    List<int> get_all_client_ids = getAllClientIds();
    List<Map> array = [];
    for (var i = 0; i < get_all_client_ids.length; i++) {
      int clientId = get_all_client_ids[i];
      try {
        Map get_me_result = await getMeClient(clientId: clientId);
        if (get_me_result["ok"] == true && get_me_result["result"] is Map) {
          array.add(get_me_result["result"] as Map);
        }
      } catch (e) {}
    }
    return array;
  }

  Future<List<Map>> invokeAllClients(
    String method, {
    Map<String, dynamic>? parameters,
    bool isVoid = false,
    Duration? delayDuration,
    Duration? invokeTimeOut,
    String? extra,
  }) async {
    List<int> get_all_client_ids = getAllClientIds();
    List<Map> array = [];
    for (var i = 0; i < get_all_client_ids.length; i++) {
      int clientId = get_all_client_ids[i];
      try {
        var result = await invoke(
          method,
          parameters: parameters,
          clientId: clientId,
          isVoid: isVoid,
          delayDuration: delayDuration,
          invokeTimeOut: invokeTimeOut,
          extra: extra,
        );
        array.add({
          "@type": "invoke",
          "@client_id": client_id,
          "data": result,
        });
      } catch (e) {
        array.add({
          "@type": "error",
          "@client_id": client_id,
          "message": "${e}",
        });
      }
    }
    return array;
  }

  List<Map> invokeSyncAllClients(
    String method, {
    Map<String, dynamic>? parameters,
    bool isVoid = false,
    Duration? delayDuration,
    Duration? invokeTimeOut,
    String? extra,
  }) {
    List<int> get_all_client_ids = getAllClientIds();
    List<Map> array = [];
    for (var i = 0; i < get_all_client_ids.length; i++) {
      int clientId = get_all_client_ids[i];
      try {
        var result = invokeSync(
          method,
          parameters: parameters,
          clientId: clientId, 
        );
        array.add({
          "@type": "invoke",
          "@client_id": client_id,
          "data": result,
        });
      } catch (e) {
        array.add({
          "@type": "error",
          "@client_id": client_id,
          "message": "${e}",
        });
      }
    }
    return array;
  }
  Future<List<Map>> requestAllClients(
    String method, {
    Map<String, dynamic>? parameters,
    bool isVoid = false, 
    String? extra,
  }) async {
    List<int> get_all_client_ids = getAllClientIds();
    List<Map> array = [];
    for (var i = 0; i < get_all_client_ids.length; i++) {
      int clientId = get_all_client_ids[i];
      try {
        var result = await request(
          method,
          parameters: parameters,
          clientId: clientId,
          isVoid: isVoid,
          extra: extra,
        );
        array.add({
          "@type": "invoke",
          "@client_id": client_id,
          "data": result,
        });
      } catch (e) {
        array.add({
          "@type": "error",
          "@client_id": client_id,
          "message": "${e}",
        });
      }
    }
    return array;
  }

}
