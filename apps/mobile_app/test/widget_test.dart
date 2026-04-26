import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/features/home/presentation/providers/item_provider.dart';
import 'package:mobile_app/features/home/data/models/item_model.dart';

class MockItemProvider extends ChangeNotifier implements ItemProvider {
  @override
  List<Item> get items => [];
  @override
  bool get isLoading => false;
  @override
  String? get error => null;
  @override
  Future<void> fetchItems() async {
    // No-op for tests
  }
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We use a MockItemProvider to avoid real network requests in tests
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ItemProvider>(create: (_) => MockItemProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the AppBar title is correct.
    expect(find.text('Items List'), findsOneWidget);
  });
}
