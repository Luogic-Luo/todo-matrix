import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../domain/enums/eisenhower_quadrant.dart';
import 'widgets/quadrant_card.dart';

class MatrixScreen extends ConsumerWidget {
  const MatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.matrix),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;
            final cellWidth =
                (availableWidth - AppDimensions.paddingM) / 2;
            final cellHeight =
                (availableHeight - AppDimensions.paddingM) / 2;
            final aspectRatio = cellWidth / cellHeight;

            return GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: AppDimensions.paddingM,
              crossAxisSpacing: AppDimensions.paddingM,
              childAspectRatio: aspectRatio,
              children: const [
                QuadrantCard(quadrant: EisenhowerQuadrant.doFirst),
                QuadrantCard(quadrant: EisenhowerQuadrant.schedule),
                QuadrantCard(quadrant: EisenhowerQuadrant.delegate),
                QuadrantCard(quadrant: EisenhowerQuadrant.eliminate),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('taskNew'),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('艾森豪威尔矩阵'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
              icon: Icons.priority_high,
              title: AppStrings.doFirst,
              desc: AppStrings.doFirstDesc,
            ),
            Gap(AppDimensions.paddingM),
            _InfoRow(
              icon: Icons.calendar_today,
              title: AppStrings.schedule,
              desc: AppStrings.scheduleDesc,
            ),
            Gap(AppDimensions.paddingM),
            _InfoRow(
              icon: Icons.person_add,
              title: AppStrings.delegate,
              desc: AppStrings.delegateDesc,
            ),
            Gap(AppDimensions.paddingM),
            _InfoRow(
              icon: Icons.cancel_outlined,
              title: AppStrings.eliminate,
              desc: AppStrings.eliminateDesc,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const Gap(AppDimensions.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
