import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../model_enums/quardant_enum.dart';
import '../notifier/walkthrough_notifier.dart';


// A StatefulWidget for displaying a walkthrough/tutorial overlay on a widget
class WalkthroughWidget extends StatefulWidget {


  // Required parameters to uniquely identify the widget and define its behavior
  final String id, nextId;
  final String title, desc;
  final Widget childWidget, displayWidget;


  // Constructor that initializes the widget's parameters and allows for optional highlightedWidget
  const WalkthroughWidget({
    super.key,
    required this.id,
    required this.childWidget,
    Widget? highlightedWidget,
    this.nextId = '',    // ID of the next walkthrough step
    this.title  = '',    // Title of the walkthrough
    this.desc   = '',    // Description of the walkthrough
  }) : displayWidget = highlightedWidget ?? childWidget;  // Default to childWidget if no highlightedWidget is provided


  @override
  State<WalkthroughWidget> createState() => _WalkthroughWidgetState();
}


// The state associated with WalkthroughWidget
class _WalkthroughWidgetState extends State<WalkthroughWidget> {

  // Variables for the widget's render box, position, and quadrants
  RenderBox?  _renderBox;
  Offset?     _position;
  Quardant?   _xQuard, _yQuard;


  final _globalKey = GlobalKey();  // GlobalKey for finding the position of the widget
  final _notifier  = WalkThroughNotifier.instance;  // Instance of the WalkthroughNotifier


  @override
  void initState() {
    super.initState();

    // Using SchedulerBinding to trigger setState after the first frame is rendered.
    // This is needed because we want to access the widget's position after the build phase.
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() { }));
  }


  // The build method constructs the widget tree and listens for changes in the notifier.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _notifier.id,  // Listens to changes in the walkthrough ID
        builder: (context, value, child) {
          // If the current walkthrough ID matches the widget ID and it hasn't been shown before,
          // trigger the walkthrough to be displayed as an alert.
          if (value == widget.id && !_notifier.isShownBefore) {
            Future.microtask(() => _showWalkthroughAsAlert());
          }

          // Return the child widget with the global key assigned for position tracking
          return SizedBox(
            key: _globalKey,
            child: widget.childWidget,
          );
        }
    );
  }


  // Displays the walkthrough as an overlay with an alert-like UI
  Future<void> _showWalkthroughAsAlert() async {
    // Preprocess the widget to get its position and size
    await _preProcessWidget();

    // If renderBox is null, abort the process (could happen if widget isn't rendered properly)
    if (_renderBox == null) return;

    // Set the quadrant for positioning the alert based on the widget's position
    _setWidgetQuard();

    // Show the walkthrough overlay alert
    _showAlert();
  }


  // Builds and shows the alert with highlighter and informational content
  void _showAlert() {
    showDialog(
      context: context,
      useSafeArea: true,  // Use safe area to avoid overlap with system UI
      builder: (_) {
        return GestureDetector(
          onTap: () {
            // Dismiss the dialog and move to the next walkthrough step
            Navigator.pop(context);
            WalkThroughNotifier.instance.setId(widget.nextId);
          },
          child: Stack(
            children: [
              // Opaque background to dim the screen
              Positioned(
                top     : 0,
                left    : 0,
                right   : 0,
                bottom  : 0,
                child   : Container(color: Colors.black12),
              ),

              // Highlighted area around the widget to emphasize it
              Positioned(
                left: _position!.dx - (_renderBox!.size.width/2) - 10,
                top: _position!.dy - (_renderBox!.size.height/2) - 30,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(150)),
                  ),
                  child: widget.displayWidget,  // Display the highlighted widget content
                ),
              ),

              // Walkthrough informational content (title, description, and arrows)
              Positioned(
                left: 0,
                right: 0,
                top: _getVerticalPadding(),  // Dynamic vertical padding based on position
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the top arrow if applicable
                      if (checkPointVisibility())
                        Transform.translate(
                          offset: _getHorizontalOffset(),
                          child: Transform.rotate(
                            angle: 95,  // Rotate the arrow to point upwards
                            child: Container(
                              height: 30,
                              width : 30,
                              color : Colors.white,
                            ),
                          ),
                        ),

                      // Title and description of the walkthrough
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.desc,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),

                      // Display the bottom arrow if applicable
                      if (checkPointVisibility(false))
                        Transform.translate(
                          offset: _getHorizontalOffset(false),
                          child: Transform.rotate(
                            angle: 95,  // Rotate the arrow to point downwards
                            child: Container(
                              height: 30,
                              width : 30,
                              color : Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  // Retrieves the widget's position relative to the global coordinate system
  Future<void> _preProcessWidget() async {
    _renderBox  = _globalKey.currentContext?.findRenderObject() as RenderBox?;
    _position   = _renderBox?.localToGlobal(Offset.zero);
  }


  // Determines the quadrant (first, second, third, or fourth) of the widget's position on the screen
  void _setWidgetQuard() {
    if (_renderBox != null && _position != null) {
      final size = MediaQuery.of(context).size;

      // Calculate the x and y quadrant for the widget based on its position
      _xQuard = _quadFinder(_position!.dx, size.width);
      _yQuard = _quadFinder(_position!.dy, size.height);
    }
  }


  // Helper function to determine the quadrant based on position and screen size
  Quardant _quadFinder(double pos, double fullSize) {
    final quadWith = fullSize / 4;

    if (pos < quadWith) {
      return Quardant.first;
    } else if (pos < (2 * quadWith)) {
      return Quardant.second;
    } else if (pos < (3 * quadWith)) {
      return Quardant.third;
    }
    return Quardant.forth;
  }


  // Determines the vertical padding for positioning the informational content
  double _getVerticalPadding() {
    final quadHeight    = MediaQuery.of(context).size.height / 4;
    final widgetHeight  = _renderBox!.size.height / 2;

    switch (_yQuard) {
      case Quardant.third:
      case Quardant.first:
        return quadHeight + widgetHeight;
      default:
        return (2 * quadHeight) + widgetHeight;
    }
  }


  // Calculates the horizontal offset for positioning the arrows and informational content
  Offset _getHorizontalOffset([bool isTop = true]) {
    switch (_xQuard) {
      case Quardant.first:
      case Quardant.second:
        return Offset(_position!.dx - 10, 18 * (isTop ? 1 : -1));
      default:
        return Offset(_position!.dx - 25, 18 * (isTop ? 1 : -1));
    }
  }


  // Determines whether the top or bottom point of the walkthrough should be visible
  bool checkPointVisibility([bool isTop = true]) {
    return isTop
        ? (_yQuard != null && (_yQuard == Quardant.first || _yQuard == Quardant.second))
        : (_yQuard != null && (_yQuard == Quardant.third || _yQuard == Quardant.forth));
  }
}
