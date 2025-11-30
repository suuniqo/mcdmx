import 'package:flutter/material.dart';
import 'package:mcdmx/state/scheme.dart';
import 'package:mcdmx/style/format.dart';
import 'package:provider/provider.dart';

class IconTextfield extends StatefulWidget {
  final IconData icon;
  final String msg;
  final bool primary;
  final FocusNode? focusNode;
  final VoidCallback? onPressed;
  final TextEditingController? controller;
  final bool enabled;
  final bool readOnly;

  IconTextfield({
    required this.icon,
    required this.msg,
    required this.primary,
    this.focusNode,
    this.onPressed,
    this.controller,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  State<IconTextfield> createState() => _IconTextfieldState();
}

class _IconTextfieldState extends State<IconTextfield> {
  late final TextEditingController controller = widget.controller ?? TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = context.watch<SchemeState>();

    return TextField(
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      controller: controller,
      focusNode: widget.focusNode,
      keyboardAppearance: scheme.isDarkMode
          ? Brightness.dark
          : Brightness.light,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.primary
          ? theme.colorScheme.surfaceContainerLow
          : theme.colorScheme.surfaceContainerLowest,
        hintText: widget.msg,
        prefixIcon: IconButton(
          icon: Icon(widget.icon, color: theme.colorScheme.primary,),
          onPressed: widget.onPressed,

        ),
        suffixIcon: controller.text.isEmpty
            ? SizedBox()
            : IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: () => controller.clear(),
              ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Format.borderRadius),
          borderSide: BorderSide(
            color: widget.primary
              ? theme.colorScheme.surfaceContainerLow
              : theme.colorScheme.surfaceContainerLowest,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Format.borderRadius),
          borderSide: BorderSide(
            color: widget.primary
              ? theme.colorScheme.surfaceContainerLow
              : theme.colorScheme.surfaceContainerLowest,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Format.borderRadius),
          borderSide: BorderSide(
            color: widget.primary
              ? theme.colorScheme.surfaceContainerLow
              : theme.colorScheme.surfaceContainerLowest,
          ),
        ),
      ),
      textInputAction: TextInputAction.done,
    );
  }
}
