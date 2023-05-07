import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class SliderValue extends ChangeNotifier {
  // SliderValue._sharedInstance();
  // static final SliderValue _shared = SliderValue._sharedInstance();
  // factory SliderValue() => _shared;


  double _value = 0.0;
  double get value => _value;
  set value(double newVal) {
    if (newVal != _value) {
      _value = newVal;
      notifyListeners();
    }
  }
}

final sliderData = SliderValue();

class SliderInheritedNotifier extends InheritedNotifier<SliderValue> {
  const SliderInheritedNotifier({
    super.key,
    required super.child,
    required super.notifier,
  });

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Inherited Notifier and Change Notifier"),
        ),
        body: SliderInheritedNotifier(
          notifier: sliderData,
          child: Builder(
            builder: (context) => Column(
              children: [
                Slider.adaptive(
                  value: SliderInheritedNotifier.of(context),
                  onChanged: (value) {
                    sliderData.value = value;
                  },
                ),
                Row(
                  children: [
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 250,
                        color: Colors.yellow,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 250,
                        color: Colors.blue,
                      ),
                    ),
                  ].everyWidgetExpanded(),
                ),
              ],
            ),
          ),
        ));
  }
}

extension expandEveryWidget on Iterable<Widget> {
  List<Widget> everyWidgetExpanded() {
    return map((widget) => Expanded(
          child: widget,
        )).toList();
  }
}
