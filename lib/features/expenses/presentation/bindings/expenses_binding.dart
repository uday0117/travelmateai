import 'package:get/get.dart';
import 'package:travelmateai/core/network/network_info.dart';
import 'package:travelmateai/core/services/database_service.dart';
import 'package:travelmateai/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:travelmateai/features/expenses/data/datasources/expense_remote_datasource.dart';
import 'package:travelmateai/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:travelmateai/core/services/ai/ai_service.dart';
import 'package:travelmateai/features/expenses/presentation/controllers/expenses_controller.dart';

class ExpensesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExpenseLocalDataSource(Get.find<DatabaseService>()));
    Get.lazyPut(ExpenseRemoteDataSource.new);
    Get.lazyPut<ExpenseRepositoryImpl>(
      () => ExpenseRepositoryImpl(
        local: Get.find(),
        remote: Get.find(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
    );
    Get.lazyPut(() => ExpensesController(Get.find(), Get.find<AiService>()));
  }
}
