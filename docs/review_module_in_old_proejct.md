# File Upload & Review Feature - Complete Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Data Models](#data-models)
4. [UI Components](#ui-components)
5. [Controller Logic](#controller-logic)
6. [File Management](#file-management)
7. [File Viewing System](#file-viewing-system)
8. [Form Structure](#form-structure)
9. [Upload Process](#upload-process)
10. [Implementation Guide](#implementation-guide)

---

## Overview

The File Upload & Review Feature is a comprehensive system that allows users to submit product reviews with multimedia attachments (images and videos). The feature includes:

- Multi-file upload (up to 6 files)
- Support for images (JPG, PNG) and videos (MP4)
- File size validation (max 50MB per file)
- Video thumbnail generation
- Local file preview
- Online file viewing with swipeable page viewer
- Progress tracking during upload
- File deletion capability
- Form validation
- Confetti celebration on success

---

## Architecture

### Tech Stack
- **Flutter Framework**: UI development
- **GetX State Management**: Reactive state management and dependency injection
- **Flutter Form Builder**: Form handling and validation
- **File Picker**: Native file selection
- **Video Player**: Video playback
- **Video Thumbnail Generator**: Generate thumbnails from video files
- **Dio**: HTTP client for file uploads with progress tracking

### File Structure
```
lib/
├── features/
│   ├── rating/
│   │   ├── rate_product_screen.dart          # Main UI screen
│   │   ├── controller/
│   │   │   └── rate_product_controller.dart  # Business logic
│   │   └── widgets/
│   │       └── progress_bar_submit.dart      # Upload progress widget
│   ├── video/
│   │   ├── file_viewer.dart                  # Page viewer for online files
│   │   ├── online_video_player.dart          # Stream video from URL
│   │   ├── local_video_player.dart           # Play local video files
│   │   └── video_viewer.dart                 # Generic video viewer
│   └── review/
│       └── controller/
│           └── review_controller.dart        # Review management
├── models/
│   └── product_review.dart                   # Data models
├── core/
│   ├── helpers/
│   │   └── thumbnail_helper.dart             # Video thumbnail generation
│   └── shared/
│       └── images/
│           ├── local_file_image_full_screen_display.dart
│           └── online_image_full_screen_display.dart
```

---

## Data Models

### ProductReview Model
**Location**: `lib/models/product_review.dart`

```dart
class ProductReview {
  int? id;
  int? user_id;
  ProductReviewUser? user_data;
  int? product_id;
  int? rating;
  String? message;
  String? created_at;
  String? updated_at;
  List<ReviewFile>? media;
}
```

### ReviewFile Model
Represents individual media files attached to a review:

```dart
class ReviewFile {
  String? url;      // File URL (for online files)
  String? type;     // MIME type (e.g., "image/jpeg", "video/mp4")
}
```

### ProductReviewUser Model
User information associated with the review:

```dart
class ProductReviewUser {
  int? id;
  String? name;
  String? email;
  String? profile;
}
```

**Key Features**:
- JSON serialization/deserialization
- `copyWith()` method for immutable updates
- Type-safe nullable fields
- Equality operators for comparison

---

## UI Components

### Main Screen: RateProductScreen
**Location**: `lib/features/rating/rate_product_screen.dart`

#### Structure
```
Scaffold
└── Column
    ├── CustomScrollView (Expandable content)
    │   └── FormBuilder
    │       ├── User Greeting
    │       ├── Rating Bar (1-5 stars)
    │       ├── Progress Indicator (during upload)
    │       ├── Message TextField (multiline)
    │       └── File Grid View (4 columns)
    │           ├── Add Button (index 0)
    │           └── Media Files (index 1+)
    │               ├── Image/Video Preview
    │               ├── Play Icon (for videos)
    │               └── Remove Button (X)
    └── Submit Button (fixed at bottom with shadow)
```

#### Key UI Elements

##### 1. Confetti Animation
**Lines**: 73-93

Celebration effect triggered on successful submission:
```dart
ConfettiWidget(
  confettiController: conffetecontroller,
  blastDirectionality: BlastDirectionality.explosive,
  shouldLoop: true,
  emissionFrequency: 0.01,
  numberOfParticles: 5,
  colors: [AVANTE_PRIMARY, avanteOrangeTextColor, ...]
)
```

##### 2. Rating Bar
**Lines**: 119-145

Interactive 5-star rating system:
```dart
RatingBar(
  initialRating: 1.0,
  minRating: 1.0,
  itemCount: 5,
  allowHalfRating: false,
  onRatingUpdate: (rating) {
    rateProductController.updateRating(rating);
  }
)
```

##### 3. Upload Progress Indicator
**Lines**: 147-163

Shows progress during file upload:
```dart
Obx(() {
  if (rateProductController.isLoading.value) {
    return rateProductController.mediaFiles.isNotEmpty
      ? ProgressBarSubmit(progress: rateProductController.uploadProgress.value)
      : LinearProgressIndicator();
  }
  return SizedBox(height: 8);
})
```

##### 4. Message TextField
**Lines**: 164-200

Multi-line text input with validation:
```dart
FormBuilderTextField(
  name: 'message',
  maxLines: 5,
  decoration: InputDecoration(...),
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
  ]),
)
```

##### 5. File Grid View
**Lines**: 204-372

4-column grid displaying selected files:
- **Index 0**: Add button (always visible)
- **Index 1+**: Selected media files

**Video Preview**:
- Generates thumbnail using `ThumbnailHelper`
- Displays play button overlay
- Shows loading indicator while generating

**Image Preview**:
- Displays image directly from file
- Maintains aspect ratio with `BoxFit.cover`

**Remove Button**:
- Positioned at top-right corner (-10, -10 offset)
- Circular gradient background
- Close icon

---

## Controller Logic

### RateProductController
**Location**: `lib/features/rating/controller/rate_product_controller.dart`

#### State Variables

```dart
var isPickingFile = false.obs;              // Track file picker state
var rating = 1.0.obs;                       // Current rating
var selectedProduct = Product().obs;         // Selected product
var isLoading = false.obs;                  // Upload loading state
var mediaFiles = <File>[].obs;              // Selected files list
var uploadProgress = 0.0.obs;               // Upload progress (0.0 - 1.0)
final formKey = GlobalKey<FormBuilderState>(); // Form state key
```

#### Key Methods

##### 1. updateRating()
**Lines**: 42-45

Updates the rating value and triggers UI rebuild:
```dart
void updateRating(double newRating) {
  rating.value = newRating;
  update();
}
```

##### 2. pickFile()
**Lines**: 94-159

Handles file selection with validation and error handling:

**Features**:
- Maximum 6 files limit
- File size validation (50MB max)
- Supported formats: JPG, PNG, MP4
- Multiple file selection
- Loading modal during selection
- Toast notifications for errors
- Platform exception handling

**Flow**:
1. Check if file limit reached (6 files)
2. Show loading modal
3. Open file picker with custom filters
4. Validate each selected file:
   - Check file size
   - Check total count
5. Add valid files to `mediaFiles` list
6. Close loading modal
7. Update UI

**Error Handling**:
- File too large: Skip file, show toast
- Already picking: Show "already active" message
- Other errors: Show generic error message

##### 3. removeFile()
**Lines**: 167-173

Removes a file from the selection:
```dart
void removeFile(int index) {
  if (index >= 0 && index < mediaFiles.length) {
    mediaFiles.removeAt(index);
    update();
  }
}
```

##### 4. clearFiles()
**Lines**: 162-165

Removes all selected files:
```dart
void clearFiles() {
  mediaFiles.clear();
  update();
}
```

##### 5. viewFile()
**Lines**: 175-182

Opens full-screen viewer for local files:
```dart
void viewFile(File file) {
  if (file.path.endsWith(".mp4")) {
    Get.to(() => LocalVideoPlayer(filePath: file.path));
  } else {
    Get.to(() => LocalFileImageFullScreenDisplay(imagePath: file.path));
  }
}
```

##### 6. storeReview()
**Lines**: 192-270

Main method for submitting reviews with file uploads:

**Process**:
1. Validate form
2. Show confirmation dialog
3. Set loading state
4. Prepare FormData:
   - user_id
   - rating
   - product_id
   - message
   - media[] (array of files)
5. Upload with progress tracking
6. Handle response:
   - Success: Show toast, clear files, refresh product
   - Failure: Show error dialog
7. Reset state

**API Integration**:
```dart
var response = await ApiService.filePostAuthenticatedFileResource(
  'reviews',
  formData,
  onSendProgress: (int sent, int total) {
    uploadProgress.value = sent / total;
    update();
  },
);
```

##### 7. deleteReview()
**Lines**: 307-355

Deletes a review with confirmation:

**Features**:
- Confirmation dialog
- Loading modal
- Optimistic UI update (removes from local list)
- Error handling
- Success toast

**Flow**:
1. Show confirmation dialog
2. User confirms
3. Show loading modal
4. Send delete request
5. Remove from local list
6. Update UI
7. Show success message

##### 8. fullScreenDisplay()
**Lines**: 54-64

Opens page viewer for online review files:
```dart
void fullScreenDisplay(BuildContext context, List<ReviewFile> reviewFiles, ReviewFile file) {
  int initialIndex = reviewFiles.indexOf(file);

  Get.to(() => FileViewer(
    mediaFiles: reviewFiles,
    initialIndex: initialIndex,
  ));
}
```

---

## File Management

### File Selection Process

#### 1. File Picker Configuration
**Package**: `file_picker`

```dart
FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['jpg', 'png', 'mp4'],
  allowMultiple: true,
);
```

**Parameters**:
- `type`: FileType.custom (custom file types)
- `allowedExtensions`: ['jpg', 'png', 'mp4']
- `allowMultiple`: true (allow multiple selections)

#### 2. Validation Rules

**File Count Limit**:
```dart
if (mediaFiles.length >= 6) {
  Modal.showToast(msg: 'Limit Reached. Maximum 6 files.', ...);
  return;
}
```

**File Size Limit**:
```dart
const int maxFileSize = 50 * 1024 * 1024; // 50 MB

if (file.size > maxFileSize) {
  Modal.showToast(msg: 'File too large. Maximum 50 MB.', ...);
  continue;
}
```

#### 3. File Storage

Files are stored as `File` objects in an observable list:
```dart
var mediaFiles = <File>[].obs;
```

This allows reactive UI updates when files are added or removed.

### Thumbnail Generation

**Location**: `lib/core/helpers/thumbnail_helper.dart`

#### ThumbnailHelper Class

```dart
class ThumbnailHelper {
  static Future<Uint8List?> getThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
  }
}
```

**Parameters**:
- `video`: Path to video file
- `imageFormat`: JPEG format
- `maxWidth`: 128px (thumbnail size)
- `quality`: 25 (compression level)

**Usage in UI**:
```dart
FutureBuilder<Uint8List?>(
  future: ThumbnailHelper.getThumbnail(file.path),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasData) {
      return Image.memory(snapshot.data!, fit: BoxFit.cover);
    } else {
      return Container(color: Colors.black45);
    }
  },
)
```

---

## File Viewing System

### 1. Local File Viewers (During Selection)

#### LocalVideoPlayer
**Location**: `lib/features/video/local_video_player.dart`

**Features**:
- Plays video from local file path
- Custom video controls (play/pause, seek, skip)
- Progress indicator with time display
- Skip forward/backward (10 seconds)
- Close button
- Black background

**Controls**:
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    IconButton(icon: Icon(Icons.replay_10), onPressed: _skipBackward),
    IconButton(icon: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow)),
    IconButton(icon: Icon(Icons.forward_10), onPressed: _skipForward),
  ],
)
```

**Time Formatting**:
```dart
String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}
```

#### LocalFileImageFullScreenDisplay
**Location**: `lib/core/shared/images/local_file_image_full_screen_display.dart`

**Features**:
- Full-screen image display
- Black background
- Close button at top-right
- Image fit: BoxFit.contain

```dart
Center(
  child: Image.file(
    File(imagePath),
    fit: BoxFit.contain,
  ),
)
```

### 2. Online File Viewer (After Upload)

#### FileViewer - Page Viewer
**Location**: `lib/features/video/file_viewer.dart`

**Key Feature**: Swipeable page viewer for browsing multiple review files

**Structure**:
```dart
class FileViewer extends StatefulWidget {
  final List<ReviewFile> mediaFiles;
  final int initialIndex;
}
```

**Implementation**:
```dart
Scaffold(
  backgroundColor: Colors.black,
  body: PageView.builder(
    controller: _pageController,
    itemCount: widget.mediaFiles.length,
    itemBuilder: (context, index) {
      final file = widget.mediaFiles[index];
      return file.type!.startsWith('video')
        ? OnlineVideoPlayer(url: file.url ?? '')
        : OnineImageWithClose(imageUrl: file.url ?? '');
    },
  ),
)
```

**Features**:
- Horizontal swipe navigation
- Initial page set to clicked file
- Supports both videos and images
- Black background
- Smooth page transitions

**Usage Flow**:
1. User clicks on a review file thumbnail
2. `fullScreenDisplay()` is called with:
   - List of all review files
   - Clicked file
3. Finds index of clicked file
4. Opens FileViewer at that index
5. User can swipe left/right to view other files

#### OnlineVideoPlayer
**Location**: `lib/features/video/online_video_player.dart`

**Features**:
- Streams video from URL
- Error handling with retry button
- Video controls (same as local player)
- Loading indicator
- Close button

**Error Handling**:
```dart
void _initializePlayer() {
  _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
    ..initialize().then((_) {
      setState(() => _isError = false);
      _controller.play();
    }).catchError((error) {
      setState(() => _isError = true);
    });
}
```

**Retry Mechanism**:
```dart
void _retry() {
  setState(() => _isError = false);
  _initializePlayer();
}
```

---

## Form Structure

### Flutter Form Builder Integration

**Package**: `flutter_form_builder`, `form_builder_validators`

#### Form Key
```dart
final formKey = GlobalKey<FormBuilderState>();
```

#### Form Wrapper
```dart
FormBuilder(
  key: controller.formKey,
  child: Column(children: [...]),
)
```

#### Form Field
```dart
FormBuilderTextField(
  name: 'message',
  maxLines: 5,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
  ]),
)
```

#### Form Validation & Submission
```dart
if (formKey.currentState!.saveAndValidate()) {
  String message = formKey.currentState?.instantValue['message'] ?? '';
  // Process form...
}
```

**Key Benefits**:
- Automatic form state management
- Built-in validators
- Easy value retrieval
- Error handling

---

## Upload Process

### Step-by-Step Flow

#### 1. User Interaction
```
User fills form → Taps "Submit Review" → Confirmation dialog → User confirms
```

#### 2. Data Preparation
**Location**: `rate_product_controller.dart:206-224`

```dart
var formData = dio.FormData();

// Add form fields
formData.fields.addAll([
  MapEntry('user_id', user?.id.toString() ?? ''),
  MapEntry('rating', rating.value.toInt().toString()),
  MapEntry('product_id', ProductController2.controller.selectedProduct.value.id.toString()),
  MapEntry('message', message),
]);

// Add media files
for (var file in mediaFiles) {
  formData.files.add(MapEntry(
    'media[]',
    await dio.MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last
    ),
  ));
}
```

**FormData Structure**:
```
POST /reviews
Content-Type: multipart/form-data

