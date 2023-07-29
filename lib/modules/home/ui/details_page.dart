import 'package:flutter/material.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.entity});

  final NasaPictureEntity entity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nasa Pictures'), centerTitle: true),
      body: ListView(children: [
        Image.network(
          entity.url ?? '',
          fit: BoxFit.cover,
        ),
      ]),
    );
  }
}
