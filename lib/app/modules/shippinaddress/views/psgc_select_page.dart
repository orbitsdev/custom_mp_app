import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/data/models/shippingaddress/region_model.dart';
import 'package:custom_mp_app/app/data/repositories/psgc_repository.dart';
import 'package:custom_mp_app/app/global/widgets/modals/app_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PSGCLevel { region, province, municipality, barangay }

class PSGCSelectPage extends StatefulWidget {
  final PSGCLevel level;
  final String? parentCode; // regionCode, provinceCode, municipalityCode
  final RegionModel? initialSelection;

  const PSGCSelectPage({
    super.key,
    required this.level,
    this.parentCode,
    this.initialSelection,
  });

  @override
  State<PSGCSelectPage> createState() => _PSGCSelectPageState();
}

class _PSGCSelectPageState extends State<PSGCSelectPage> {
  final _searchCtrl = TextEditingController();
  final _items = <RegionModel>[];
  bool _isLoading = false;

  late final PSGCRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = Get.find<PSGCRepository>();
    _loadItems();
    _searchCtrl.addListener(() {
      setState(() {}); // only local filter
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.level) {
      case PSGCLevel.region:
        return 'Select Region';
      case PSGCLevel.province:
        return 'Select Province';
      case PSGCLevel.municipality:
        return 'Select Municipality';
      case PSGCLevel.barangay:
        return 'Select Barangay';
    }
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);

    final result = switch (widget.level) {
      PSGCLevel.region => await _repo.fetchRegions(),
      PSGCLevel.province =>
          await _repo.fetchProvinces(widget.parentCode ?? ''),
      PSGCLevel.municipality =>
          await _repo.fetchMunicipalities(widget.parentCode ?? ''),
      PSGCLevel.barangay =>
          await _repo.fetchBarangays(widget.parentCode ?? ''),
    };

    result.match(
      (failure) {
        AppModal.error(title: 'Error', message: failure.message);
      
      },
      (list) {
        _items
          ..clear()
          ..addAll(list);
      },
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _items
        : _items
            .where((e) =>
                (e.name ?? '').toLowerCase().contains(query) ||
                e.code.toLowerCase().contains(query))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      backgroundColor: AppColors.brandBackground,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? _buildShimmerList()
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, thickness: 0.5),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isSelected = widget.initialSelection?.code ==
                          item.code;

                      return ListTile(
                        title: Text(item.name ?? ''),
                       
                        trailing: isSelected
                            ? Icon(Icons.check, color: AppColors.brandDark)
                            : null,
                        onTap: () {
                          Get.back(result: item);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    // simple shimmer-like placeholders (no extra package)
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
