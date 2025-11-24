import 'package:custom_mp_app/app/modules/search/controllers/search_controller.dart';
import 'package:custom_mp_app/app/modules/search/controllers/search_results_controller.dart';
import 'package:get/get.dart';

/// Search Binding
///
/// Manages dependency injection for search controllers
class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // ProductSearchController - persist across app (maintains search history)
    Get.put<ProductSearchController>(ProductSearchController(), permanent: true);

    // SearchResultsController - lazy load for results page only
    Get.lazyPut<SearchResultsController>(() => SearchResultsController());
  }
}
