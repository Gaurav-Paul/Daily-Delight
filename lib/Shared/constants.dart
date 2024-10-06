import "dart:async";
import "package:flutter/material.dart";
import "package:project_trial/Screens/Actual_App/Sub_Pages/item_desc_screen.dart";
import "package:project_trial/Services/auth_class.dart";
import "package:provider/provider.dart";
import "package:smooth_page_indicator/smooth_page_indicator.dart";

final List<String> banners = [
  "assets/Banners/Independence Day Sale Banner.png",
  "assets/Banners/Sale on Vegies Banner.png",
  "assets/Banners/Sale on Spices Banner.png"
];

final List items = [
  //[Item Name, Item image asset, Single Item Price, Single Item Quantity, Item Quantity type(kg/litre/etc)]
  [
    // Contains Only Dairy Items
    [
      "Butter",
      ["assets/Item_Images/Dairy/butter.png"],
      "114",
      "200",
      "g"
    ],
    [
      "Cheese",
      ["assets/Item_Images/Dairy/cheese.png"],
      "145",
      "200",
      "g"
    ],
    [
      "Curd",
      ["assets/Item_Images/Dairy/curd.png"],
      "75",
      "1",
      "Kg"
    ],
    [
      "Milk",
      ["assets/Item_Images/Dairy/milk.png"],
      "74",
      "1",
      "L"
    ],
  ],

  [
    // Contains Only Grain Items
    [
      "Atta",
      ["assets/Item_Images/Grains/atta.png"],
      "58",
      "1",
      "Kg"
    ],
    [
      "Dal",
      ["assets/Item_Images/Grains/dal.png"],
      "110",
      "500",
      "g"
    ],
    [
      "Rice",
      ["assets/Item_Images/Grains/rice.png"],
      "65",
      "1",
      "Kg"
    ]
  ],

  [
    [
      "Beetroot",
      ["assets/Item_Images/Vegetables/beetroot.png"],
      "50",
      "500",
      "g"
    ],
    [
      "Bitter Gourd",
      ["assets/Item_Images/Vegetables/bitter gourd.png"],
      "30",
      "250",
      "g"
    ],
    [
      "Broccoli",
      ["assets/Item_Images/Vegetables/broccoli.png"],
      "70",
      "250",
      "g"
    ],
    [
      "Cabbage",
      ["assets/Item_Images/Vegetables/cabbage.png"],
      "60",
      "500",
      "g"
    ],
    [
      "Capsicum",
      ["assets/Item_Images/Vegetables/capsicum.png"],
      "40",
      "250",
      "g"
    ],
    [
      "Carrot",
      ["assets/Item_Images/Vegetables/carrot.png"],
      "35",
      "250",
      "g"
    ],
    [
      "Cauliflower",
      ["assets/Item_Images/Vegetables/cauliflower.png"],
      "150",
      "500",
      "g"
    ],
    [
      "Corn",
      ["assets/Item_Images/Vegetables/corn.png"],
      "70",
      "2",
      "pcs"
    ],
    [
      "Eggplant",
      ["assets/Item_Images/Vegetables/eggplant.png"],
      "50",
      "500",
      "g"
    ],
    [
      "Garlic",
      ["assets/Item_Images/Vegetables/garlic.png"],
      "200",
      "500",
      "g"
    ],
    [
      "Lady Finger",
      ["assets/Item_Images/Vegetables/lady finger.png"],
      "30",
      "250",
      "g"
    ],
    [
      "Lettuce",
      ["assets/Item_Images/Vegetables/lettuce.png"],
      "110",
      "200",
      "g"
    ],
    [
      "Onion",
      ["assets/Item_Images/Vegetables/onion.png"],
      "65",
      "1",
      "Kg"
    ],
    [
      "Potato",
      ["assets/Item_Images/Vegetables/potato.png"],
      "50",
      "1",
      "Kg"
    ],
    [
      "Radish",
      ["assets/Item_Images/Vegetables/radish.png"],
      "50",
      "500",
      "g"
    ],
    [
      "Tomato",
      ["assets/Item_Images/Vegetables/tomato.png"],
      "50",
      "1",
      "Kg"
    ],
  ],
  [
    [
      "Chilli",
      ["assets/Item_Images/Spices/chilli.png"],
      "20",
      "100",
      "g"
    ],
    [
      "Pepper",
      ["assets/Item_Images/Spices/pepper.png"],
      "120",
      "100",
      "g"
    ],
    [
      "Salt",
      ["assets/Item_Images/Spices/salt.png"],
      "25",
      "1",
      "Kg"
    ],
    [
      "Tamarind",
      ["assets/Item_Images/Spices/tamarind.png"],
      "80",
      "250",
      "g"
    ],
  ]
];

final InputDecoration textFormFieldInputDecor = InputDecoration(
    labelStyle:
        TextStyle(color: Colors.green.shade600, fontStyle: FontStyle.italic),
    filled: true,
    fillColor: Colors.green[100],
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: Colors.green.shade100),
        borderRadius: const BorderRadius.all(Radius.circular(20.0))),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: Colors.green.shade400),
        borderRadius: const BorderRadius.all(Radius.circular(20.0))),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: Colors.green.shade100),
        borderRadius: const BorderRadius.all(Radius.circular(20.0))),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: Colors.green.shade400),
        borderRadius: const BorderRadius.all(Radius.circular(20.0))));

bool currentScreenisItemDescScreen = false;

