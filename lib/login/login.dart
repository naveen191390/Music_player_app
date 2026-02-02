import 'package:flutter/material.dart';
import 'package:music_player_app/screen/bottomnav.dart';
import 'package:shared_preferences/shared_preferences.dart';

class mmmmmmmmm extends StatefulWidget {
  const mmmmmmmmm({super.key});

  @override
  State<mmmmmmmmm> createState() => _mmmmmmmmmState();
}

class _mmmmmmmmmState extends State<mmmmmmmmm> {
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();

  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_if_allerdy_login();
  }

  Future<void> check_if_allerdy_login() async {
    logindata = await SharedPreferences.getInstance();

    newuser = (logindata.getBool('login') ?? true);
    print("new user is $newuser");

    if (newuser == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => bottomnavvv()),
      );
    }
  }

  void handlelogin() {
    String username = usernamecontroller.text;
    String password = passwordcontroller.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      print('login sucess');

      logindata.setBool('login', false);
      logindata.setString('username', username);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => bottomnavvv()),
      );
    } else {
      print('please enter username and password');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    usernamecontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  late final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          // color: Colors.transparent,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 8),
                    //BACKDROPFILTER--GLASS BLUR
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 500,
                          width: 500,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                              255,
                              250,
                              248,
                              248,
                            ).withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Column(
                              children: [
                                Text(
                                  'USER LOGIN',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 30),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    child: TextFormField(
                                      textDirection: TextDirection.ltr,
                                      controller: usernamecontroller,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        //   labelText: 'user name',
                                        hintText: ' enter your user name',
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    child: TextFormField(
                                      controller: passwordcontroller,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        //  contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        // labelText: 'user name',
                                        hintText: ' enter your password',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 8,
                                    ),
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                  ),
                                  onPressed: handlelogin,
                                  child: Text(
                                    "login",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
