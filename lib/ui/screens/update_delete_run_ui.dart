import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/distance_validation.dart';
import '../../data/providers.dart';
import '../../models/run_entry.dart';
import '../../theme/tokens.dart';
import '../widgets/run_form.dart';

/// Edit / delete: existing photo or logo, pre-filled fields, update / delete.
class UpdateDeleteRunUi extends ConsumerStatefulWidget {
  const UpdateDeleteRunUi({super.key, required this.runId});

  final String runId;

  @override
  ConsumerState<UpdateDeleteRunUi> createState() => _UpdateDeleteRunUiState();
}

class _UpdateDeleteRunUiState extends ConsumerState<UpdateDeleteRunUi> {
  final TextEditingController _where = TextEditingController();
  final TextEditingController _person = TextEditingController();
  final TextEditingController _distance = TextEditingController();

  RunEntry? _run;
  bool _loaded = false;
  bool _busy = false;

  /// New capture; null means keep the stored photo.
  String? _newPhotoPath;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final run = await ref.read(runRepositoryProvider).getRun(widget.runId);
    if (!mounted) return;
    if (run != null) {
      _where.text = run.runWhere;
      _person.text = run.runPerson;
      _distance.text = '${run.runDistance}';
    }
    setState(() {
      _run = run;
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _where.dispose();
    _person.dispose();
    _distance.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final store = ref.read(photoStoreProvider);
    final shot = await store.capturePhoto();
    if (!mounted || shot == null) return;
    final saved = await store.persistPhoto(shot);
    if (!mounted) return;
    setState(() => _newPhotoPath = saved);
  }

  Future<void> _update() async {
    final error = validateRunForm(
      runWhere: _where.text,
      runPerson: _person.text,
      runDistance: _distance.text,
    );
    if (error != null) {
      _toast(error);
      return;
    }

    setState(() => _busy = true);
    try {
      final store = ref.read(photoStoreProvider);
      final previous = _run?.runImageUrl;
      final newPhoto = _newPhotoPath;

      await ref.read(runRepositoryProvider).updateRun(
            widget.runId,
            RunDraft(
              runWhere: _where.text,
              runPerson: _person.text,
              runDistance: int.parse(_distance.text.trim()),
              photoPath: newPhoto,
            ),
          );

      // Replaced photo: drop the old local file (Supabase will delete run_bk
      // objects in the same spot once it is wired).
      if (newPhoto != null && previous != null && previous != newPhoto) {
        await store.deletePhoto(previous);
      }

      await ref.read(runListProvider.notifier).refresh();
      if (!mounted) return;
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      _toast('บันทึกแก้ไขข้อมูลไม่สำเร็จ');
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('ลบข้อมูลนี้?'),
        content: const Text('ข้อมูลการวิ่งและรูปภาพจะถูกลบออกจากรายการ'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'ไม่ลบ',
              style: AppText.fieldLabel.copyWith(color: AppColors.navy),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'ลบข้อมูล',
              style: AppText.fieldLabel.copyWith(
                color: AppColors.buttonDanger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) await _delete();
  }

  Future<void> _delete() async {
    setState(() => _busy = true);
    try {
      final store = ref.read(photoStoreProvider);
      final stored = _run?.runImageUrl;
      await ref.read(runRepositoryProvider).deleteRun(widget.runId);
      if (stored != null) await store.deletePhoto(stored);
      await ref.read(runListProvider.notifier).refresh();
      if (!mounted) return;
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      _toast('ลบข้อมูลไม่สำเร็จ');
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final photoResolver = ref.watch(photoUrlResolverProvider);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(RunFormCopy.editTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          onPressed: () => context.pop(),
          tooltip: 'ย้อนกลับ',
        ),
        leadingWidth: 56,
      ),
      body: SafeArea(
        child: !_loaded
            ? const Center(child: CircularProgressIndicator())
            : _run == null
                ? Center(
                    child: Text(
                      'ไม่พบข้อมูล',
                      style: AppText.fieldText
                          .copyWith(color: AppColors.buttonDanger),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pageInset,
                      26,
                      AppSpacing.pageInset,
                      32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        PhotoSlot(
                          onTap: _capture,
                          photoPath: _newPhotoPath ?? _run!.runImageUrl,
                          showLogoFallback: true,
                          photoResolver: photoResolver,
                        ),
                        const SizedBox(height: 40),
                        RunForm(
                          whereController: _where,
                          personController: _person,
                          distanceController: _distance,
                          primaryLabel: RunFormCopy.updateLabel,
                          onPrimary: _update,
                          dangerLabel: RunFormCopy.deleteLabel,
                          onDanger: _confirmDelete,
                          busy: _busy,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
