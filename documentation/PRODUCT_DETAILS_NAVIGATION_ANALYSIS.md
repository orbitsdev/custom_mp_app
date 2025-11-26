# Product Details Page Navigation Analysis

## Current Implementation

### How It Works Now

**SelectProductController (onInit):**
```dart
@override
void onInit() {
  super.onInit();

  if (Get.arguments != null && Get.arguments is ProductModel) {
    selectedProduct.value = Get.arguments as ProductModel;
  }
}
```

**ProductDetailsPage:**
```dart
// Uses Get.find to get the controller
final controller = Get.find<SelectProductController>();

// Displays product or shows "Product not found"
Obx(() {
  final product = controller.selectedProduct.value;
  if (product == null) {
    return Center(child: Text('Product not found'));
  }
  // ... display product
})
```

### Current Navigation Pattern

**From Product List:**
```dart
// User taps ProductCard
Get.toNamed(
  Routes.productDetailsPage,
  arguments: productModel, // ← Full ProductModel object
);
```

✅ **Works:** When navigating from product list (product already loaded)

---

## ❌ Problems for Notifications & Deep Links

### Scenario 1: Notification Tap

```dart
// Notification handler (what we want to do):
static void _handleProductTap(Map<String, dynamic> data) {
  Get.toNamed(
    Routes.productDetailsPage,
    arguments: data['product_id'], // ← Only ID (e.g., 123)
  );
}
```

**Problem:**
- `onInit` expects `ProductModel`, not an ID
- No method to fetch product by ID
- Page shows "Product not found"

### Scenario 2: Deep Link

```
myapp://product/456
```

**Problem:**
- Deep link only provides product ID (456)
- Cannot pass full `ProductModel` object
- Same issue as notifications

### Scenario 3: Share URL

```
https://myapp.com/products/fresh-shrimp
```

**Problem:**
- URL contains slug, not full product data
- Need to fetch product from API
- Current implementation doesn't support this

---

## ✅ Recommended Solution

### Architecture Changes Needed

We need to support **3 navigation patterns**:

| Pattern | From | Argument Type | Behavior |
|---------|------|---------------|----------|
| **Pattern A** | Product list | `ProductModel` | Display immediately (current) |
| **Pattern B** | Notification | `int` (product_id) | Fetch by ID, then display |
| **Pattern C** | Deep link | `String` (slug) | Fetch by slug, then display |

---

## Implementation Plan

### 1. Update ProductRepository

**Add method to fetch by ID:**

```dart
/// Fetch product by ID
///
/// **Example:**
/// ```dart
/// final result = await productRepo.fetchProductById(123);
/// ```
EitherModel<ProductModel> fetchProductById(int productId) async {
  try {
    final dio = await DioClient.auth;

    print('🔍 Fetching product ID: $productId');

    final response = await dio.get(
      'products/$productId', // ← Assuming API supports this
      queryParameters: {
        'include': ProductIncludes.full.join(','),
      },
    );

    final product = ProductModel.fromMap(response.data['data']);

    print('✅ Product loaded: ${product.name}');

    return right(product);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      return left(FailureModel.manual('Product not found'));
    }
    return left(FailureModel.fromDio(e));
  } catch (e) {
    return left(FailureModel.manual('Unexpected error: $e'));
  }
}
```

---

### 2. Update SelectProductController

**Enhanced onInit to handle multiple argument types:**

```dart
@override
void onInit() {
  super.onInit();

  final arg = Get.arguments;

  if (arg == null) {
    // No argument provided
    print('⚠️ No product argument provided');
    return;
  }

  // Pattern A: Full ProductModel (from product list)
  if (arg is ProductModel) {
    selectedProduct.value = arg;
    return;
  }

  // Pattern B: Product ID (from notification)
  if (arg is int) {
    _loadProductById(arg);
    return;
  }

  // Pattern C: Product slug (from deep link)
  if (arg is String) {
    _loadProductBySlug(arg);
    return;
  }

  print('⚠️ Unknown argument type: ${arg.runtimeType}');
}

/// Load product by ID (for notifications)
Future<void> _loadProductById(int productId) async {
  isLoading.value = true;

  final result = await _productRepository.fetchProductById(productId);

  isLoading.value = false;

  result.fold(
    (failure) {
      print('❌ Failed to load product: ${failure.message}');
      AppToast.error('Failed to load product');
    },
    (product) {
      selectedProduct.value = product;
      print('✅ Product loaded: ${product.name}');
    },
  );
}

