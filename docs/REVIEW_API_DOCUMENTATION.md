# Review API Documentation

## Overview
The Review API allows authenticated users to create, read, update, and delete product reviews with optional media attachments (images and videos). Each review includes ratings, comments, and user information.

## Base URL
```
https://dev.avantefoods.com/api
```

## Authentication
All endpoints require authentication using Bearer token in the Authorization header:
```
Authorization: Bearer {token}
```

---

## API Endpoints Summary

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/products/{id}/reviews` | POST | Create a new review for a product |
| `/products/{id}/reviews` | GET | Get all reviews for a product (with filters) |
| `/products/{id}/reviews/statistics` | GET | Get review statistics for a product |
| `/products/{id}` | GET | Get product details with review summary |
| `/reviews/my-reviews` | GET | Get authenticated user's reviews |
| `/reviews/{id}` | GET | Get specific review details |
| `/reviews/{id}` | PUT | Update a review |
| `/reviews/{id}` | DELETE | Delete a review |

---

## Endpoints

### 1. Create Review

Create a new review for a product with optional media attachments.

**Endpoint:** `POST /products/{product_id}/reviews`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: multipart/form-data
Accept: application/json
```

**Request Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| rating | integer | Yes | Rating from 1 to 5 |
| comment | string | No | Review comment (max 1000 characters) |
| variant_snapshot | array | No | Product variant information snapshot |
| attachments | array | No | Array of image/video files (max 5 files) |

**File Upload Rules:**
- Maximum 5 files per review
- Supported formats: jpeg, jpg, png, gif, mp4, mov, avi
- Maximum file size: 10MB per file
- Server upload limit must be configured accordingly

**Example Request:**
```bash
curl -X POST "https://dev.avantefoods.com/api/products/2/reviews" \
  -H "Authorization: Bearer 43|rRr1yzFo6x7X45KAac8A1I0RXWKbDgxdS2XUgHtka2648948" \
  -H "Accept: application/json" \
  -F "rating=5" \
  -F "comment=This is an amazing product! Highly recommend." \
  -F "attachments[]=@/path/to/image.jpg" \
  -F "attachments[]=@/path/to/video.mp4"
```

**Success Response (201):**
```json
{
  "status": true,
  "message": "Review created successfully.",
  "data": {
    "id": 3,
    "rating": "5",
    "comment": "This is an amazing product! Highly recommend.",
    "variant_snapshot": null,
    "created_at": "2025-11-30 13:17:54",
    "updated_at": "2025-11-30 13:17:54",
    "user": {
      "id": 2,
      "name": "brianon",
      "avatar_url": "https://dev.avantefoods.com/storage/12/avatar.jpg"
    },
    "product": {
      "id": 2,
      "name": "Apple",
      "slug": "apple",
      "thumbnail": "https://dev.avantefoods.com/storage/11/thumbnail.png"
    },
    "attachments": [
      {
        "id": 16,
        "url": "https://dev.avantefoods.com/storage/16/example2.mp4",
        "mime_type": "video/mp4",
        "size": 2746869,
        "name": "example2.mp4"
      }
    ]
  }
}
```

**Error Response (400):**
```json
{
  "status": false,
  "message": "You have already reviewed this product. Please update your existing review instead."
}
```

**Error Response (422):**
```json
{
  "status": false,
  "message": "Validation failed",
  "errors": {
    "rating": ["The rating field is required."],
    "attachments.0": ["The file must be a valid image or video."]
  }
}
```

---

### 2. Get Product Reviews (with Advanced Filtering)

Retrieve all reviews for a specific product with pagination, filtering, and sorting options.

**Endpoint:** `GET /products/{product_id}/reviews`

