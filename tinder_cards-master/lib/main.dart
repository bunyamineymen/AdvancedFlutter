import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp
    (
      title: 'Tinder cards swipe',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget
{
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin
{
  AnimationController animCtrl;
  Animation<double> animation;

  AnimationController animCtrl2;
  Animation<double> animation2;

  bool showFirst = true;

  @override
  void initState()
  {
    super.initState();
    
    // Animation init
    animCtrl = new AnimationController(duration: new Duration(milliseconds: 500), vsync: this);
    animation = new CurvedAnimation(parent: animCtrl, curve: Curves.easeOut);
    animation.addListener(() { this.setState(() {}); });
    animation.addStatusListener((AnimationStatus status) {});
    
    animCtrl2 = new AnimationController(duration: new Duration(milliseconds: 1000), vsync: this);
    animation2 = new CurvedAnimation(parent: animCtrl2, curve: Curves.easeOut);
    animation2.addListener(() { this.setState(() {}); });
    animation2.addStatusListener((AnimationStatus status) {});
  }

  @override
  void dispose()
  {
    animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold
    (
      appBar: new AppBar
      (
        title: new Text('Tinder cards swipe - test'),
      ),
      body: new Center
      (
        child: new Stack
        (
          children: <Widget>
          [
            new Center
            (
              child: new DragTarget
              (
                onWillAccept: (_) { print('red'); return true; },
                onAccept: (_) { setState(() => showFirst = false); animCtrl.forward(); animCtrl2.forward(); },
                builder: (_, _1, _2)
                {
                  return new SizedBox.expand
                  (
                    child: new Container
                    (
                      color: Colors.red
                    ),
                  );
                }
              ),
            ),
            new Center
            (
              child: new DragTarget
              (
                onWillAccept: (_) { print('green'); return true; },
                builder: (_, _1, _2)
                {
                  return new SizedBox.fromSize
                  (
                    size: new Size(350.0, 350.0),
                    child: new Container
                    (
                      color: Colors.green
                    ),
                  );
                }
              ),
            ),
            new Stack
            (
              alignment: FractionalOffset.center,
              children: <Widget>
              [
                new Align
                (
                  alignment: new Alignment(0.0, 0.5 - animation.value * 0.15),
                  child: new CardView(200.0 + animation.value * 60),
                ),
                new Align
                (
                  alignment: new Alignment(0.0, 0.35 - animation2.value * 0.35),
                  child: new InkWell
                  (
                    onTap: () => Navigator.of(context).push(new MaterialPageRoute(builder: (_) => new MyHomePage())),
                    child: new CardView(260.0 + animation2.value * 80),
                  )
                ),
                new Draggable
                (
                  feedback: new CardView(340.0),
                  child: showFirst ? new CardView(340.0) : new Container(),
                  childWhenDragging: new Container(),
                )
              ]
            ),
          ],
        )
      ),
    );
  }
}

class CardView extends StatelessWidget
{
  final double cardSize;
  CardView(this.cardSize);

  @override
  Widget build(BuildContext context)
  {
    return new Card
    (
      child: new SizedBox.fromSize
      (
        size: new Size(cardSize, cardSize),
      )
    );
  }
}