import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/datasources/remote/firebase_storage_datasource.dart';
import '../../../domain/entities/gym_entity.dart';
import '../../blocs/gym/gym_bloc.dart';
import '../../widgets/loading_indicator.dart';

/// Reusable form for both creating and editing a gym listing.
/// When [existingGym] is provided the form is pre-filled for editing;
/// otherwise it creates a new gym.
class GymFormPage extends StatefulWidget {
  const GymFormPage({super.key, this.existingGym});

  final GymEntity? existingGym;

  @override
  State<GymFormPage> createState() => _GymFormPageState();
}

class _GymFormPageState extends State<GymFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _amenitiesCtrl;
  late String _selectedDistrict;

  // ── Gallery state ──────────────────────────────────────────────────────────
  late List<String> _existingUrls; // URLs already persisted in Firestore
  final List<XFile> _newImages = []; // picked locally, not yet uploaded
  bool _isUploading = false;

  bool get _isEditing => widget.existingGym != null;

  @override
  void initState() {
    super.initState();
    final g = widget.existingGym;
    _nameCtrl = TextEditingController(text: g?.name ?? '');
    _descCtrl = TextEditingController(text: g?.description ?? '');
    _priceCtrl = TextEditingController(
      text: g != null ? g.subscriptionPrice.toStringAsFixed(0) : '',
    );
    _amenitiesCtrl = TextEditingController(
      text: g?.amenities.join(', ') ?? '',
    );
    _selectedDistrict = g?.district ?? AppConstants.districts.first;
    _existingUrls = List<String>.from(g?.galleryUrls ?? []);
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() => _newImages.addAll(picked));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _amenitiesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isUploading = true);
    try {
      // Upload any freshly picked images and collect their download URLs.
      final storage = sl<CloudinaryDataSource>();
      final uploadedUrls = <String>[];
      for (final xfile in _newImages) {
        final url = await storage.uploadGymImage(File(xfile.path));
        uploadedUrls.add(url);
      }

      final amenities = _amenitiesCtrl.text
          .split(',')
          .map((a) => a.trim())
          .where((a) => a.isNotEmpty)
          .toList();

      final gym = GymEntity(
        id: widget.existingGym?.id ?? '',
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        district: _selectedDistrict,
        subscriptionPrice: double.parse(_priceCtrl.text.trim()),
        galleryUrls: [..._existingUrls, ...uploadedUrls],
        amenities: amenities,
      );

      if (!mounted) return;
      if (_isEditing) {
        context.read<GymBloc>().add(UpdateGymRequested(gym));
      } else {
        context.read<GymBloc>().add(CreateGymRequested(gym));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image upload failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GymBloc, GymState>(
      listener: (context, state) {
        if (state is GymOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.pop();
        }
        if (state is GymError) {
          setState(() => _isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? AppStrings.editGym : AppStrings.addGym),
          actions: [
            TextButton(
              onPressed: _isUploading ? null : _submit,
              child: _isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      AppStrings.save,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<GymBloc, GymState>(
            builder: (context, state) {
              if (state is GymOperationLoading) {
                return const FitlifeLoadingIndicator(message: 'Saving…');
              }
              return _buildForm();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gym Name
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.gymName,
                prefixIcon: Icon(Icons.fitness_center_outlined),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? AppStrings.fieldRequired
                  : null,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.description,
                prefixIcon: Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (v) => v == null || v.trim().isEmpty
                  ? AppStrings.fieldRequired
                  : null,
            ),
            const SizedBox(height: 16),

            // District
            DropdownButtonFormField<String>(
              initialValue: _selectedDistrict,
              decoration: const InputDecoration(
                labelText: AppStrings.districtLabel,
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              items: AppConstants.districts
                  .map((d) => DropdownMenuItem<String>(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedDistrict = v ?? _selectedDistrict),
            ),
            const SizedBox(height: 16),

            // Price
            TextFormField(
              controller: _priceCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.priceRwf,
                prefixIcon: Icon(Icons.attach_money_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return AppStrings.fieldRequired;
                }
                if (double.tryParse(v.trim()) == null) {
                  return 'Enter a valid number.';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Gallery
            _GalleryPickerField(
              existingUrls: _existingUrls,
              newImages: _newImages,
              onPickImages: _isUploading ? null : _pickImages,
              onRemoveExisting: (i) =>
                  setState(() => _existingUrls.removeAt(i)),
              onRemoveNew: (i) => setState(() => _newImages.removeAt(i)),
            ),
            const SizedBox(height: 16),

            // Amenities
            TextFormField(
              controller: _amenitiesCtrl,
              decoration: const InputDecoration(
                labelText: AppStrings.amenitiesLabel,
                prefixIcon: Icon(Icons.star_outline),
                helperText: 'e.g. Pool, Sauna, Free WiFi',
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isUploading ? null : _submit,
              child: Text(_isEditing ? 'Update Gym' : 'Create Gym'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Gallery Picker ─────────────────────────────────────────────────────────────

/// Horizontal scrolling thumbnail row with an "Add Photos" button.
/// Supports removing both pre-existing URL images and freshly picked files.
class _GalleryPickerField extends StatelessWidget {
  const _GalleryPickerField({
    required this.existingUrls,
    required this.newImages,
    required this.onPickImages,
    required this.onRemoveExisting,
    required this.onRemoveNew,
  });

  final List<String> existingUrls;
  final List<XFile> newImages;
  final VoidCallback? onPickImages;
  final void Function(int index) onRemoveExisting;
  final void Function(int index) onRemoveNew;

  @override
  Widget build(BuildContext context) {
    final total = existingUrls.length + newImages.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_library_outlined,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Gallery Photos ($total)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: onPickImages,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: const Text('Add Photos'),
            ),
          ],
        ),
        if (total == 0)
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'No photos yet — tap Add Photos',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < existingUrls.length; i++)
                  _Thumbnail(
                    onRemove: () => onRemoveExisting(i),
                    child: Image.network(
                      existingUrls[i],
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) =>
                          const Icon(Icons.broken_image),
                    ),
                  ),
                for (int i = 0; i < newImages.length; i++)
                  _Thumbnail(
                    onRemove: () => onRemoveNew(i),
                    child: Image.file(
                      File(newImages[i].path),
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A 100×100 clipped thumbnail with a dismiss ✕ overlay button.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.child, required this.onRemove});

  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(width: 100, height: 100, child: child),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black54,
                ),
                child:
                    const Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
