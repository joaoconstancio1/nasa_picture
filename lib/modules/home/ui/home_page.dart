import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_store.dart';
import 'package:nasa_picture/modules/home/data/stores/nasa_picture_states.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';

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
  List<NasaPictureEntity> _filteredNasaPictures = [];

  @override
  void initState() {
    widget.store.getData();
    super.initState();
  }

  Future<void> _handleRefresh() async {
    widget.store.getData();
  }

  void _filterNasaPictures(String query) {
    final currentState = widget.store.state;
    if (currentState is NasaPictureSuccessState) {
      setState(() {
        _filteredNasaPictures = currentState.entity
            .where((picture) =>
                picture.title?.toLowerCase().contains(query.toLowerCase()) ==
                    true ||
                picture.date?.toLowerCase().contains(query.toLowerCase()) ==
                    true)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                onChanged: _filterNasaPictures,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ScopedBuilder(
          store: widget.store,
          onError: (_, __) => const Text('Error occurred'),
          onState: (context, NasaPictureState state) {
            if (state is NasaPictureSuccessState) {
              final List<NasaPictureEntity> nasaPictures =
                  _filteredNasaPictures.isNotEmpty
                      ? _filteredNasaPictures
                      : state.entity;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: nasaPictures.length,
                itemBuilder: (context, index) {
                  final NasaPictureEntity nasaPicture = nasaPictures[index];
                  const double borderRadius = 10.0;

                  return GestureDetector(
                    onTap: () {
                      Modular.to.pushNamed('details', arguments: nasaPicture);
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
                },
              );
            } else if (state is NasaPictureLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NasaPictureErrorState) {
              return const Text('Error occurred');
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
