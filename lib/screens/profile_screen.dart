import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:vietime/custom_widgets/animated_progress_bar.dart';
import 'package:colorful_iconify_flutter/icons/fxemoji.dart';
import 'package:vietime/screens/settings/settings_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double progressBarWidth = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80,),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                        'assets/user_avatar.png'), // Replace with your image asset
                  ),
                  SizedBox(height: 16),
                  Text(
                    'HynDuf',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/bronze.png', // Replace with your ranking icon asset
                            height: 58,
                            width: 58,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'II', // Replace with your roman character
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.brown,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        children: [
                          AnimatedProgressBar(
                              width: progressBarWidth,
                              height: 23,
                              progress: 0.8),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Iconify(Ph.lightning_fill, color: Colors.yellow),
                              SizedBox(width: 4),
                              Text(
                                '13 / 20',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading
                        Text(
                          'Thông số',
                          style: TextStyle(
                            fontSize: 24.0, // Adjust the font size as needed
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        SizedBox(
                            height:
                                16.0), // Add some space between heading and grid

                        // Grid
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: (350 / 141),
                          shrinkWrap: true,
                          children: [
                            // Streak cell
                            GridCell(
                              icon: Iconify(
                                Fxemoji.fire,
                                size: 30,
                              ),
                              title: '5',
                              subtitle: 'Streak',
                            ),
                            GridCell(
                              icon: Image.asset(
                                'assets/bolt.png',
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              title: '1000',
                              subtitle: 'Kinh nghiệm',
                            ),
                            GridCell(
                              icon: Image.asset(
                                'assets/bronze.png',
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              title: 'Bronze',
                              subtitle: 'Xếp hạng',
                            ),
                            GridCell(
                              icon: Image.asset(
                                'assets/medal.png',
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                              title: '3',
                              subtitle: 'Thành tích',
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 25.0,
            right: 25.0,
            child: Container(
              height: 55.0,
              width: 55.0,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  elevation: 5,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                  tooltip: 'Settings',
                  child: Icon(
                    Icons.settings,
                    color: Colors.grey[700]!,
                    size: 32,
                  ),
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.grey[200]!, // Set border color
                      width: 2.0, // Set border width
                    ),
                  ),
                  heroTag: null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridCell extends StatelessWidget {
  final Widget icon; // Icon for the left side
  final String title; // Main text (number)
  final String subtitle; // Subtitle explaining

  const GridCell({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey[300]!,
            width: 2), // Grey border with increased weight
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Row(
        children: [
          // Icon on the left
          icon,
          SizedBox(width: 15.0),

          // Main text and subtitle in a column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
