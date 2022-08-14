part of 'app_navigator.dart';

class NavigationLayer extends StatelessWidget {
  final Widget initPage;
  final String initPath;

  NavigationLayer({required this.initPage, required this.initPath}) {
    AppNavigator().pages.value = [AppPage(child: initPage, name: initPath)];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Page>>(
      valueListenable: AppNavigator().pages,
      builder: (BuildContext context, pages, _) {
        return Navigator(
          key: Key('navigator'),
          transitionDelegate: DefaultTransitionDelegate(),
          pages: pages,
          onPopPage: (route, result) {
            if (route.didPop(result)) {
              AppNavigator().pop();
              return true;
            } else {
              return false;
            }
          },
        );
      },
    );
  }
}
