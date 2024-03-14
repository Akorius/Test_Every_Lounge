import 'package:equatable/equatable.dart';

class PhotoViewerState extends Equatable {
  final bool isLoading;
  final int currentPage;
  final List<String> idsList;

  const PhotoViewerState({
    this.isLoading = true,
    this.currentPage = 0,
    this.idsList = const [],
  });

  @override
  List<Object?> get props => [
        isLoading,
        currentPage,
        idsList,
      ];

  PhotoViewerState copyWith({
    bool? isLoading,
    int? currentPage,
    List<String>? idsList,
  }) {
    return PhotoViewerState(
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      idsList: idsList ?? this.idsList,
    );
  }
}
