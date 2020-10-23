import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/styles.dart';
import 'package:flutter/material.dart';

class SurveyNew extends StatefulWidget {
  @override
  _SurveyNewState createState() => _SurveyNewState();
}

class _SurveyNewState extends State<SurveyNew> {
  AnimationController animationController,
      firstWidgetController,
      question1Controller;
  bool isQuestion1 = false,isQuestion2=false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
          visible: !isQuestion1,
          child: FadeOutLeft(
            manualTrigger: true,
            controller: (controller) {
              firstWidgetController = controller;
            },
            child: Column(
              children: [
                SizedBox(height: 20),
                FadeIn(
                  child: Container(
                    width: width,
                    child: Image.asset(
                      'assets/images/doctor.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
                FadeIn(
                  child: Container(
                      width: width * 0.7,
                      padding: EdgeInsets.only(top: 10, left: 10, bottom: 2),
                      child: Text(
                        "Accurate answers help us-help you better. Medical and support staff are valuable and very limited. Be a responsible citizen.",
                        style: subtitleTextSmall,
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Visibility(
          visible: !isQuestion1,
          child: FadeOutLeft(
            manualTrigger: true,
            controller: (controller) {
              animationController = controller;
            },
            child: FadeIn(
              child: Container(
                width: width * 0.5,
                child: RaisedButton(
                  color: blueColor,
                  animationDuration: Duration(seconds: 1),
                  elevation: 6.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  onPressed: () async {
                    animationController.forward();
                    firstWidgetController.forward();
                    setState(() {
                      isQuestion1 = true;
                    });
                    Timer(
                        Duration(
                          milliseconds: 50,
                        ), () {
                      question1Controller.forward();
                    });
                  },
                  child: Text(
                    "Okay, Got it",
                    style: buttonText,
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(visible: isQuestion1 && !isQuestion2 , child: question1()),
        Visibility(visible: isQuestion2 , child: question2())

      ],
    );
  }

  Widget question1() {
    return FadeInRight(
      manualTrigger: true,
      controller: (controller) {
        question1Controller = controller;
      },
      child: Column(
        children: [
          Text("Question1"),
          RaisedButton(
            onPressed: () {
              setState(() {
                isQuestion2 = true;
              });
            },
            child: Text("Next"),
          )
        ],
      ),
    );
  }

  Widget question2() {
    return FadeInRight(
      manualTrigger: true,
      controller: (controller) {
        question1Controller = controller;
      },
      child: Column(
        children: [
          Text("Question2"),
          RaisedButton(
            onPressed: () {},
            child: Text("Next"),
          )
        ],
      ),
    );
  }
}
