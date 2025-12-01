# Review API Documentation

## Overview
This document provides comprehensive documentation for the Review API endpoints. The API allows users to create, read, update, and delete product reviews, as well as retrieve review statistics.

## Base URL
All endpoints are prefixed with `/api/mobile/` (adjust based on your API configuration)

## Authentication
All endpoints require authentication via Bearer token unless specified otherwise.

---

## Endpoints

### 1. Get Product Reviews

Retrieve paginated reviews for a specific product with advanced filtering and sorting capabilities.

**Endpoint:** `GET /products/{product}/reviews`

**Authentication:** Optional

**Path Parameters:**
- `product` (integer, required) - The product ID

**Query Parameters:**
- `per_page` (integer, optional) - Number of results per page (default: 15)
- `page` (integer, optional) - Page number for pagination
- `include` (string, optional) - Related data to include (comma-separated: `user`, `product`, `media`)
- `sort` (string, optional) - Sort field (prefix with `-` for descending order)

**Available Filters:**
- `filter[rating]` - Filter by exact rating(s). Can be single value or array
  - Example: `filter[rating]=5` or `filter[rating][]=4&filter[rating][]=5`
- `filter[min_rating]` - Filter by minimum rating
  - Example: `filter[min_rating]=3`
- `filter[max_rating]` - Filter by maximum rating
  - Example: `filter[max_rating]=4`
- `filter[has_attachments]` - Filter reviews with images/videos (1 or true)
  - Example: `filter[has_attachments]=1`
- `filter[has_comment]` - Filter reviews with text comments (1 or true)
  - Example: `filter[has_comment]=1`

**Available Sorts:**
- `rating` - Sort by rating (ascending)
- `-rating` - Sort by rating (descending)
- `created_at` - Sort by date (ascending)
- `-created_at` - Sort by date (descending, default)
- `recent` - Alias for `-created_at`
- `highest_rating` - Sort by highest rating first
- `lowest_rating` - Sort by lowest rating first

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Reviews retrieved successfully.",
  "data": [
    {
      "id": 1,
      "rating": 5,
      "comment": "Excellent product!",
      "variant_snapshot": {
        "color": "red",
        "size": "large"
      },
      "created_at": "2025-12-01 10:00:00",
      "updated_at": "2025-12-01 10:00:00",
      "user": {
        "id": 123,
        "name": "John Doe",
        "avatar_url": "https://example.com/storage/avatars/avatar.jpg"
      },
      "product": {
        "id": 456,
        "name": "Product Name",
        "slug": "product-name",
        "thumbnail": "https://example.com/storage/products/thumbnail.jpg"
      },
      "attachments": [
        {
          "id": 1,
          "url": "https://example.com/storage/attachments/image.jpg",
          "mime_type": "image/jpeg",
          "size": 204800,
          "name": "image.jpg"
        }
      ]
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 15,
    "total": 73
  },
  "links": {
    "first": "http://example.com/api/products/456/reviews?page=1",
    "last": "http://example.com/api/products/456/reviews?page=5",
    "prev": null,
    "next": "http://example.com/api/products/456/reviews?page=2"
  }
}
```

**Example Requests:**
```bash
# Get all 5-star reviews
GET /products/456/reviews?filter[rating]=5

# Get reviews with minimum 4 stars, sorted by most recent
GET /products/456/reviews?filter[min_rating]=4&sort=-created_at

# Get reviews with attachments only
GET /products/456/reviews?filter[has_attachments]=1

