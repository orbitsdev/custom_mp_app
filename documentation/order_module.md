# Orders Module API Documentation

## Overview

The Orders Module provides endpoints for mobile applications to manage and retrieve user orders with support for filtering, pagination, and infinite scrolling. The API is built using Laravel's Spatie QueryBuilder for flexible filtering and includes comprehensive order status management.

---

## Base URL

```
/api/mobile/orders
```

---

## Authentication

All endpoints require authentication using Bearer token:

```http
Authorization: Bearer {access_token}
```

---

## Endpoints

### 1. List Orders (with Pagination & Filters)

Retrieve a paginated list of orders for the authenticated user.

#### Endpoint

```http
GET /api/mobile/orders
```

#### Default Behavior

- **Without any filters**: Returns orders with `order_status = "pending"`
- **With filters applied**: Returns orders matching the filter criteria
- **Pagination**: 15 orders per page
- **Sorting**: Latest orders first (by `created_at` desc)

#### Query Parameters

| Parameter | Type | Required | Description | Example |
|-----------|------|----------|-------------|---------|
| `page` | integer | No | Page number for pagination | `?page=2` |
| `filter[order_status]` | string | No | Filter by order status | `?filter[order_status]=completed` |
| `filter[is_paid]` | boolean | No | Filter by payment status | `?filter[is_paid]=1` |
| `filter[is_active]` | boolean | No | Filter by active status | `?filter[is_active]=1` |
| `filter[payment_type]` | string | No | Filter by payment type | `?filter[payment_type]=cod` |
| `filter[delivery_type]` | string | No | Filter by delivery type | `?filter[delivery_type]=delivery` |
| `include` | string | No | Load relationships | `?include=package,payments` |

#### Available Order Statuses

- `pending` - Order is pending (default filter)
- `placed` - Order has been placed
- `cancelled` - Order was cancelled
- `processing` - Order is being processed
- `paid` - Order has been paid
- `preparing` - Order is being prepared
- `out_for_delivery` - Order is out for delivery
- `delivered` - Order has been delivered
- `returned` - Order was returned
- `ready_for_pickup` - Order is ready for pickup
- `completed` - Order is completed

#### Available Includes

- `user` - Include user information
- `package` - Include package details
- `payments` - Include payment records
- `orderStatusLogs` - Include order status change history

#### Request Examples

**1. Get pending orders (default)**
```http
GET /api/mobile/orders
```

**2. Get all orders (remove default pending filter)**
```http
GET /api/mobile/orders?filter[order_status]=
```

**3. Get completed orders**
```http
GET /api/mobile/orders?filter[order_status]=completed
```

**4. Get paid orders**
```http
GET /api/mobile/orders?filter[is_paid]=1
```

**5. Get orders with pagination**
```http
GET /api/mobile/orders?page=2
```

**6. Get orders with relationships**
```http
GET /api/mobile/orders?include=package,payments,orderStatusLogs
```

**7. Get delivered orders with package info**
```http
GET /api/mobile/orders?filter[order_status]=delivered&include=package
```

**8. Get orders for pickup**
```http
GET /api/mobile/orders?filter[delivery_type]=pickup
```

#### Success Response

**Status Code:** `200 OK`

