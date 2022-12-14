import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
// import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart' as gets;
import 'package:get/get.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Database/model.dart';
import 'package:merokarobar/EditData/Service/blcprovider.dart';
import 'package:merokarobar/Expenses/showexpense.dart';
import 'package:merokarobar/Home/bloc/list_bloc.dart';
import 'package:merokarobar/Routes/route.dart';
import 'package:merokarobar/Settings/settings.dart';
import 'package:merokarobar/Theme/theme.dart';
import 'package:merokarobar/ThemeManager/themeprovider.dart';
import 'package:merokarobar/Utils/dialog.dart';
import 'package:merokarobar/firebase/internet/checkconnectivity.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PartyModel> a = [];

  List<PartyModel> foundUsers = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().getTheme();
      context.read<BlcProvider>().gettotalblc();
      context.read<BlcProvider>().getpaidblc();
      context.read<ExpenseProvider>().gettotalblc();
    });
    context.read<ListBloc>().add(ListfetchingEvent());
    Future.delayed(const Duration(seconds: 1), () {
      context.read<ListBloc>().add(ListfetchedEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    User? auth = FirebaseAuth.instance.currentUser;
    Color? primaryColor = context.watch<ThemeProvider>().themecolor;
    return Scaffold(
        floatingActionButton: floatingButtons(primaryColor),
        appBar: AppBar(
            backgroundColor: primaryColor,
            elevation: 0,
            title: const Text("Len Den", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            actions: [
              GestureDetector(
                  onTap: () async {
                    await context.read<CheckInternet>().checkConnectivity() ? Dialogs.syncData(context) : Dialogs.noInternet(context);
                  },
                  child: const Icon(Icons.sync)),
              const SizedBox(width: 20)
            ]),
        drawer: homeDrawer(context, auth),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(color: primaryColor, height: 15, width: MediaQuery.of(context).size.width, child: const Text("")),
              Container(
                color: primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /////// Incoming Amount Container///////
                        GestureDetector(
                          onTap: () {
                            AllRoutes.routeToShowIncome();
                          },
                          child: Container(
                              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                              height: 75,
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("assets/Images/incoming.png", height: 45),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Rs. ${context.watch<BlcProvider>().totalblc.toString()}",
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                            const Text("Incoming",
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              )),
                        ),

                        ///Outgoing Amount Container /////////
                        GestureDetector(
                          onTap: () {
                            AllRoutes.routeToshowOutgoings();
                          },
                          child: Container(
                              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
                              height: 75,
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        Image.asset("assets/Images/outgoing.png", height: 45),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text("Rs. ${context.watch<BlcProvider>().paidblc.toString()}",
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                          const Text("Outgoing", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54))
                                        ])
                                      ])),
                                  const SizedBox(height: 5),
                                ],
                              )),
                        ),
                      ],
                    ),
                    Container(color: primaryColor, height: 30, width: 100, child: const Text("")),
                    reminderrow(),
                    Container(color: primaryColor, height: 20, width: 100, child: const Text("")),
                  ],
                ),
              ),
              searchWidget(context),
              BlocBuilder<ListBloc, ListState>(
                builder: (context, state) {
                  if (state is ListFetchingState) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: FutureBuilder<List<PartyModel>>(
                        future: DatabaseHelper.instance.getPartyName(),
                        builder: (BuildContext context, AsyncSnapshot<List<PartyModel>> snapshot) {
                          a = snapshot.data ?? [];
                          foundUsers = a;
                          if (!snapshot.hasData) {
                            return const Center(child: Text("Loading..."));
                          }
                          return snapshot.data!.isEmpty
                              ? const Center(child: Text("No Parties found"))
                              : foundUsers.isNotEmpty
                                  ? ListView.builder(itemCount: foundUsers.length, itemBuilder: (context, index) => const Text(""))
                                  : const Text("No User Found");
                        },
                      ),
                    );
                  }
                  if (state is ListFetchedState) {
                    return FutureBuilder<List<PartyModel>>(
                        future: DatabaseHelper.instance.getPartyName(),
                        builder: (BuildContext context, AsyncSnapshot<List<PartyModel>> snapshot) {
                          a = snapshot.data ?? [];
                          if (!snapshot.hasData) {
                            return const Center(child: Text("Loading"));
                          }
                          return snapshot.data!.isEmpty
                              ? Center(
                                  child: Column(children: const [
                                  Icon(Icons.person, size: 150, color: Colors.black54),
                                  Text("No Parties found !", style: TextStyle(fontSize: 18, color: Colors.black54)),
                                  SizedBox(height: 10),
                                  Text("Start by Adding Parties", style: TextStyle(fontSize: 18, color: Colors.black54))
                                ]))
                              : foundUsers.isNotEmpty
                                  ? partyListView()
                                  : const Text("No User Found");
                        });
                  }
                  return Container();
                },
              )
            ],
          ),
        ));
  }

  SpeedDial floatingButtons(Color? primaryColor) {
    return SpeedDial(
      onOpen: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      animatedIcon: AnimatedIcons.add_event,
      backgroundColor: primaryColor,
      overlayOpacity: 0.3,
      overlayColor: primaryColor,
      activeIcon: Icons.add,
      children: [
        SpeedDialChild(
            child: const Icon(Icons.add),
            label: "Add Incoming",
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            labelBackgroundColor: const Color.fromARGB(255, 137, 238, 159),
            backgroundColor: primaryColor,
            onTap: () {
              AllRoutes.routeToAddIncome();
            }),
        SpeedDialChild(
            child: const Icon(Icons.add),
            label: "Add Outgoing",
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            labelBackgroundColor: const Color.fromARGB(255, 255, 161, 160),
            backgroundColor: primaryColor,
            onTap: () {
              AllRoutes.routeToAddOutgoings();
            }),
        SpeedDialChild(
            child: const Icon(Icons.add),
            label: "Add Expenses",
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            labelBackgroundColor: const Color.fromARGB(255, 255, 161, 160),
            backgroundColor: primaryColor,
            onTap: () {
              AllRoutes.routeToAddExpenses();
            })
      ],
    );
  }

  Drawer homeDrawer(BuildContext context, User? auth) {
    var totalblc = context.watch<ExpenseProvider>().totalblc;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: context.watch<ThemeProvider>().themecolor),
              currentAccountPicture: const Icon(Icons.face, size: 48.0, color: Colors.white),
              accountName: const Text("Coming soon"),
              accountEmail: Text(auth!.phoneNumber ?? "dasd")),
          ListTile(title: const Text("App Features"), onTap: () => {}),
          ListTile(
              leading: const Icon(Icons.arrow_forward, color: Colors.green),
              title: const Text("Show Incoming"),
              onTap: () {
                Navigator.pop(context);

                AllRoutes.routeToShowIncome();
              }),
          ListTile(
              leading: const Icon(Icons.arrow_back, color: Colors.red),
              title: const Text("Show Outgoing"),
              onTap: () {
                Navigator.pop(context);

                AllRoutes.routeToshowOutgoings();
              }),
          ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.red),
              title: const Text("Show Expenses"),
              onTap: () {
                Navigator.pop(context);

                AllRoutes.routeToshowExpenses(totalblc);
              }),
          ListTile(
              leading: const Icon(Icons.calendar_month_outlined, color: Colors.green),
              title: const Text("Show Reminder"),
              onTap: () {
                Navigator.pop(context);

                AllRoutes.routeToshowalarm();
              }),
          const Divider(),
          ListTile(title: const Text("Settings"), onTap: () => {}),
          ListTile(
              leading: Icon(Icons.add_to_home_screen, color: context.watch<ThemeProvider>().themecolor),
              title: const Text("Import Data"),
              onTap: () async {
                Navigator.pop(context);

                await context.read<CheckInternet>().checkConnectivity() ? Dialogs.importData(context) : Dialogs.noInternet(context);
              }),
          ListTile(
              leading: Icon(Icons.sync, color: context.watch<ThemeProvider>().themecolor),
              title: const Text("Sync Data"),
              onTap: () async {
                Navigator.pop(context);
                await context.read<CheckInternet>().checkConnectivity() ? Dialogs.syncData(context) : Dialogs.noInternet(context);
              }),
          ListTile(
              leading: Icon(Icons.settings, color: context.watch<ThemeProvider>().themecolor),
              title: const Text("All Settings"),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const Settings(), transition: gets.Transition.rightToLeftWithFade);
              }),
          const Divider(),
          ListTile(title: const Text("Account"), onTap: () => {}),
          ListTile(
              leading: Icon(Icons.logout, color: context.watch<ThemeProvider>().themecolor),
              title: const Text("Logout"),
              onTap: () async {
                Navigator.pop(context);
                await context.read<CheckInternet>().checkConnectivity() ? Dialogs.syncDatalogout(context) : Dialogs.noInternet(context);
              }),
        ],
      ),
    );
  }

  Row reminderrow() {
    var totalblc = context.watch<ExpenseProvider>().totalblc;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 00),
          child: SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  AllRoutes.routeToshowalarm();
                },
                style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.white),
                child: Row(children: const [
                  Text("Reminders", style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(width: 10),
                  Icon(Icons.calendar_month_outlined, color: Colors.black)
                ])),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 00),
          child: SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
                onPressed: () {
                  // AllRoutes.routeToshowExpenses(totalblc);
    gets.Get.to(() => ShowExpenses(totalblc: totalblc), transition: gets.Transition.downToUp, duration: const Duration(milliseconds: 300));

                },
                style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.white),
                child: Row(children: const [
                  Text("Expenses", style: TextStyle(color: Colors.black, fontSize: 16)),
                  SizedBox(width: 10),
                  Icon(Icons.shopping_cart, color: Colors.black)
                ])),
          ),
        ),
      ],
    );
  }

  AnimationLimiter partyListView() {
    return AnimationLimiter(
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: foundUsers.length,
          itemBuilder: (context, index) => Column(
                children: [
                  AnimationConfiguration.staggeredList(
                    position: index,
                    child: FadeInAnimation(
                      // verticalOffset: 50.0,
                      duration: const Duration(seconds: 1),
                      child: ScaleAnimation(
                        child: ListTile(
                          leading: ProfilePicture(name: foundUsers[index].name!, radius: 20, random: false, fontsize: 21),
                          onTap: () {
                            Navigator.pushNamed(context, "edit", arguments: {"model": foundUsers[index].toMap()});
                          },
                          title: Text(foundUsers[index].name!),
                          subtitle: Text(foundUsers[index].phone!),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Rs. ${foundUsers[index].totalblc}",
                                  style: foundUsers[index].mode == 1 ? const TextStyle(color: Colors.green) : const TextStyle(color: Colors.red)),
                              const SizedBox(height: 5),
                              Text(foundUsers[index].mode == 1 ? "To Receive" : "To Give",
                                  style: foundUsers[index].mode == 1
                                      ? const TextStyle(color: Colors.green, fontSize: 12)
                                      : const TextStyle(color: Colors.red, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              )),
    );
  }

  Row searchWidget(BuildContext context) {
    return Row(children: [
      Flexible(
          flex: 1,
          child: SizedBox(
              width: MediaQuery.of(context).size.width / 1.3,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      onChanged: (value) => searchParties(value),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: CTheme.kPrimaryColor!)),
                          focusColor: CTheme.kPrimaryColor,
                          border: const OutlineInputBorder(),
                          prefixIconColor: Colors.black54,
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Search for party name')))))
    ]);
  }

  searchParties(String value) {
    List<PartyModel> result = [];
    if (value.isEmpty) {
      result = a;
    } else {
      result = a.where((element) => element.name!.toLowerCase().contains(value.toLowerCase())).toList();
    }
    setState(() {
      foundUsers = result;
    });
  }
}
