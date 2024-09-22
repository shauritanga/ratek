import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ratek/accordian.dart';
import 'package:ratek/farm_details.dart';
import 'package:ratek/get_started.dart';
import 'package:ratek/my_farm.dart';
import 'package:ratek/providers/farm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = FirebaseAuth.instance.currentUser;
    Size size = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final asyncValue = ref.watch(farmProvider);
    return asyncValue.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Text("$error"),
      data: (data) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: size.height * 0.40,
                    ),
                    Container(
                      height: size.height * 0.25,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.yellow],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: statusBarHeight,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.13,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 2,
                                left: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      context: context,
                                      builder: (ctx) => Container(
                                        height: 150,
                                        padding: const EdgeInsets.all(16.0),
                                        width: double.infinity,
                                        child: ListView(
                                          children: [
                                            ListTile(
                                              leading: const Icon(
                                                  FontAwesomeIcons.gear),
                                              title: const Text("Settings"),
                                              trailing: const Icon(
                                                FontAwesomeIcons.chevronRight,
                                                size: 12,
                                                color: Colors.grey,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              leading: const Icon(
                                                  FontAwesomeIcons.powerOff),
                                              title: const Text("Logout"),
                                              trailing: const Icon(
                                                FontAwesomeIcons.chevronRight,
                                                size: 12,
                                                color: Colors.grey,
                                              ),
                                              onTap: () async {
                                                SharedPreferences preferences =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await preferences
                                                    .remove("isLoggedIn");
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const GetStartedScreen(),
                                                    ),
                                                    (route) => false);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 46,
                                    width: 46,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${user?.photoURL}")),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 2,
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: user?.photoURL == null
                                        ? Text(
                                            "${user?.displayName?.split(" ")[0][0].toUpperCase()}",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const SizedBox(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Karibu ${user?.displayName?.split(" ")[0]}",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700),
                              ),
                              const Text(
                                "Furahia huduma za Agripoa",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: size.height * 0.21,
                      left: 20,
                      right: 20,
                      child: Container(
                        height: size.height * 0.18,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Menu(
                              title: "Mashamba",
                              icon: FontAwesomeIcons.envira,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyFarmsScreen(),
                                  ),
                                );
                              },
                            ),
                            Menu(
                              title: "Matumizi",
                              icon: FontAwesomeIcons.coins,
                              onPressed: () {},
                            ),
                            Menu(
                              title: "Ripoti",
                              icon: EvaIcons.barChart,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                CarouselSlider(
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      height: 190.0,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enlargeFactor: 0.2,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlayInterval: const Duration(seconds: 3)),
                  items: [
                    "https://www.planetnatural.com/wp-content/uploads/2023/09/Avocado-Tree.jpg",
                    "https://images.unsplash.com/photo-1552346989-e069318e20a5?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGNvZmZlZSUyMHRyZWVzfGVufDB8fDB8fHww",
                    "https://images.unsplash.com/photo-1695624737174-2d4fec7d183b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8bWFpemV8ZW58MHx8MHx8fDA%3D",
                    "https://images.unsplash.com/photo-1629797476194-676af5633f30?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bWFpemV8ZW58MHx8MHx8fDA%3D",
                    "https://images.unsplash.com/photo-1600150806193-cf869bcfee05?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDJ8fHJpY2UlMjBmYXJtc3xlbnwwfHwwfHx8MA%3D%3D"
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(i),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10)),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    height: size.height * 0.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mashamba",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: size.width * 0.064,
                          runAlignment: WrapAlignment.center,
                          runSpacing: size.width * 0.06,
                          children: [
                            ...List.generate(data.length > 6 ? 6 : data.length,
                                ((i) => i)).map((item) {
                              final farm = data[item];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FarmDetails(farm: farm),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: size.height * 0.18,
                                  width: size.width / 4,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: size.height * 0.11,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(7.0),
                                            topRight: Radius.circular(7.0),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          "${farm.name}",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          "${farm.village}",
                                          style: TextStyle(fontSize: 9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  child: Text(
                    "Gharama za Uwekezaji",
                    style: TextStyle(),
                  ),
                ),
                const SizedBox(height: 8),
                const MyAccordion(
                  title: "Matumizi Ya Shamba",
                ),
                const SizedBox(height: 16),
                const MyAccordion(
                  title: "Upandaji",
                ),
                const SizedBox(height: 16),
                const MyAccordion(
                  title: "Usimaizi wa shamba",
                ),
                const SizedBox(height: 16),
                const MyAccordion(
                  title: "Mavuno",
                ),
                const SizedBox(height: 16),
                const MyAccordion(
                  title: "Usafiri",
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Menu extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final void Function()? onPressed;
  const Menu({
    this.onPressed,
    this.title,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 0.5, color: Colors.grey)),
            child: Icon(
              icon,
              color: Colors.green,
              size: 35,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title!,
            style: const TextStyle(color: Colors.lightGreen),
          ),
        ],
      ),
    );
  }
}