```json
{
  "status": true,
  "message": "Orders retrieved successfully.",
  "data": {
    "items": [
      {
        "id": 1,
        "order_reference_id": "ORD-2025-001",
        "order_status": "pending",
        "payment_type": "cod",
        "payment_method_used": null,
        "delivery_type": "delivery",
        "is_paid": false,
        "is_active": true,
        "total_price": 150.50,
        "total_item_price": 140.50,
        "shipping_fee": 10.00,
        "ordered_at": {
          "formatted": "Nov 24, 2025 at 10:30 AM",
          "human": "2 hours ago",
          "timestamp": 1732449000
        },
        "created_at": {
          "formatted": "Nov 24, 2025 at 10:00 AM",
          "human": "2 hours ago",
          "timestamp": 1732447200
        },
        "updated_at": {
          "formatted": "Nov 24, 2025 at 10:00 AM",
          "human": "2 hours ago",
          "timestamp": 1732447200
        },
        "user": null,
        "package": null,
        "payments": [],
        "order_status_logs": null,
        "shipping_address_snapshot": {
          "name": "John Doe",
          "phone": "+1234567890",
          "address": "123 Main St",
          "city": "New York",
          "zipcode": "10001"
        },
        "cart_items_snapshot": [
          {
            "product_id": 5,
            "product_name": "Sample Product",
            "quantity": 2,
            "price": 70.25
          }
        ],
        "package_snapshot": {
          "name": "Standard Package",
          "price": 10.00
        }
      },
      {
        "id": 2,
        "order_reference_id": "ORD-2025-002",
        "order_status": "pending",
        "payment_type": "gcash",
        "payment_method_used": "gcash",
        "delivery_type": "pickup",
        "is_paid": true,
        "is_active": true,
        "total_price": 250.00,
        "total_item_price": 250.00,
        "shipping_fee": 0.00,
        "ordered_at": {
          "formatted": "Nov 24, 2025 at 9:15 AM",
          "human": "3 hours ago",
          "timestamp": 1732444500
        },
        "created_at": {
          "formatted": "Nov 24, 2025 at 9:00 AM",
          "human": "3 hours ago",
          "timestamp": 1732443600
        },
        "updated_at": {
          "formatted": "Nov 24, 2025 at 9:20 AM",
          "human": "3 hours ago",
          "timestamp": 1732444800
        },
        "user": null,
        "package": null,
        "payments": [],
        "order_status_logs": null,
        "shipping_address_snapshot": null,
        "cart_items_snapshot": [
          {
            "product_id": 8,
            "product_name": "Another Product",
            "quantity": 1,
            "price": 250.00
          }
        ],
        "package_snapshot": null
      }
    ],
    "pagination": {
      "current_page": 1,
      "last_page": 15,
      "per_page": 15,
      "total": 215,
      "next_page_url": "http://yourdomain.com/api/mobile/orders?page=2",
      "prev_page_url": null
    }
  }
}
```

#### Success Response (with Includes)

**Request:**
```http
GET /api/mobile/orders?include=package,payments
```

**Response:**
```json
{
  "status": true,
  "message": "Orders retrieved successfully.",
  "data": {
    "items": [
      {
        "id": 1,
        "order_reference_id": "ORD-2025-001",
        "order_status": "processing",
        "payment_type": "gcash",
        "payment_method_used": "gcash",
        "delivery_type": "delivery",
        "is_paid": true,
        "is_active": true,
        "total_price": 150.50,
        "total_item_price": 140.50,
        "shipping_fee": 10.00,
        "ordered_at": {
          "formatted": "Nov 24, 2025 at 10:30 AM",
          "human": "2 hours ago",
          "timestamp": 1732449000
        },
        "created_at": {
          "formatted": "Nov 24, 2025 at 10:00 AM",
          "human": "2 hours ago",
          "timestamp": 1732447200
        },
        "updated_at": {
          "formatted": "Nov 24, 2025 at 10:30 AM",
          "human": "2 hours ago",
          "timestamp": 1732449000
        },
        "user": null,
        "package": {
          "id": 1,
          "name": "Standard Package",
          "description": "Standard delivery package",
          "price": 10.00,
          "delivery_days": "3-5 days"
        },
        "payments": [
          {
            "id": 1,
            "order_id": 1,
            "amount": 150.50,
            "status": "completed",
            "payment_method": "gcash",
            "transaction_id": "TXN123456",
            "created_at": "2025-11-24 10:10:00"
          }
        ],
        "order_status_logs": null,
        "shipping_address_snapshot": {
          "name": "John Doe",
          "phone": "+1234567890",
          "address": "123 Main St",
          "city": "New York",
          "zipcode": "10001"
        },
        "cart_items_snapshot": [
          {
            "product_id": 5,
            "product_name": "Sample Product",
            "quantity": 2,
            "price": 70.25
          }
        ],
        "package_snapshot": {
          "name": "Standard Package",
          "price": 10.00
        }
      }
    ],
    "pagination": {
      "current_page": 1,
      "last_page": 1,
      "per_page": 15,
      "total": 1,
      "next_page_url": null,
      "prev_page_url": null
    }
  }
}
```

#### Error Response

**Status Code:** `401 Unauthorized`

```json
{
  "status": false,
  "message": "Unauthenticated."
}
```

---

### 2. Get Single Order Details

Retrieve detailed information about a specific order.

#### Endpoint

```http
GET /api/mobile/orders/{id}
```

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `id` | integer | Yes | Order ID |

#### Request Example

```http
GET /api/mobile/orders/1
```

#### Success Response

