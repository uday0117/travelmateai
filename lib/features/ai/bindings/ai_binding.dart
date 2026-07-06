import 'package:get/get.dart';
import 'package:travelmateai/core/services/ai/ai_service.dart';
import 'package:travelmateai/features/ai/controllers/ai_chat_controller.dart';
import 'package:travelmateai/features/ai/controllers/ai_hub_controller.dart';

class AiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiHubController(Get.find<AiService>()));
    Get.lazyPut(() => AiChatController(Get.find<AiService>()));
  }
}
