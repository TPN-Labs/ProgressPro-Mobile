import 'package:flutter/material.dart';

Widget settingsRow(BuildContext context, String? title, IconData leadingIcon, String? endingLabel, Color? highlightColor) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(
            leadingIcon,
            color: highlightColor ?? Theme.of(context).textTheme.titleLarge!.color,
            size: 25,
          ),
          const SizedBox(width: 10),
          Text(
            title!,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: highlightColor ?? Theme.of(context).textTheme.bodyMedium!.color,
                ),
          ),
        ],
      ),
      Row(
        children: [
          if (endingLabel != null) ...[
            Text(
              endingLabel,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: highlightColor ?? Theme.of(context).textTheme.bodyMedium!.color,
                  ),
            ),
            const SizedBox(width: 5),
          ],
          Icon(
            Icons.arrow_forward_ios,
            color: highlightColor ?? Theme.of(context).textTheme.titleLarge!.color,
            size: 25,
          )
        ],
      ),
    ],
  );
}
