import 'package:custom_mp_app/app/data/models/category/category_model.dart';
import 'package:get/get.dart';

import 'package:custom_mp_app/app/data/repositories/category_repository.dart';
import 'package:custom_mp_app/app/global/widgets/toasts/app_toast.dart';

class CategoryController extends GetxController {
  final CategoryRepository _repo = CategoryRepository();

  /// Observables
  final isLoading = false.obs;
  final categories = <CategoryModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    fetchCategories(); 
  }

  /// Fetch all categories from API
  Future<void> fetchCategories({bool refresh = false}) async {
    if (!refresh) isLoading.value = true;

    final result = await _repo.fetchCategories();

    result.fold(
      (failure) {
        print('❌ Category fetch failed: ${failure.message}');
        AppToast.error('Failed to load categories: ${failure.message}');
        categories.clear();
      },
      (data) {
        categories.assignAll(data);
        print('✅ Loaded ${data.length} categories');
      },
    );

    isLoading.value = false;
  }

  /// Optional helper: Get category by slug (cached or fetch new)
  CategoryModel? getCategoryBySlug(String slug) {
    return categories.firstWhereOrNull((cat) => cat.slug == slug);
  }
}
