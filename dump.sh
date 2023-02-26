FAPP='postgresql://postgres:bnfr757y47gyerdfbhr7ruf@db.tictapp.io:30036/postgres'
PRO1='postgresql://postgres:s4GqeHNyYye9iPrw@db.tictapp.io:30032/postgres'

pg_dump 'postgresql://postgres:bnfr757y47gyerdfbhr7ruf@db.tictapp.io:30036/postgres' > fapp.sql
psql 'postgresql://postgres:s4GqeHNyYye9iPrw@db.tictapp.io:30032/postgres' < fapp.sql
