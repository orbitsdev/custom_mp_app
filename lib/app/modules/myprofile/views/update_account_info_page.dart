import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/modules/myprofile/controllers/profile_update_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateAccountInfoPage extends StatefulWidget {
  const UpdateAccountInfoPage({Key? key}) : super(key: key);

  @override
  State<UpdateAccountInfoPage> createState() => _UpdateAccountInfoPageState();
}

class _UpdateAccountInfoPageState extends State<UpdateAccountInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedGender = 'male';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<ProfileUpdateController>();
    final accountInfo = controller.currentUser?.accountInformation;

    if (accountInfo != null) {
      _fullNameController.text = accountInfo.fullName;
      _phoneController.text = accountInfo.phoneNumber;
      _selectedGender = accountInfo.gender;

      // Parse date if available
      if (accountInfo.rawDate != null) {
        try {
          _selectedDate = DateTime.parse(accountInfo.rawDate!);
        } catch (e) {
          _selectedDate = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.brand,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

  if (value.trim().isEmpty) return 'Required';
          if (value.length != 11) return 'Must be 11 digits';
          if (!value.startsWith("09")) return 'Phone must start with 09';
          return null;

  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      Get.snackbar(
        'Required Field',
        'Please select your date of birth',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    final controller = Get.find<ProfileUpdateController>();

    // Format date as YYYY-MM-DD
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    await controller.updateUserDetails({
      'account_information': {
        'full_name': _fullNameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'gender': _selectedGender,
        'date_of_birth': formattedDate,
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileUpdateController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
        elevation: 0,
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Update your account details',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // Full Name
              const Text(
                'Full Name',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _fullNameController,
                decoration: _inputDecoration('Enter your full name'),
                textCapitalization: TextCapitalization.words,
                validator: (value) => _validateRequired(value, 'Full name'),
              ),
              const SizedBox(height: 20),

              // Phone Number
              const Text(
                'Phone Number',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration(
                  '09xxxxxxxxx',
                ).copyWith(counterText: ""),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validatePhone,
              ),
              const SizedBox(height: 20),

              // Gender
              const Text(
                'Gender',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.brandBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedGender = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date of Birth
              const Text(
                'Date of Birth',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? DateFormat('MMMM dd, yyyy').format(_selectedDate!)
                            : 'Select date of birth',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate != null
                              ? Colors.black
                              : Colors.grey[600],
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.brand,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Obx(
                () => ElevatedButton(
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
