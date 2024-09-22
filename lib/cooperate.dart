import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ratek/db/local.dart';
import 'package:ratek/farmers.dart';
import 'package:ratek/get_started.dart';
import 'package:ratek/groups.dart';
import 'package:ratek/news_details.dart';
import 'package:ratek/sales.dart';
import 'package:ratek/utils/number_format.dart';
import 'package:ratek/widgets/card.dart';
import 'package:ratek/widgets/news_card.dart';
import 'package:ratek/widgets/summary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CooperativeScreen extends StatefulWidget {
  const CooperativeScreen({super.key});

  @override
  State<CooperativeScreen> createState() => _CooperativeScreenState();
}

class _CooperativeScreenState extends State<CooperativeScreen> {
  double totalSales = 0.0;
  int farmerCount = 0;
  int groupCount = 0;
  int totalWeight = 0;

  List news = [
    {
      "title": "Agripoa, fursa kwa wakulima",
      "image": "assets/images/agripoa.jpeg",
      "short_description": "Agripoa yaanza kufanya kazi na vikundi ya wakulima",
      "description": "Vikundi vya wakulima ni vyombo muhimu katika jamii, kutokana na uwezo wake mkubwa wa kuleta mabadiliko ya kiuchumi hasa pale vinapoanzishwa kwa kuzingatia sheria na taratibu ambazo wanavikundi wamejiwekea."
          "Mafanikio huwa makubwa zaidi kama wanakikundi hushiriki katika kupanga na kutoa maamuzi ya jinsi ya kuendesha shughuli za kikundi tokea hatua za mwanzo. Kwa kufanya hivyo, na hivyo uwezekano wa kutekeleza "
          "yale waliyojipangia huongezeka. Kikundi cha wakulima huanzishwa na kuendeshwa kwa kuzingatia katiba ya kikundi, ambayo hutoa miongozo na maelekezo mbalimbali kwa lengo la kuhakikisha vikundi vinakuwa ni vyombo"
          " imara na hai kiuchumi. Aidha uanzishaji wa kikundi hulenga kuwapa uwezo na kuwawezesha wanachama kutekeleza madhumuni waliyojiwekea katika kuboresha hali zao za maisha. Kikundi cha wakulima kinaweza kuanzishwa"
          " mahali popote ambapo pana watu walio katika eneo moja linalowawezesha kufanya shughuli zao za pamoja kwa urahisi na ambao wataonesha nia yao kwa kulipa viingilio na hisa. Idadi ya chini ya watu wanaotakiwa kuanzisha"
          " kikundi ni kumi. Hata hivyo, idadi pekee haitoshelezi bali la msingi zaidi ni uhai wa kiuchumi.\n\n Kupituia Mfumo wa Agripoa, tunawezesha vikundi mbali mbali vya wakulima kuunda/kutengeneza vikundi, kutunza kumbukumbu "
          "mbali mbali za vikundi vyao kama (Database/kanzi data ya wana kikundi, michango mbali mbali, kutunza michango ya Hisa na Jamii). Mwisho wa siku, wana kikundi watapata mchanganuo wa mapato na matumizi. Hata hivyo Agripoa "
          "anaangalia mwenendo wa vikundi na kutafuta fursa ya kuwekeza pesa kwa ajili ya kuwasaidia wakulima kukopa pembejeo za kilimo kama mbegu, madawa na mbolea.\n\n",
    },
    {
      "title": "Kampuni ya Teknolojia ya kilimo",
      "image": "assets/images/best.jpeg",
      "short_description":
          "Kampuni bora ya Teknolojia ya kilimo inayochipukia kwa kasi.",
      "description":
          "Agripoa ni kampuni iliyopata tuzo kutoka Tume ya Sayansi na Teknolojia mwaka 2022. Hatua hii ilitokana baada ya tume kutafuta kampuni changa za teknolojia zinazo chipukia kwa kasinchini Tanzania.\n\nKulikuwa na vipengele vingi "
              "vya kuchagua kampuni hizi na Agripoa ilishinda katika kipengele cha Best Agritech (Kapuni ya Ubunifu wa teknolojia ya Kilimo).\n\n",
    },
    {
      "title": "Elimu kwa wakulima wa Parachichi na Kahawa",
      "image": "assets/images/elimu.jpeg",
      "short_description":
          "Agripoa yaanza kutoa elimu kwa wakulima wa Parachichi na Kahawa",
      "description": "Zao la Parachichi na Kahawa limekuwa ni zao kubwa linalosaidia kuongeza kipato wa wakulima wengi nchini Tanzania. Hii imesababisha"
          "kuvutia wawekezaji na wanunuzi kutoka mataifa mbali mbali kuja Tanzania kununua mazao haya kwa ajili ya matumizi ya masoko ya kimataifa.\n\n"
          "Kwa sasa, Tanzania inasafirisha zaidi ya tani 20,000 nje ya nchi ambazo zinakadiria kuingiza zaidi ya shilingi Bilioni 70. Nchi yetu inaweza"
          "kuuza nje ya nchi mpaka tani 33,000 kwa mwaka 2026 ambazo zinaweza kutuletea zaidi ya Bilioni 100 kwa mwaka.\n\n Kuna umuhimu wa kutoa elimu"
          "kwa wakulima hawa ili kuzalisha zaidi parachichi kwa sababu soko lipo kubwa sana. Lakini pia inahitajika kuwapa elimu juu ya magonjwa, na matumizi"
          "ya madawa. Agripoa inafanya mambo haya yote kwa wakulima ili kuhakikisha wanazalisha vyema kwa ajili ya soko la ndani na nje ya nchi.\n\n",
    },
    {
      "title": "Maonyesho ya Nane Nane Mbeya",
      "image": "assets/images/nanenane.jpeg",
      "short_description": "Agripoa yahudhuria Nane Nane Mbeya",
      "description": "Kampuni ya Agripoa ni moja ya makampuni 10 yaliyofadhiliwa na Serikali kupitia Tume ya Sayansi ya Teknolojia kuhudhuria maonesho ya Nane"
          " nane ya mwaka 2023 yaliyofanyika katika viwanja vya Mwakangale Mbeya. Kampuni hizi zote zilihudhuria kuonesha teknolojia zao"
          " kwa wakulima ili kuweza kuwasaidia katika uzalishaji wa mazo.\n\n Mkurugenzi wa kampuni ya Agripoa Bw. Placidius Castus alikuwa"
          " ni mmoja wapo wa vijana walio hudhuria maonesho haya. Wakulima wengi wa Parachichi na Kahawa walionekana kupenda mfumo wa Agripoa"
          " na walikuwa tayari kuanza kutumia mfumo huu kwa kuwasaidia kuweza kutunza kumbukumbu zao za shambani.\n\n",
    },
    {
      "title": "CRDB – Imbeju",
      "image": "assets/images/crdb.jpeg",
      "short_description":
          "Agripoa miongoni mwa kampuni zilizo shiriki programu ya CRDB – Imbeju",
      "description": "Programu ya Imbeju ilizinduliwa Machi 12 na Waziri Mkuu Kassim Majaliwa na kwa mwezi mzima, CRDB Bank Foundation kwa kushirikiana na Tume"
          " ya Taifa ya Sayansi na Teknolojia (COSTECH) na Tume ya TEHAMA (ICTC) ilipokea maombi kutoka kwa wabunifu 709 ambayo yalipochujwa yalibaki 196 yaliyokidhi vigezo.\n\n "
          "Wote waliowasilisha maombi yao, Tully amesema kuna utaratibu wa kuwawezesha kwa kurekebisha kasoro zilizokuwamo kwenye maombi yao.\n\n "
          "Hii ni fursa itakayomgusa kila mmoja. Tungependa kuwawezesha wabunifu wengi kadri iwezekanavyo.  Nawaomba nanyi mkawe mabalozi wazuri "
          "wa programu hii ili mwakani tutakapotangaza kupokea maombi, wabunifu wengi wajitokeze na kunufaika,” amesema Tully.\n\n"
          "Mafunzo hayo yalifunguliwa Jumatatu ya wiki hii na Mkurugenzi Mtendaji wa Benki ya CRDB, Abdulmajid Nsekela aliyewapongeza washiriki "
          "na kuwasisitiza kuwa ubunifu wao wa kipekee, shauku yao isiyoyumba, na jitihada zao katika ujasiriamali zimewaweka mbele ya kundi kubwa "
          "la washiriki waliowasilisha maombi yao hivyo kuwa sehemu ya fursa hii.\n\n"
          "Tunapoianza kambi hii ya mafunzo, ni wakati muhimu katika safari yenu ya ujasiriamali kwani mtapata fursa ya kuboresha bidhaa na huduma "
          "zenu, mikakati na kupata ujuzi muhimu unaohitajika ili kuwawezesha kufanikiwa katika hatua hii ya mwanzo katika uendeshaji wa biashara.\n\n"
          "Niwasihi kujifunza kwa umakini mkubwa ili kutumia mafunzo na uzoefu mtakaoupata kuboresha biashara zenu. Kumbukeni kuwa maarifa ni nguvu na "
          "kwa kujijengea ufahamu na ujuzi sahihi, mtakuwa tayari kukabiliana na changamoto na kuchukua fursa nyingi zilizopo mbele yenu. Na hapo "
          "ndipo mafanikio ya programu hii yatakapoonekana,” alisema Nsekela.\n\n",
    },
  ];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    totalSales = await LocalDatabase.getTotalSales();
    farmerCount = await LocalDatabase.getFarmerCount();
    groupCount = await LocalDatabase.getGroupCount();
    totalWeight = await LocalDatabase.getTotalWeight();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).viewPadding.top,
            ),
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.closeDrawer();
              },
              icon: const Icon(Icons.close),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text("Home"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CooperativeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(EvaIcons.logOut),
              title: const Text("logout"),
              onTap: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.remove("isLoggedIn");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GetStartedScreen(),
                    ),
                    (route) => false);
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Container(
                height: size.height * 0.33,
              ),
              Container(
                width: double.infinity,
                height: size.height * 0.25,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/home.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: statusBarHeight,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset("assets/images/menu.png"),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.19,
                left: 16,
                right: 16,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  height: size.height * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: const [
                      BoxShadow(
                          offset: Offset(0.5, 1),
                          blurRadius: 0.5,
                          spreadRadius: 1,
                          color: Colors.grey)
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Summary(
                          title: formatNumber((totalWeight / 1000)),
                          subtitle: "Tani zilizopimwa",
                          icon: FontAwesomeIcons.weightHanging,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 0.5,
                        height: size.height * 0.06,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Summary(
                          title: formatNumber(totalSales, type: "short"),
                          subtitle: "Mauzo yaliyofanyika",
                          icon: FontAwesomeIcons.arrowUpRightDots,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 0.5,
                        height: size.height * 0.06,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Summary(
                          title: formatNumber(farmerCount),
                          subtitle: "Wakulima nilio sajili",
                          icon: FontAwesomeIcons.person,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 0.5,
                        height: size.height * 0.06,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Summary(
                          title: formatNumber(groupCount),
                          subtitle: "Vikundi nilivyosajili",
                          icon: FontAwesomeIcons.userGroup,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text("Vipengele"),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomCard(
                        color: Colors.yellow,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FarmersScreen(),
                            ),
                          );
                        },
                        title: "Sajili wakulima",
                        height: size.height * 0.09,
                        icon: "assets/images/book.png",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GroupsScreen(),
                            ),
                          );
                        },
                        color: Colors.yellow,
                        title: "Tengeneza kikundi",
                        height: size.height * 0.09,
                        icon: "assets/images/people.png",
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CustomCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SalesScreen(),
                            ),
                          );
                        },
                        color: Colors.yellow,
                        title: "Fanya mauzo",
                        height: size.height * 0.09,
                        icon: "assets/images/shopping-bag.png",
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomCard(
                        color: Colors.yellow,
                        title: "Fanya malipo",
                        height: size.height * 0.09,
                        icon: "assets/images/payment.png",
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                const Text("Taarifa mbalimbali"),
                const SizedBox(height: 8),
              ],
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: news.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final habari = news[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: NewsCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailsSCreen(news: habari),
                      ),
                    );
                  },
                  color: Colors.green,
                  height: size.height * 0.15,
                  width: size.width * 0.23,
                  title: habari['title'],
                  image: habari['image'],
                  shortDescriprion: habari['short_description'],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
