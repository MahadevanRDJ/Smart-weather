import 'package:flutter/material.dart';

class WidgetResource {
  static Orientation getOrientation(context) => MediaQuery.orientationOf(context);

  static tapOutside(context) => () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      };

  static AlertDialog getLoader(context) => _loader;
  static PageRouteBuilder getSlideNavigation(context, nextScreen) => _EnterExitRoute(exitPage: context, enterPage: nextScreen);
}

AlertDialog _loader = const AlertDialog(
  surfaceTintColor: Colors.transparent,
  backgroundColor: Colors.transparent,
  content: Center(
    child: CircularProgressIndicator(
      color: Colors.blue,
      strokeWidth: 5.0,
    ),
  ),
);

class _EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  _EnterExitRoute({required this.exitPage, required this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(-1.0, 0.0),
                ).animate(animation),
                child: exitPage,
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: enterPage,
              )
            ],
          ),
        );
}