# Get reviews with ratings 4 or 5, with user and media included
GET /products/456/reviews?filter[rating][]=4&filter[rating][]=5&include=user,media
```

---

### 2. Create Product Review

Create a new review for a specific product. Users can only submit one review per product.

**Endpoint:** `POST /products/{product}/reviews`

**Authentication:** Required

**Path Parameters:**
- `product` (integer, required) - The product ID

**Request Body (multipart/form-data):**
- `rating` (integer, required) - Rating from 1 to 5
- `comment` (string, optional) - Review text (max 1000 characters)
- `variant_snapshot` (object, optional) - Snapshot of product variant details
- `attachments` (file[], optional) - Up to 5 images/videos
  - Allowed formats: jpeg, jpg, png, gif, mp4, mov, avi
  - Max file size: 10MB per file

**Success Response (201 Created):**
```json
{
  "success": true,
  "message": "Review created successfully.",
  "data": {
    "id": 1,
    "rating": 5,
    "comment": "Excellent product!",
    "variant_snapshot": {
      "color": "red",
      "size": "large"
    },
    "created_at": "2025-12-01 10:00:00",
    "updated_at": "2025-12-01 10:00:00",
    "user": {
      "id": 123,
      "name": "John Doe",
      "avatar_url": "https://example.com/storage/avatars/avatar.jpg"
    },
    "product": {
      "id": 456,
      "name": "Product Name",
      "slug": "product-name",
      "thumbnail": "https://example.com/storage/products/thumbnail.jpg"
    },
    "attachments": []
  }
}
```

**Error Responses:**

*Validation Error (422 Unprocessable Entity):*
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "rating": ["The rating field is required."],
    "comment": ["The comment must not be greater than 1000 characters."],
    "attachments": ["The attachments must not have more than 5 items."]
  }
}
```

*Duplicate Review (400 Bad Request):*
```json
{
  "success": false,
  "message": "You have already reviewed this product. Please update your existing review instead."
}
```

*Product Not Found (404 Not Found):*
```json
{
  "success": false,
  "message": "Product not found"
}
```

**Example Request:**
```bash
curl -X POST "http://example.com/api/products/456/reviews" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: multipart/form-data" \
  -F "rating=5" \
  -F "comment=Excellent product!" \
  -F "variant_snapshot[color]=red" \
  -F "variant_snapshot[size]=large" \
  -F "attachments[]=@/path/to/image1.jpg" \
  -F "attachments[]=@/path/to/image2.jpg"
```

---

### 3. Get My Reviews

Retrieve all reviews created by the authenticated user.

**Endpoint:** `GET /reviews/my-reviews`

**Authentication:** Required

**Query Parameters:**
- `per_page` (integer, optional) - Number of results per page (default: 15)
- `page` (integer, optional) - Page number
- `include` (string, optional) - Related data to include (`user`, `product`, `media`)
- `sort` (string, optional) - Sort field

**Available Filters:**
- `filter[rating]` - Filter by rating
- `filter[product_id]` - Filter by exact product ID

**Available Sorts:**
- `rating` / `-rating`
- `created_at` / `-created_at` (default)

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Your reviews retrieved successfully.",
  "data": [
    {
      "id": 1,
      "rating": 5,
      "comment": "Great product!",
      "variant_snapshot": null,
      "created_at": "2025-12-01 10:00:00",
      "updated_at": "2025-12-01 10:00:00",
      "user": {
        "id": 123,
        "name": "John Doe",
        "avatar_url": "https://example.com/storage/avatars/avatar.jpg"
      },
      "product": {
        "id": 456,
        "name": "Product Name",
        "slug": "product-name",
        "thumbnail": "https://example.com/storage/products/thumbnail.jpg"
      },
      "attachments": []
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 2,
    "per_page": 15,
    "total": 23
  }
}
```

**Example Requests:**
```bash
# Get all my reviews
GET /reviews/my-reviews

# Get my 5-star reviews
GET /reviews/my-reviews?filter[rating]=5

# Get my reviews for a specific product
GET /reviews/my-reviews?filter[product_id]=456
```

---

### 4. Get Review Details

Retrieve details of a specific review by ID.

**Endpoint:** `GET /reviews/{id}`

**Authentication:** Optional

**Path Parameters:**
- `id` (integer, required) - The review ID

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Review retrieved successfully.",
  "data": {
    "id": 1,
    "rating": 5,
    "comment": "Excellent product!",
    "variant_snapshot": {
      "color": "red",
      "size": "large"
    },
    "created_at": "2025-12-01 10:00:00",
    "updated_at": "2025-12-01 10:00:00",
    "user": {
      "id": 123,
      "name": "John Doe",
      "avatar_url": "https://example.com/storage/avatars/avatar.jpg"
    },
    "product": {
      "id": 456,
      "name": "Product Name",
      "slug": "product-name",
      "thumbnail": "https://example.com/storage/products/thumbnail.jpg"
    },
    "attachments": [
      {
        "id": 1,
        "url": "https://example.com/storage/attachments/image.jpg",
        "mime_type": "image/jpeg",
        "size": 204800,
        "name": "image.jpg"
      }
    ]
  }
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "message": "Review not found"
}
```

---

