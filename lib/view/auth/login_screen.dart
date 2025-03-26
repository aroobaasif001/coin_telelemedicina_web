import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../translate/controller/translations_controller.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool isChecked = false;
  final TranslationsController translationsController =
  Get.put(TranslationsController());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
    isLoading.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty");
      return;
    }

    try {
      final adminDoc = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();

      if (adminDoc.docs.isNotEmpty) {
        Get.to(() => HomeScreen());
      } else {
        Get.snackbar("Error", "Invalid email or password");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F5F7),
        title: Padding(
          padding:
          EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.9),
          child: Obx(
                () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: translationsController.selectedLanguage.value,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    translationsController.updateLanguage(newValue);
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text("English"),
                  ),
                  DropdownMenuItem(
                    value: 'es',
                    child: Text("Spanish"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/img.png", height: 100, width: 100),
              const SizedBox(height: 15),
              Text(
                "Welcome back!",
                style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              Text(
                "Log in to your account",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              _buildTextField("Email", emailController, false),
              const SizedBox(height: 12),
              _buildTextField("Password", passwordController, true),
              const SizedBox(height: 10),
              Row(
                children: [
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Checkbox(
                        activeColor: Colors.green,
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      );
                    },
                  ),
                  Text("Remember me", style: GoogleFonts.poppins(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _login,
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
            GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 5),
        ValueListenableBuilder<bool>(
          valueListenable:
          isPassword ? isPasswordVisible : ValueNotifier(false),
          builder: (context, isVisible, child) {
            return TextField(
              controller: controller,
              obscureText: isPassword ? !isVisible : false,
              decoration: InputDecoration(
                hintText: "Enter $label",
                suffixIcon: isPassword
                    ? IconButton(
                  icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[600]),
                  onPressed: () => isPasswordVisible.value = !isVisible,
                )
                    : null,
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            );
          },
        ),
      ],
    );
  }
}



///

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../home_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
//   final ValueNotifier<bool> isLoading = ValueNotifier(false);
//   bool isChecked = false;
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     isPasswordVisible.dispose();
//     isLoading.dispose();
//     super.dispose();
//   }
//
//   Future<void> _login() async {
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       Get.snackbar("Error", "Email and password cannot be empty");
//       return;
//     }
//
//     try {
//       final adminDoc = await FirebaseFirestore.instance
//           .collection('admin')
//           .where('email', isEqualTo: email)
//           .where('password', isEqualTo: password)
//           .get();
//
//       if (adminDoc.docs.isNotEmpty) {
//         Get.to(() => HomeScreen());
//       } else {
//         Get.snackbar("Error", "Invalid email or password");
//       }
//     } catch (e) {
//       print("Firestore query error: $e");
//       Get.snackbar("Error", "An error occurred: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F5F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF4F5F7),
//         title: Padding(
//           padding:
//               EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.9),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: "English",
//               icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
//               style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87),
//               onChanged: (String? newValue) {},
//               items: ["English", "Spanish"]
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Container(
//           width: 450,
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 2,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.asset("assets/img.png",height: 100,width: 100,),
//               const SizedBox(height: 15),
//               Text(
//                 "Welcome back!",
//                 style: GoogleFonts.poppins(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87),
//               ),
//               Text(
//                 "Log in to your account",
//                 style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
//               ),
//               const SizedBox(height: 20),
//               _buildTextField("Email", emailController, false),
//               const SizedBox(height: 12),
//               Stack(
//                 children: [
//                   _buildTextField("Password", passwordController, true),
//                   // Positioned(
//                   //   left: 222,
//                   //   child: Text(
//                   //     "Forgot password?",
//                   //     style: GoogleFonts.poppins(
//                   //         fontSize: 14, color: Colors.green),
//                   //   ),
//                   // ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   StatefulBuilder(
//                     builder: (context, setState) {
//                       return Checkbox(
//                         activeColor: Colors.green,
//                         value: isChecked,
//                         onChanged: (value) {
//                           setState(() {
//                             isChecked = value!;
//                           });
//                         },
//                       );
//                     },
//                   ),
//                   Text("Remember me", style: GoogleFonts.poppins(fontSize: 14)),
//                 ],
//               ),
//               const SizedBox(height: 15),
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                   onPressed: _login,
//                   style:
//                       ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   child: Text(
//                     "Login",
//                     style: GoogleFonts.poppins(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 15),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(
//       String label, TextEditingController controller, bool isPassword) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style:
//                 GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
//         const SizedBox(height: 5),
//         ValueListenableBuilder<bool>(
//           valueListenable:
//               isPassword ? isPasswordVisible : ValueNotifier(false),
//           builder: (context, isVisible, child) {
//             return TextField(
//               controller: controller,
//               obscureText: isPassword ? !isVisible : false,
//               decoration: InputDecoration(
//                 hintText: "Enter $label",
//                 suffixIcon: isPassword
//                     ? IconButton(
//                         icon: Icon(
//                             isVisible ? Icons.visibility : Icons.visibility_off,
//                             color: Colors.grey[600]),
//                         onPressed: () => isPasswordVisible.value = !isVisible,
//                       )
//                     : null,
//                 border: OutlineInputBorder(),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
