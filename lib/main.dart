import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NavigationLayer(),
    );
  }
}

class NavigationLayer extends StatefulWidget {
  @override
  _NavigationLayerState createState() => _NavigationLayerState();
}

class _NavigationLayerState extends State<NavigationLayer> {
  List<Page<Object>> pages = <Page>[];

  @override
  void initState() {
    CustomNavigator().pages = [BasePage(name: 'page1', widget: Pape1())];
    pages = [...CustomNavigator().pages];

    CustomNavigator().addListener(() {
      setState(() {
        pages = [...CustomNavigator().pages];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: pages,
      onPopPage: (route, result) {
        if (route.didPop(result)) {
          CustomNavigator().pop();
          return true;
        } else {
          return false;
        }
      },
    );
  }
}

class CustomNavigator extends ChangeNotifier {
  static final CustomNavigator _singleton = CustomNavigator._internal();
  List<Page<Object>> pages = <Page>[];

  void push(
    Widget widget, {
    bool fullScreenDialog = false,
    @required String name,
  }) {
    pages.add(BasePage(
      widget: widget,
      fullScreenDialog: fullScreenDialog,
      name: name,
    ));
    notifyListeners();
  }

  void pushAndReplaceAllStack(
    Widget widget, {
    bool fullScreenDialog = false,
    @required String name,
  }) {
    pages = [
      BasePage(
        widget: widget,
        fullScreenDialog: fullScreenDialog,
        name: name,
      )
    ];
    notifyListeners();
  }

  void pop() {
    pages.removeLast();
    notifyListeners();
  }

  void popUntil(String routeName) {
    int i = pages.length - 1;
    while (i >= 0 && pages[i].name != routeName) {
      pages.removeLast();
      i--;
    }
    notifyListeners();
  }

  void pushReplacement(
    Widget widget, {
    bool fullScreenDialog = false,
    @required String name,
  }) {
    pages.last = BasePage(
      widget: widget,
      fullScreenDialog: fullScreenDialog,
      name: name,
    );
    notifyListeners();
  }

  factory CustomNavigator() {
    return _singleton;
  }

  CustomNavigator._internal();
}

class BasePage extends Page {
  BasePage({
    @required this.widget,
    @required String name,
    this.fullScreenDialog = false,
  }) : super(key: ValueKey(name), name: name);

  final Widget widget;
  final bool fullScreenDialog;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      fullscreenDialog: fullScreenDialog,
      builder: (context) => widget,
    );
  }
}

class Pape1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Container(
        child: ElevatedButton(
          child: Text('Go to Page 2'),
          onPressed: () => CustomNavigator().push(Page2(), name: 'page2'),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: Container(
        child: ElevatedButton(
          child: Text('Go to Page 3'),
          onPressed: () => CustomNavigator().push(Page3(), name: 'page3'),
        ),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 3'),
      ),
      body: Container(
        child: ElevatedButton(
          child: Text('Go to Page1'),
          onPressed: () => CustomNavigator().popUntil('page1'),
        ),
      ),
    );
  }
}