Fields:
- user_id: string
- rating: string (1-5)
- product_id: string
- message: string

Files:
- media[]: array of files (max 6, max 50MB each)
```

#### 3. Upload Execution
**Location**: `rate_product_controller.dart:227-234`

```dart
var response = await ApiService.filePostAuthenticatedFileResource(
  'reviews',
  formData,
  onSendProgress: (int sent, int total) {
    uploadProgress.value = sent / total;
    update();
  },
);
```

**Progress Tracking**:
- `sent`: Bytes uploaded so far
- `total`: Total bytes to upload
- `uploadProgress`: Value from 0.0 to 1.0

#### 4. Response Handling

**Success Case** (Lines 243-258):
```dart
response.fold(
  (failure) => { /* Show error dialog */ },
  (success) {
    isLoading(false);
    uploadProgress.value = 0.0;
    mediaFiles.clear();
    update();

    // Refresh product data
    ProductController2.controller.getProduct(context, updatedProduct);

    // Show success message
    Modal.showToast(msg: 'Review submitted! 🎉', toastLength: Toast.LENGTH_LONG);
    Get.back();
  }
);
```

**Error Case** (Lines 236-242):
```dart
(failure) {
  FocusScope.of(context).unfocus();
  isLoading(false);
  uploadProgress.value = 0.0;
  update();
  Modal.showErrorDialog(context, failure: failure);
}
```

#### 5. UI State Updates

**During Upload**:
- `isLoading = true`
- Progress bar visible
- Submit button disabled (implicitly)
- `uploadProgress` updates continuously

**After Upload**:
- `isLoading = false`
- Progress bar hidden
- Files cleared
- Form reset
- Success toast displayed

---

## Implementation Guide

### How to Integrate This Feature in Your Project

#### Step 1: Install Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.5
  flutter_form_builder: ^9.1.0
  form_builder_validators: ^9.0.0
  file_picker: ^5.3.0
  video_player: ^2.6.1
  get_thumbnail_video: ^0.6.1
  dio: ^5.1.2
  confetti: ^0.7.0
  flutter_rating_bar: ^4.0.1
```

