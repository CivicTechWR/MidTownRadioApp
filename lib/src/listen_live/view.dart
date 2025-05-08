import 'package:audio_service/audio_service.dart';
import 'package:ctwr_midtown_radio_app/main.dart';
import 'package:flutter/material.dart';

class ListenLivePage extends StatelessWidget {
  const ListenLivePage({super.key});

  static const routeName = '/listen_live';

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        StreamBuilder(
            stream: audioHandler.playbackState,
            builder: (context, snapshot) {
              // final processingState =
              //     snapshot.data?.processingState ?? AudioProcessingState.idle;
              return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              if (audioPlayerHandler.mediaItem.value?.id == 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a') {
                                if (audioPlayerHandler.isPlaying) {
                                  audioPlayerHandler.pause();
                                } else {
                                  audioPlayerHandler.play();
                                }
                              } else {
                                audioPlayerHandler.setStream(
                                  MediaItem(
                                    id: 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a',
                                    title: "Midtown Radio KW",
                                    isLive: true
                                ));
                                audioPlayerHandler.play();
                              }
                              }, 
                            style: ButtonStyle(
                              fixedSize: WidgetStatePropertyAll(Size.fromRadius(100)),
                              padding: WidgetStatePropertyAll(EdgeInsets.all(10))),
                            child: Stack(alignment: AlignmentDirectional.center,children: [
                              Container(
                                width: 150, 
                                height: 150, 
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xff005c5f),Color(0xff00989d),Color(0xff33cccc)],
                                    begin: Alignment.bottomCenter,
                                    end:Alignment.topCenter,
                                    ),
                                    shape:BoxShape.circle,
                                    ),),
                              Icon(audioPlayerHandler.isPlaying ? Icons.pause:Icons.play_arrow,size: 100, color: Color.fromRGBO(217, 217, 216, 0.9),)
                              ]),
                          ),
                          // Icon(Icons.radio, size: 100),
                          // PlayerWidget(),
                          // SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(top:20),
                            child: Image.asset('assets/images/we-play-local-music.png', width: 300,),
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    );
            }),
        SizedBox(height: 20),
        SizedBox(height: 10),
        //PlayerWidget()
      ],
    ));
  }
}
