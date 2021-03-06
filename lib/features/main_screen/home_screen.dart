import 'package:flutter/material.dart';
import 'package:taxi_line/features/cab/presentation/screens/cab_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var index = 0;

var screens = [
  const HomePage(),
];

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          
        },
        items: [
        const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              activeIcon: Icon(Icons.home),
              label: 'Home'),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'UserPage'

          )
      ]),
      // CustomBottomNavigation(
      //   onTap: (index) {
      //     print('it should setState');
      //   },
      //   items: const [
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Icons.home_outlined,
          //     ),
          //     activeIcon: Icon(Icons.home),
          //     label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.wallet_giftcard_outlined,
      //         ),
      //         activeIcon: Icon(Icons.wallet_giftcard),
      //         label: 'Wallet'),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.history_outlined,
      //         ),
      //         activeIcon: Icon(Icons.history),
      //         label: 'History'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.more_horiz_rounded),
      //         activeIcon: Icon(Icons.more),
      //         label: 'More'),
      //   ],
      // ),
      // bottomNavigationBar: BottomNavigationBar(items: [BottomNavigationBarItem(icon: Icon(Icons.abc))],),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: FloatingActionButton.large(
            onPressed: () =>
                Navigator.of(context).pushNamed(CabScreen.routeName),
            child: const Icon(Icons.add),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screens[index],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              const Text('UserName'),
              Row(
                children: const [
                  Text('Credit'),
                  Icon(Icons.attach_money_rounded)
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 12,
          child: const Text('here would be an image'),
        ),
        ElevatedButton(onPressed: () {}, child: const Text('take a cab')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: Theme.of(context).primaryColor,),
            ),
            leading: Image.asset('assets/images/uber_plus.jpg'),
            title: const Text('UberPlus'),
            subtitle: const Text('KM'),
            trailing: const Text('\$'),
            onTap: () {},
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(25)),
        color: Colors.white,
        backgroundBlendMode: BlendMode.srcOver
      ),
      child: Column(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: const BorderSide(color: Colors.cyan)),
            title: const Text('ssssss'),
          ),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: const BorderSide(color: Colors.cyan)),
            title: const Text('ssssss'),
          ),
        ],
      ),
    ),
            ],
          ),
        )
      ],
    );
  }
}

class CustomBottomNavigation extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int>? onTap;

  const CustomBottomNavigation({
    Key? key,
    required this.items,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomPaint(
          size: Size(size.width, 80),
          painter: BottomNavigationBarPainter(
              bgColor: Theme.of(context).colorScheme.primary),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              items[0].icon,
              items[1].icon,
              const SizedBox(
                width: 20,
              ),
              items[2].icon,
              items[3].icon,
            ],
          ),
        )
      ],
    );
  }
}

class BottomNavigationBarPainter extends CustomPainter {
  final Color bgColor;

  BottomNavigationBarPainter({
    required this.bgColor,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.deepOrangeAccent
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.2, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.4, 0, size.width * 0.4, 20);
    path.arcToPoint(Offset(size.width * 0.6, 20),
        radius: const Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.6, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.8, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
