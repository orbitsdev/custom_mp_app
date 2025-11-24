# Mobile Order API Documentation

**For Flutter Developers**

This document provides complete details on the Order API endpoints, including how to use them, expected responses, and filtering logic for implementing order tabs (similar to Shopee).

---

## 📋 Table of Contents

1. [Order Status Flow](#order-status-flow)
2. [Order Status Definitions](#order-status-definitions)
3. [API Endpoints](#api-endpoints)
4. [Tab Filtering Logic](#tab-filtering-logic)
5. [Response Structures](#response-structures)
6. [Important Field Explanations](#important-field-explanations)

---

## 📊 Order Status Flow

```
┌─────────────────────────────────────────────────────────┐
│  CUSTOMER PLACES ORDER                                  │
└─────────────────────────────────────────────────────────┘
                    ↓
         ┌──────────────────┐
         │ 1. PLACED        │ ← Order created (unpaid)
         │    paid_at: NULL │
         └──────────────────┘
                    ↓ (Payment webhook)
         ┌──────────────────┐
         │ 2. PROCESSING    │ ← Payment confirmed, seller preparing
         │    paid_at: SET  │
         └──────────────────┘
                    ↓
         ┌──────────────────────────┐
         │ 3. OUT_FOR_DELIVERY      │ ← Order in transit
         │    OR                    │
         │    READY_FOR_PICKUP      │ ← Ready at pickup location
         └──────────────────────────┘
                    ↓
         ┌──────────────────┐
         │ 4. DELIVERED     │ ← Customer received order
         └──────────────────┘
                    ↓
         ┌──────────────────┐
         │ 5. COMPLETED     │ ← Order finalized
         └──────────────────┘

       (Alternative paths)
         ┌──────────────────┐
         │ CANCELLED        │ ← Cancelled before/after payment
         └──────────────────┘

         ┌──────────────────┐
         │ RETURNED         │ ← Returned after delivery
         └──────────────────┘
```

---

## 🎯 Order Status Definitions

| Status | Value | Shopee Equivalent | Description | When Used |
|--------|-------|------------------|-------------|-----------|
| **PLACED** | `placed` | "Unpaid" | Order created but not paid | Order creation |
| **PAID** | `paid` | "To Confirm" | Payment received (currently not used in flow) | - |
| **PROCESSING** | `processing` | "To Ship" | Payment confirmed, seller preparing order | After payment webhook |
| **OUT_FOR_DELIVERY** | `out_for_delivery` | "To Receive" / "Shipping" | Order is in transit | When shipped |
| **READY_FOR_PICKUP** | `ready_for_pickup` | "Ready to Pickup" | Order ready at pickup location | When ready for pickup |
| **DELIVERED** | `delivered` | "Delivered" | Customer received the order | After delivery confirmed |
| **COMPLETED** | `completed` | "Completed" | Order finalized | After return period expires |
| **CANCELLED** | `canceled` | "Cancelled" | Order was cancelled | When cancelled |
| **RETURNED** | `returned` | "Return/Refund" | Order returned after delivery | When returned |

### ⚠️ Note on Status Flow

**Current Implementation:**
- After payment: `placed` → `processing` (status jumps directly to processing)
- The `paid` status exists but is **not used** in the current flow
- Use `paid_at` field to check if order is paid (NOT NULL = paid)

---

## 🔌 API Endpoints

### Base URL
```
https://your-domain.com/api
```

### Authentication
All order endpoints require authentication using Laravel Sanctum tokens.

**Required Headers:**
```
Authorization: Bearer {token}
Accept: application/json
Content-Type: application/json
```

---

## 1️⃣ Get Orders List

Fetch user's orders with optional filtering for tabs.

### Endpoint
```http
GET /api/orders
```

### Query Parameters

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| `filter[order_status]` | string | No | Filter by order status | `filter[order_status]=processing` |
| `filter[payment_type]` | string | No | Filter by payment type | `filter[payment_type]=online` |
| `filter[delivery_type]` | string | No | Filter by delivery type | `filter[delivery_type]=delivery` |
| `filter[is_active]` | boolean | No | Filter by active status | `filter[is_active]=1` |
| `include` | string | No | Include relationships | `include=package,payments,orderStatusLogs` |
| `page` | integer | No | Page number for pagination | `page=1` |

### Available Includes

- `user` - User information
- `package` - Package details
- `payments` - Payment records
- `orderStatusLogs` - Status change history

### Example Request

```http
GET /api/orders?filter[order_status]=processing&include=package,payments&page=1
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
Accept: application/json
```

### Success Response (200 OK)

```json
{
  "success": true,
  "message": "Orders retrieved successfully.",
  "data": {
    "data": [
      {
        "id": 1,
        "order_reference_id": "202511071ABCDEF",
        "order_status": "processing",
        "payment_type": "online",
        "payment_method_used": "gcash",
        "delivery_type": "delivery",
        "paid_at": "Nov 07, 2025 at 2:30 PM",
        "is_active": true,
        "total_price": 1500.00,
        "total_item_price": 1350.00,
        "shipping_fee": 150.00,
        "ordered_at": {
          "formatted": "Nov 07, 2025 at 2:15 PM",
          "human": "2 hours ago",
          "timestamp": 1699344900
        },
        "created_at": {
          "formatted": "Nov 07, 2025 at 2:15 PM",
          "human": "2 hours ago",
          "timestamp": 1699344900
        },
        "updated_at": {
          "formatted": "Nov 07, 2025 at 2:30 PM",
          "human": "1 hour ago",
          "timestamp": 1699345800
        },
        "shipping_address_snapshot": {
          "id": 1,
          "name": "John Doe",
          "phone": "+639171234567",
          "address": "123 Main St, Barangay San Isidro",
          "city": "Manila",
          "province": "Metro Manila",
          "postal_code": "1000",
          "is_default": true
        },
        "cart_items_snapshot": [
          {
            "id": 1,
            "user_id": 1,
            "variant_id": 5,
            "quantity": 2,
            "is_selected": true,
            "is_checked_out": true,
            "variant_price_snapshot": 500.00,
            "adjustment_amount_snapshot": 0,
            "created_at": "2025-11-07T14:10:00.000000Z",
            "updated_at": "2025-11-07T14:15:00.000000Z",
            "variant": {
              "id": 5,
              "product_id": 10,
              "name": "Red / Large",
              "price": 500.00,
              "product": {
                "id": 10,
                "name": "Cotton T-Shirt",
                "slug": "cotton-t-shirt",
                "thumbnail": "https://your-domain.com/storage/products/shirt.jpg"
              }
            }
          },
          {
            "id": 2,
            "user_id": 1,
            "variant_id": 8,
            "quantity": 1,
            "is_selected": true,
            "is_checked_out": true,
            "variant_price_snapshot": 350.00,
            "adjustment_amount_snapshot": 0,
            "created_at": "2025-11-07T14:10:00.000000Z",
            "updated_at": "2025-11-07T14:15:00.000000Z",
            "variant": {
              "id": 8,
              "product_id": 12,
              "name": "Blue / Medium",
              "price": 350.00,
              "product": {
                "id": 12,
                "name": "Denim Jeans",
                "slug": "denim-jeans",
                "thumbnail": "https://your-domain.com/storage/products/jeans.jpg"
              }
            }
          }
        ],
        "package_snapshot": {
          "id": 1,
          "name": "Standard Packaging",
          "price": 50.00,
          "description": "Standard packaging with bubble wrap",
          "is_active": true
        },
        "package": {
          "id": 1,
          "name": "Standard Packaging",
          "price": 50.00,
          "description": "Standard packaging with bubble wrap",
          "is_active": true,
          "created_at": "2025-10-01T10:00:00.000000Z",
          "updated_at": "2025-10-01T10:00:00.000000Z"
        },
        "payments": [
          {
            "id": 1,
            "provider": "paymongo",
            "status": "paid",
            "amount": 1500.00,
            "payment_intent_id": "pi_1234567890abcdef",
            "checkout_session_id": "cs_9876543210fedcba",
            "order_reference_id": "202511071ABCDEF",
            "created_at": "2025-11-07 14:30:00"
          }
        ]
      }
    ],
    "links": {
      "first": "https://your-domain.com/api/orders?page=1",
      "last": "https://your-domain.com/api/orders?page=5",
      "prev": null,
      "next": "https://your-domain.com/api/orders?page=2"
    },
    "meta": {
      "current_page": 1,
      "from": 1,
      "last_page": 5,
      "path": "https://your-domain.com/api/orders",
      "per_page": 15,
      "to": 15,
      "total": 75
    }
  }
}
```

### Error Response (401 Unauthorized)

```json
{
  "message": "Unauthenticated."
}
```

---

## 2️⃣ Get Single Order Details

Fetch detailed information about a specific order by ID.

### Endpoint
```http
GET /api/orders/{id}
```

### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Order ID |

### Query Parameters

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| `include` | string | No | Include relationships | `include=package,payments,orderStatusLogs` |

### Example Request

```http
GET /api/orders/1?include=package,payments,orderStatusLogs
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
Accept: application/json
```

### Success Response (200 OK)

```json
{
  "success": true,
  "message": "Order details retrieved successfully.",
  "data": {
    "id": 1,
    "order_reference_id": "202511071ABCDEF",
    "order_status": "processing",
    "payment_type": "online",
    "payment_method_used": "gcash",
    "delivery_type": "delivery",
    "paid_at": "Nov 07, 2025 at 2:30 PM",
    "is_active": true,
    "total_price": 1500.00,
    "total_item_price": 1350.00,
    "shipping_fee": 150.00,
    "ordered_at": {
      "formatted": "Nov 07, 2025 at 2:15 PM",
      "human": "2 hours ago",
      "timestamp": 1699344900
    },
    "created_at": {
      "formatted": "Nov 07, 2025 at 2:15 PM",
      "human": "2 hours ago",
      "timestamp": 1699344900
    },
    "updated_at": {
      "formatted": "Nov 07, 2025 at 2:30 PM",
      "human": "1 hour ago",
      "timestamp": 1699345800
    },
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+639171234567",
      "created_at": "2025-10-01T10:00:00.000000Z"
    },
    "package": {
      "id": 1,
      "name": "Standard Packaging",
      "price": 50.00,
      "description": "Standard packaging with bubble wrap",
      "is_active": true,
      "created_at": "2025-10-01T10:00:00.000000Z",
      "updated_at": "2025-10-01T10:00:00.000000Z"
    },
    "payments": [
      {
        "id": 1,
        "provider": "paymongo",
        "status": "paid",
        "amount": 1500.00,
        "payment_intent_id": "pi_1234567890abcdef",
        "checkout_session_id": "cs_9876543210fedcba",
        "order_reference_id": "202511071ABCDEF",
        "created_at": "2025-11-07 14:30:00"
      }
    ],
    "order_status_logs": [
      {
        "id": 1,
        "order_id": 1,
        "status": "placed",
        "description": "Order has been placed.",
        "created_at": "2025-11-07 14:15:00",
        "updated_at": "2025-11-07 14:15:00"
      },
      {
        "id": 2,
        "order_id": 1,
        "status": "paid",
        "description": "Order has been paid successfully via gcash",
        "created_at": "2025-11-07 14:30:00",
        "updated_at": "2025-11-07 14:30:00"
      },
      {
        "id": 3,
        "order_id": 1,
        "status": "processing",
        "description": "Order is being processed",
        "created_at": "2025-11-07 14:30:00",
        "updated_at": "2025-11-07 14:30:00"
      }
    ],
    "shipping_address_snapshot": {
      "id": 1,
      "name": "John Doe",
      "phone": "+639171234567",
      "address": "123 Main St, Barangay San Isidro",
      "city": "Manila",
      "province": "Metro Manila",
      "postal_code": "1000",
      "is_default": true
    },
    "cart_items_snapshot": [
      {
        "id": 1,
        "user_id": 1,
        "variant_id": 5,
        "quantity": 2,
        "is_selected": true,
        "is_checked_out": true,
        "variant_price_snapshot": 500.00,
        "adjustment_amount_snapshot": 0,
        "variant": {
          "id": 5,
          "product_id": 10,
          "name": "Red / Large",
          "price": 500.00,
          "product": {
            "id": 10,
            "name": "Cotton T-Shirt",
            "slug": "cotton-t-shirt",
            "thumbnail": "https://your-domain.com/storage/products/shirt.jpg"
          }
        }
      }
    ],
    "package_snapshot": {
      "id": 1,
      "name": "Standard Packaging",
      "price": 50.00,
      "description": "Standard packaging with bubble wrap",
      "is_active": true
    }
  }
}
```

### Error Response (404 Not Found)

```json
{
  "success": false,
  "message": "Order not found.",
  "data": null
}
```

---

## 3️⃣ Get Order by Reference ID

Check order status using order reference ID (useful after payment redirect).

### Endpoint
```http
GET /api/mobile/orders/{orderReferenceId}
```

### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `orderReferenceId` | string | Yes | Order Reference ID (e.g., "202511071ABCDEF") |

### Example Request

```http
GET /api/mobile/orders/202511071ABCDEF
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...
Accept: application/json
```

### Success Response (200 OK)

```json
{
  "success": true,
  "message": "Order status retrieved.",
  "data": {
    "order_reference_id": "202511071ABCDEF",
    "order_status": "processing",
    "total_price": 1500.00,
    "paid_at": "2025-11-07 14:30:00",
    "payment_type": "online",
    "payment_method_used": "gcash",
    "package_snapshot": {
      "id": 1,
      "name": "Standard Packaging",
      "price": 50.00,
      "description": "Standard packaging with bubble wrap",
      "is_active": true
    },
    "shipping_address": {
      "id": 1,
      "name": "John Doe",
      "phone": "+639171234567",
      "address": "123 Main St, Barangay San Isidro",
      "city": "Manila",
      "province": "Metro Manila",
      "postal_code": "1000",
      "is_default": true
    },
    "cart_items": [
      {
        "id": 1,
        "user_id": 1,
        "variant_id": 5,
        "quantity": 2,
        "variant_price_snapshot": 500.00,
        "adjustment_amount_snapshot": 0,
        "variant": {
          "id": 5,
          "product_id": 10,
          "name": "Red / Large",
          "price": 500.00,
          "product": {
            "id": 10,
            "name": "Cotton T-Shirt",
            "thumbnail": "https://your-domain.com/storage/products/shirt.jpg"
          }
        }
      }
    ],
    "payments": [
      {
        "id": 1,
        "provider": "paymongo",
        "status": "paid",
        "amount": 1500.00,
        "payment_intent_id": "pi_1234567890abcdef",
        "checkout_session_id": "cs_9876543210fedcba",
        "order_reference_id": "202511071ABCDEF",
        "created_at": "2025-11-07 14:30:00"
      }
    ]
  }
}
```

### Error Response (404 Not Found)

```json
{
  "success": false,
  "message": "Order not found.",
  "data": null
}
```

---

## 🏷️ Tab Filtering Logic (Shopee-style)

To implement tabs similar to Shopee, use these filters:

### 1️⃣ **To Pay Tab**

**Display:** Orders that are placed but not yet paid

**API Request:**
```http
GET /api/orders?filter[order_status]=placed
```

**Logic:**
- `order_status = 'placed'`
- `paid_at IS NULL`

**What to Display:**
- Order reference number
- Total amount
- Order items with thumbnails
- "Pay Now" button
- "Cancel Order" button

---

### 2️⃣ **To Ship Tab**

**Display:** Orders that are paid and being prepared

**API Request:**
```http
GET /api/orders?filter[order_status]=processing
```

**Logic:**
- `order_status = 'processing'`
- `paid_at IS NOT NULL`

**What to Display:**
- Order reference number
- Payment confirmation badge
- Order items
- "Track Order" button
- "Contact Seller" button
- Estimated preparation time

**Note:** After payment webhook, orders automatically move from `placed` to `processing`.

---

### 3️⃣ **To Receive Tab**

**Display:** Orders that are shipped or ready for pickup

**API Request (For Delivery):**
```http
GET /api/orders?filter[order_status]=out_for_delivery
```

**API Request (For Pickup):**
```http
GET /api/orders?filter[order_status]=ready_for_pickup
```

**Logic:**
- `order_status IN ('out_for_delivery', 'ready_for_pickup')`

**What to Display:**

**For Delivery (`out_for_delivery`):**
- Tracking information
- Courier details
- Estimated delivery date
- "Track Shipment" button
- "Contact Courier" button

**For Pickup (`ready_for_pickup`):**
- Pickup location address
- Pickup hours
- QR code or pickup code
- "Get Directions" button
- "Call Store" button

---

### 4️⃣ **Completed Tab**

**Display:** Delivered and finalized orders

**API Request:**
```http
GET /api/orders?filter[order_status]=delivered
```

**Or for fully completed:**
```http
GET /api/orders?filter[order_status]=completed
```

**Logic:**
- `order_status IN ('delivered', 'completed')`

**What to Display:**
- Order reference number
- Delivery date
- Order items
- "Rate Order" button (if not rated yet)
- "Request Return" button (if within return period)
- "Reorder" button

---

### 5️⃣ **Cancelled / Returned Tab** (Optional)

**Display:** Cancelled or returned orders

**API Request (Cancelled):**
```http
GET /api/orders?filter[order_status]=canceled
```

**API Request (Returned):**
```http
GET /api/orders?filter[order_status]=returned
```

**Logic:**
- `order_status IN ('canceled', 'returned')`

**What to Display:**
- Order reference number
- Cancellation/return reason
- Refund status (if applicable)
- Refund amount
- "Reorder" button

---

## 📦 Response Structures

### Order Object

```json
{
  "id": 1,
  "order_reference_id": "202511071ABCDEF",
  "order_status": "processing",
  "payment_type": "online",
  "payment_method_used": "gcash",
  "delivery_type": "delivery",
  "paid_at": "Nov 07, 2025 at 2:30 PM",
  "is_active": true,
  "total_price": 1500.00,
  "total_item_price": 1350.00,
  "shipping_fee": 150.00,
  "ordered_at": {
    "formatted": "Nov 07, 2025 at 2:15 PM",
    "human": "2 hours ago",
    "timestamp": 1699344900
  },
  "created_at": {...},
  "updated_at": {...},
  "shipping_address_snapshot": {...},
  "cart_items_snapshot": [...],
  "package_snapshot": {...}
}
```

### Shipping Address Snapshot

```json
{
  "id": 1,
  "name": "John Doe",
  "phone": "+639171234567",
  "address": "123 Main St, Barangay San Isidro",
  "city": "Manila",
  "province": "Metro Manila",
  "postal_code": "1000",
  "is_default": true
}
```

### Cart Item Snapshot

```json
{
  "id": 1,
  "user_id": 1,
  "variant_id": 5,
  "quantity": 2,
  "is_selected": true,
  "is_checked_out": true,
  "variant_price_snapshot": 500.00,
  "adjustment_amount_snapshot": 0,
  "created_at": "2025-11-07T14:10:00.000000Z",
  "updated_at": "2025-11-07T14:15:00.000000Z",
  "variant": {
    "id": 5,
    "product_id": 10,
    "name": "Red / Large",
    "price": 500.00,
    "product": {
      "id": 10,
      "name": "Cotton T-Shirt",
      "slug": "cotton-t-shirt",
      "thumbnail": "https://your-domain.com/storage/products/shirt.jpg"
    }
  }
}
```

### Package Snapshot

```json
{
  "id": 1,
  "name": "Standard Packaging",
  "price": 50.00,
  "description": "Standard packaging with bubble wrap",
  "is_active": true
}
```

### Payment Object

```json
{
  "id": 1,
  "provider": "paymongo",
  "status": "paid",
  "amount": 1500.00,
  "payment_intent_id": "pi_1234567890abcdef",
  "checkout_session_id": "cs_9876543210fedcba",
  "order_reference_id": "202511071ABCDEF",
  "created_at": "2025-11-07 14:30:00"
}
```

### Order Status Log Object

```json
{
  "id": 1,
  "order_id": 1,
  "status": "placed",
  "description": "Order has been placed.",
  "created_at": "2025-11-07 14:15:00",
  "updated_at": "2025-11-07 14:15:00"
}
```

### Pagination Meta

```json
{
  "current_page": 1,
  "from": 1,
  "last_page": 5,
  "path": "https://your-domain.com/api/orders",
  "per_page": 15,
  "to": 15,
  "total": 75
}
```

### Pagination Links

```json
{
  "first": "https://your-domain.com/api/orders?page=1",
  "last": "https://your-domain.com/api/orders?page=5",
  "prev": null,
  "next": "https://your-domain.com/api/orders?page=2"
}
```

---

## 🔑 Important Field Explanations

### **`order_status`**
- **Type:** String (enum)
- **Purpose:** Tracks the current lifecycle stage of the order
- **Values:** `placed`, `paid`, `processing`, `out_for_delivery`, `ready_for_pickup`, `delivered`, `completed`, `canceled`, `returned`
- **Use:** This is the **primary field** for filtering orders by tabs

**Current Flow:**
```
placed → processing → out_for_delivery → delivered → completed
```

---

### **`paid_at`**
- **Type:** Timestamp (nullable, formatted as string)
- **Purpose:** Records when payment was successfully received
- **Format:** `"Nov 07, 2025 at 2:30 PM"` or `null`
- **Use:** Determine if an order has been paid

**Logic:**
- `paid_at = null` → Order not paid yet (show in "To Pay" tab)
- `paid_at != null` → Order has been paid (show in other tabs)

**Important:** This field is critical for filtering "To Pay" vs other tabs!

---

### **`payment_type`**
- **Type:** String (enum, nullable)
- **Values:** `online`, `cod` (Cash on Delivery)
- **Purpose:** Indicates the payment method chosen by customer
- **Note:** Currently only `online` is implemented via Paymongo

---

### **`payment_method_used`**
- **Type:** String (nullable)
- **Values:** `gcash`, `paymaya`, `card`, `grab_pay`, etc.
- **Purpose:** Specific payment method used (set after payment completion)
- **Use:** Display payment method icon/badge in order details

---

### **`delivery_type`**
- **Type:** String
- **Values:** `delivery`, `pickup`
- **Default:** `delivery`
- **Purpose:** Determines if order is for delivery or pickup

**Use:**
- If `delivery` → Show delivery address and courier info
- If `pickup` → Show pickup location and store info

---

### **`total_price`**
- **Type:** Decimal
- **Purpose:** Total order amount (items + shipping + package)
- **Format:** Already divided by 100 (e.g., `1500.00` means ₱1,500.00)

---

### **`total_item_price`**
- **Type:** Decimal
- **Purpose:** Sum of all cart items only (excluding shipping and package)
- **Format:** Already divided by 100

---

### **`shipping_fee`**
- **Type:** Decimal
- **Purpose:** Delivery/shipping cost
- **Format:** Already divided by 100
- **Note:** Currently set to 0 in checkout flow

---

### **`order_reference_id`**
- **Type:** String
- **Format:** `YYYYMMDD{ULID}` (e.g., `202511071ABCDEF`)
- **Purpose:** Unique identifier for the order
- **Use:** Display to user as order number, use for tracking

---

### **`shipping_address_snapshot`**
- **Type:** JSON Object
- **Purpose:** Frozen copy of delivery address at time of order
- **Why Snapshot:** Preserves address even if user later changes their default address

---

### **`cart_items_snapshot`**
- **Type:** JSON Array
- **Purpose:** Frozen copy of cart items at time of order
- **Why Snapshot:** Preserves product details, prices, and variants even if they change later

---

### **`package_snapshot`**
- **Type:** JSON Object
- **Purpose:** Frozen copy of selected package at time of order
- **Why Snapshot:** Preserves package details even if it's deleted or price changes

---

## 🔔 Payment Webhook Flow

Understanding how orders transition from `placed` to `processing`:

1. **User Completes Payment** on Paymongo checkout page
2. **Paymongo Sends Webhook** to `/api/paymongo/webhook`
3. **Webhook Handler** (`PaymongoWebhookController`) receives event
4. **Payment Job Dispatched** (`PaymongoPaymentSuccessJob`)
5. **Order Updated:**
   - `paid_at` → Set to current timestamp
   - `order_status` → Changed from `placed` to `processing`
   - `payment_type` → Set to `online`
   - `payment_method_used` → Set (e.g., `gcash`)
6. **Status Log Created** with description: "Order has been paid successfully via {method}"

**Timeline:**
```
Order Created (placed) → User Pays → Webhook (few seconds) → Order Updated (processing)
```

**Note:** There may be a 1-5 second delay between payment and status update due to webhook processing.

---

## ⚡ Performance & Best Practices

### 1. **Pagination**
- Default: 15 orders per page
- Use `page` parameter to load more: `/api/orders?page=2`
- Check `meta.last_page` to know total pages

### 2. **Lazy Loading**
- Load order **list** without includes for fast loading
- Load order **details** with includes only when user taps on an order

**Example:**
```
List View: GET /api/orders?filter[order_status]=processing
Detail View: GET /api/orders/123?include=package,payments,orderStatusLogs
```

### 3. **Caching**
- Cache order lists locally
- Refresh on pull-to-refresh gesture
- Clear cache after payment completion

### 4. **Includes**
- Only include relationships you actually need
- Avoid loading all includes in list view (slower performance)

---

## 🐛 Error Handling

### HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | Process data normally |
| 401 | Unauthorized | Token expired/invalid - redirect to login |
| 404 | Not Found | Order doesn't exist - show error message |
| 422 | Validation Error | Invalid parameters - show validation errors |
| 500 | Server Error | Something went wrong - show generic error |

### Error Response Format

```json
{
  "success": false,
  "message": "Error message here",
  "data": null
}
```

### Common Errors

#### 1. Unauthorized (401)
```json
{
  "message": "Unauthenticated."
}
```
**Action:** Clear local token, redirect to login

#### 2. Order Not Found (404)
```json
{
  "success": false,
  "message": "Order not found.",
  "data": null
}
```
**Action:** Show "Order not found" message

#### 3. Validation Error (422)
```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "filter.order_status": [
      "The selected filter.order_status is invalid."
    ]
  }
}
```
**Action:** Show validation error messages

---

## 📊 Summary Table: Tab Filters

| Tab | API Endpoint | Status Filter | `paid_at` Logic |
|-----|-------------|---------------|-----------------|
| **To Pay** | `/api/orders?filter[order_status]=placed` | `placed` | `NULL` |
| **To Ship** | `/api/orders?filter[order_status]=processing` | `processing` | `NOT NULL` |
| **To Receive (Delivery)** | `/api/orders?filter[order_status]=out_for_delivery` | `out_for_delivery` | `NOT NULL` |
| **To Receive (Pickup)** | `/api/orders?filter[order_status]=ready_for_pickup` | `ready_for_pickup` | `NOT NULL` |
| **Completed** | `/api/orders?filter[order_status]=delivered` or `completed` | `delivered`, `completed` | `NOT NULL` |
| **Cancelled** | `/api/orders?filter[order_status]=canceled` | `canceled` | `NULL` or `NOT NULL` |
| **Returned** | `/api/orders?filter[order_status]=returned` | `returned` | `NOT NULL` |

---

## 📌 Quick Reference

### Get All Orders (No Filter)
```http
GET /api/orders
```

### Get "To Pay" Orders
```http
GET /api/orders?filter[order_status]=placed
```

### Get "To Ship" Orders
```http
GET /api/orders?filter[order_status]=processing
```

### Get "To Receive" Orders
```http
GET /api/orders?filter[order_status]=out_for_delivery
```

### Get "Completed" Orders
```http
GET /api/orders?filter[order_status]=delivered
```

### Get Order Details with All Relationships
```http
GET /api/orders/123?include=package,payments,orderStatusLogs
```

### Check Order After Payment
```http
GET /api/mobile/orders/{orderReferenceId}
```

---

**Last Updated:** November 24, 2025
**Version:** 1.0
