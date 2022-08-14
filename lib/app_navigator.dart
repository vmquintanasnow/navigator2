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
    Widget child, {
    bool fullScreenDialog = false,
    required String name,
  }) {
    pages.value = List.from(pages.value)
      ..add(AppPage(
        child: child,
        fullScreenDialog: fullScreenDialog,
        name: name,
      ));
  }

  void pushAndReplaceAllStack(
    Widget child, {
    bool fullScreenDialog = false,
    required String name,
  }) {
    pages.value = [
      AppPage(
        child: child,
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
    Widget child, {
    required String name,
  }) {
    pages.value = List.from(pages.value)
      ..last = AppPage(
        child: child,
        name: name,
        fullScreenDialog: false,
      );
  }

  void replacement(
    Widget child, {
    required String name,
    required String target,
  }) {
    final targetIndex = pages.value.indexWhere((element) => element.name == target);
    if (targetIndex >= 0) {
      final List<Page> pagesCopy = List.from(pages.value);
      pagesCopy[targetIndex] = AppPage(
        child: child,
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

class AppPage extends Page<dynamic> {
  AppPage({
    required this.child,
    required String name,
    this.fullScreenDialog,
  }) : super(key: UniqueKey(), name: name);

  final Widget child;
  final bool? fullScreenDialog;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      fullscreenDialog: fullScreenDialog ?? false,
      builder: (context) => child,
    );
  }
}
