
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../config/constants.dart';
import '../controllers/app_controller.dart';
import '../custom_widgets/button.dart';
import '../models/user_model.dart';
import '../widgets/bottom_controls.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  late final AppController _appController;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _referral = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _currentStep = 1;
  late PageController _pageController;
  bool _isLoading = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: 1);
    _appController = context.read<AppController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () => context.pop()),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: kHorizontalSpacing, top: kVerticalSpacing / 2),
            child: Row(
              children: [
                Text(
                  "Create",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontSize: MediaQuery.of(context).size.height * .06),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text(
                  "Account",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontSize: MediaQuery.of(context).size.height * .06),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text(
                  "Track your fitness.",
                  style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontSize: MediaQuery.of(context).size.height * .025),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildUserTypeSelection(context, theme),
                _buildAccountForm(context, theme),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomControls(),
    );
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    if (value!.isNotEmpty) {
      if (_appController.configurations.testEmails != null) {
        if (_appController.configurations.testEmails!.contains(value)) {
          return null;
        }
      }
      if (regex.hasMatch(value)) {
        if (value.contains("sbcc") || value.contains("ucsb")) {
          return null;
        }
      }
    }
    return 'Enter a valid email address';
  }

  String? validateEmailBusiness(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    if (value!.isNotEmpty) {
      if (regex.hasMatch(value)) {
        return null;
      }
    }
    return 'Enter a valid email address';
  }

  Widget _buildAccountForm(BuildContext context, ThemeData theme) {
    String emailHint = "john@gmail.com";


    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextFormField(
                  controller: _firstName,
                  textCapitalization: TextCapitalization.words,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "First Name is required";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(

                    hintText: 'First Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextFormField(
                  controller: _lastName,
                  textCapitalization: TextCapitalization.words,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Last Name is required";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(

                    hintText: 'Last Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              //   child: TextFormField(
              //     controller: _userName,
              //     autocorrect: false,
              //     validator: (val) {
              //       if (val!.isEmpty) {
              //         return "Username is required";
              //       } else {
              //         return null;
              //       }
              //     },
              //     decoration: InputDecoration(
              //       hintText: 'Username',
              //       filled: true,
              //       fillColor: Colors.white,
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(kBorderRadius),
              //         borderSide: BorderSide.none,
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Password is required";
                    } else if (val.length < 6) {
                      return "Password must be at least 6 characters long";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextFormField(
                  autocorrect: false,
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmailBusiness,
                  decoration: InputDecoration(
                    hintText: emailHint,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              //   child: TextFormField(
              //     controller: _referral,
              //     //obscureText: true,
              //     decoration: InputDecoration(
              //       prefixIcon: Padding(
              //         padding: const EdgeInsets.all(10.0),
              //         child: SvgPicture.asset("assets/svg/messages.svg"),
              //       ),
              //       hintText: 'Referral',
              //       filled: true,
              //       fillColor: Colors.white,
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(20.0),
              //         borderSide: BorderSide.none,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSelection(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: kHorizontalSpacing,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
            child: Row(
              children: [
                Text(
                  "Please select your role",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * .028,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: kHorizontalSpacing / 2,
          ),
          InkWell(
            onTap: () {
              context.goNamed("auth.login");
            },
            child: Padding(
              padding: const EdgeInsets.all(kHorizontalSpacing / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Colors.black.withOpacity(.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        const Text(
                          " Log In",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }


  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      User user = User(
          id: 0,
          firstName: _firstName.text,
          lastName: _lastName.text,
          userName: _userName.text,
          password: _password.text,
          profilePhotoUrl: "",
          email: _email.text,
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
      );
      try {
        await _appController.createUser(user: user);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (e.toString().contains("account_username_unique")) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text(
                  "Username already exist, please try another username.",
                  textAlign: TextAlign.center,
                )));
          }
        } else if (e.toString().contains("accounts_email_key")) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                "An account with this email already exist, please login instead.",
                textAlign: TextAlign.center,
              )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                e.toString(),
                textAlign: TextAlign.center,
              )));
        }
      }
    }
  }

  Widget _buildBottomControls() {
    final theme = Theme.of(context);

    final backButton = InkWell(
      onTap: _isLoading ? null : _handleBack,
      child: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
        child: const Icon(Icons.arrow_back),
      ),
    );

    Widget nextButton = SizedBox(
      height: 60,
      child: CustomButton(
        onClick: _handleNext,
        isLoading: _isLoading,
        title: _currentStep == 1 ? 'Signup' : 'Continue',
      ),
    );

    nextButton = Expanded(child: nextButton);

    return BottomControls(
      gradientColor: theme.primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _currentStep == 1 ? const SizedBox() : backButton,
          if (_currentStep != 0) const SizedBox(width: 15),
          nextButton,
        ],
      ),
    );
  }

  void _handleNext() {
    if (_currentStep == 1) {
      _createAccount();
    } else {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      setState(() {
        _currentStep = 1;
      });
    }
  }

  void _handleBack() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    setState(() {
      _currentStep = 0;
    });
  }
}
