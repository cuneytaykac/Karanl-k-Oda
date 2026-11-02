import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/onboarding/onboarding.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/settings/settings.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/ko_icon_button.dart';
import '../../../../l10n/l10n.dart';
import '../../../ads/presentation/providers/ads_coordinator.dart';

/// 46 · Ayarlar. Değişiklikler anında cihaza kaydedilir.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final controller = ref.read(settingsProvider.notifier);
    // Avrupa'daki oyuncular reklam onayını buradan değiştirebilmeli (GDPR).
    final privacyRequired =
        ref.watch(privacyOptionsRequiredProvider).value ?? false;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              KoSpacing.l, KoSpacing.l, KoSpacing.l, KoSpacing.xxl),
          children: [
            Row(
              children: [
                KoIconButton(
                    icon: Icons.chevron_left,
                    label: context.l10n.back,
                    onPressed: () => context.pop()),
                const SizedBox(width: KoSpacing.m),
                Text(context.l10n.settingsTitle,
                    style: KoText.screenTitle.copyWith(fontSize: 24)),
              ],
            ),
            _SectionHeader(context.l10n.sectionSound),
            _Group(children: [
              _SwitchRow(
                  context.l10n.music, settings.music, controller.setMusic),
              _SwitchRow(context.l10n.sfx, settings.sfx, controller.setSfx),
              _SwitchRow(context.l10n.vibration, settings.vibration,
                  controller.setVibration),
            ]),
            if (privacyRequired) ...[
              _SectionHeader(context.l10n.sectionPrivacy),
              _Group(children: [
                ListTile(
                  key: const Key('privacy-options'),
                  title: Text(context.l10n.privacyOptions,
                      style: KoText.body
                          .copyWith(color: KoColor.text, fontSize: 14.5)),
                  subtitle: Text(context.l10n.privacyOptionsSubtitle,
                      style: KoText.bodySmall.copyWith(fontSize: 12)),
                  trailing:
                      const Icon(Icons.chevron_right, color: KoColor.textDim),
                  onTap: () =>
                      ref.read(adsPlatformProvider).showPrivacyOptions(),
                ),
              ]),
            ],
            _SectionHeader(context.l10n.sectionHelp),
            _Group(children: [
              ListTile(
                key: const Key('replay-tutorial'),
                title: Text(context.l10n.replayTutorial,
                    style: KoText.body
                        .copyWith(color: KoColor.text, fontSize: 14.5)),
                subtitle: Text(context.l10n.replayTutorialSubtitle,
                    style: KoText.bodySmall.copyWith(fontSize: 12)),
                trailing:
                    const Icon(Icons.chevron_right, color: KoColor.textDim),
                onTap: () {
                  ref.read(onboardingProvider.notifier).reset();
                  context.go(Routes.welcome);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(6, KoSpacing.l, 6, 6),
        child: Text(label, style: KoText.label),
      );
}

class _Group extends StatelessWidget {
  const _Group({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Material(
        color: KoColor.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const Divider(),
              children[i],
            ],
          ],
        ),
      );
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow(this.title, this.value, this.onChanged, {this.subtitle});
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title,
            style: KoText.body.copyWith(color: KoColor.text, fontSize: 14.5)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: KoText.bodySmall.copyWith(fontSize: 12)),
      );
}
