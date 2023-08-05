import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../domain/entities/nasa_picture_entity.dart';
import '../stores/nasa_picture_states.dart';
import '../stores/nasa_picture_store.dart';
import '../widgets/nasa_picture_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final store = Modular.get<NasaPictureStore>();

  @override
  void initState() {
    store.getData();
    _filterData();

    super.initState();
  }

  _filterData() => store.searchController.addListener(() {
        store.filterNasaPictures(store.searchController.text);
        setState(() {});
      });

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
                controller: store.searchController,
                onChanged: store.filterNasaPictures,
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
        onRefresh: store.handleRefresh,
        child: ScopedBuilder(
          store: store,
          onError: (_, __) => const Text('Error occurred'),
          onState: (context, NasaPictureState state) {
            if (state is NasaPictureSuccessState) {
              final List<NasaPictureEntity> nasaPictures =
                  store.filteredNasaPictures.isNotEmpty
                      ? store.filteredNasaPictures
                      : state.entity;

              return ListView(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: nasaPictures.length,
                    itemBuilder: (context, index) {
                      final NasaPictureEntity nasaPicture = nasaPictures[index];

                      return NasaPictureCard(
                        nasaPicture: nasaPicture,
                        index: index,
                        resetSearch: store.resetSearch,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: store.loadMore,
                      child: const Text(
                        'Load More',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
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
