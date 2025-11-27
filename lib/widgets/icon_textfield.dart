import 'package:flutter/material.dart';
import 'package:mcdmx/state/scheme.dart';
import 'package:mcdmx/style/format.dart';
import 'package:provider/provider.dart';

class IconTextfield extends StatefulWidget {
  final IconData icon;
  final String msg;
  final FocusNode? focusNode;

  IconTextfield({required this.icon, required this.msg, this.focusNode});

  @override
  State<IconTextfield> createState() => _IconTextfieldState();
}

class _IconTextfieldState extends State<IconTextfield> {
  final TextEditingController controller = TextEditingController();

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
      controller: controller,
      focusNode: widget.focusNode,
      keyboardAppearance: scheme.isDarkMode
        ? Brightness.dark
        : Brightness.light,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
        hintText: widget.msg,
        prefixIcon: Icon(widget.icon, color: theme.colorScheme.primary,),
        suffixIcon: controller.text.isEmpty
          ? SizedBox()
          : IconButton(
            icon: Icon(Icons.close_rounded),
            onPressed: () => controller.clear(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Format.borderRadius),
          borderSide: BorderSide(
            color: theme.colorScheme.surfaceContainerLowest,
          )
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Format.borderRadius),
          borderSide: BorderSide(
            color: theme.colorScheme.surfaceContainerLowest,
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Format.borderRadius),
          borderSide: BorderSide(
            color: theme.colorScheme.surfaceContainerLowest,
          )
        )
      ),
      textInputAction: TextInputAction.done,
    );
  }
}
