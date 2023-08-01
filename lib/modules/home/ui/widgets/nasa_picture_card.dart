import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

class NasaPictureCard extends StatelessWidget {
  final NasaPictureEntity nasaPicture;
  final int index;
  final VoidCallback resetSearch;

  const NasaPictureCard({
    required this.nasaPicture,
    required this.index,
    required this.resetSearch,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 10.0;

    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed('details', arguments: nasaPicture);
        resetSearch();
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(index.toString()),
                  Flexible(
                    child: Text(
                      nasaPicture.title ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      nasaPicture.date ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
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