**Status Code:** `200 OK`

```json
{
  "status": true,
  "message": "Order details retrieved successfully.",
  "data": {
    "id": 1,
    "order_reference_id": "ORD-2025-001",
    "order_status": "delivered",
    "payment_type": "gcash",
    "payment_method_used": "gcash",
    "delivery_type": "delivery",
    "is_paid": true,
    "is_active": true,
    "total_price": 150.50,
    "total_item_price": 140.50,
    "shipping_fee": 10.00,
    "ordered_at": {
      "formatted": "Nov 24, 2025 at 10:30 AM",
      "human": "5 hours ago",
      "timestamp": 1732449000
    },
    "created_at": {
      "formatted": "Nov 24, 2025 at 10:00 AM",
      "human": "5 hours ago",
      "timestamp": 1732447200
    },
    "updated_at": {
      "formatted": "Nov 24, 2025 at 3:30 PM",
      "human": "30 minutes ago",
      "timestamp": 1732467000
    },
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com"
    },
    "package": {
      "id": 1,
      "name": "Standard Package",
      "description": "Standard delivery package",
      "price": 10.00,
      "delivery_days": "3-5 days"
    },
    "payments": [
      {
        "id": 1,
        "order_id": 1,
        "amount": 150.50,
        "status": "completed",
        "payment_method": "gcash",
        "transaction_id": "TXN123456",
        "created_at": "2025-11-24 10:10:00"
      }
    ],
    "order_status_logs": [
      {
        "id": 1,
        "order_id": 1,
        "status": "pending",
        "created_at": "2025-11-24 10:00:00"
      },
      {
        "id": 2,
        "order_id": 1,
        "status": "processing",
        "created_at": "2025-11-24 10:30:00"
      },
      {
        "id": 3,
        "order_id": 1,
        "status": "out_for_delivery",
        "created_at": "2025-11-24 14:00:00"
      },
      {
        "id": 4,
        "order_id": 1,
        "status": "delivered",
        "created_at": "2025-11-24 15:30:00"
      }
    ],
    "shipping_address_snapshot": {
      "name": "John Doe",
      "phone": "+1234567890",
      "address": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zipcode": "10001",
      "country": "USA"
    },
    "cart_items_snapshot": [
      {
        "product_id": 5,
        "product_name": "Sample Product",
        "product_image": "https://example.com/image.jpg",
        "variant_id": 10,
        "variant_name": "Red - Large",
        "quantity": 2,
        "price": 70.25,
        "total": 140.50
      }
    ],
    "package_snapshot": {
      "id": 1,
      "name": "Standard Package",
      "description": "Standard delivery package",
      "price": 10.00,
      "delivery_days": "3-5 days"
    }
  }
}
```

#### Error Responses

**Status Code:** `404 Not Found`

```json
{
  "status": false,
  "message": "Order not found or does not belong to the authenticated user."
}
```

**Status Code:** `401 Unauthorized`

```json
{
  "status": false,
  "message": "Unauthenticated."
}
```

---

## Mobile App Integration Guide

### Infinite Scroll Implementation

The API is designed to support infinite scrolling for optimal performance when loading large order lists.

#### Example Flow (React Native / Flutter)

**1. Initial Load - Fetch Pending Orders**
```javascript
// On page open, load first page of pending orders
const response = await fetch('/api/mobile/orders', {
  headers: {
    'Authorization': `Bearer ${accessToken}`
  }
});

// Parse response
const data = await response.json();
const orders = data.data.items;
const pagination = data.data.pagination;

// Display orders
// Store next_page_url for infinite scroll
```

**2. Load More on Scroll**
```javascript
// When user scrolls to bottom
if (pagination.next_page_url) {
  const nextResponse = await fetch(pagination.next_page_url, {
    headers: {
      'Authorization': `Bearer ${accessToken}`
    }
  });

  const nextData = await nextResponse.json();

  // Append new orders to existing list
  orders.push(...nextData.data.items);

  // Update pagination info
  pagination = nextData.data.pagination;
}
```

**3. Filter by Status**
```javascript
// User selects "Completed" filter
const response = await fetch('/api/mobile/orders?filter[order_status]=completed', {
  headers: {
    'Authorization': `Bearer ${accessToken}`
  }
});

// Replace current order list with filtered results
const data = await response.json();
orders = data.data.items;
```

### Status Tabs Implementation

Create tabs in your mobile app for different order statuses:

