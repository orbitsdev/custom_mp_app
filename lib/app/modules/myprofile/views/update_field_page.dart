import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/myprofile/controllers/profile_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateFieldPage extends StatefulWidget {
  const UpdateFieldPage({Key? key}) : super(key: key);

  @override
  State<UpdateFieldPage> createState() => _UpdateFieldPageState();
}

class _UpdateFieldPageState extends State<UpdateFieldPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late final String _field;
  late final String _title;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    _field = args['field'] as String;
    _title = args['title'] as String;
    final currentValue = args['currentValue'] as String;
    _controller = TextEditingController(text: currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.brandBackground,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: AppColors.brand),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1.0, color: Colors.transparent),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0, color: AppColors.error),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: AppColors.error),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  String? _validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (_field == 'email') {
      if (!GetUtils.isEmail(value)) {
        return 'Please enter a valid email';
      }
    }
    return null;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<ProfileUpdateController>();
    await controller.updateUserDetails({_field: _controller.text.trim()});
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileUpdateController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        elevation: 0,
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _field == 'name' ? 'Enter your new name' : 'Enter your new email address',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _controller,
                decoration: _inputDecoration(
                  _field == 'name' ? 'Full Name' : 'Email Address',
                ),
                keyboardType: _field == 'email' ? TextInputType.emailAddress : TextInputType.name,
                textCapitalization: _field == 'name' ? TextCapitalization.words : TextCapitalization.none,
                validator: _validator,
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
