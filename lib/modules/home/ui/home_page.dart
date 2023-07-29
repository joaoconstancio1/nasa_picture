import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nasa_picture/modules/home/data/cubits/cubit/nasa_picture_cubit.dart';
import 'package:nasa_picture/modules/home/data/cubits/states/nasa_picture_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<NasaPictureCubit>().getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Nasa Pictures')),
        body: BlocConsumer<NasaPictureCubit, NasaPictureState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is NasaPictureLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is NasaPictureErrorState) {
              return Container(
                child: Text('Error occurred:  ${state.exception}'),
              );
            } else if (state is NasaPictureSuccessState) {
              return ListView(
                children: [
                  Text(state.entity.title ?? ''),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ));
  }
}
