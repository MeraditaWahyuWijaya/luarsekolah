import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../widget/dummy_profile_form_test.dart';

void main() {
  testWidgets('ProfileFormDummy renders and button works', (tester) async { //ARRANGE
    await tester.pumpWidget(const ProfileFormDummy()); //widget tester yg pump widget itu memuat widget yg nantinya bakal dibuild
    //widget tester buat simulasi interaksi pengguna 
    final saveButton = find.widgetWithText(ElevatedButton, "Simpan Perubahan"); //nyari fungsi buat dieksekusi
    expect(saveButton, findsOneWidget);

    // isi semua field supaya tombol bisa aktif  //ACT 
    await tester.enterText(find.byType(TextFormField).at(0), "Nama");
    await tester.enterText(find.byType(TextFormField).at(1), "01-01-2000");
    await tester.enterText(find.byType(TextFormField).at(2), "Alamat lengkap");

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Laki-laki").last);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Mahasiswa").last);
    await tester.pumpAndSettle();

    // tombol simpan sekarang aktif //ASSERT 
    final buttonWidget = tester.widget<ElevatedButton>(saveButton);
    expect(buttonWidget.enabled, true);
  });
}
