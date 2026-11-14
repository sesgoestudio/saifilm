// SAI FILM — Supabase browser client
// The publishable key is intended for public frontend use.
// Protect every exposed table and Storage bucket with RLS policies.
import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm";

const SUPABASE_URL = "https://xypnghzmbrwauzcnjaih.supabase.co";
const SUPABASE_PUBLISHABLE_KEY = "sb_publishable_yyNMJis9Ztw5a7Qnbox3Pg_HLTzLszt";

export const supabase = createClient(
  SUPABASE_URL,
  SUPABASE_PUBLISHABLE_KEY,
  {
    auth: {
      autoRefreshToken: true,
      persistSession: true,
      detectSessionInUrl: true
    }
  }
);
