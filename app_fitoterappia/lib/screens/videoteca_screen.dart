import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideotecaScreen extends StatefulWidget {
  const VideotecaScreen({super.key});

  @override
  State<VideotecaScreen> createState() => _VideotecaScreenState();
}

class _VideotecaScreenState extends State<VideotecaScreen> {
  YoutubePlayerController? _controller;

  final List<Map<String, String>> videos = [
    {'id': 'n9fdUlG2lJw', 'title': 'Video 1'},
    {'id': 'D3yn04pCkFk', 'title': 'Video 2'},
    {'id': 'BM0mFpFuMvA', 'title': 'Video 3'},
  ];


  @override
  void initState(){
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videos[0]['id']!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute:  false,
        isLive: false
      )
    );
  }

  // Función para crear cada tarjeta de video
  Widget _buildVideoCard(String videoId, String title) {
    return GestureDetector(
      onTap: () {
        // Cuando se haga clic en el video, cambiar al video correspondiente
        setState(() {
          _controller!.load(videoId);
        });
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 20),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: 350,
              height: 170,
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                    isLive: false,
                  ),
                ),
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                progressColors: ProgressBarColors(
                  playedColor: Colors.amber,
                  handleColor: Colors.amberAccent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
      ), 
      builder: (context, player){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Image.asset(
              'assets/logos/logo_menu.png',
              height: 90,
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      // Título decorativo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.brown, width: 2),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/videoteca_icon.png',
                              height: 70,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Videoteca",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D813A),
                              ),
                            ),
                          ],
                        ),
                      ),  
                      const SizedBox(height: 20),
                      // Aquí estamos mostrando los videos
                      Column(
                        children: [
                          for (int i = 0; i < videos.length; i++)
                            _buildVideoCard(videos[i]['id']!, videos[i]['title']!),
                        ],
                      ),
                      
                                      
                    ],
                  ),
                ),
              ),
            ),
        );
      }
    );
    

  }
}