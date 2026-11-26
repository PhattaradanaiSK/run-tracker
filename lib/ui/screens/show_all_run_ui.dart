import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../../models/run_entry.dart';
import '../../theme/tokens.dart';
import '../router/app_router.dart';
import '../widgets/brand_logo.dart';
import '../widgets/navy_fab.dart';
import '../widgets/run_card.dart';
import '../widgets/run_thumb.dart';

/// The Thai slogan under the logo, on both the empty and the filled state.
const String kSlogan = 'วิ่งกันเถอะ';

/// Show all: navy app bar, brand logo, slogan, optional list, navy FAB.
class ShowAllRunUi extends ConsumerWidget {
  const ShowAllRunUi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runs = ref.watch(runListProvider);
    final photoResolver = ref.watch(photoUrlResolverProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Run Tracker'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.fabBottomPadding),
        child: NavyFab(onPressed: () => context.push(AppRoutes.add)),
      ),
      body: SafeArea(
        child: runs.when(
          loading: () => const _ShowAllShell(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, _) => _ShowAllShell(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageInset,
                vertical: 32,
              ),
              child: Text(
                'โหลดข้อมูลไม่สำเร็จ',
                textAlign: TextAlign.center,
                style: AppText.fieldText.copyWith(color: AppColors.buttonDanger),
              ),
            ),
          ),
          data: (list) => _ShowAllShell(
            child: _RunList(runs: list, photoResolver: photoResolver),
          ),
        ),
      ),
    );
  }
}

/// Logo + slogan header shared by every Show all state.
class _ShowAllShell extends StatelessWidget {
  const _ShowAllShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 54),
          child: Center(child: BrandLogo(width: AppSpacing.brandLogoWidth)),
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text(kSlogan, style: AppText.slogan, textAlign: TextAlign.center),
        ),
        const SizedBox(height: 24),
        Expanded(child: child),
      ],
    );
  }
}

class _RunList extends StatelessWidget {
  const _RunList({required this.runs, this.photoResolver});

  final List<RunEntry> runs;
  final PhotoUrlResolver? photoResolver;

  @override
  Widget build(BuildContext context) {
    if (runs.isEmpty) {
      // Empty DB: the header alone is the design; nothing else in the body.
      return const SizedBox.shrink();
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        AppSpacing.fabSize + 40,
      ),
      itemCount: runs.length,
      itemBuilder: (context, index) {
        final run = runs[index];
        return RunCard(
          run: run,
          index: index,
          photoResolver: photoResolver,
          onTapInfo: () => context.push(AppRoutes.editFor(run.id)),
        );
      },
    );
  }
}
