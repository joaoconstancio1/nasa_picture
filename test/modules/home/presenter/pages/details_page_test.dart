import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_picture/modules/home/domain/entities/nasa_picture_entity.dart';
import 'package:nasa_picture/modules/home/presenter/pages/details_page.dart';

void main() {
  testWidgets('DetailsPage displays correct data', (WidgetTester tester) async {
    final NasaPictureEntity mockEntity = NasaPictureEntity(
      title: 'Test Title',
      date: '2023-08-01',
      explanation: 'Test Explanation',
      url: 'https://example.com/test-image.jpg',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DetailsPage(entity: mockEntity),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('2023-08-01'), findsOneWidget);
    expect(find.text('Test Explanation'), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}
