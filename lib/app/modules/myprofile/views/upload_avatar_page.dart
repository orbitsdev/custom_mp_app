import 'dart:io';

import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/myprofile/controllers/profile_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadAvatarPage extends StatefulWidget {
  const UploadAvatarPage({Key? key}) : super(key: key);

  @override
  State<UploadAvatarPage> createState() => _UploadAvatarPageState();
}

class _UploadAvatarPageState extends State<UploadAvatarPage> {
  File? _selectedImage;
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take Photo'),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Get.back();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Cancel'),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpload() async {
    if (_selectedImage == null) {
      Get.snackbar(
        'No Image',
        'Please select an image first',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    final controller = Get.find<ProfileUpdateController>();
    await controller.uploadAvatar(_selectedImage!.path);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileUpdateController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Avatar'),
        elevation: 0,
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a photo for your profile',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Image Preview
            Center(
              child: GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.brandBackground,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.brand,
                      width: 3,
                    ),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: AppColors.brand,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to select',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select Image Button
            if (_selectedImage == null)
              OutlinedButton.icon(
                onPressed: _showImageSourceDialog,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.brand),
                  foregroundColor: AppColors.brand,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.image),
                label: const Text(
                  'Select Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

            // Change Image Button
            if (_selectedImage != null)
              OutlinedButton.icon(
                onPressed: _showImageSourceDialog,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.brand),
                  foregroundColor: AppColors.brand,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.image),
                label: const Text(
                  'Change Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

            const SizedBox(height: 12),

            // Upload Progress
            Obx(() {
              if (controller.isLoading.value && controller.uploadProgress.value > 0) {
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: controller.uploadProgress.value,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.brand),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(controller.uploadProgress.value * 100).toStringAsFixed(0)}% uploaded',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // Upload Button
            Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoading.value || _selectedImage == null
                      ? null
                      : _handleUpload,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(
                    controller.isLoading.value ? 'Uploading...' : 'Upload Avatar',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),

            const SizedBox(height: 24),

            // Image Requirements Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Image Requirements',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Maximum file size: 2MB\n'
                    '• Accepted formats: JPEG, PNG, GIF, WebP\n'
                    '• Recommended: Square image (1:1 ratio)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
