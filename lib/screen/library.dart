import 'package:flutter/material.dart';

class libraryy extends StatefulWidget {
  const libraryy({super.key});

  @override
  State<libraryy> createState() => _libraryyState();
}

class _libraryyState extends State<libraryy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'this is library page',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
// 













// import 'package:flutter/material.dart';
// import 'package:login_sharedpref/homepage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class shrdprfrnc extends StatefulWidget {
//   const shrdprfrnc({super.key});

//   @override
//   State<shrdprfrnc> createState() => _shrdprfrncState();
// }

// class _shrdprfrncState extends State<shrdprfrnc> {
//   final username_controller = TextEditingController();
//   final password_controller = TextEditingController();

//   late SharedPreferences logindata;
//   late bool newuser;

//   @override
//   void initState() {
//     super.initState();
//     check_if_already_login();
//   }

//   //  Function to check if user already logged in
//   Future<void> check_if_already_login() async {
//     logindata = await SharedPreferences.getInstance();

//     newuser = (logindata.getBool('login') ?? true);
//     print("Is new user? → $newuser");

//     if (newuser == false) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => dashboard()),
//       );
//     }
//   }

//   // Function to save login button click
//   void handleLogin() {
//     String username = username_controller.text;
//     String password = password_controller.text;

//     if (username.isNotEmpty && password.isNotEmpty) {
//       print('Login Success');

//       logindata.setBool('login', false); //already login kniknu
//       logindata.setString('username', username);

//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => dashboard()),
//       );
//     } else {
//       print('Please enter username and password');
//     }
//   }

//   @override
//   void dispose() {
//     username_controller.dispose();
//     password_controller.dispose();
//     super.dispose();
//   }

//   //  UI Part
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Shared Preferences")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Login Page',
//               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),

//             // Username TextField
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: TextField(
//                 controller: username_controller,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Username',
//                   hintText: 'Enter your username',
//                 ),
//               ),
//             ),

//             // Password TextField
//             Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: TextField(
//                 obscureText: true,
//                 controller: password_controller,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Password',
//                   hintText: 'Enter your password',
//                 ),
//               ),
//             ),

//             // Login Button
//             ElevatedButton(onPressed: handleLogin, child: Text("Log In")),
//           ],
//         ),
//       ),
//     );
//   }
// }




//  //homepage




