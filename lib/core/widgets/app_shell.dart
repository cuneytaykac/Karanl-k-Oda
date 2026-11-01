import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/progress/presentation/providers/progress_providers.dart';
import 'bottom_nav.dart';

/// Banyo / Dosyalar / Defter sekmelerini alt menüyle saran iskelet.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const notebookTab = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeProgressProvider);
    final onNotebook = shell.currentIndex == notebookTab;
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNav(
        selected: shell.currentIndex,
        // Defterde görülmemiş yeni ipucu ya da teori varsa nokta yanar.
        notebookDot: !onNotebook && (active?.hasUnseenNotes ?? false),
        onSelected: (i) {
          if (i == notebookTab && active != null) {
            ref.read(progressProvider.notifier).markNotebookSeen(active.caseId);
          }
          // Aynı sekmeye tekrar dokununca o sekmenin başına döner.
          shell.goBranch(i, initialLocation: i == shell.currentIndex);
        },
      ),
    );
  }
}
