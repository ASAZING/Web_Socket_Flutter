import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
        home: MyHomePage(
            title: 'Flutter Demo Home Page',
            channel: IOWebSocketChannel.connect('ws://echo.websocket.org')));
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({Key key, this.title, @required this.channel}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: "Send a message"),
                ),
              ),
              StreamBuilder(
                  stream: widget.channel.stream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                    );
                  }),
                  RaisedButton(
                    child: Text("Send"),
                    onPressed: _sendMessage,
                  )
            ],
          ),
        ));
  }
        void _sendMessage(){
          if(_controller.text.isNotEmpty){
            widget.channel.sink.add(_controller.text);          
            }
        }
        @override
        void dispose(){
          widget.channel.sink.close();
          super.dispose();
        }
  }

