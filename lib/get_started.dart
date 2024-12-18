import 'package:flutter/material.dart';
import 'package:ratek/cooperate.dart';
import 'package:ratek/home.dart';
import 'package:ratek/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Role { farmer, cooperative, agronomist, input, seedling }

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  Future checkSigned() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final result = preferences.getBool("isLoggedIn");
    final rol = preferences.getString("role");
    if (result != null && rol == "cooperative") {
      setState(() {
        signedIn = true;
        role = rol;
      });
    }
    if (result != null) {
      setState(() {
        signedIn = true;
      });
    }
  }

  Role? _role = Role.farmer;
  bool? signedIn;
  String? role;

  @override
  void initState() {
    checkSigned();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_role?.name);
    if (signedIn == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(27),
              topRight: Radius.circular(27),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Chagua shughuli yako",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        RadioListTile(
                          title: const Text('Mkulima'),
                          value: Role.farmer,
                          groupValue: _role,
                          onChanged: (Role? value) {
                            setState(() {
                              _role = value;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('Ushirika'),
                          value: Role.cooperative,
                          groupValue: _role,
                          onChanged: (Role? value) {
                            setState(() {
                              _role = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.setString("role", _role!.name);

                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                "Endelea",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
    }
    if (role == "cooperative") {
      return const CooperativeScreen();
    }
    return const HomeScreen();
  }
}