#### Step 2: Create Data Models

Copy the following files:
- `lib/models/product_review.dart`

Or create your own models with these essential fields:
```dart
class Review {
  int? id;
  int? userId;
  int? rating;
  String? message;
  List<MediaFile>? media;
}

class MediaFile {
  String? url;
  String? type;
}
```

#### Step 3: Create Thumbnail Helper

Copy `lib/core/helpers/thumbnail_helper.dart`:
```dart
import 'dart:typed_data';
import 'package:get_thumbnail_video/video_thumbnail.dart';

class ThumbnailHelper {
  static Future<Uint8List?> getThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
  }
}
```

#### Step 4: Create Controller

Create a controller based on `RateProductController`:
```dart
class ReviewController extends GetxController {
  var rating = 1.0.obs;
  var mediaFiles = <File>[].obs;
  var uploadProgress = 0.0.obs;
  var isLoading = false.obs;
  final formKey = GlobalKey<FormBuilderState>();

  // Implement pickFile(), removeFile(), viewFile(), storeReview()
}
```

#### Step 5: Create Video Players

Copy the player files:
- `lib/features/video/local_video_player.dart`
- `lib/features/video/online_video_player.dart`
- `lib/features/video/file_viewer.dart`

#### Step 6: Create Image Viewers

Copy the image viewer files:
- `lib/core/shared/images/local_file_image_full_screen_display.dart`
- `lib/core/shared/images/online_image_full_screen_display.dart`

