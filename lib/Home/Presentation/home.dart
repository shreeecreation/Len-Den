import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:merokarobar/Database/database.dart';
import 'package:merokarobar/Database/model.dart';
import 'package:merokarobar/Home/Service/expandablefloating.dart';
import 'package:merokarobar/Home/bloc/list_bloc.dart';
import 'package:merokarobar/Theme/theme.dart';

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
    var totalblc = DatabaseHelper.totalblc();
    print(totalblc.then((value) => print(value)));
    context.read<ListBloc>().add(ListfetchingEvent());
    Future.delayed(const Duration(seconds: 1), () {
      context.read<ListBloc>().add(ListfetchedEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: ExpandableFabClass(
          distanceBetween: 80.0,
          subChildren: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pushNamed(context, "addtodo");
              },
              child: const Text("Add Receiving"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pushNamed(context, "addtodoout");
              },
              child: const Text("Add Outgoing"),
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: CTheme.kPrimaryColor,
          elevation: 0,
          title: const Text("Shree Krishna Shrestha"),
          actions: [
            GestureDetector(
                onTap: () {
                  DatabaseHelper.deleteDatabase();
                },
                child: const Icon(Icons.sync)),
            const SizedBox(width: 20)
          ],
        ),
        drawer: const Drawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(color: CTheme.kPrimaryColor, height: 15, width: MediaQuery.of(context).size.width, child: const Text("")),
              Container(
                color: CTheme.kPrimaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /////// Incoming Amount Container///////
                        Container(
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
                                        children: const [
                                          Text("Rs. 0", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                          Text("Incoming", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            )),

                        ///Outgoing Amount Container /////////
                        Container(
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
                                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                                        Text("Rs. 0", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                        Text("Outgoing", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
                                      ])
                                    ])),
                                const SizedBox(height: 5),
                              ],
                            )),
                      ],
                    ),
                    Container(color: CTheme.kPrimaryColor, height: 30, width: 100, child: const Text(""))
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
                            return const Center(child: Text("Loading"));
                          }
                          return snapshot.data!.isEmpty
                              ? const Center(child: Text("No Parties found"))
                              : foundUsers.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: foundUsers.length, itemBuilder: (context, index) => ListTile(title: Text(foundUsers[index].name!)))
                                  : const Text("No User Found");
                        },
                      ),
                    );
                  }
                  if (state is ListFetchedState) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: FutureBuilder<List<PartyModel>>(
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
                            }));
                  }
                  return Container();
                },
              )
            ],
          ),
        ));
  }

  ListView partyListView() {
    return ListView.builder(
        itemCount: foundUsers.length,
        itemBuilder: (context, index) => Column(
              children: [
                ListTile(
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
                const Divider(),
              ],
            ));
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
