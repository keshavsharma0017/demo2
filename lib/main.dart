import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: ApiProvider(
        api: Api(),
        child: const Homepage(),
      ),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ValueKey _textkey = const ValueKey<String?>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(ApiProvider.of(context).api.dateandTime ?? 'HomePage'),
        ),
      ),
      body: GestureDetector(
        onTap: () async {
          final api = ApiProvider.of(context).api;
          final dateAndTime = await api.getDateandTime();
          setState(() {
            _textkey = ValueKey(dateAndTime);
          });
        },
        child: SizedBox.expand(
          child: Center(
            child: DateandTime(
              key: _textkey,
            ),
          ),
        ),
      ),
    );
  }
}

class Api {
  String? dateandTime;

  Future<String> getDateandTime() async {
    return Future.delayed(
            const Duration(seconds: 1),
            () => dateandTime =
                '${DateTime.now().hour}-${DateTime.now().minute}-${DateTime.now().second}.${DateTime.now().millisecond}')
        .then((value) {
      dateandTime = value;
      return value;
    });
  }
}

class ApiProvider extends InheritedWidget {
  final Api api;
  final String uuid;

  ApiProvider({
    Key? key,
    required this.api,
    required Widget child,
  })  : uuid = const Uuid().v4(),
        super(key: key, child: child);
  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid != oldWidget.uuid;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

class DateandTime extends StatelessWidget {
  const DateandTime({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Text(api.dateandTime ?? 'Tap on the Mee');
  }
}
