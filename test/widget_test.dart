import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled2/main.dart';  // تأكد من أنك تستورد ملف main.dart الخاص بك

void main() {
  testWidgets('التأكد من وجود العنوان في التطبيق', (WidgetTester tester) async {
    // بناء التطبيق وتشغيل الإطار
    await tester.pumpWidget(CryptoTradingApp());

    // التأكد من وجود العنوان
    expect(find.text('Crypto Trading Platform'), findsOneWidget);
  });

  testWidgets('التأكد من وجود زر الدخول', (WidgetTester tester) async {
    // بناء التطبيق وتشغيل الإطار
    await tester.pumpWidget(CryptoTradingApp());

    // التأكد من وجود زر الدخول
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('التأكد من وجود حقول الإدخال في شاشة تسجيل الدخول', (WidgetTester tester) async {
    // بناء التطبيق وتشغيل شاشة تسجيل الدخول
    await tester.pumpWidget(CryptoTradingApp());

    // التأكد من وجود حقل البريد الإلكتروني
    expect(find.byType(TextField), findsNWidgets(2));  // يتوقع وجود حقلين (البريد الإلكتروني وكلمة المرور)

    // التأكد من وجود حقل كلمة المرور
    expect(find.byIcon(Icons.lock), findsOneWidget);
  });

  testWidgets('التأكد من التفاعل مع تسجيل الدخول وتخطيه', (WidgetTester tester) async {
    // بناء التطبيق وتشغيل شاشة تسجيل الدخول
    await tester.pumpWidget(CryptoTradingApp());

    // العثور على حقول البريد الإلكتروني وكلمة المرور
    final emailField = find.byType(TextField).first;
    final passwordField = find.byType(TextField).at(1);

    // إدخال بيانات في الحقول
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');

    // العثور على زر تسجيل الدخول
    final loginButton = find.byType(ElevatedButton);

    // الضغط على زر تسجيل الدخول
    await tester.tap(loginButton);
    await tester.pumpAndSettle();  // تحديث الإطار وانتظار التفاعل مع الانتقال

    // التأكد من أن التطبيق انتقل إلى لوحة التحكم (Dashboard)
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('التأكد من التفاعل مع زر الإضافة', (WidgetTester tester) async {
    // بناء التطبيق وتشغيل الإطار
    await tester.pumpWidget(CryptoTradingApp());

    // التأكد من أن العداد يبدأ من 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // التفاعل مع الزر
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // التأكد من زيادة العداد
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