#### Step 7: Create Main Review Screen

Adapt `RateProductScreen` to your needs:
- Customize colors/styles
- Adjust file limits
- Modify validation rules
- Update API endpoints

#### Step 8: Configure API Service

Ensure your API service supports:
- Multipart form data
- Progress callbacks
- File uploads
- Authentication

Example with Dio:
```dart
static Future<Either<Failure, Success>> filePostAuthenticatedFileResource(
  String endpoint,
  FormData formData, {
  required Function(int sent, int total) onSendProgress,
}) async {
  try {
    final response = await _dio.post(
      endpoint,
      data: formData,
      onSendProgress: (sent, total) {
        onSendProgress(sent, total);
      },
    );
    return Right(Success(response.data));
  } catch (e) {
    return Left(Failure(e.toString()));
  }
}
```

#### Step 9: Backend API Endpoint

Your backend should handle:
```
POST /reviews
Content-Type: multipart/form-data

Expected fields:
- user_id: integer
- product_id: integer
- rating: integer (1-5)
- message: string
- media[]: array of files

Response:
{
  "success": true,
  "data": {
    "id": 123,
    "user_id": 456,
    "product_id": 789,
    "rating": 5,
    "message": "Great product!",
    "media": [
      {
        "url": "https://example.com/files/image1.jpg",
        "type": "image/jpeg"
      },
      {
        "url": "https://example.com/files/video1.mp4",
        "type": "video/mp4"
      }
    ]
  }
}
```

