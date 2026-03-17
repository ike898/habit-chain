import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_chain/main.dart';

void main() {
  testWidgets('App launches and shows HabitChain title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: HabitChainApp()),
    );
    expect(find.text('HabitChain'), findsOneWidget);
  });
}
