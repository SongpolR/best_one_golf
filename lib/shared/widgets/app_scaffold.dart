import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: leading,
        automaticallyImplyLeading: leading == null,
        actions: actions,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ),
      body: SafeArea(child: body),
    );
  }
}