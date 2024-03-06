// supabase_config.dart
import 'package:supabase/supabase.dart';

const String supabaseUrl = 'YOUR_SUPABASE_URL';
const String supabaseApiKey = 'YOUR_SUPABASE_API_KEY';

final SupabaseClient supabaseClient = SupabaseClient(
  supabaseUrl,
  supabaseApiKey,
);
