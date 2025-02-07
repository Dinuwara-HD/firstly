import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicPage extends StatelessWidget {
  final Map<String, String> _spotifyPlaylists = {
    'Calm': 'https://open.spotify.com/playlist/37i9dQZF1DWZd79rJ6a7lp',
    'Positive': 'https://open.spotify.com/playlist/37i9dQZF1DX3rxVfibe1L0',
    'Focus': 'https://open.spotify.com/playlist/37i9dQZF1DX3gLKzHdK7jF',
    'Sleep': 'https://open.spotify.com/playlist/37i9dQZF1DWZd79rJ6a7lp',
  };

  void _openSpotify(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title:
            const Text('Music Library', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Colors.orangeAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  const Text(
                    'Find your vibe 🎶',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _spotifyPlaylists.length,
                      itemBuilder: (context, index) {
                        String playlistName =
                            _spotifyPlaylists.keys.elementAt(index);
                        String playlistUrl =
                            _spotifyPlaylists.values.elementAt(index);

                        return GestureDetector(
                          onTap: () => _openSpotify(playlistUrl),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: const Offset(2, 4),
                                )
                              ],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orangeAccent.withOpacity(0.9),
                                  Colors.deepOrange.withOpacity(0.9),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: const Icon(Icons.music_note,
                                  size: 32, color: Colors.white),
                              title: Text(
                                playlistName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 30),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
