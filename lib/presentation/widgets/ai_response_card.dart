import 'package:flutter/material.dart';
import '../helpers/color/color_helper.dart';
import '../values/colors.dart';
import '../values/strings.dart';

class AiResponseCard extends StatelessWidget {
  final String response;
  final bool isThinking;

  const AiResponseCard({
    super.key,
    required this.response,
    this.isThinking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: ScreenStyleHelper.getModernCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology, color: AppColors.indigoPrimary, size: 24),
              const SizedBox(width: 8),
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.indigoPrimary,
                ),
              ),
            ],
          ),
          if (isThinking)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.indigoPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'AI sedang berpikir...',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            const SizedBox(height: 12),
            Text(
              response,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: ScreenColorHelper.getHeadingText(context),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