```javascript
const orderTabs = [
  { label: 'Pending', filter: 'pending' },
  { label: 'Processing', filter: 'processing' },
  { label: 'Delivered', filter: 'delivered' },
  { label: 'Completed', filter: 'completed' },
  { label: 'All', filter: '' } // Empty filter for all orders
];

// When tab is selected
async function loadOrdersByStatus(status) {
  const filterParam = status ? `?filter[order_status]=${status}` : '?filter[order_status]=';
  const response = await fetch(`/api/mobile/orders${filterParam}`, {
    headers: {
      'Authorization': `Bearer ${accessToken}`
    }
  });

  const data = await response.json();
  return data.data.items;
}
```

---

## Performance Considerations

1. **Pagination**: 15 orders per page prevents loading too much data at once
2. **Default Filter**: Defaults to pending orders to show most relevant data first
3. **Lazy Loading**: Use `include` parameter only when relationships are needed
4. **Infinite Scroll**: Load pages incrementally as user scrolls
5. **Caching**: Consider caching order lists on mobile device for offline viewing

---

## Example Use Cases

### Use Case 1: Order History Screen

```http
GET /api/mobile/orders?filter[order_status]=completed&include=package&page=1
```

Show completed orders with package details for order history.

### Use Case 2: Track Active Order

```http
GET /api/mobile/orders/{id}
```

Show real-time status updates with full order details and status logs.

### Use Case 3: Pending Orders Dashboard

```http
GET /api/mobile/orders
```

Default view shows all pending orders waiting for user action.

### Use Case 4: Filter Unpaid Orders

```http
GET /api/mobile/orders?filter[is_paid]=0
```

Show orders that still need payment.

---

## Field Descriptions

### Order Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | integer | Unique order identifier |
| `order_reference_id` | string | Human-readable order reference |
| `order_status` | string | Current order status (see statuses list) |
| `payment_type` | string | Payment method type (cod, gcash, paymaya, etc.) |
| `payment_method_used` | string | Actual payment method used |
| `delivery_type` | string | Delivery or pickup |
| `is_paid` | boolean | Payment status |
| `is_active` | boolean | Order active status |
| `total_price` | decimal | Total order price including shipping |
| `total_item_price` | decimal | Total price of items only |
| `shipping_fee` | decimal | Shipping/delivery fee |
| `ordered_at` | object | When order was placed (formatted, human, timestamp) |
| `created_at` | object | Order creation timestamp (formatted, human, timestamp) |
| `updated_at` | object | Last update timestamp (formatted, human, timestamp) |

### Date Format

All date fields (`ordered_at`, `created_at`, `updated_at`) return an object with three formats for maximum flexibility:

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `formatted` | string | Human-readable formatted date | "Nov 24, 2025 at 10:30 AM" |
| `human` | string | Relative time from now | "2 hours ago", "3 days ago" |
| `timestamp` | integer | Unix timestamp for calculations | 1732449000 |

**Usage Examples:**

```javascript
// Display relative time in UI
order.created_at.human // "2 hours ago"

// Display full formatted date
order.ordered_at.formatted // "Nov 24, 2025 at 10:30 AM"

// Use timestamp for sorting or calculations
const orderDate = new Date(order.created_at.timestamp * 1000)
```

### Snapshot Fields

These fields contain historical data captured at the time of order placement:

- `shipping_address_snapshot`: Address details when order was placed
- `cart_items_snapshot`: Cart items with prices at order time
- `package_snapshot`: Package/shipping details at order time

---

## Error Codes

| HTTP Code | Description |
|-----------|-------------|
| 200 | Success |
| 401 | Unauthorized - Invalid or missing token |
| 404 | Not Found - Order doesn't exist or doesn't belong to user |
| 422 | Validation Error - Invalid parameters |
| 500 | Server Error - Internal server error |

---

## Notes

- All monetary values are in decimal format (e.g., 150.50)
- All datetime fields return three formats: `formatted` (human-readable), `human` (relative time), and `timestamp` (Unix timestamp)
- Orders are scoped to the authenticated user automatically
- Snapshots preserve historical data even if related records are modified later
- Order status logs provide complete audit trail of status changes
- The `human` date format updates dynamically based on current time (e.g., "2 hours ago" becomes "3 hours ago" after an hour)

---

## Support

For issues or questions about the Orders API, please contact the development team or refer to the main API documentation.