#### Step 10: Test the Feature

Test scenarios:
1. ✅ Select single image
2. ✅ Select single video
3. ✅ Select multiple files (mix of images/videos)
4. ✅ Reach file limit (6 files)
5. ✅ Try to upload file > 50MB
6. ✅ View local image
7. ✅ View local video
8. ✅ View online files with page viewer
9. ✅ Remove files
10. ✅ Submit form with validation
11. ✅ Monitor upload progress
12. ✅ Handle upload errors
13. ✅ Verify file types (JPG, PNG, MP4 only)

---

## Key Features Summary

### ✨ File Management
- ✅ Multi-file selection (up to 6 files)
- ✅ File type filtering (JPG, PNG, MP4)
- ✅ File size validation (50MB max)
- ✅ Add/remove files dynamically
- ✅ Video thumbnail generation

### 🎨 User Interface
- ✅ Clean 4-column grid layout
- ✅ Responsive design
- ✅ Loading states
- ✅ Progress indicators
- ✅ Error messages
- ✅ Success animations (confetti)
- ✅ Form validation

### 📹 Video Playback
- ✅ Local video player
- ✅ Online video player
- ✅ Custom controls (play/pause, seek, skip)
- ✅ Progress bar
- ✅ Time display
- ✅ Error handling with retry

