import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_store.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.store,
  }) : super(key: key);

  final NasaPictureStore store;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    widget.store.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: const Text('Nasa Pictures'), centerTitle: true),
      body: ScopedBuilder(
        store: widget.store,
        onLoading: (_) => const Center(child: CircularProgressIndicator()),
        onError: (_, __) => Text('Error occurred'),
        onState: (context, NasaPictureState state) {
          if (state is NasaPictureSuccessState) {
            const double borderRadius = 10.0;
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                GestureDetector(
                  onTap: () {
                    Modular.to.pushNamed('details');
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(borderRadius),
                              topRight: Radius.circular(borderRadius)),
                          child: Image.network(
                            state.entity.url ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.entity.title ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.entity.date ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
