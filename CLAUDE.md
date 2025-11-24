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

### 1. Binding Strategy (IMPORTANT!)

**HomeBinding vs Page Bindings:**

- **HomeBinding** (`home_binding.dart`) - For global/persistent controllers:
  ```dart
  Get.put<Controller>(Controller(), permanent: true);
  ```
  Use when:
  - Controller needed across multiple pages
  - State must persist throughout session
  - Used for: Auth, Cart, Orders, Profile, Notifications

- **Page Bindings** - For page-specific controllers:
  ```dart
  Get.lazyPut<Controller>(() => Controller());
  ```
  Use when:
  - Controller only needed on one page
  - Should dispose when leaving page
  - Used for: ProductDetail, Checkout, specific settings

**Rule:** If a controller is already in HomeBinding, do NOT create it in page bindings.

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

### 7. Order Status Management

**Order Status Flow:**
1. `placed` - Unpaid order (To Pay tab)
2. `processing` - Paid, being prepared (To Ship tab)
3. `out_for_delivery` - In transit (To Receive tab)
4. `delivered` - Customer received (Completed tab)
5. `completed` - Finalized
6. `canceled` - Cancelled orders

**Tab Indices:**
- Tab 0: To Pay (`placed`)
- Tab 1: To Ship (`processing`)
- Tab 2: To Receive (`out_for_delivery`)
- Tab 3: Completed (`delivered`)
- Tab 4: Cancelled (`canceled`)

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

### 9. Model Conventions

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

## Common Pitfalls

1. **Don't create controllers in page bindings if they're in HomeBinding**
   - OrdersController, CartController, ProfileController are permanent

2. **Always use actual API response structure, not documentation**
   - Check actual responses with `curl` or Dio logger
   - API returns `items` not `data` for orders
   - Pagination is in `pagination` not `meta`

3. **Don't use private build methods in large pages**
   - Extract to separate widget files in `widgets/` subdirectory
   - Makes code more maintainable and testable

4. **Media URL handling**
   - Use `original_url` for images from API
   - Check variant media first, then product media
   - Handle empty media arrays gracefully

5. **Never skip error handling in repositories**
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

## Documentation

- Order API documentation: `documentation/MOBILE_ORDER_API_DOCUMENTATION.md`
- Always check actual API responses, not just documentation
- Use Dio logger to inspect real response structures