### 🖼️ Image Display
- ✅ Full-screen local images
- ✅ Full-screen online images
- ✅ Proper aspect ratio handling
- ✅ Black background for focus

### 📄 Page Viewer
- ✅ Swipeable navigation
- ✅ Mixed media types (images & videos)
- ✅ Initial page selection
- ✅ Smooth transitions

### 🔄 Upload System
- ✅ Multipart form data
- ✅ Real-time progress tracking
- ✅ Error handling
- ✅ Retry mechanism
- ✅ Optimistic UI updates

### 🗑️ Review Management
- ✅ Create reviews
- ✅ Delete reviews (with confirmation)
- ✅ Edit reviews (structure in place)
- ✅ View all reviews

---

## Best Practices Used

### 1. State Management
- ✅ GetX for reactive updates
- ✅ Observable variables with `.obs`
- ✅ Proper disposal of controllers

### 2. Error Handling
- ✅ Try-catch blocks
- ✅ Platform exception handling
- ✅ User-friendly error messages
- ✅ Retry mechanisms

### 3. Performance
- ✅ Lazy loading with FutureBuilder
- ✅ Thumbnail generation (not full videos)
- ✅ File size limits
- ✅ Progress indicators for long operations

### 4. User Experience
- ✅ Confirmation dialogs
- ✅ Loading modals
- ✅ Toast notifications
- ✅ Visual feedback
- ✅ Celebration effects

### 5. Code Organization
- ✅ Separation of concerns (UI, logic, models)
- ✅ Reusable components
- ✅ Clear naming conventions
- ✅ Proper file structure

---

## Potential Enhancements

### Future Improvements
1. **Multiple File Formats**
   - Add support for GIF, WebP, HEIC
   - Support more video formats (AVI, MOV)

2. **Image Editing**
   - Crop/rotate before upload
   - Apply filters
   - Add text overlays

3. **Compression**
   - Auto-compress large files
   - Quality selection
   - Preview compressed version

4. **Cloud Storage**
   - Direct upload to S3/Firebase
   - CDN integration
   - Optimized delivery

5. **Offline Support**
   - Queue uploads for later
   - Sync when online
   - Local draft storage

6. **Advanced Video Features**
   - Trim videos
   - Add captions
   - Video effects

7. **Accessibility**
   - Screen reader support
   - Voice commands
   - High contrast mode

8. **Analytics**
   - Track upload success rates
   - Monitor file sizes
   - User behavior analysis

---

## Troubleshooting

### Common Issues

#### Issue 1: "File picker already active"
**Cause**: Attempting to open file picker while it's already open.
**Solution**: Implemented in code with `isPickingFile` observable and platform exception handling.

#### Issue 2: Video thumbnail not generating
**Cause**: Incompatible video format or corrupted file.
**Solution**: Added fallback UI (black container) when thumbnail generation fails.

#### Issue 3: Upload progress not updating
**Cause**: Progress callback not properly connected.
**Solution**: Ensure `onSendProgress` is passed correctly to Dio.

#### Issue 4: Large files causing app freeze
**Cause**: File size too large for memory.
**Solution**: Implemented 50MB file size limit with validation.

#### Issue 5: Video player not disposing
**Cause**: Controller not disposed in widget lifecycle.
**Solution**: Always call `_controller.dispose()` in `dispose()` method.

---

## Conclusion

This File Upload & Review Feature provides a comprehensive, production-ready solution for handling multimedia reviews in Flutter applications. The architecture is modular, maintainable, and follows Flutter best practices.

### Key Takeaways
- ✅ Clean architecture with separation of concerns
- ✅ Robust error handling and validation
- ✅ Excellent user experience with feedback
- ✅ Scalable and maintainable codebase
- ✅ Production-ready with proper testing considerations

### File References
- Main Screen: `lib/features/rating/rate_product_screen.dart`
- Controller: `lib/features/rating/controller/rate_product_controller.dart`
- Models: `lib/models/product_review.dart`
- File Viewer: `lib/features/video/file_viewer.dart`
- Video Players: `lib/features/video/local_video_player.dart`, `lib/features/video/online_video_player.dart`
- Image Viewers: `lib/core/shared/images/`
- Thumbnail Helper: `lib/core/helpers/thumbnail_helper.dart`

---

**Document Version**: 1.0
**Last Updated**: 2025-12-01
**Author**: Technical Documentation Team
**Project**: Avante E-Commerce Platform
