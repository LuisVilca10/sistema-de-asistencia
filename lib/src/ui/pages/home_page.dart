import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';

GlobalKey<ScaffoldState> homePageKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldMessengerState> homePageMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const HOME_PAGE_ROUTE = "home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;
    return ScaffoldMessenger(
      key: homePageMessengerKey,
      child: Stack(
        children: [
          Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: theme.primary(),
              onPressed: () => {},
              child: Icon(Icons.add, size: 25),
            ),
            backgroundColor: theme.background(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.menu, color: fontColor()),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.info_circle, color: fontColor()),
                ),
                /*IconButton(
                  onPressed: () {
                    _controller.open();
                  },
                  icon: Icon(
                    Icons.lock,
                    color: fontColor(),
                  ),
                )*/
              ],
            ),
            body: _Body(),
          ),
          // Transform.translate(
          //   offset: Offset(
          //     0,
          //     size.height + 100 - (size.height * _controller.value),
          //   ),
          //   child: CustomBottomSheet(
          //     close: () {
          //       _controller.close();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  List<dynamic> notes = [];

  Widget _image() {
    return Container(
      height: 100.0,
      width: double.infinity,
      margin: EdgeInsets.only(left: 30, right: 30, top: 90),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/logougel.png")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ThemeController.instance.background(),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _image(),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Presione el boton (+) para registrar un evento o reunión",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
//     return Column(
//       children: [
//         AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           title: Text(
//             "Notas",
//             style: TextStyle(color: fontColor(), fontWeight: FontWeight.bold),
//           ),
//         ),
//         Expanded(
//           child: FutureBuilder(
//             future: _services.read("notes"),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return StatusMessage(() async {
//                   await _services.read("notes");
//                 }, StatusNetwork.Exception);
//               }
//               if (!snapshot.hasData) {
//                 return Container();
//               } else {
//                 Map<String, dynamic> response =
//                     snapshot.data as Map<String, dynamic>;
//                 if (response["status"] == StatusNetwork.Connected) {
//                   notes = response["data"];
//                   return StaggeredGridView.countBuilder(
//                     physics: BouncingScrollPhysics(),
//                     crossAxisCount: 2,
//                     itemCount: notes.length,
//                     itemBuilder: (context, index) {
//                       Note nota;
//                       if (notes[index].type == TypeNote.Text) {
//                         nota = notes[index];
//                         return SimpleCard(
//                           nota = notes[index],
//                           onTap: () {
//                             print("Tipo de nota: ${nota.type}");

//                             Navigator.pushNamed(
//                               context,
//                               NotePage.NOTE_PAGE_ROUTE,
//                               arguments: NotePageArguments(note: nota),
//                             );
//                           },
//                         );
//                       }
//                       ;
//                       if (notes[index].type == TypeNote.Image) {
//                         nota = notes[index];
//                         return ImageCard(
//                           nota = notes[index],
//                           onTap: () {
//                             print("Tipo de nota: ${nota.type}");

//                             Navigator.pushNamed(
//                               context,
//                               NotePage.NOTE_PAGE_ROUTE,
//                               arguments: NotePageArguments(note: nota),
//                             );
//                           },
//                         );
//                       }
//                       if (notes[index].type == TypeNote.TextImage) {
//                         nota = notes[index];
//                         return TextImageCard(
//                           nota = notes[index],
//                           onTap: () {
//                             print("Tipo de nota: ${nota.type}");

//                             Navigator.pushNamed(
//                               context,
//                               NotePage.NOTE_PAGE_ROUTE,
//                               arguments: NotePageArguments(note: nota),
//                             );
//                           },
//                         );
//                       }
//                       return Container();
//                     },
//                     staggeredTileBuilder:
//                         (int index) =>
//                             new StaggeredTile.count(1, index.isEven ? 1 : 1.3),
//                     mainAxisSpacing: 1,
//                     crossAxisSpacing: 1.0,
//                   );
//                 } else {
//                   return StatusMessage(() async {}, StatusNetwork.Exception);
//                 }
//               }
//             },
//           ),
//         ),
//       ],
//     );

// }
