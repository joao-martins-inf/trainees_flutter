import 'package:flutter/material.dart';

class Gym extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _GymState();

}

class _GymState extends State<Gym> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body:Center(
        child: OrientationBuilder(
          builder: (context, orientation) {
            int count = 2;
            if(orientation == Orientation.landscape){
              count = 4;
            }
            return GridView.count(
              shrinkWrap: true,
              crossAxisCount: count,

              children: <Widget>[
                Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 150, height: 100),
                    child:
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
              primary: Colors.teal,
              onPrimary: Colors.white,
              shadowColor: Colors.red,


            ),
                  onPressed: () {},
                  label: Text('Classes', style: TextStyle(fontSize: 15.0)),
                  icon: Icon(Icons.add),
                ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 150, height: 100),
                    child:
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal,
                      onPrimary: Colors.white,
                      shadowColor: Colors.red,

                    ),
                  onPressed: () {},
                  label: Text('Session', style: TextStyle(fontSize: 15.0)),
                  icon: Icon(Icons.eject),
                ),
                ),
          ]),
            Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 150, height: 100),
                child:

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                    shadowColor: Colors.red,
                    ),
                  onPressed: () {Navigator.pushNamed(context, '/scan');},
                  label:
                  Text('Scan QR', style: TextStyle(fontSize: 15.0)),
                  icon: Icon(Icons.vertical_align_bottom),

                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(width: 150, height: 100),
              child:
                ElevatedButton.icon(
                 style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                    shadowColor: Colors.red,
                    elevation: 5,),
                  onPressed: () {Navigator.pushNamed(context, '/evaluate');},
                  label:
                  Text('Evaluate', style: TextStyle(fontSize: 15.0)),
                  icon: Icon(Icons.vertical_align_top),
                ),
              ),
]),
              ],
            );
          },
        ),
        ),
    );
  }

  }
