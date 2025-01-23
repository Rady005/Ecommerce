
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/material.dart';

// import '../models/db/dbloginmodel.dart';
// import '../routes/routes.dart'; // Update with your actual import

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _register() async {
//     if (_formKey.currentState!.validate()) {
//       String username = _usernameController.text.trim();
//       String password = _passwordController.text.trim();
//       String firstName = _firstNameController.text.trim();
//       String lastName = _lastNameController.text.trim();

//       // Check if the username already exists
//       bool userExists = await LoginHelper.checkUserExists(username, password);
//       if (userExists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content:
//                   Text("Username already exists. Please choose another one.")),
//         );
//       } else {
//         // Register the user
//         await LoginHelper.registerUser(username, password, firstName, lastName);

//         AwesomeDialog(
//           context: context,
//           dialogType: DialogType.info,
//           animType: AnimType.rightSlide,
//           title: 'Dialog Title',
//           desc: 'Dialog description here.............',
//           btnOkOnPress: () {
//             Navigator.pushNamedAndRemoveUntil(context, Routes.mains, (route) => false,);
//           },
//         ).show();
//       }
//     }
//   }

//   String? _validateEmptyField(String? value, String fieldName) {
//     if (value == null || value.isEmpty) {
//       return "$fieldName is required";
//     }
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return "Password is required";
//     } else if (value.length < 6) {
//       return "Password must be at least 6 characters long";
//     }
//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     if (value != _passwordController.text) {
//       return "Passwords do not match";
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: 20),
//                 // Profile Image
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.grey[300],
//                   child: Icon(Icons.person, size: 40, color: Colors.black54),
//                 ),
//                 SizedBox(height: 40),
//                 // First Name
//                 TextFormField(
//                   controller: _firstNameController,
//                   decoration: InputDecoration(
//                     hintText: "First Name",
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) =>
//                       _validateEmptyField(value, "First Name"),
//                 ),
//                 SizedBox(height: 16),
//                 // Last Name
//                 TextFormField(
//                   controller: _lastNameController,
//                   decoration: InputDecoration(
//                     hintText: "Last Name",
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => _validateEmptyField(value, "Last Name"),
//                 ),
//                 SizedBox(height: 16),
//                 // Username
//                 TextFormField(
//                   controller: _usernameController,
//                   decoration: InputDecoration(
//                     hintText: "Username",
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) => _validateEmptyField(value, "Username"),
//                 ),
//                 SizedBox(height: 16),
//                 // Password
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     hintText: "Password",
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: _validatePassword,
//                 ),
//                 SizedBox(height: 16),
//                 // Confirm Password
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: !_isConfirmPasswordVisible,
//                   decoration: InputDecoration(
//                     hintText: "Confirm Password",
//                     border: OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isConfirmPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isConfirmPasswordVisible =
//                               !_isConfirmPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: _validateConfirmPassword,
//                 ),
//                 SizedBox(height: 30),
//                 // Register Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _register,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       padding:
//                           EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//                     ),
//                     child: Text(
//                       "REGISTER",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Spacer(),
//                 Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Already have an account? ",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(context, Routes.login);
//                         },
//                         child: Text(
//                           "Login",
//                           style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Login Text
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../models/db/dbloginmodel.dart';
import '../routes/routes.dart'; // Update with your actual import

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();

      // Check if the username already exists
      bool userExists = await LoginHelper.checkUserExists(username, password);
      if (userExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("Username already exists. Please choose another one.")),
        );
      } else {
        // Register the user
        await LoginHelper.registerUser(username, password, firstName, lastName);

        // Show success dialog
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Registration Successful',
          desc: 'You have registered successfully!',
          btnOkOnPress: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.mains,
              (route) => false,
            );
          },
        ).show();
      }
    }
  }

  String? _validateEmptyField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    } else if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // Profile Image
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 40, color: Colors.black54),
                ),
                SizedBox(height: 40),
                // First Name
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: "First Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      _validateEmptyField(value, "First Name"),
                ),
                SizedBox(height: 16),
                // Last Name
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: "Last Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateEmptyField(value, "Last Name"),
                ),
                SizedBox(height: 16),
                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => _validateEmptyField(value, "Username"),
                ),
                SizedBox(height: 16),
                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validatePassword,
                ),
                SizedBox(height: 16),
                // Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: _validateConfirmPassword,
                ),
                SizedBox(height: 30),
                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    ),
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.login);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                // Login Text
              ],
            ),
          ),
        ),
      ),
    );
  }
}