### 5. Update Review

Update an existing review. Users can only update their own reviews.

**Endpoint:** `PUT /reviews/{id}`

**Authentication:** Required

**Path Parameters:**
- `id` (integer, required) - The review ID

**Request Body (multipart/form-data or JSON):**
- `rating` (integer, optional) - Rating from 1 to 5
- `comment` (string, optional) - Review text (max 1000 characters)
- `variant_snapshot` (object, optional) - Product variant details
- `attachments` (file[], optional) - Up to 5 images/videos (replaces existing)

**Note:** When updating attachments, all existing attachments are replaced with the new ones.

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Review updated successfully.",
  "data": {
    "id": 1,
    "rating": 4,
    "comment": "Updated review comment",
    "variant_snapshot": {
      "color": "blue"
    },
    "created_at": "2025-12-01 10:00:00",
    "updated_at": "2025-12-01 12:00:00",
    "user": {
      "id": 123,
      "name": "John Doe",
      "avatar_url": "https://example.com/storage/avatars/avatar.jpg"
    },
    "product": {
      "id": 456,
      "name": "Product Name",
      "slug": "product-name",
      "thumbnail": "https://example.com/storage/products/thumbnail.jpg"
    },
    "attachments": []
  }
}
```

**Error Responses:**

*Unauthorized (403 Forbidden):*
```json
{
  "success": false,
  "message": "You can only update your own reviews."
}
```

*Validation Error (422 Unprocessable Entity):*
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "rating": ["The rating must be between 1 and 5."]
  }
}
```

*Review Not Found (404 Not Found):*
```json
{
  "success": false,
  "message": "Review not found"
}
```

**Example Request:**
```bash
curl -X PUT "http://example.com/api/reviews/1" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "rating": 4,
    "comment": "Updated my review after using it more"
  }'
```

---

### 6. Delete Review

Delete an existing review. Users can only delete their own reviews.

**Endpoint:** `DELETE /reviews/{id}`

**Authentication:** Required

**Path Parameters:**
- `id` (integer, required) - The review ID

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Review deleted successfully.",
  "data": null
}
```

**Error Responses:**

*Unauthorized (403 Forbidden):*
```json
{
  "success": false,
  "message": "You can only delete your own reviews."
}
```

*Review Not Found (404 Not Found):*
```json
{
  "success": false,
  "message": "Review not found"
}
```

**Example Request:**
```bash
curl -X DELETE "http://example.com/api/reviews/1" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

### 7. Get Product Review Statistics

Retrieve statistical information about reviews for a specific product.

**Endpoint:** `GET /products/{product}/reviews/statistics`

**Authentication:** Optional

**Path Parameters:**
- `product` (integer, required) - The product ID

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Review statistics retrieved successfully.",
  "data": {
    "total_reviews": 127,
    "average_rating": 4.3,
    "rating_distribution": {
      "5_star": 68,
      "4_star": 32,
      "3_star": 15,
      "2_star": 8,
      "1_star": 4
    }
  }
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "message": "Product not found"
}
```

**Example Request:**
```bash
curl -X GET "http://example.com/api/products/456/reviews/statistics"
```

---

## Common Patterns

### Pagination
All list endpoints return paginated results with the following structure:
- `data`: Array of resources
- `meta`: Pagination metadata (current_page, last_page, per_page, total)
- `links`: Navigation links (first, last, prev, next)

### Filtering
Use the `filter` query parameter with the field name:
```
?filter[field_name]=value
```

For array values:
```
?filter[field_name][]=value1&filter[field_name][]=value2
```

### Sorting
Use the `sort` query parameter:
- Ascending: `?sort=field_name`
- Descending: `?sort=-field_name`
- Multiple: `?sort=-rating,created_at`

### Including Relations
Use the `include` query parameter:
```
?include=user,product,media
```

---

## Business Rules

1. **One Review Per Product:** Users can only submit one review per product. Attempting to create a duplicate will return an error with instructions to update the existing review.

2. **Attachment Limits:** Reviews support up to 5 media attachments (images or videos), each with a maximum size of 10MB.

3. **Ownership Validation:** Users can only update or delete their own reviews. Attempting to modify another user's review will return a 403 Forbidden error.

4. **Rating Range:** Ratings must be integers between 1 and 5 (inclusive).

5. **Comment Length:** Review comments are limited to 1000 characters.

6. **Attachment Replacement:** When updating a review with new attachments, all existing attachments are replaced.

7. **Variant Snapshot:** The `variant_snapshot` field stores product variant details (color, size, etc.) at the time of review creation, providing historical context.

---

## Error Handling

All error responses follow a consistent format:

```json
{
  "success": false,
  "message": "Error description",
  "errors": {
    "field_name": ["Validation error message"]
  }
}
```

### Common HTTP Status Codes
- `200 OK` - Successful GET, PUT, DELETE
- `201 Created` - Successful POST
- `400 Bad Request` - Business logic error (duplicate review)
- `401 Unauthorized` - Missing or invalid authentication token
- `403 Forbidden` - User lacks permission for the action
- `404 Not Found` - Resource not found
- `422 Unprocessable Entity` - Validation error

---

## Testing Examples

### Scenario 1: Create and Update a Review
```bash
# 1. Create a review
curl -X POST "http://example.com/api/products/123/reviews" \
  -H "Authorization: Bearer TOKEN" \
  -F "rating=5" \
  -F "comment=Amazing product!"

