import 'package:flutter/material.dart';

part 'navigation_layer.dart';

class AppNavigator {
  //Singleton stuffs
  static final AppNavigator _singleton = AppNavigator._internal();

  AppNavigator._internal();

  factory AppNavigator() {
    return _singleton;
  }

  //Pages notifier
  ValueNotifier<List<Page>> pages = ValueNotifier(<Page>[]);

  //Navigation methods
  void push(
    Widget widget, {
    bool fullScreenDialog = false,
    required String name,
  }) {
    pages.value = List.from(pages.value)
      ..add(BasicPage(
        widget: widget,
        fullScreenDialog: fullScreenDialog,
        name: name,
      ));
  }

  void pushAndReplaceAllStack(
    Widget widget, {
    bool fullScreenDialog = false,
    required String name,
  }) {
    pages.value = [
      BasicPage(
        widget: widget,
        fullScreenDialog: fullScreenDialog,
        name: name,
      )
    ];
  }

  void popUntilNamed(String path) {
    if (pages.value.any((element) => element.name == path)) {
      final List<Page> pagesCopy = List.from(pages.value);
      while (pagesCopy.last.name != path) {
        pagesCopy.removeLast();
      }
      pages.value = pagesCopy;
    }
  }

  void pop() {
    if (pages.value.length > 1) {
      pages.value = List.from(pages.value)..removeLast();
    }
  }

  void pushReplacement(
    Widget widget, {
    required String name,
  }) {
    pages.value = List.from(pages.value)
      ..last = BasicPage(
        widget: widget,
        name: name,
        fullScreenDialog: false,
      );
  }

  void replacement(
    Widget widget, {
    required String name,
    required String target,
  }) {
    final targetIndex = pages.value.indexWhere((element) => element.name == target);
    if (targetIndex >= 0) {
      final List<Page> pagesCopy = List.from(pages.value);
      pagesCopy[targetIndex] = BasicPage(
        widget: widget,
        name: name,
        fullScreenDialog: false,
      );

      pages.value = pagesCopy;
    }
  }

  //Aux
  String? get currentPath {
    return pages.value.last.name;
  }

  Iterable<String> get navigationTree {
    return pages.value.map((page) => page.name ?? 'nameLess page');
  }
}

class AppPage extends Page {
  final Widget child;

  const AppPage({required String name, required this.child}) : super(name: name);

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (context) => child,
    );
  }
}

class BasicPage extends Page<dynamic> {
  BasicPage({
    required this.widget,
    required String name,
    this.fullScreenDialog,
  }) : super(key: UniqueKey(), name: name);

  final Widget widget;
  final bool? fullScreenDialog;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      fullscreenDialog: fullScreenDialog ?? false,
      builder: (context) => widget,
    );
  }
}
