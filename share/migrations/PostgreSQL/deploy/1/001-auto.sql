-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Thu Sep 24 18:29:47 2015
-- 
;
--
-- Table: generation
--
CREATE TABLE "generation" (
  "generation_id" serial NOT NULL,
  "generation" integer NOT NULL,
  "attempt" integer,
  PRIMARY KEY ("generation_id")
);

;
--
-- Table: strand
--
CREATE TABLE "strand" (
  "strand_id" uuid NOT NULL,
  "generation_id" integer NOT NULL,
  "parent_1_id" uuid,
  "parent_2_id" uuid,
  "json_description" json NOT NULL,
  "matches" integer DEFAULT 0 NOT NULL,
  "matches_won" integer DEFAULT 0 NOT NULL,
  PRIMARY KEY ("strand_id")
);
CREATE INDEX "strand_idx_generation_id" on "strand" ("generation_id");

;
--
-- Table: player
--
CREATE TABLE "player" (
  "player_id" uuid NOT NULL,
  "name" text NOT NULL,
  "strand_id" uuid,
  "wins" integer DEFAULT 0 NOT NULL,
  PRIMARY KEY ("player_id")
);
CREATE INDEX "player_idx_strand_id" on "player" ("strand_id");

;
--
-- Table: match
--
CREATE TABLE "match" (
  "match_id" uuid NOT NULL,
  "is_complete" boolean DEFAULT 'f' NOT NULL,
  "fen" text NOT NULL,
  "json_move_log" json NOT NULL,
  "number_of_moves" integer DEFAULT 0 NOT NULL,
  "white_player_id" uuid NOT NULL,
  PRIMARY KEY ("match_id")
);
CREATE INDEX "match_idx_white_player_id" on "match" ("white_player_id");

;
--
-- Table: match_player
--
CREATE TABLE "match_player" (
  "match_id" uuid NOT NULL,
  "player_id" uuid NOT NULL,
  PRIMARY KEY ("match_id", "player_id")
);
CREATE INDEX "match_player_idx_match_id" on "match_player" ("match_id");
CREATE INDEX "match_player_idx_player_id" on "match_player" ("player_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "strand" ADD CONSTRAINT "strand_fk_generation_id" FOREIGN KEY ("generation_id")
  REFERENCES "generation" ("generation_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "player" ADD CONSTRAINT "player_fk_strand_id" FOREIGN KEY ("strand_id")
  REFERENCES "strand" ("strand_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "match" ADD CONSTRAINT "match_fk_white_player_id" FOREIGN KEY ("white_player_id")
  REFERENCES "player" ("player_id") ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "match_player" ADD CONSTRAINT "match_player_fk_match_id" FOREIGN KEY ("match_id")
  REFERENCES "match" ("match_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "match_player" ADD CONSTRAINT "match_player_fk_player_id" FOREIGN KEY ("player_id")
  REFERENCES "player" ("player_id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
