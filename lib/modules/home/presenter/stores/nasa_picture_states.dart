import 'package:equatable/equatable.dart';
import '../../domain/entities/nasa_picture_entity.dart';

abstract class NasaPictureState extends Equatable {
  const NasaPictureState();

  @override
  List<Object> get props => [];
}

class NasaPictureInitialState extends NasaPictureState {}

class NasaPictureLoadingState extends NasaPictureState {}

class NasaPictureSuccessState extends NasaPictureState {
  final List<NasaPictureEntity> entity;

  const NasaPictureSuccessState(this.entity);
}

class NasaPictureErrorState extends NasaPictureState {
  final Exception exception;

  const NasaPictureErrorState({required this.exception});
}
