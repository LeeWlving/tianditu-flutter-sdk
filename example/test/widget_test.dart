import 'package:flutter_test/flutter_test.dart';
import 'package:tianditu_example/main.dart';

void main() {
  testWidgets('shows the map demo', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('天地图 Flutter SDK'), findsOneWidget);
    expect(find.text('请配置天地图 API Key'), findsOneWidget);
  });
}
