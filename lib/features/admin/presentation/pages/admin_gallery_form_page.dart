import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../landing/domain/entities/gallery_image.dart';
import '../../domain/repositories/admin_gallery_repository.dart';

/// Add (image == null) or edit (image != null) gallery image.
class AdminGalleryFormPage extends StatefulWidget {
  const AdminGalleryFormPage({super.key, this.image});

  final GalleryImage? image;

  @override
  State<AdminGalleryFormPage> createState() => _AdminGalleryFormPageState();
}

class _AdminGalleryFormPageState extends State<AdminGalleryFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _urlController;
  late final TextEditingController _categoryController;
  late final TextEditingController _captionController;
  bool _saving = false;

  bool get _isEdit => widget.image != null;

  @override
  void initState() {
    super.initState();
    final img = widget.image;
    _urlController = TextEditingController(text: img?.url ?? '');
    _categoryController = TextEditingController(text: img?.category ?? '');
    _captionController = TextEditingController(text: img?.caption ?? '');
  }

  @override
  void dispose() {
    _urlController.dispose();
    _categoryController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);
    try {
      final repo = getIt<AdminGalleryRepository>();
      final url = _urlController.text.trim();
      final category = _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim();
      final caption = _captionController.text.trim().isEmpty ? null : _captionController.text.trim();
      if (_isEdit) {
        await repo.updateImage(
          id: widget.image!.id,
          url: url,
          category: category,
          caption: caption,
        );
      } else {
        await repo.addImage(url: url, category: category, caption: caption);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEdit ? 'Image updated' : 'Image added')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit image' : 'Add image'),
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
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
                hintText: 'https://...',
              ),
              keyboardType: TextInputType.url,
              validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextFormField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: 'Caption (optional)',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