# 2. Update the review
curl -X PUT "http://example.com/api/reviews/1" \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"rating": 4, "comment": "Still good after updates"}'
```

### Scenario 2: Filter Product Reviews
```bash
# Get all 5-star reviews with attachments
GET /products/123/reviews?filter[rating]=5&filter[has_attachments]=1

# Get reviews with rating 4 or higher
GET /products/123/reviews?filter[min_rating]=4

# Get reviews sorted by lowest rating first
GET /products/123/reviews?sort=lowest_rating
```

### Scenario 3: View Statistics
```bash
# Get review statistics for product
GET /products/123/reviews/statistics

# Use statistics to show rating breakdown in UI
```

---

## Response Structure

### Review Object Fields

All review responses use the `ReviewResource` transformation and include the following fields:

**Core Fields:**
- `id` (integer) - Unique review identifier
- `rating` (integer) - Rating value (1-5)
- `comment` (string|null) - Review text content
- `variant_snapshot` (object|null) - Product variant details at review time (e.g., color, size)
- `created_at` (string) - Creation timestamp in format "YYYY-MM-DD HH:MM:SS"
- `updated_at` (string) - Last update timestamp in format "YYYY-MM-DD HH:MM:SS"

**User Object** (included when `user` relation is loaded):
- `id` (integer) - User ID
- `name` (string) - User's full name
- `avatar_url` (string) - User's avatar URL or fallback to UI Avatars API
  - Fallback format: `https://ui-avatars.com/api/?name={name}&background=random`

**Product Object** (included when `product` relation is loaded):
- `id` (integer) - Product ID
- `name` (string) - Product name
- `slug` (string) - Product URL slug
- `thumbnail` (string) - Product thumbnail image URL

**Attachments Array** (always included):
- `id` (integer) - Media file ID
- `url` (string) - Full URL to access the media file
- `mime_type` (string) - File MIME type (e.g., "image/jpeg", "video/mp4")
- `size` (integer) - File size in bytes
- `name` (string) - Original filename

### Important Notes:
1. **Date Format:** All timestamps use "YYYY-MM-DD HH:MM:SS" format (not ISO 8601)
2. **Relations:** User and product objects only appear when explicitly loaded
3. **Attachments:** Always included as an array (empty if no attachments)
4. **Avatar Fallback:** If user has no avatar, a generated avatar URL is provided
5. **Foreign Keys:** `user_id` and `product_id` are NOT included in the response (use nested objects instead)

---

## Implementation Notes

### Controller Location
`app/Http/Controllers/Api/Mobile/ReviewController.php`

### Resource Location
`app/Http/Resources/ReviewResource.php`

### Dependencies
- **Spatie Query Builder:** Used for advanced filtering, sorting, and including relations
- **Spatie Media Library:** Used for managing review attachments
- **Laravel Resources:** ReviewResource transforms review data for API responses

### Database Schema
Reviews table includes:
- `user_id` - Foreign key to users table
- `product_id` - Foreign key to products table
- `rating` - Integer (1-5)
- `comment` - Text (nullable)
- `variant_snapshot` - JSON (nullable)
- `created_at`, `updated_at` - Timestamps

### Media Collection
Review attachments are stored in the `attachments` media collection with a limit of 5 items.
