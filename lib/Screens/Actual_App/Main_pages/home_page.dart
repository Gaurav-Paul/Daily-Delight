import "package:flutter/material.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:project_trial/Services/database.dart";
import "package:project_trial/Shared/constants.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String typedInput = "";
  final AuthService _auth = AuthService();
  late Database _db;
  final SearchController searchController = SearchController();
  List<Widget> searchResultList = [];
  final List<String> searchBaseList = [
    "Butter",
    "Cheese",
    "Curd",
    "Milk",
    "Atta",
    "Dal",
    "Rice",
    "Beetroot",
    "Bitter Gourd",
    "Broccoli",
    "Cabbage",
    "Capsicum",
    "Carrot",
    "Cauliflower",
    "Corn",
    "Eggplant",
    "Garlic",
    "Lady Finger",
    "Lettuce",
    "Onion",
    "Potato",
    "Radish",
    "Tomato",
    "Chilli",
    "Pepper",
    "Salt",
    "Tamarind"
  ];

  @override
  void initState() {
    super.initState();
    _db = Database(uid: _auth.getCurrentUserUID());
    for (int i = 0; i < searchBaseList.length; i++) {
      searchResultList.add(ListTile(
        onTap: () {FocusScope.of(context).requestFocus(FocusNode());
          searchController.closeView(searchBaseList[i]);
          displayItemDescScreen(
              context, _db.getitemsListIndexFromName(searchBaseList[i])!);
        },
        leading: Text(searchBaseList[i]),
      ));
    }
  }

  void findSearchResults() {
    searchResultList.clear();
    if (typedInput == "") {
      searchResultList.clear();
      for (int i = 0; i < searchBaseList.length; i++) {
        searchResultList.add(MediaQuery.withNoTextScaling(
          child: ListTile(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              searchController.closeView(searchBaseList[i]);
              displayItemDescScreen(
                  context, _db.getitemsListIndexFromName(searchBaseList[i])!);
            },
            leading: MediaQuery.withNoTextScaling(child: Text(searchBaseList[i], style: const TextStyle(fontSize: 16),)),
          ),
        ));
      }
    } else {
      searchResultList.clear();
      for (int i = 0; i < searchBaseList.length; i++) {
        if (searchBaseList[i]
            .toLowerCase()
            .startsWith(typedInput.toLowerCase())) {
          searchResultList.add(MediaQuery.withNoTextScaling(
            child: ListTile(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                searchController.closeView(searchBaseList[i]);
                displayItemDescScreen(
                    context, _db.getitemsListIndexFromName(searchBaseList[i])!);
              },
              leading: MediaQuery.withNoTextScaling(child: Text(searchBaseList[i], style: const TextStyle(fontSize: 16),)),
            ),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: Container(
        color: Colors.green[50],
        child: SingleChildScrollView(
            child: SafeArea(
                child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MediaQuery.withNoTextScaling(
                    child: SearchAnchor.bar(
                      barTextStyle: WidgetStatePropertyAll(
                          TextStyle(color: Colors.green[800])),
                      viewHeaderTextStyle: TextStyle(color: Colors.green[800]),
                      viewHeaderHintStyle: TextStyle(color: Colors.green[800]),
                      barHintStyle: WidgetStatePropertyAll(
                          TextStyle(color: Colors.green[800])),
                      viewTrailing: [
                        IconButton(
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  searchController.text = "";
                                  typedInput = "";
                                });
                              }
                              findSearchResults();
                            },
                            icon: const Icon(Icons.close))
                      ],
                      onSubmitted: (value) {},
                      onChanged: (val) {
                        if (mounted) {
                          setState(() => typedInput = searchController.text);
                        }
                        findSearchResults();
                      },
                      barHintText: "Search",
                      // barOverlayColor: WidgetStatePropertyAll(Colors.green[800]),
                      barBackgroundColor: WidgetStatePropertyAll(Colors.green[100]),
                      searchController: searchController,
                      viewBackgroundColor: Colors.green[100],
                      suggestionsBuilder: (context, controller) {
                        typedInput = searchController.text;
                        return searchResultList;
                      },
                      dividerColor: Colors.green[200],
                      viewConstraints:
                          BoxConstraints.tight(const Size.fromHeight(400)),
                    ),
                  )),
      
              const SizedBox(
                height: 10,
              ),
              // Banner with offers
              const HomeScreenBanner(),
      
              // Dairy Items
              const SeeAllButton(
                text: "Dairy Items",
                category: "Dairy",
                genre: 0,
              ),
              const ItemRows(genre: 0, type: "category"),
      
              // Grain Based Items
              const SeeAllButton(
                text: "Grain Based Items",
                category: "Grain Based",
                genre: 1,
              ),
              const ItemRows(genre: 1, type: "category"),
      
              // Vegies
              const SeeAllButton(
                text: "Vegies",
                category: "Vegies",
                genre: 2,
              ),
              const ItemRows(genre: 2, type: "category"),
      
              // Spices
              const SeeAllButton(
                text: "Spices",
                category: "Spices",
                genre: 3,
              ),
              const ItemRows(genre: 3, type: "category"),
      
              //
            ],
          ),
        ))),
      ),
    );
  }
}
