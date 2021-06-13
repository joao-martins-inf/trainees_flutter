import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Evaluate extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _EvaluateState();

}

class _EvaluateState extends State<Evaluate> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:(AppBar(
        backgroundColor: Colors.blue,
        title: Text("Gym evaluation"),
        centerTitle: true,
        elevation:0,
      )),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding:EdgeInsets.symmetric(horizontal:16.0),
                child:

            TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Write an opinion about the gym",
                ),

            ),
            ),
          Padding(
            padding:EdgeInsets.symmetric(vertical:16.0),
            child:

          RatingBar(
          initialRating: 3,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: _image('assets/images/heart.png'),
            half: _image('assets/images/heart_half.png'),
            empty: _image('assets/images/heart_border.png'),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
          ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child:
              OutlinedButton(
                onPressed: () {
                  // Respond to button press
                },
                child: Text("Save evaluation"),
              )
            )
          ],
        )
      ),
    );
  }

}

Widget _image(String asset) {
  return Image.asset(
    asset,
    height: 30.0,
    width: 30.0,
    color: Colors.red,
  );
}
