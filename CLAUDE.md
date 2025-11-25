# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter e-commerce mobile application built with GetX state management, featuring product browsing, shopping cart, checkout flow, order management, and user profiles. The app follows a clean modular architecture with strict separation between UI, business logic, and data layers.

## Development Commands

### Running the Application
```bash
# Run on connected device/emulator
flutter run

# Run with hot reload
flutter run --hot

# Run in release mode
flutter run --release
```

### Testing & Linting
```bash
# Run all tests
flutter test

# Run linter
flutter analyze

# Format code
flutter format lib/
```

### Building
```bash
# Build APK (Android)
flutter build apk

# Build App Bundle (Android)
flutter build appbundle

# Build iOS
flutter build ios
```

### Dependencies
```bash
# Install dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Clean build cache
flutter clean && flutter pub get
```

## Architecture & Code Organization

### Module Structure (GetX Pattern)

Every feature module follows this strict structure:
```
lib/app/modules/{module_name}/
├── bindings/          # Dependency injection
├── controllers/       # Business logic (GetX controllers)
├── views/            # Pages (StatelessWidget with Obx)
├── widgets/          # Reusable UI components
└── models/           # (Optional) Module-specific models
```

### Core Directory Structure
```
lib/app/
├── core/
│   ├── bindings/     # AppBinding (global dependencies)
│   ├── enums/        # Shared enums (OrderStatus, etc.)
│   ├── plugins/      # DioClient, SecureStorage, Analytics
│   ├── routes/       # Route definitions and middleware
│   └── theme/        # AppTheme, AppColors, button styles
├── data/
│   ├── models/       # Data models with fromMap/toMap
│   └── repositories/ # API communication layer
├── global/
│   └── widgets/      # Shared widgets (buttons, toasts, etc.)
└── modules/          # Feature modules
```

## Critical Patterns & Conventions

### 1. Binding Strategy (CRITICAL!)

**Three-Tier Binding System:**

1. **AppBinding** (`app_binding.dart`) - App initialization:
   ```dart
   Get.put(AuthController(), permanent: true);
   ```
   - Loaded before app starts
   - Only for: AuthController

2. **HomeBinding** (`home_binding.dart`) - Global/persistent controllers:
   ```dart
   Get.put<Controller>(Controller(), permanent: true);
   ```
   Use when:
   - Controller needed across multiple pages
   - State must persist throughout session
   - Current permanent controllers: HomeController, CategoryController, ProductController, CartController, OrdersController, NotificationController, ShippingAddressController
   - ProfileController is lazy-loaded (not permanent)

3. **Page Bindings** - Page-specific controllers:
   ```dart
   Get.lazyPut<Controller>(() => Controller());
   ```
   Use when:
   - Controller only needed on one page
   - Should dispose when leaving page
   - Examples: ProductBinding, SearchBinding, PaymentBinding

**CRITICAL RULES:**
- If a controller is in AppBinding or HomeBinding, NEVER create it in page bindings
- ALL modules must have a binding registered in routes, even if using HomeBinding controllers
- Use `Get.find<Controller>()` in pages, NOT `Get.put()` manually
- Manual `Get.put()` without binding causes lifecycle issues and Obx errors

### 2. API Communication

**Base URL:** `https://dev.avantefoods.com/api/`

**DioClient Usage:**
```dart
// Public endpoints (no auth)
final dio = DioClient.public;

// Authenticated endpoints
final dio = await DioClient.auth;
```

**Repository Pattern:**
All API calls must go through repositories using `fpdart` Either type:
```dart
Future<Either<FailureModel, SuccessType>> methodName() async {
  try {
    final response = await dio.get('endpoint');
    return right(SuccessModel.fromMap(response.data));
  } catch (e) {
    return left(FailureModel(message: e.toString()));
  }
}
```

### 3. API Response Structures

**CRITICAL:** Actual API responses differ from some documentation.

**Orders API Response:**
```json
{
  "status": true,
  "message": "Orders retrieved successfully.",
  "data": {
    "items": [...],        // NOT "data"!
    "pagination": {        // NOT "meta"!
      "current_page": 1,
      "last_page": 3,
      "per_page": 15,
      "total": 34
    }
  }
}
```

**Order Item Structure:**
- Cart items have nested structure: `item['variant']['product']['media'][0]['original_url']`
- Shipping address has nested objects: `address['barangay']['name']`, `address['municipality']['name']`
- Use `original_url` for images, not `url` or `thumbnail`

### 4. Widget Organization

**When to Extract Widgets:**
- If a build method exceeds ~100 lines, extract sections into separate widget files
- Place extracted widgets in `widgets/` subdirectory with descriptive names
- Example: `order_detail_page.dart` → `widgets/orderdetails/order_header_widget.dart`

**Widget Structure:**
```dart
class MyWidget extends StatelessWidget {
  final RequiredType data;

  const MyWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implementation
  }
}
```

### 5. State Management with GetX

