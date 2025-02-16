/// Tree view widget library
library tree_view;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TreeView extends InheritedWidget {
  final List<Widget> children;
  final bool startExpanded;

  TreeView({
    Key? key,
    required List<Widget> children,
    bool startExpanded = false,
  })  : this.children = children,
        this.startExpanded = startExpanded,
        super(
          key: key,
          child: _TreeViewData(
            children: children,
          ),
        );

  static TreeView? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TreeView>();
  }

  @override
  bool updateShouldNotify(TreeView oldWidget) {
    if (oldWidget.children == this.children &&
        oldWidget.startExpanded == this.startExpanded) {
      return false;
    }
    return true;
  }
}

class _TreeViewData extends StatelessWidget {
  final List<Widget>? children;

  const _TreeViewData({
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: children!.length,
      itemBuilder: (context, index) {
        return children!.elementAt(index);
      },
    );
  }
}

class TreeViewChild extends StatefulWidget {
  final bool? startExpanded;
  final Widget parent;
  final List<Widget> children;
  final VoidCallback? onTap;

  TreeViewChild({
    required this.parent,
    required this.children,
    this.startExpanded,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  TreeViewChildState createState() => TreeViewChildState();

  TreeViewChild copyWith(
    TreeViewChild source, {
    bool? startExpanded,
    Widget? parent,
    List<Widget>? children,
    VoidCallback? onTap,
  }) {
    return TreeViewChild(
      parent: parent ?? source.parent,
      children: children ?? source.children,
      startExpanded: startExpanded ?? source.startExpanded,
      onTap: onTap ?? source.onTap,
    );
  }
}

class TreeViewChildState extends State<TreeViewChild>
    with SingleTickerProviderStateMixin {
  bool? isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.startExpanded;
  }

  @override
  void didChangeDependencies() {
    isExpanded = widget.startExpanded ?? TreeView.of(context)!.startExpanded;
    super.didChangeDependencies();
  }

    @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          children: [
            widget.parent,
            Positioned(
              left: 0,
              right: 100,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: widget.onTap ?? () => toggleExpanded(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
        Container(
          child: isExpanded!
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.children,
                )
              : Offstage(),
        ),
      ],
    );
  }
  void toggleExpanded() {
    setState(() {
      this.isExpanded = !this.isExpanded!;
    });
  }
}

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
