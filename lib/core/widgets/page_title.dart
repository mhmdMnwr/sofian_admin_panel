import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String pageName;
  const PageTitle({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Text(
      pageName,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24),
    );
  }
}