**Headers:**
```
Authorization: Bearer {token}
Accept: application/json
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| per_page | integer | No | Items per page (default: 15) |
| page | integer | No | Page number (default: 1) |
| filter[rating] | integer or array | No | Filter by specific rating(s) (1-5) |
| filter[has_attachments] | boolean | No | Filter reviews with media attachments (1 = true) |
| filter[has_comment] | boolean | No | Filter reviews with text comments (1 = true) |
| filter[min_rating] | integer | No | Filter by minimum rating (1-5) |
| filter[max_rating] | integer | No | Filter by maximum rating (1-5) |
| sort | string | No | Sort by: `-created_at` (newest), `created_at` (oldest), `-rating` (highest), `rating` (lowest) |
| include | string | No | Include relations: `user`, `product`, `media` |

**Example Requests:**

**Basic request:**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/2/reviews?per_page=10&page=1" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Filter by 5-star reviews only:**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/2/reviews?filter[rating]=5" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Filter by 4 and 5-star reviews:**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/2/reviews?filter[rating][]=4&filter[rating][]=5" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Filter reviews with images/videos only:**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/2/reviews?filter[has_attachments]=1" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Filter reviews with comments only:**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/2/reviews?filter[has_comment]=1" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Filter by minimum rating and sort by highest rating:**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/2/reviews?filter[min_rating]=3&sort=-rating" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Combined filters (4+ stars with attachments, sorted by newest):**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/2/reviews?filter[min_rating]=4&filter[has_attachments]=1&sort=-created_at" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Success Response (200):**
```json
{
  "status": true,
  "message": "Reviews retrieved successfully.",
  "data": {
    "items": [
      {
        "id": 1,
        "rating": 5,
        "comment": "Great product!",
        "variant_snapshot": null,
        "created_at": "2025-11-30 13:07:22",
        "updated_at": "2025-11-30 13:07:22",
        "user": {
          "id": 2,
          "name": "brianon",
          "avatar_url": "https://dev.avantefoods.com/storage/12/avatar.jpg"
        },
        "product": {
          "id": 2,
          "name": "Apple",
          "slug": "apple",
          "thumbnail": "https://dev.avantefoods.com/storage/11/thumbnail.png"
        },
        "attachments": [
          {
            "id": 13,
            "url": "https://dev.avantefoods.com/storage/13/image.jpeg",
            "mime_type": "image/jpeg",
            "size": 120943,
            "name": "image.jpeg"
          }
        ]
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

---

### 3. Get Review Statistics

Get statistical information about reviews for a product.

**Endpoint:** `GET /products/{product_id}/reviews/statistics`

**Headers:**
```
Authorization: Bearer {token}
Accept: application/json
```

**Example Request:**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/2/reviews/statistics" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Success Response (200):**
```json
{
  "status": true,
  "message": "Review statistics retrieved successfully.",
  "data": {
    "total_reviews": 5,
    "average_rating": 4.2,
    "rating_distribution": {
      "5_star": 3,
      "4_star": 1,
      "3_star": 1,
      "2_star": 0,
      "1_star": 0
    }
  }
}
```

---

### 4. Get My Reviews (with Filtering)

Retrieve all reviews created by the authenticated user with filtering and sorting options.

**Endpoint:** `GET /reviews/my-reviews`

**Headers:**
```
Authorization: Bearer {token}
Accept: application/json
```

**Query Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| per_page | integer | No | Items per page (default: 15) |
| page | integer | No | Page number (default: 1) |
| filter[rating] | integer | No | Filter by specific rating (1-5) |
| filter[product_id] | integer | No | Filter by specific product ID |
| sort | string | No | Sort by: `rating`, `created_at`, `-rating`, `-created_at` |
| include | string | No | Include relations: `user`, `product`, `media` |

**Example Requests:**

**Basic request:**
```bash
curl -X GET "https://dev.avantefoods.com/api/reviews/my-reviews" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Filter by rating:**
```bash
curl -X GET "https://dev.avantefoods.com/api/reviews/my-reviews?filter[rating]=5" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Filter by product:**
```bash
curl -X GET "https://dev.avantefoods.com/api/reviews/my-reviews?filter[product_id]=2" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Sort by newest first:**
```bash
curl -X GET "https://dev.avantefoods.com/api/reviews/my-reviews?sort=-created_at" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Success Response (200):**
```json
{
  "status": true,
  "message": "Your reviews retrieved successfully.",
  "data": {
    "items": [
      {
        "id": 1,
        "rating": 5,
        "comment": "Excellent product!",
        "variant_snapshot": null,
        "created_at": "2025-11-30 13:07:22",
        "updated_at": "2025-11-30 13:07:22",
        "user": {
          "id": 2,
          "name": "brianon",
          "avatar_url": "https://dev.avantefoods.com/storage/12/avatar.jpg"
        },
        "product": {
          "id": 2,
          "name": "Apple",
          "slug": "apple",
          "thumbnail": "https://dev.avantefoods.com/storage/11/thumbnail.png"
        },
        "attachments": []
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

---

### 5. Get Specific Review

Retrieve details of a specific review by ID.

**Endpoint:** `GET /reviews/{review_id}`

**Headers:**
```
Authorization: Bearer {token}
Accept: application/json
```

**Example Request:**
```bash
curl -X GET "https://dev.avantefoods.com/api/reviews/1" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Success Response (200):**
```json
{
  "status": true,
  "message": "Review retrieved successfully.",
  "data": {
    "id": 1,
    "rating": 4,
    "comment": "Good product!",
    "variant_snapshot": null,
    "created_at": "2025-11-30 13:07:22",
    "updated_at": "2025-11-30 13:08:39",
    "user": {
      "id": 2,
      "name": "brianon",
      "avatar_url": "https://dev.avantefoods.com/storage/12/avatar.jpg"
    },
    "product": {
      "id": 2,
      "name": "Apple",
      "slug": "apple",
      "thumbnail": "https://dev.avantefoods.com/storage/11/thumbnail.png"
    },
    "attachments": [
      {
        "id": 14,
        "url": "https://dev.avantefoods.com/storage/14/image.jpeg",
        "mime_type": "image/jpeg",
        "size": 120943,
        "name": "image.jpeg"
      }
    ]
  }
}
```

**Error Response (404):**
```json
{
  "status": false,
  "message": "Review not found."
}
```

---

### 6. Update Review

Update an existing review. Users can only update their own reviews.

**Endpoint:** `PUT /reviews/{review_id}`

**Note:** When uploading files with PUT, use POST with `_method=PUT` query parameter.

**Headers:**
```
Authorization: Bearer {token}
Content-Type: multipart/form-data
Accept: application/json
```

**Request Parameters:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| rating | integer | No | Rating from 1 to 5 |
| comment | string | No | Review comment (max 1000 characters) |
| variant_snapshot | array | No | Product variant information snapshot |
| attachments | array | No | Array of image/video files (max 5 files) |

**Note:** When attachments are provided, they replace ALL existing attachments.

**Example Request:**
```bash
curl -X POST "https://dev.avantefoods.com/api/reviews/1?_method=PUT" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json" \
  -F "rating=4" \
  -F "comment=Updated review comment" \
  -F "attachments[]=@/path/to/new-image.jpg"
```

**Success Response (200):**
```json
{
  "status": true,
  "message": "Review updated successfully.",
  "data": {
    "id": 1,
    "rating": "4",
    "comment": "Updated review comment",
    "variant_snapshot": null,
    "created_at": "2025-11-30 13:07:22",
    "updated_at": "2025-11-30 13:20:15",
    "user": {
      "id": 2,
      "name": "brianon",
      "avatar_url": "https://dev.avantefoods.com/storage/12/avatar.jpg"
    },
    "product": {
      "id": 2,
      "name": "Apple",
      "slug": "apple",
      "thumbnail": "https://dev.avantefoods.com/storage/11/thumbnail.png"
    },
    "attachments": [
      {
        "id": 17,
        "url": "https://dev.avantefoods.com/storage/17/new-image.jpg",
        "mime_type": "image/jpeg",
        "size": 95432,
        "name": "new-image.jpg"
      }
    ]
  }
}
```

**Error Response (403):**
```json
{
  "status": false,
  "message": "You can only update your own reviews."
}
```

---

### 7. Delete Review

Delete a review. Users can only delete their own reviews.

**Endpoint:** `DELETE /reviews/{review_id}`

**Headers:**
```
Authorization: Bearer {token}
Accept: application/json
```

**Example Request:**
```bash
curl -X DELETE "https://dev.avantefoods.com/api/reviews/1" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Success Response (200):**
```json
{
  "status": true,
  "message": "Review deleted successfully.",
  "data": null
}
```

**Error Response (403):**
```json
{
  "status": false,
  "message": "You can only delete your own reviews."
}
```

**Error Response (404):**
```json
{
  "status": false,
  "message": "Review not found."
}
```

---

### 8. Get Product Details (with Review Data)

Retrieve product details including review summary and preview of top reviews.

**Endpoint:** `GET /products/{product_id}`

**Headers:**
```
Authorization: Bearer {token}
Accept: application/json
```

**Description:**
When fetching product details, the API automatically includes:
- **review_summary**: Total reviews, average rating, and rating distribution (calculated from ALL reviews)
- **reviews**: Top 5 most recent reviews with user info and attachments

**Example Request:**
```bash
curl -X GET "https://dev.avantefoods.com/api/products/1" \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

**Success Response (200):**
```json
{
  "status": true,
  "message": "Product details retrieved successfully.",
  "data": {
    "id": 1,
    "name": "Fresh Young Coconut",
    "slug": "fresh-young-coconut",
    "price": 62,
    "thumbnail": "https://dev.avantefoods.com/storage/5/thumbnail.png",
    "variants": [...],
    "categories": [...],

    "review_summary": {
      "total_reviews": 15,
      "average_rating": 4.5,
      "rating_distribution": {
        "5_star": 8,
        "4_star": 5,
        "3_star": 1,
        "2_star": 1,
        "1_star": 0
      }
    },

    "reviews": [
      {
        "id": 5,
        "rating": 5,
        "comment": "Amazing product! Fresh and delicious.",
        "variant_snapshot": null,
        "created_at": "2025-11-30 13:25:10",
        "updated_at": "2025-11-30 13:25:10",
        "user": {
          "id": 3,
          "name": "john_doe",
          "avatar_url": "https://dev.avantefoods.com/storage/20/avatar.jpg"
        },
        "attachments": [
          {
            "id": 25,
            "url": "https://dev.avantefoods.com/storage/25/review-image.jpg",
            "mime_type": "image/jpeg",
            "size": 245678,
            "name": "review-image.jpg"
          }
        ]
      }
    ]
  }
}
```

**Usage Notes:**
- The `review_summary` is calculated from ALL product reviews, not just the 5 loaded previews
- The `reviews` array contains only the top 5 most recent reviews
- To see all reviews, use the "Get Product Reviews" endpoint with pagination
- The "View All Reviews" button should link to the full reviews list endpoint

---

## Attachment Structure

Each attachment in the response includes:

| Field | Type | Description |
|-------|------|-------------|
| id | integer | Unique attachment ID |
| url | string | Full URL to access the file |
| mime_type | string | File MIME type (e.g., "image/jpeg", "video/mp4") |
| size | integer | File size in bytes |
| name | string | Original filename |

**Detecting Media Type:**
- Use `mime_type` field to determine if attachment is image or video
- Image MIME types start with `image/` (e.g., `image/jpeg`, `image/png`)
- Video MIME types start with `video/` (e.g., `video/mp4`, `video/mov`)

---

## Validation Rules

### Create/Update Review:
- **rating**: Required, integer, between 1-5
- **comment**: Optional, string, max 1000 characters
- **variant_snapshot**: Optional, must be a valid array
- **attachments**: Optional, array, max 5 files
- **attachments.***: Must be a file, allowed types: jpeg, jpg, png, gif, mp4, mov, avi, max size 10MB

### Business Rules:
- Users can only create ONE review per product
- Users can only update/delete their own reviews
- If a user tries to create a duplicate review, they receive a 400 error with instructions to update their existing review
- When updating attachments, ALL existing attachments are replaced with new ones

---

## Error Codes

| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 201 | Created |
| 400 | Bad Request (duplicate review, business logic error) |
| 401 | Unauthenticated |
| 403 | Forbidden (unauthorized to modify resource) |
| 404 | Not Found |
| 422 | Validation Error |

---

## Server Configuration Requirements

### PHP Settings (php.ini):
```ini
upload_max_filesize = 15M
post_max_size = 15M
max_file_uploads = 20
memory_limit = 256M
```

### Nginx Configuration (if applicable):
```nginx
client_max_body_size 15M;
```

---

## Database Schema

### Reviews Table:
```sql
- id (bigint, primary key)
- user_id (bigint, foreign key, nullable)
- product_id (bigint, foreign key)
- rating (integer)
- comment (text, nullable)
- variant_snapshot (json, nullable)
- created_at (timestamp)
- updated_at (timestamp)
```

### Media Table (managed by Spatie Media Library):
- Attachments are stored in the 'attachments' collection
- Maximum 5 attachments per review
- Supports both images and videos

---

## Advanced Filtering & Sorting Features

### Available Filters:
- **filter[rating]**: Filter by specific rating(s) - supports single value or array
- **filter[has_attachments]**: Filter reviews with media (images/videos)
- **filter[has_comment]**: Filter reviews with text comments
- **filter[min_rating]**: Filter by minimum rating
- **filter[max_rating]**: Filter by maximum rating
- **filter[product_id]**: Filter by specific product (for "My Reviews" endpoint)

### Available Sorting:
- **sort=-created_at**: Newest first (default)
- **sort=created_at**: Oldest first
- **sort=-rating**: Highest rating first
- **sort=rating**: Lowest rating first

### Combined Query Examples:

**4-5 star reviews with attachments:**
```
GET /api/products/{id}/reviews?filter[min_rating]=4&filter[has_attachments]=1
```

**Filter multiple ratings:**
```
GET /api/products/{id}/reviews?filter[rating][]=4&filter[rating][]=5
```

**Reviews with comments, sorted by rating:**
```
GET /api/products/{id}/reviews?filter[has_comment]=1&sort=-rating
```

---

## API Testing Results

All endpoints have been successfully tested and verified:

### Core Functionality:
- ✅ Create review with image attachment (PNG, JPEG)
- ✅ Create review with video attachment (MP4)
- ✅ Create review with multiple attachments (up to 5 files)
- ✅ Get product details with review summary and top 5 reviews
- ✅ Get product reviews with pagination
- ✅ Get review statistics (total, average, distribution)
- ✅ Get user's own reviews
- ✅ Get specific review details
- ✅ Update review with new attachments
- ✅ Delete review

### Advanced Features:
- ✅ Filter by single rating (e.g., 5-star only)
- ✅ Filter by multiple ratings (e.g., 4 and 5-star)
- ✅ Filter by minimum/maximum rating
- ✅ Filter reviews with attachments
- ✅ Filter reviews with comments
- ✅ Sort by rating (highest/lowest)
- ✅ Sort by date (newest/oldest)
- ✅ Combined filters (e.g., 4+ stars with attachments)

### Security & Validation:
- ✅ Authorization checks (users can only modify their own reviews)
- ✅ Duplicate review prevention (one review per user per product)
- ✅ File type validation (images and videos only)
- ✅ File size validation (10MB max per file)
- ✅ Rating validation (1-5 range)
- ✅ Comment length validation (max 1000 characters)

---

## Support

For issues or questions, contact the development team or refer to the main API documentation.
