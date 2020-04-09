import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:territorios/maps.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

ProgressDialog pr;

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController control;
  static String usuario = "";

  static final List<Map> collections = [
    {"title": "Centro", "image": null},
    {"title": "Quiabos", "image": null},
    {"title": "Mutirão", "image": null},
    {"title": "Anil", "image": null},
  ];
  int index = 0;
  static Widget mainListBuilder(BuildContext context, int index) {
    if (index == 0) return buildHeader(context);
    if (index == 1) return buildSectionHeader(context);
    if (index == 2) return buildCollectionsRow();
    if (index == 3)
      return Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
          child:
              Text("Últimos mapas", style: Theme.of(context).textTheme.title));
    return buildListItem();
  }

  List<Widget> tab = [
    Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("icon/09.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: null /* add child content content here */,
        ),
        ListView.builder(
          itemCount: 7,
          itemBuilder: mainListBuilder,
        ),
      ],
    ),
    Container(
      child: Text("ola"),
    )
  ];
  @override
  void initState() {
    control = TabController(vsync: this, length: tab.length);
    completaPreferencias();
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Carregando...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    super.initState();
  }

  @override
  void dispose() {
    control.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      body: TabBarView(
        controller: control,
        children: tab,
      ),
      appBar: AppBar(
        title: Text("Territorio Central"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.grey.shade800,
        unselectedItemColor: Colors.grey,
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
            control.animateTo(index);
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), title: Text("Ínicio")),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), title: Text("Histórico")),
        ],
      ),
    );
  }

  static Widget buildListItem() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0), child: Icon(Icons.tab)),
    );
  }

  completaPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    usuario = prefs.getString('cpf');
  }

  static Container buildSectionHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Meus mapas",
            style: Theme.of(context).textTheme.title,
          ),
          FlatButton(
            onPressed: () {
              pr.show();
              Future.delayed(Duration(seconds: 1)).then((value) {
                pr.hide().whenComplete(() {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Maps()));
                });
              });
            },
            child: Text(
              "Escolher novo mapa",
              style: TextStyle(color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  static Container buildCollectionsRow() {
    return Container(
      color: Colors.white,
      height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: collections.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              width: 150.0,
              height: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Icon(Icons.tab))),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(collections[index]['title'],
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .merge(TextStyle(color: Colors.grey.shade600)))
                ],
              ));
        },
      ),
    );
  }

  static Container buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      height: 240.0,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 40.0, left: 40.0, right: 40.0, bottom: 10.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Text("Olá " + usuario,
                      style: Theme.of(context).textTheme.title),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text("Publicador | Mapas"),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 40.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "15",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Mapas".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "100+",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Publicadores".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.0)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              "40.000+",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Cidade".toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.0)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage("icon/user.png")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
