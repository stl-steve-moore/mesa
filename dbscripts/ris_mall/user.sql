CREATE TABLE "user_table" (
   "user_id" SERIAL,
   "user_name" text,
   "real_name" text,
   "email" text,
   "password" text,
   "confirm_hash" text,
   PRIMARY KEY ("user_id")
);
