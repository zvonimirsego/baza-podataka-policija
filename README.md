# PostgreSQL database - police station

This project was made as a part of a college course, available on this [link](https://www.mathos.unios.hr/en/kolegiji/moderni-sustavi-baza-podataka/). <br>
## Contents of this database:
  - 12 tables, all filled with data
  - 2 procedures
  - 4 triggers
  - 20 queries (5 simple, 5 multi-table, 5 nested, 5 using aggregate functions)
  - `CHECK` conditions
  - `DEFAULT` values
  - table comments
  - indicies
  - MER model
  - relational model

## How this database works?
Firstly, you need to start the "create" file, which is `policijska_stanica_create.sql` for this database. This SQL script will create all the necessary tables and relationships between them, along with procedures, triggers (subsequently, functions too), table comments and indicies. It also definies check conditions and default values for the columns which use one of those. <br>

The, you need to insert some values into tables. This is done by running the `policijska_stanica_insert.sql` script. Feel free to change or add your own data, but **without commiting it do this git repo**. <br>

Moreover, there are some prewritten queries which I needed to make to fulfill project requirements. Those are found in `policijska_stanica_queries.sql` script. Feel free to test the database with your own queries, you don't need to use the one I made.

Lastly, I want to point out that the schematics for how the database was made (relationships between entities/tables, primary and foreign keys, uniqueness, etc.) can be found in `MER_model.drawio.pdf` and `REL_model.drawio.pdf`.
