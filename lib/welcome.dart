// import 'package:flutter/material.dart';

// import 'pages/login.dart';

// class Welcome extends StatelessWidget {
//   const Welcome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         // decoration: const BoxDecoration(
//         //   image: DecorationImage(
//         //       image: AssetImage("assets/images/aaa.jpg"), fit: BoxFit.fill),
//         // ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             RichText(
//               text: const TextSpan(
//                 children: [
//                   TextSpan(
//                     text: "Safety",
//                     style: TextStyle(color: Colors.black, fontSize: 40),
//                   ),
//                   TextSpan(
//                     text: "Driving.",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 40),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 200,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => LoginPage(
//                         onTap: () {},
//                       ),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     side: BorderSide.none,
//                     shape: const StadiumBorder()),
//                 child: const Text(
//                   'Start Driving',
//                   style: TextStyle(
//                       color: Colors.black, fontWeight: FontWeight.w500),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:online/content.dart';
import 'package:online/pages/login.dart';
import 'package:online/pages/register.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key, required Null Function() onTap});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentIndex = 0;
  late PageController _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    // TODO: implement initState
    super.initState();
  }

  // void _goToLoginPage() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => LoginPage(
  //               onTap: () {},
  //             )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: SafeArea(
              left: true,
              top: true,
              right: true,
              bottom: true,
              minimum: const EdgeInsets.all(16.0),
              child: Text(
                "",
                style: TextStyle(
                    color: Colors.pinkAccent[700],
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
              child: PageView.builder(
            controller: _controller,
            itemCount: contents.length,
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 60, right: 60, bottom: 40),
                child: Column(
                  children: [
                    // Text(contents[i].image)
                    Image.asset(
                      contents[i].image,
                      height: 300,
                    )
                  ],
                ),
              );
            },
          )),
          Container(
            height: 390.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: new Column(
              children: [
                new Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 20, right: 20, bottom: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text(
                          contents[currentIndex].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30),
                        Text(
                          contents[currentIndex].discription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: Colors.black54, height: 1.5),
                        ),
                        SizedBox(height: 35),
                        // togglea
                        Container(
                          padding: EdgeInsets.only(left: 170),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(
                              contents.length,
                              (index) => buildDot(index, context),
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                        // button route ke login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // tombol button login
                            Container(
                              width: 160,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 43, 96, 209),
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Atur radius sesuai kebutuhan
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            SizedBox(width: 50),
                            // tommbol button register
                            Container(
                              width: 160,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(
                                        onTap: () {},
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 43, 96, 209),
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Atur radius sesuai kebutuhan
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // GestureDetector(
                        //   onTap: _goToLoginPage,
                        //   child: Container(
                        //     padding: EdgeInsets.only(
                        //         top: 10, bottom: 10, left: 30, right: 30),
                        //     decoration: BoxDecoration(
                        //         color: Colors.blue,
                        //         borderRadius: BorderRadius.circular(12)),
                        //     child: Text(
                        //       'Login',
                        //       style: TextStyle(
                        //         fontSize: 15,
                        //         fontWeight: FontWeight.bold,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      width: currentIndex == index ? 17 : 8,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey),
    );
  }
}
