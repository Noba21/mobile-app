import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../landing/domain/entities/package.dart';
import '../../domain/repositories/admin_package_repository.dart';

/// Create (package == null) or edit (package != null) package form.
class AdminPackageFormPage extends StatefulWidget {
  const AdminPackageFormPage({super.key, this.package});

  final Package? package;

  @override
  State<AdminPackageFormPage> createState() => _AdminPackageFormPageState();
}

class _AdminPackageFormPageState extends State<AdminPackageFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late final TextEditingController _categoryController;
  late final TextEditingController _serviceController;

  List<String> _includedServices = [];
  List<String> _sampleImageUrls = [];
  bool _saving = false;

  bool get _isEdit => widget.package != null;

  @override
  void initState() {
    super.initState();
    final p = widget.package;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p?.price.toString() ?? '');
    _durationController = TextEditingController(text: p?.duration ?? '');
    _categoryController = TextEditingController(text: p?.category ?? '');
    _serviceController = TextEditingController();
    _includedServices = List.from(p?.includedServices ?? []);
    _sampleImageUrls = List.from(p?.sampleImageUrls ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _categoryController.dispose();
    _serviceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid price')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = getIt<AdminPackageRepository>();
      if (_isEdit) {
        await repo.updatePackage(
          id: widget.package!.id,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          duration: _durationController.text.trim(),
          includedServices: _includedServices,
          sampleImageUrls: _sampleImageUrls,
          category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
        );
      } else {
        await repo.createPackage(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          price: price,
          duration: _durationController.text.trim(),
          includedServices: _includedServices,
          sampleImageUrls: _sampleImageUrls,
          category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEdit ? 'Package updated' : 'Package created')),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _addService() {
    final s = _serviceController.text.trim();
    if (s.isEmpty) return;
    setState(() {
      _includedServices.add(s);
      _serviceController.clear();
    });
  }

  void _removeService(String s) {
    setState(() => _includedServices.remove(s));
  }

  void _addImageUrl() {
    showDialog(
      context: context,
      builder: (ctx) {
        final c = TextEditingController();
        return AlertDialog(
          title: const Text('Add image URL'),
          content: TextField(
            controller: c,
            decoration: const InputDecoration(hintText: 'https://...'),
            keyboardType: TextInputType.url,
            autofocus: true,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final url = c.text.trim();
                if (url.isNotEmpty) {
                  setState(() => _sampleImageUrls.add(url));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeImageUrl(int index) {
    setState(() => _sampleImageUrls.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit package' : 'New package'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saving ? null : _submit,
              child: const Text('Save'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid number';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration',
                      border: OutlineInputBorder(),
                      hintText: 'e.g. 2 hours',
                    ),
                    validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            const Text('Included services', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._includedServices.map(
                  (s) => Chip(
                    label: Text(s),
                    onDeleted: () => _removeService(s),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _serviceController,
                    decoration: InputDecoration(
                      hintText: 'Add service',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addService,
                      ),
                    ),
                    onSubmitted: (_) => _addService(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingLg),
            const Text('Sample image URLs', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...List.generate(_sampleImageUrls.length, (i) {
              return ListTile(
                dense: true,
                title: Text(
                  _sampleImageUrls[i],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _removeImageUrl(i),
                ),
              );
            }),
            TextButton.icon(
              onPressed: _addImageUrl,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add image URL'),
            ),
          ],
        ),
      ),
    );
  }
}
