import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favorite_app/blocs/favorite_bloc.dart';
import 'package:favorite_app/blocs/videos_bloc.dart';
import 'package:favorite_app/screens/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideosBloc(),
      child: BlocProvider(
          bloc: FavoriteBloc(),
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "My App",
              home: Home(),
          ),
      )
    );
  }

}