MyUser getUID(BuildContext context) {
  final user = Provider.of<MyUser?>(context);
  return user!;
}

displayItemDescScreen(BuildContext context, List item) {
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
    return ItemDescScreen(itemVal: item);
  }));
  return "Hello";
}

void displayAllCategoryItemsScreen(
    BuildContext context, String category, int genre) {
  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
    return AllCategoryItemsScreen(categoryName: category, genre: genre);
  }));
}

class HomeScreenBanner extends StatefulWidget {
  const HomeScreenBanner({super.key});

  @override
  State<HomeScreenBanner> createState() => _HomeScreenBannerState();
}

class _HomeScreenBannerState extends State<HomeScreenBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool firstAnimationDone = false;

  @override
  void didChangeDependencies() {
    for (int i = 0; i < banners.length; i++) {
      precacheImage(AssetImage(banners[i]), context);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < banners.length - 1) {
          _currentPage++;
          _pageController.animateToPage(_currentPage,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut);
        } else if (_currentPage == banners.length - 1) {
          _currentPage = 0;
          _pageController.animateToPage(_currentPage,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      child: SizedBox(
        child: Column(
          children: [
            // Actual Banner
            SizedBox(
                width: 420,
                height: 225.0,
                child: PageView.builder(
                  onPageChanged: (value) => setState(() {
                    _currentPage = value;
                  }),
                  physics: const NeverScrollableScrollPhysics(),
                  allowImplicitScrolling: true,
                  controller: _pageController,
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          banners[index],
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ));
                  },
                )),

            //Spacing
            const SizedBox(height: 7),

            // Page Indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: banners.length,
              effect: ExpandingDotsEffect(
                  dotColor: Colors.green.shade200,
                  activeDotColor: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}

class ItemRows extends StatefulWidget {
  // final Widget? child;
  final int genre;
  final String type;
  const ItemRows({super.key, required this.genre, required this.type});

  @override
  State<ItemRows> createState() => _ItemRowsState();
}

class _ItemRowsState extends State<ItemRows> {
  @override
  void didChangeDependencies() {
    for (int i = 0; i < items[widget.genre].length; i++) {
      precacheImage(AssetImage(items[widget.genre][i][1][0]), context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: widget.type == "category"
                ? List.generate(
                    items[widget.genre].length < 10
                        ? items[widget.genre].length
                        : 10, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: .1),
                      child: Card(
                          color: Colors.green[100],
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            // height:175.0,
                            width: 170.0,
                            child: InkWell(
                              splashColor: Colors.green[200],
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                displayItemDescScreen(
                                    context, items[widget.genre][index]);
                                currentScreenisItemDescScreen = true;
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        items[widget.genre][index][1][0]),
                                    Divider(
                                      height: 0.0,
                                      color: Colors.green[900],
                                      indent: 7,
                                      endIndent: 7,
                                    ),

                                    // Item Name
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7.0),
                                          child: Text(
                                            items[widget.genre][index][0],
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.green[900]),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7.0),
                                            child: Text(
                                                "${items[widget.genre][index][3]}${items[widget.genre][index][items[widget.genre][index].length - 1]}",
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.green[900]))),
                                      ],
                                    ),
                                    // Item Price
                                    Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7.0),
                                            child: Text(
                                                "₹${items[widget.genre][index][2]}",
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.green[900]))),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )),
                    );
                  })
                : List.generate(10, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: .1),
                      child: Card(
                          color: Colors.green[100],
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: SizedBox(
                            height: 175.0,
                            width: 140.0,
                            child: InkWell(
                              splashColor: Colors.green[200],
                              onTap: () {},
                            ),
                          )),
                    );
                  })));
  }
}

class SeeAllButton extends StatelessWidget {
  final String text;
  final String category;
  final int genre;
  const SeeAllButton(
      {super.key,
      required this.text,
      required this.category,
      required this.genre});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[50],
              foregroundColor: Colors.green[600],
              shadowColor: Colors.transparent),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            displayAllCategoryItemsScreen(context, category, genre);
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(text), const Text("See all")])),
    );
  }
}

class AllCategoryItemsScreen extends StatelessWidget {
  final String categoryName;
  final int genre;
  const AllCategoryItemsScreen(
      {super.key, required this.categoryName, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(categoryName),
          backgroundColor: Colors.green[50],
        ),
        body: Container(
          color: Colors.green[50],
          child: GridView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: items[genre].length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 210, maxCrossAxisExtent: 170),
              itemBuilder: (context, index) {
                return MediaQuery.withNoTextScaling(
                    child: Card(
                        color: Colors.green[100],
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                          // height:175.0,
                          width: 170.0,
                          child: InkWell(
                            splashColor: Colors.green[200],
                            onTap: () {
                              displayItemDescScreen(
                                  context, items[genre][index]);
                              currentScreenisItemDescScreen = true;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(items[genre][index][1][0]),
                                  Divider(
                                    height: 0.0,
                                    color: Colors.green[900],
                                    indent: 7,
                                    endIndent: 7,
                                  ),

                                  // Item Name
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0),
                                        child: Text(
                                          items[genre][index][0],
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.green[900]),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7.0),
                                          child: Text(
                                              "${items[genre][index][3]}${items[genre][index][4]}",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.green[900]))),
                                    ],
                                  ),
                                  // Item Price
                                  Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7.0),
                                          child: Text(
                                              "₹${items[genre][index][2]}",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.green[900]))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )));
              }),
        ));
  }
}