/// Load product by slug (for deep links)
Future<void> _loadProductBySlug(String slug) async {
  isLoading.value = true;

  final result = await _productRepository.fetchProductBySlug(slug);

  isLoading.value = false;

  result.fold(
    (failure) {
      print('❌ Failed to load product: ${failure.message}');
      AppToast.error('Failed to load product');
    },
    (product) {
      selectedProduct.value = product;
      print('✅ Product loaded: ${product.name}');
    },
  );
}
```

---

### 3. Update ProductDetailsPage

**Add loading state while fetching:**

```dart
body: Obx(() {
  final product = controller.selectedProduct.value;
  final isLoading = controller.isLoading.value;

  // Show loading spinner while fetching
  if (isLoading) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Show error if product not found
  if (product == null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LocalImageSvg(
            imageUrl: PathHelpers.imagePath('empty.svg'),
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          Text(
            'Product not found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  // Display product
  return RefreshIndicator(
    onRefresh: controller.refreshProduct,
    child: CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const DetailsSliverImage(),
        const DetailsGallery(),
        const DetailsInfoSection(),
        const DetailsTabs(),
        const DetailsTabContent(),
      ],
    ),
  );
}),
```

---

### 4. Update Notification Handlers

**Enable product navigation:**

```dart
// In local_notification_service.dart
static void _handleProductTap(Map<String, dynamic> data) {
  FirebaseLogger.log("📍 Navigate to Product: ${data['product_id']}");

  final productId = data['product_id'];

  if (productId != null) {
    Get.toNamed(
      Routes.productDetailsPage,
      arguments: int.parse(productId.toString()), // ← Pass ID as int
    );
  }
}

static void _handleNewProductTap(Map<String, dynamic> data) {
  FirebaseLogger.log("📍 Navigate to New Product: ${data['product_id']}");

  final productId = data['product_id'];

  if (productId != null) {
    Get.toNamed(
      Routes.productDetailsPage,
      arguments: int.parse(productId.toString()), // ← Pass ID as int
    );
  }
}
```

---

## Usage Examples

### Pattern A: From Product List (Current)
```dart
// ProductCard onTap
Get.toNamed(
  Routes.productDetailsPage,
  arguments: productModel, // ← Full object
);
```

### Pattern B: From Notification (New)
```dart
// Notification tap handler
Get.toNamed(
  Routes.productDetailsPage,
  arguments: 123, // ← Product ID (int)
);
```

### Pattern C: From Deep Link (Future)
```dart
// Deep link handler
Get.toNamed(
  Routes.productDetailsPage,
  arguments: 'fresh-shrimp', // ← Product slug (String)
);
```

---

## Benefits of This Approach

✅ **Flexible** - Supports 3 navigation patterns
✅ **Backward Compatible** - Existing navigation still works
✅ **Loading State** - Shows spinner while fetching
✅ **Error Handling** - Graceful failure with "Go Back" button
✅ **Deep Link Ready** - Easy to integrate deep links later
✅ **Notification Ready** - Works with notification tap handlers
✅ **Type Safe** - Uses Dart type checking (int, String, ProductModel)

---

## Deep Link Integration (Future)

When you're ready to add deep links, use a package like **uni_links** or **go_router**:

```dart
// Example with uni_links
void handleDeepLink(Uri uri) {
  // myapp://product/123
  if (uri.pathSegments.first == 'product') {
    final productId = int.tryParse(uri.pathSegments[1]);

    if (productId != null) {
      Get.toNamed(
        Routes.productDetailsPage,
        arguments: productId, // ← Already supported!
      );
    }
  }
}
```

---

## Firebase Notification Payloads

**Product Notification:**
```json
{
  "notification": {
    "title": "New Product Available",
    "body": "Check out our fresh tiger prawns!"
  },
  "data": {
    "type": "product",
    "product_id": "123"
  }
}
```

**New Product Notification:**
```json
{
  "notification": {
    "title": "Fresh Arrivals",
    "body": "Atlantic salmon now in stock"
  },
  "data": {
    "type": "new_product",
    "product_id": "456"
  }
}
```

---

## API Endpoint Assumption

This solution assumes your backend supports:

```
GET /api/products/{id}
GET /api/products/{slug}
```

**Check with backend:**
- ✅ If `GET /api/products/123` works → Use `fetchProductById(123)`
- ✅ If `GET /api/products/fresh-shrimp` works → Use `fetchProductBySlug('fresh-shrimp')`

Most REST APIs support both patterns.

---

## Summary

### Before (Current):
- ❌ Only works with full `ProductModel`
- ❌ Can't navigate from notifications
- ❌ Can't use deep links
- ❌ Can't share URLs

### After (Recommended):
- ✅ Works with `ProductModel`, `int` (ID), or `String` (slug)
- ✅ Notification navigation ready
- ✅ Deep link ready
- ✅ URL sharing ready
- ✅ Loading state while fetching
- ✅ Error handling

---

**Next Steps:**
1. Add `fetchProductById()` to ProductRepository
2. Update `SelectProductController.onInit()` to handle multiple types
3. Add loading state to ProductDetailsPage
4. Uncomment notification tap handlers
5. Test with notifications
6. (Future) Add deep link package and integrate

---

**Last Updated:** November 2025
**Status:** Analysis Complete - Ready for Implementation
