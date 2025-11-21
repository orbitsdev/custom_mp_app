// lib/app/modules/shippinaddress/views/create_address_page.dart
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/region_model.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/shipping_address_model.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/controllers/shipping_address_controller.dart';
import 'package:custom_mp_app/app/modules/shippinaddress/views/psgc_select_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreateAddressPage extends StatefulWidget {
  final ShippingAddressModel? address; // null = create, not null = edit

  const CreateAddressPage({super.key, this.address});

  @override
  State<CreateAddressPage> createState() => _CreateAddressPageState();
}

class _CreateAddressPageState extends State<CreateAddressPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();

  String _addressType = 'HOME';

  RegionModel? _region;
  RegionModel? _province;
  RegionModel? _municipality;
  RegionModel? _barangay;

  bool _isSaving = false;

  late final ShippingAddressController _saController;

  @override
  void initState() {
    super.initState();
    _saController = Get.find<ShippingAddressController>();
    _initFromExisting();
  }

  void _initFromExisting() {
    final addr = widget.address;
    if (addr == null) return;

    _fullNameCtrl.text = addr.fullName;
    _phoneCtrl.text = addr.phoneNumber;
    _postalCtrl.text = addr.postalCode;
    _streetCtrl.text = addr.street;
    _landmarkCtrl.text = addr.landmark ?? '';
    _addressType = addr.type;

    _region = addr.region;
    _province = addr.province;
    _municipality = addr.municipality;
    _barangay = addr.barangay;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _postalCtrl.dispose();
    _streetCtrl.dispose();
    _landmarkCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.brandBackground,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
    );
  }

  Future<void> _pickRegion() async {
    final selected = await Get.to<RegionModel>(() => PSGCSelectPage(
          level: PSGCLevel.region,
          initialSelection: _region,
        ));

    if (selected != null) {
      setState(() {
        _region = selected;
        _province = null;
        _municipality = null;
        _barangay = null;
      });
    }
  }

  Future<void> _pickProvince() async {
    if (_region == null) {
      Get.snackbar('Select Region', 'Please select region first.');
      return;
    }

    final selected = await Get.to<RegionModel>(() => PSGCSelectPage(
          level: PSGCLevel.province,
          parentCode: _region!.code,
          initialSelection: _province,
        ));

    if (selected != null) {
      setState(() {
        _province = selected;
        _municipality = null;
        _barangay = null;
      });
    }
  }

  Future<void> _pickMunicipality() async {
    if (_province == null) {
      Get.snackbar('Select Province', 'Please select province first.');
      return;
    }

    final selected = await Get.to<RegionModel>(() => PSGCSelectPage(
          level: PSGCLevel.municipality,
          parentCode: _province!.code,
          initialSelection: _municipality,
        ));

    if (selected != null) {
      setState(() {
        _municipality = selected;
        _barangay = null;
      });
    }
  }

  Future<void> _pickBarangay() async {
    if (_municipality == null) {
      Get.snackbar('Select Municipality', 'Please select municipality first.');
      return;
    }

    final selected = await Get.to<RegionModel>(() => PSGCSelectPage(
          level: PSGCLevel.barangay,
          parentCode: _municipality!.code,
          initialSelection: _barangay,
        ));

    if (selected != null) {
      setState(() {
        _barangay = selected;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_region == null ||
        _province == null ||
        _municipality == null ||
        _barangay == null) {
      Get.snackbar(
        'Incomplete',
        'Please complete Region, Province, Municipality and Barangay.',
      );
      return;
    }

    final payload = {
      'full_name': _fullNameCtrl.text.trim(),
      'phone_number': _phoneCtrl.text.trim(),
      'type': _addressType,

      'region': _region!.toMap(),
      'province': _province!.toMap(),
      'municipality': _municipality!.toMap(),
      'barangay': _barangay!.toMap(),

      'region_code': _region!.code,
      'province_code': _province!.code,
      'municipality_code': _municipality!.code,
      'barangay_code': _barangay!.code,

      'postal_code': _postalCtrl.text.trim(),
      'street': _streetCtrl.text.trim(),
      'landmark':
          _landmarkCtrl.text.trim().isEmpty ? null : _landmarkCtrl.text.trim(),
    };

    setState(() => _isSaving = true);

    bool ok;
    if (widget.address == null) {
      ok = await _saController.createAddress(payload);
    } else {
      ok = await _saController.updateAddress(widget.address!.id, payload);
    }

    setState(() => _isSaving = false);

    if (ok) {
      Get.back(result: true);
    } else {
      final err = _saController.errorMessage.value;
      if (err.isNotEmpty) {
        Get.snackbar('Error', err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.address != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Address' : 'Add Address'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
      ),
      backgroundColor: AppColors.brandBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Full name + phone
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          label: 'Full Name *',
                          child: TextFormField(
                            controller: _fullNameCtrl,
                            decoration:
                                _inputDecoration('Enter full name'),
                            validator: (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildLabeledField(
                          label: 'Phone Number *',
                          child: TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            decoration:
                                _inputDecoration('09xxxxxxxxx'),
                            validator: (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Address type
                  _buildLabeledField(
                    label: 'Address Type *',
                    child: Row(
                      children: [
                        _typeChip('HOME'),
                        const SizedBox(width: 8),
                        _typeChip('WORK'),
                        const SizedBox(width: 8),
                        _typeChip('OTHER'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Region / Province (full-screen selector)
                  Row(
                    children: [
                      Expanded(
                        child: _buildPickerTile(
                          label: 'Region *',
                          value: _region?.name,
                          onTap: _pickRegion,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPickerTile(
                          label: 'Province *',
                          value: _province?.name,
                          onTap: _pickProvince,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildPickerTile(
                          label: 'Municipality *',
                          value: _municipality?.name,
                          onTap: _pickMunicipality,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPickerTile(
                          label: 'Barangay *',
                          value: _barangay?.name,
                          onTap: _pickBarangay,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Postal code
               _buildLabeledField(
  label: 'Postal Code *',
  child:  TextFormField(
  controller: _postalCtrl,
  keyboardType: TextInputType.number,
  maxLength: 4,
  decoration: _inputDecoration('e.g. 9800').copyWith(
    counterText: '', // 🔥 hides the 0/4 counter
  ),
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
),

),

                  const SizedBox(height: 16),

                  // Street
                  _buildLabeledField(
                    label: 'Street *',
                    child: TextFormField(
                      controller: _streetCtrl,
                      decoration: _inputDecoration(
                          'House no., street, purok'),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Landmark
                  _buildLabeledField(
                    label: 'Landmark',
                    child: TextFormField(
                      controller: _landmarkCtrl,
                      maxLines: 3,
                      decoration: _inputDecoration('Optional landmark'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isEdit ? 'Save Changes' : 'Save Address',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Get.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textDark)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _typeChip(String value) {
    final selected = _addressType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _addressType = value),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.brandLight : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  selected ? AppColors.brandDark : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.brandDark
                    : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerTile({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return _buildLabeledField(
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.brandBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? 'Select',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: value == null
                        ? AppColors.textLight
                        : AppColors.textDark,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
