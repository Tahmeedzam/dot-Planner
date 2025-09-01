import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> createNote({String? title, required String body}) async {
  try {
    final response = await Supabase.instance.client.from('notes').insert({
      'title': title,
      'body': body,
      'updated_at': DateTime.now().toIso8601String(),
    }).select(); // 👈 This makes Supabase return the inserted row(s)

    print('Note created: $response');
  } catch (e) {
    print('❌ Error creating note: $e');
  }
}
