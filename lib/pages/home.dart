import 'package:flutter/material.dart';
import 'meditation_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = '';
  String _hoveredCategory = '';
  int _selectedIndex = 0;

  void _navigateTo(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(title: title)),
    );
  }

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _navigateTo(context, category);
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to Meditation Page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MeditationPage()),
      );
    } else {
      // Keep other navigation as is
      List<String> pages = ['Sleep', 'Progress'];
      _navigateTo(context, pages[index - 1]);
    }
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
            _buildCard(
              context,
              title: 'Let it go',
              subtitle: "Don't Judge Yourself",
              duration: '32 min',
              tracks: '8 tracks',
              readTime: '2 min read',
              color: Colors.lightBlueAccent,
              image: Icons.self_improvement,
            ),
            const SizedBox(height: 20),
            const Text('How are you feeling today?'),
            const SizedBox(height: 10),
            _buildCategoryChips(),
            const SizedBox(height: 20),
            _buildCard(
              context,
              title: 'Access our library',
              subtitle: 'From conflict to harmony',
              duration: '10 min',
              tracks: '4 tracks',
              readTime: '1 min read',
              color: Colors.greenAccent,
              image: Icons.menu_book,
            ),
            const SizedBox(height: 20),
            _buildCard(
              context,
              title: 'Want to talk to someone?',
              subtitle: 'Discover the art of stillness',
              duration: '14 min',
              tracks: '6 tracks',
              readTime: '3 min read',
              color: Colors.orangeAccent,
              image: Icons.support_agent,
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

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String duration,
    required String tracks,
    required String readTime,
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

  Widget _buildCategoryChips() {
    final categories = ['Recommended', 'Breathe', 'Calm', 'Music'];
    return Wrap(
      spacing: 8.0,
      children: categories.map((category) {
        bool isSelected = _selectedCategory == category;
        bool isHovered = _hoveredCategory == category;
        return MouseRegion(
          onEnter: (_) => setState(() => _hoveredCategory = category),
          onExit: (_) => setState(() => _hoveredCategory = ''),
          child: GestureDetector(
            onTap: () => _onCategoryTap(category),
            child: Chip(
              label: Text(category),
              backgroundColor: isSelected
                  ? Colors.black
                  : isHovered
                      ? Colors.blueGrey
                      : Colors.grey.shade300,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected || isHovered ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('Welcome to $title page!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
