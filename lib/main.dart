// This example shows a [Scaffold] with an [AppBar], a [BottomAppBar] and a
// [FloatingActionButton]. The [body] is a [Text] placed in a [Center] in order
// to center the text within the [Scaffold] and the [FloatingActionButton] is
// centered and docked within the [BottomAppBar] using
// [FloatingActionButtonLocation.centerDocked]. The [FloatingActionButton] is
// connected to a callback that increments a counter.

import 'package:contacts_service/contacts_service.dart';
import 'package:fetch_contact_process/permissions.dart';
import 'package:flutter/material.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Code Sample for material.Scaffold',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
        seconds: 14,
        navigateAfterSeconds: MyStatefulWidget(),
        title: Text(
          'Welcome In SplashScreen',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        gradientBackground: LinearGradient(
            colors: [Colors.cyan, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        image: Image.network(
          'https://images.pexels.com/photos/1040499/pexels-photo-1040499'
              '.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
          fit: BoxFit.fill,
        ),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: 100.0,
        onClick: () => print("Flutter Egypt"),
        loaderColor: Colors.red,
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<Contact> contactsList = [];

  Future _getAllContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    return contactsList.addAll(contacts);
  }

  @override
  void initState() {
    super.initState();
//    _getAllContacts().then((onValue) {
//      setState(() {
//        for (int i = 0; i < contactsList.length; i++) {
//          if (contactsList[i].displayName.substring(0).startsWith('+')) {
//            contactsList.removeAt(i);
//          }
//        }
//        contactsList.sort((o1, o2) {
//          return o1.displayName.compareTo(o2.displayName);
//        });
//      });
//    });
    checkPermission(Permission.ReadContacts).then((onValue) {
      if (onValue) {
        _getAllContacts().then((onValue) {
          setState(() {
            for (int i = 0; i < contactsList.length; i++) {
              if (contactsList[i].displayName.substring(0).startsWith('+')) {
                contactsList.removeAt(i);
              }
            }
            contactsList.sort((o1, o2) {
              return o1.displayName.compareTo(o2.displayName);
            });
          });
        });
      } else {
        requestPermission(Permission.ReadContacts).then((onValue) {
          checkPermission(Permission.ReadContacts).then((onValue) {
            if (onValue) {
              _getAllContacts().then((onValue) {
                setState(() {
                  for (int i = 0; i < contactsList.length; i++) {
                    if (contactsList[i]
                        .displayName
                        .substring(0)
                        .startsWith('+')) {
                      contactsList.removeAt(i);
                    }
                  }
                  contactsList.sort((o1, o2) {
                    return o1.displayName.compareTo(o2.displayName);
                  });
                });
              });
            }
          });
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Code'),
      ),
      body: Center(
          child: ListView.builder(
              itemCount: contactsList.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  onTap: _getContactDetail(),
                  child: Card(
                    elevation: 5.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(contactsList[index]
                            .displayName
                            .substring(0, 1)
                            .toUpperCase()),
                      ),
                      title: Text(
                        contactsList[index].displayName,
                        style: TextStyle(fontSize: 18.0),
                      ),
                      subtitle: Text(
                          contactsList[index].phones.toList().length > 0
                              ? contactsList[index].phones.toList().length > 0
                                  ? contactsList[index].phones.toList()[0].value
                                  : ''
                              : ''),
                    ),
                  ),
                );
              })),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () => setState(() {}),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  _getContactDetail() {}
}