**Controller Pattern:**
```dart
class MyController extends GetxController {
  static MyController get instance => Get.find();

  final myState = false.obs;  // Observable
  final myData = Rxn<Model>(); // Nullable observable

  @override
  void onInit() {
    super.onInit();
    // Initialize
  }

  @override
  void onClose() {
    // Cleanup
    super.onClose();
  }
}
```

**View Pattern:**
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyController>();

    return Obx(() => Text(controller.myState.value.toString()));
  }
}
```

**CRITICAL Obx Rules:**
- `Obx()` can ONLY observe reactive variables (`.obs` types)
- If you use `Obx()` in a view, the variable MUST be observable
- Common mistake: `String searchQuery = ''` with `Obx(() => Text(controller.searchQuery))` → ERROR!
- Fix: Use `final searchQuery = ''.obs` and access with `controller.searchQuery.value`
- If a variable doesn't need to be reactive, don't wrap it in `Obx()`

### 6. Navigation

**Route Navigation:**
```dart
// Simple navigation
Get.toNamed(Routes.productDetailsPage);

// With arguments
Get.toNamed(Routes.orderDetailPage, arguments: orderModel);

// With parameters (for tab index, etc.)
Get.toNamed(Routes.ordersPage, arguments: {'initialTab': 1});

// Replace current page
Get.offNamed(Routes.homePage);

// Clear stack and navigate
Get.offAllNamed(Routes.loginPage);
```

**Middleware:**
- `AuthMiddleware` - Protects authenticated routes
- `GuestMiddleware` - Redirects authenticated users away from login/signup

### 6.5. Search Flow Architecture (Professional 3-Page Pattern)

**CRITICAL: Proper Search Navigation**

The search module follows the industry-standard 3-page architecture (Shopee, Lazada, Amazon):

**Page 1: SearchPage** (`/search`)
- Search input with auto-focus
- Shows when input is empty:
  - Search history (persistent, saved in GetStorage)
  - Popular product suggestions
- Shows when typing:
  - Instant search results (text-only list)
  - Highlighted matching text
  - Debounced API calls (500ms)
- **Action:** Click instant result → Navigate to SearchResultsPage with query

**Page 2: SearchResultsPage** (`/search-results`)
- Full product grid (2 columns)
- ProductCard with images, prices, ratings
- Sorting options (price, popularity, etc.)
- Pagination/infinite scroll
- Pull-to-refresh
- **Action:** Click product card → Navigate to ProductDetailsPage

**Page 3: ProductDetailsPage** (`/product-details`)
- Full product information
- Add to cart functionality

**❌ WRONG Pattern:**
```dart
// DON'T navigate directly to product details from instant search
onTap: () => Get.toNamed(Routes.productDetailsPage, arguments: product);
```

**✅ CORRECT Pattern:**
```dart
// Navigate to search results page first (shows all matching products in grid)
onTap: () => controller.executeSearch(query);
```

**Why This Matters:**
- Users expect to see all matching products before drilling into one
- Allows comparison shopping (key for e-commerce)
- Matches mental model from Shopee, Lazada, Amazon
- Better conversion rates

### 7. Order Status Management

**Order Status Flow:**
1. `placed` - Unpaid order (To Pay tab)
2. `processing` - Paid, being prepared (To Ship tab)
3. `out_for_delivery` - In transit (To Receive tab)
4. `delivered` - Customer received (Completed tab)
5. `completed` - Finalized
6. `canceled` - Cancelled orders (use American spelling, NOT "cancelled")

**CRITICAL: Enum Naming Convention**
- Backend API uses American spelling: `"canceled"` (single 'l')
- Enum constant must match: `OrderStatus.canceled` (NOT cancelled)
- Always match enum names to backend spelling to avoid switch case mismatches

**Tab Indices:**
- Tab 0: To Pay (`placed`)
- Tab 1: To Ship (`processing`)
- Tab 2: To Receive (`out_for_delivery`)
- Tab 3: Completed (`delivered`)
- Tab 4: Cancelled (`canceled`)

**OrdersController Caching:**
- Uses 15-second cache validity (Shopee-like UX)
- Cache invalidates automatically on tab switch
- ProfileController references OrdersController counts (single source of truth)
- Call `invalidateCache(status)` after order status changes
- Call `refreshAllCounts()` to force refresh all status counts

### 8. Storage

**Secure Storage (flutter_secure_storage):**
```dart
// Token
await SecureStorageService.saveToken(token);
final token = await SecureStorageService.getToken();

// User data
await SecureStorageService.saveUser(userJson);
final user = await SecureStorageService.getUser();

// Clear all
await SecureStorageService.clearAuthData();
```

**GetStorage (get_storage):**
Used for non-sensitive data like preferences.

### 9. User Feedback Patterns

**Smart Feedback System:**
Use appropriate feedback mechanism based on action importance:

```dart
// Critical updates (password, email, account changes)
AppModal.success(
  title: 'Password Updated',
  message: 'Your password has been changed successfully.',
  onConfirm: () => Get.back(),
);

// Quick updates (name, avatar, profile fields)
AppToast.success('Profile updated successfully');
Get.back();

