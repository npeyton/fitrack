import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../custom_widgets/button.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Stack(
        children: [
          SizedBox(
            height:MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80,),
                  FractionallySizedBox(
                      widthFactor: .6, child: Image.asset("assets/images/logo.png")),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "Verify your email",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0,top: 10),
                    child: Text(
                      "Please enter the 4-digit code sent to yourmail@gmail.com",
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                         const Expanded(child: TextField(
                           style: TextStyle(color: Colors.white, fontSize: 24),
                           textAlign: TextAlign.center,
                           cursorColor: Colors.white,
                           decoration: InputDecoration(

                             border: InputBorder.none
                           ),
                         )),
                        Container(width: 1,height: 50, color: Colors.white,),
                          const Expanded(child: TextField(
                            style: TextStyle(color: Colors.white, fontSize: 24),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                border: InputBorder.none
                            ),
                          )),
                        Container(width: 1,height: 50,color : Colors.white),
                          const Expanded(child: TextField(
                            style: TextStyle(color: Colors.white, fontSize: 24),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                border: InputBorder.none
                            ),
                          )),
                        Container(width: 1,height: 50,color : Colors.white),
                          const Expanded(child: TextField(
                            style: TextStyle(color: Colors.white, fontSize: 24),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(

                                border: InputBorder.none
                            ),
                          )),
                      ],),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Resend Code",
                          maxLines: 2,
                          style: TextStyle(
                              color: theme.primaryColorDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: CustomButton(
                      title: "Confirm",
                      onClick: () {

                        Future.delayed(const Duration(milliseconds: 1500),
                            (){
                              return showDialog<void>(
                                context: context,
                                barrierDismissible: true, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    contentPadding: const EdgeInsets.all(16),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: Wrap(children: [

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                                onTap: ()=> Navigator.pop(context),
                                                child: SvgPicture.asset("assets/svg/x.svg"))
                                          ],),
                                        Center(
                                          child: SizedBox(
                                              height: 180,
                                              child: Image.asset("assets/images/bottle.png",fit: BoxFit.fitHeight,)),
                                        ),


                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Verified!",
                                              style: TextStyle(
                                                  color: theme.primaryColor,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w700
                                              ),
                                            ),
                                          ],),

                                        const Text(
                                          "Yahoo! You have successfully verified the account",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0,bottom: 5),
                                          child: CustomButton(
                                            title: "Continue",
                                            onClick: (){

                                            },
                                          ),
                                        )
                                      ],),
                                    ),
                                  );
                                },
                              );
                            }
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          ),
        ],
      ),
    );
  }
}
