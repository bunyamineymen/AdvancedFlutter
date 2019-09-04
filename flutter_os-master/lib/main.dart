import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(new HomePage());

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlatformChannel(title: 'Flutter Demo Home Page'),
    );
  }
}

class PlatformChannel extends StatefulWidget {
  PlatformChannel({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PlatformChannelState createState() => PlatformChannelState();
}

class PlatformChannelState extends State<PlatformChannel> {
  String _batteryLevel = '电量等级: 未知';
  String _chargingStatus = '电池等级: 未知';

  Color batteryLevelTextColor = Colors.blueGrey;
  Color textColor = Colors.blueGrey;

  //////// Flutter 调用原生  Start  ////////
  static const MethodChannel methodChannel =
      MethodChannel('samples.flutter.io/battery');

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      batteryLevel = '$result%';
      batteryLevelTextColor = (result >= 50)
          ? Colors.green
          : (result <= 10 ? Colors.red : Colors.blueGrey);
    } on PlatformException {
      batteryLevel = '获取电量等级失败';
    }
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  //////// Flutter 调用原生  End  ////////

  //////// 原生 调用Flutter  Start  ////////
  static const EventChannel eventChannel =
      EventChannel('samples.flutter.io/charging');

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
    setState(() {
      _chargingStatus = "${event == '正在充电中' ? '正在充电中' : '未充电'}";
      textColor = (event == '正在充电中' ? Colors.green : Colors.red);
    });
  }

  void _onError(Object error) {
    setState(() {
      _chargingStatus = '电池状态: 未知';
      textColor = Colors.blueGrey;
    });
  }
  //////// 原生 调用Flutter  End  ////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('电量等级为: '),
                    Text(
                      _batteryLevel,
                      key: const Key('Battery level label'),
                      style: new TextStyle(color: batteryLevelTextColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Text('刷新'),
                    onPressed: _getBatteryLevel,
                  ),
                ),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('电池状态: '),
                Text(
                  _chargingStatus,
                  style: new TextStyle(color: textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
