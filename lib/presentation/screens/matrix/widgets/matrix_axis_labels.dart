import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

class MatrixAxisLabels extends StatelessWidget {
  const MatrixAxisLabels({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Top axis: Urgent / Not Urgent
        Row(
          children: [
            const Expanded(child: SizedBox.shrink()),
            Expanded(
              child: Center(
                child: Text(
                  AppStrings.urgent,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  AppStrings.notUrgent,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(AppDimensions.paddingXs),
        // Left axis: Important / Not Important (handled via Row inside GridView)
        Row(
          children: [
            // Vertical labels
            SizedBox(
              width: 30,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        AppStrings.important,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        AppStrings.notImportant,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(AppDimensions.paddingXs),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }
}
