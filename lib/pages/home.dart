import 'package:flutter/material.dart';
import 'meditation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Recommended';
  int _selectedIndex = 0;

  final Map<String, List<Map<String, dynamic>>> _categoryContent = {
    'Recommended': [
      {
        'title': 'Access our library',
        'subtitle': 'From conflict to harmony',
        'color': Colors.greenAccent,
        'icon': Icons.menu_book,
      },
      {
        'title': 'Want to talk to someone?',
        'subtitle': 'Discover the art of stillness',
        'color': Colors.orangeAccent,
        'icon': Icons.support_agent,
      },
      {
        'title': 'Let It Go',
        'subtitle': 'Release your worries and relax',
        'color': Colors.blueGrey,
        'icon': Icons.cloud,
      },
    ],
    'Breathe': [
      {
        'title': 'Deep Breathing',
        'subtitle': 'Improve your focus',
        'color': Colors.blueAccent,
        'icon': Icons.air,
      },
      {
        'title': 'Breath Control',
        'subtitle': 'Calm your mind',
        'color': Colors.cyan,
        'icon': Icons.self_improvement,
      },
    ],
    'Calm': [
      {
        'title': 'Stay Calm',
        'subtitle': 'Find inner peace',
        'color': Colors.purpleAccent,
        'icon': Icons.nightlight_round,
      },
    ],
    'Music': [
      {
        'title': 'Relaxing Sounds',
        'subtitle': 'Feel the tranquility',
        'color': Colors.deepOrange,
        'icon': Icons.music_note,
      },
    ],
    'Community': [
      {
        'title': 'Join Discussions',
        'subtitle': 'Engage with others',
        'color': Colors.teal,
        'icon': Icons.forum,
      },
    ],
  };

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MeditationPage()),
      );
    } else {
      List<String> pages = ['Sleep', 'Progress'];
      _navigateTo(context, pages[index - 1]);
    }
  }

  void _navigateTo(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Scaffold(
                appBar: AppBar(title: Text(title)),
                body: Center(child: Text('Content for $title')),
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => _navigateTo(context, 'Menu'),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.menu, color: Colors.black),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _navigateTo(context, 'Profile'),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.account_circle, color: Colors.black),
            ),
          ),
        ],
        title: const Text(
          'Vibes Nest',
          style: TextStyle(
            fontFamily: 'Serif',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good Morning, User',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Top meditation program for you',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            _buildCategoryChips(),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: ValueKey<String>(_selectedCategory),
                children: _categoryContent[_selectedCategory]!
                    .map((data) => _buildCard(
                          title: data['title'],
                          subtitle: data['subtitle'],
                          color: data['color'],
                          image: data['icon'],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: 'Meditation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight_round),
            label: 'Sleep',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categoryContent.keys.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (bool selected) {
                if (selected) {
                  _onCategoryTap(category);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData image,
  }) {
    return GestureDetector(
      onTap: () => _navigateTo(context, title),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Icon(image, size: 60, color: Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
