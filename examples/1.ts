export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json }
  | Json[]

export interface Database {
  public: {
    Tables: {
      documents: {
        Row: {
          content: string | null
          embedding: unknown | null
          id: number
          metadata: Json | null
        }
        Insert: {
          content?: string | null
          embedding?: unknown | null
          id?: number
          metadata?: Json | null
        }
        Update: {
          content?: string | null
          embedding?: unknown | null
          id?: number
          metadata?: Json | null
        }
      }
      foo: {
        Row: {
          created_at: string | null
          id: number
        }
        Insert: {
          created_at?: string | null
          id?: number
        }
        Update: {
          created_at?: string | null
          id?: number
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      match_documents: {
        Args: {
          query_embedding: unknown
          match_count: number
        }
        Returns: {
          id: number
          content: string
          metadata: Json
          similarity: number
        }[]
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

