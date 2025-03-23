import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_telelemedicina_web/utils/AppTheme.dart';
import 'package:coin_telelemedicina_web/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/app_colors.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../services/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void dispose() {
    emailInputController.dispose();
    passwordInputController.dispose();
    isPasswordVisible.dispose();
    isLoading.dispose();
    super.dispose();
  }

  Widget _buildEmailInput() {
    return CustomTextField(
      controller: emailInputController,
      hintText: "enter_email".tr,
    );
  }

  Widget _buildPasswordInput() {
    return ValueListenableBuilder<bool>(
      valueListenable: isPasswordVisible,
      builder: (context, isVisible, child) {
        return CustomTextField(
          controller: passwordInputController,
          hintText: "enter_password".tr,
          isObscure: !isVisible,
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: AppColor.primary,
            ),
            onPressed: () => isPasswordVisible.value = !isVisible,
          ),
        );
      },
    );
  }

  Widget _buildSellerButton() {
    return CustomButton(text: "login".tr, onPressed: _login);
  }

  Future<void> _login() async {
    String email = emailInputController.text.trim();
    String password = passwordInputController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("error".tr, "email_and_password_cannot_be_empty".tr);
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
        Get.snackbar("error".tr, "invalid_email_or_password".tr);
      }
    } catch (e) {
      print("Firestore query error: $e");
      Get.snackbar("error".tr, "${'an_error_occurred'.tr}: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0XFFF2F3F3),
      appBar: CustomAppBar(
        title: "admin_dashboard".tr,
        isLeading: false,
      ),
      body: SingleChildScrollView(
        child: Responsive(
          mobile: _phoneWidget(double.maxFinite),
          tablet: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _phoneWidget(400),
            ],
          ),
          desktop: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _phoneWidget(500),
            ],
          ),
        ),
      ),
    );
  }

  Widget _phoneWidget(double width) {
    return Container(
      width: width,
      decoration: width == 400 || width == 500
          ? BoxDecoration(
        border: Border.all(color: Colors.black38),
      )
          : const BoxDecoration(),
      padding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: width == 500 ? 10 : 20,
      ),
      child: Column(
        children: [
          _buildSignUpForm(width),
          SizedBox(height: 40),
          _buildSellerButton(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "login".tr,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "email".tr,
            style: const TextStyle(
              color: Color(0XCC000000),
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          _buildEmailInput(),
          const SizedBox(height: 16),
          Text(
            "password".tr,
            style: const TextStyle(
              color: Color(0XCC000000),
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          _buildPasswordInput(),
        ],
      ),
    );
  }
}