// Errors - always use modal
AppModal.error(
  title: 'Update Failed',
  message: failure.message,
);
```

**Guidelines:**
- Critical/Security actions → Modal (blocks user attention)
- Quick updates → Toast (non-intrusive)
- All errors → Modal (ensures user sees the issue)
- Confirmations for destructive actions (delete avatar, cancel order)

### 10. Model Conventions

**fromMap/toMap Pattern:**
```dart
class MyModel {
  final int id;
  final String name;

  MyModel({required this.id, required this.name});

  factory MyModel.fromMap(Map<String, dynamic> map) {
    return MyModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
```

**Handling Nullable Fields:**
- Use `??` operator for defaults
- Use `Rxn<Type>()` for nullable observables in controllers
- Check null before accessing nested objects in API responses

## Common Pitfalls & Recent Bug Fixes

### Critical Pitfalls

1. **❌ Manual Controller Creation Without Binding**
   - NEVER use `Get.put()` in page initState or build methods
   - ALWAYS register bindings in routes and use `Get.find()`
   - Example error: SearchResultsPage manually creating controller → Obx lifecycle errors
   - Fix: Add SearchBinding to routes, use `Get.find<SearchResultsController>()`

2. **❌ Non-Observable Variables in Obx**
   - If `Obx()` observes a variable, it MUST be `.obs`
   - Common mistake: `String searchQuery = ''` → `Obx(() => Text(controller.searchQuery))`
   - Error: `[Get] the improper use of a GetX has been detected`
   - Fix: Change to `final searchQuery = ''.obs` and access with `.value`

3. **❌ Enum Spelling Mismatches**
   - Backend uses American spelling (e.g., "canceled")
   - Enum constant name must match exactly: `OrderStatus.canceled` NOT `cancelled`
   - Mismatch causes switch cases to fail silently
   - Always reference backend API documentation for exact spelling

4. **❌ Duplicate State Sources**
   - Don't fetch same data in multiple controllers independently
   - Example: ProfileController and OrdersController both fetching order counts
   - Fix: Use single source of truth (OrdersController), reference from other controllers
   - Reduces API calls by 40-50% and keeps data synchronized

5. **❌ Missing Cache Invalidation**
   - Order tabs keep stale data without refresh on tab switch
   - Fix: Add tab change listener that calls `controller.invalidateCache(status)`
   - Implement smart caching (15s validity) instead of fetching every time

### Data Structure Pitfalls

6. **Always use actual API response structure, not documentation**
   - Check actual responses with `curl` or Dio logger
   - API returns `items` not `data` for orders
   - Pagination is in `pagination` not `meta`

7. **Don't use private build methods in large pages**
   - Extract to separate widget files in `widgets/` subdirectory
   - Makes code more maintainable and testable

8. **Media URL handling**
   - Use `original_url` for images from API
   - Check variant media first, then product media
   - Handle empty media arrays gracefully

9. **Never skip error handling in repositories**
   - Always return `Either<FailureModel, Success>`
   - Wrap all API calls in try-catch
   - Provide meaningful error messages

## Testing Strategy

When implementing new features:
1. Create controller with business logic
2. Add to appropriate binding (HomeBinding vs page binding)
3. Create view that uses `Get.find<Controller>()` and `Obx()`
4. Add route to `Routes` class
5. Extract complex widgets to separate files
6. Test with actual API using Dio logger

## Key Dependencies

- **get** (^4.7.2) - State management, routing, dependency injection
- **dio** (^5.9.0) - HTTP client with interceptors
- **fpdart** (^1.2.0) - Functional programming (Either type)
- **flutter_secure_storage** (^9.2.4) - Secure token storage
- **get_storage** (^2.1.1) - Local key-value storage
- **pretty_dio_logger** (^1.4.0) - API request/response logging

## Documentation & Bug Fix History

### API Documentation
- Order API: `documentation/MOBILE_ORDER_API_DOCUMENTATION.md`
- Always check actual API responses, not just documentation
- Use Dio logger to inspect real response structures

### Recent Bug Fixes (November 2025)
Reference these files for detailed fix explanations:

1. **`SEARCH_OBX_BUGFIX.md`** - Search query not observable
   - Fixed: Made searchQuery reactive in SearchResultsController
   - Learning: All variables used in Obx must be `.obs`

2. **`ORDERSTATUS_BUGFIX.md`** - Enum spelling mismatch
   - Fixed: Changed `cancelled` to `canceled` (American spelling)
   - Learning: Enum names must match backend API exactly

3. **`ORDER_SYNC_IMPROVEMENT.md`** - Order data synchronization
   - Fixed: Unified state management with OrdersController as single source
   - Added: 15-second smart caching with automatic invalidation
   - Learning: Single source of truth pattern prevents data inconsistency

4. **`PROFILE_UPDATE_IMPLEMENTATION.md`** - Profile update UX
   - Added: Smart feedback system (modals vs toasts)
   - Learning: Match feedback to action importance
- if possible use CustomScrollview when creating new page rather than normal widget, sliver offer because slvers offer advance features, if possible use seprate widget class  instead creaing function this make clean and easey to maintain,