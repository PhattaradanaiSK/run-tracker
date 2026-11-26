import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/distance_validation.dart';
import '../../data/providers.dart';
import '../../models/run_entry.dart';
import '../../theme/tokens.dart';
import '../widgets/run_form.dart';

/// Add: camera slot (optional photo), three Thai fields, save / cancel.
class AddRunUi extends ConsumerStatefulWidget {
  const AddRunUi({super.key});

  @override
  ConsumerState<AddRunUi> createState() => _AddRunUiState();
}

class _AddRunUiState extends ConsumerState<AddRunUi> {
  final TextEditingController _where = TextEditingController();
  final TextEditingController _person = TextEditingController();
  final TextEditingController _distance = TextEditingController();

  String? _photoPath;
  bool _busy = false;

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
    setState(() => _photoPath = saved);
  }

  void _clear() {
    setState(() {
      _where.clear();
      _person.clear();
      _distance.clear();
      _photoPath = null;
    });
  }

  Future<void> _save() async {
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
      await ref.read(runRepositoryProvider).createRun(
            RunDraft(
              runWhere: _where.text,
              runPerson: _person.text,
              runDistance: int.parse(_distance.text.trim()),
              photoPath: _photoPath,
            ),
          );
      await ref.read(runListProvider.notifier).refresh();
      if (!mounted) return;
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      _toast('บันทึกข้อมูลไม่สำเร็จ');
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    // A freshly captured photo is always a local file, so no resolver is
    // needed here; the slot shows either the new file or the placeholder.
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(RunFormCopy.addTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          onPressed: () => context.pop(),
          tooltip: 'ย้อนกลับ',
        ),
        leadingWidth: 56,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageInset,
            28,
            AppSpacing.pageInset,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              PhotoSlot(onTap: _capture, photoPath: _photoPath),
              const SizedBox(height: 36),
              RunForm(
                whereController: _where,
                personController: _person,
                distanceController: _distance,
                primaryLabel: RunFormCopy.saveLabel,
                onPrimary: _save,
                dangerLabel: RunFormCopy.cancelLabel,
                onDanger: _clear,
                busy: _busy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
