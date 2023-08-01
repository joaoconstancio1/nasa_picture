import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:nasa_picture/modules/home/presenter/widgets/nasa_picture_card.dart';

void main() {
  void mockResetSearch() {}

  testWidgets('NasaPictureCard displays correct information', (WidgetTester tester) async {
    final NasaPictureEntity testNasaPicture = NasaPictureEntity(
      title: 'Test Picture',
      date: '2023-08-01',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: NasaPictureCard(
          nasaPicture: testNasaPicture,
          index: 1,
          resetSearch: mockResetSearch,
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Test Picture'), findsOneWidget);
    expect(find.text('2023-08-01'), findsOneWidget);
  });
}
