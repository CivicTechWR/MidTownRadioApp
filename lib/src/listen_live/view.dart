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
              final playing = audioPlayerHandler.isPlaying;
              // final processingState =
              //     snapshot.data?.processingState ?? AudioProcessingState.idle;
              return ElevatedButton(
                onPressed: () => audioPlayerHandler.setStream(
                  MediaItem(
                    id: 'https://midtownradiokw.out.airtime.pro/midtownradiokw_a',
                    title: 'Midtown Radio KW',
                    isLive: true,
                  )
                ),
                child:
                    Icon(playing ? Icons.pause : Icons.play_arrow, size: 100),
              );
            }),
        SizedBox(height: 20),
        Text(
          'Listen Live!',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
        SizedBox(height: 10),
        //PlayerWidget()
      ],
    ));
  }
}
