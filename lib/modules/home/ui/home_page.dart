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
  int _currentPage = 1;
  @override
  void initState() {
    _fetchData(page: _currentPage);
    super.initState();
  }

  void _loadMore() {
    setState(() {
      _currentPage++;
    });
    _fetchData(page: _currentPage);
  }

  void _fetchData({required int page}) {
    widget.store.getData(page: page);
  }

  Future<void> _handleRefresh() async {
    _currentPage = 1;
    widget.store.getData(page: _currentPage);
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

              return ListView(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: nasaPictures.length,
                    itemBuilder: (context, index) {
                      final NasaPictureEntity nasaPicture = nasaPictures[index];
                      const double borderRadius = 10.0;

                      return GestureDetector(
                        onTap: () {
                          Modular.to
                              .pushNamed('details', arguments: nasaPicture);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                      onPressed: _loadMore,
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
