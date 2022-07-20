import 'package:flutter/material.dart';

import 'package:jm_flutter_demo/pages/text_controller_page/index.dart'
    deferred as controller_demo_page;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "jm_flutter_30days",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
        ),
      ),
      home: MyHomePage(title: 'jm_flutter_30days'),
      routes: routers,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: new Container(
        child: ListView.builder(itemBuilder: (context, index) {
          return new InkWell(
            onTap: () {
              print("info msg!");
            },
            child: new Card(
              child: new Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                child: new Text(routers.keys.toList()[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ContainerAsyncRouterPage extends StatelessWidget {
  final Future libraryFuture;

  ///不能直接传widget，因为 release 打包时 dart2js 优化会导致时许不对
  ///稍后更新文章到掘金
  final WidgetBuilder child;

  ContainerAsyncRouterPage(this.libraryFuture, this.child);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: libraryFuture,
        builder: (c, s) {
          if (s.connectionState == ConnectionState.done) {
            if (s.hasError) {
              return Scaffold(
                appBar: AppBar(),
                body: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Error: ${s.error}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            return child.call(context);
          }
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

Map<String, WidgetBuilder> routers = {
  "文本输入框简单的 Controller": (context) {
    return ContainerAsyncRouterPage(
      controller_demo_page.loadLibrary(),
      (context) {
        return controller_demo_page.TextControllerDemo();
      },
    );
  },
};
