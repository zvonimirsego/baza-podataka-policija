INSERT INTO cin (naziv)
VALUES
('Načelnik policije'),
('Načelnik postaje'),
('Glavni inspektor'),
('Viši inspektor'),
('Inspektor'),
('Detektiv'),
('Viši policajac'),
('Policajac');

INSERT INTO odjel (naziv)
VALUES
('Prometna policija'),
('Interna policija'),
('Interventa policija'),
('Kriminalistika'),
('Granična policija'),
('Uprava');

INSERT INTO policajac (id_policajac, ime, prezime, dat_rodj, spol, id_cin, id_odjel)
VALUES
('5362-4324', 'Ivan', 'Primorac', '06.11.1956.', 'M', 4, 4),
('4325-5287', 'Leon', 'Lučić', '25.07.1982.', 'M', 5, 4),
('3422-8732', 'Anja', 'Morić', '31.03.1983.', 'F', 5, 4),
('2432-5328', 'Vesna', 'Kozar', '12.01.1987.', 'F', 5, 4),
('0001-0001', 'Berislav', 'Plenković', '01.01.2006.', 'M', 1, 6),
('7342-2738', 'Božidar', 'Šimunović', '25.12.1972.', 'M', 3, 2),
('5463-1463', 'Marko', 'Popović', '27.04.2004.', 'M', 8, 3),
('5321-2436', 'Marko', 'Kovačić', '17.01.2005.', 'M', 8, 1),
('4322-4713', 'Ivona', 'Širić', '10.11.2004.', 'F', 7, 1),
('4327-4128', 'Ivan', 'Ivanić', '10.04.1995.', 'M', 4, 3);

UPDATE odjel
SET id_voditelj = '4322-4713'
WHERE id_odjel = 1;

UPDATE odjel
SET id_voditelj = '7342-2738'
WHERE id_odjel = 2;

UPDATE odjel
SET id_voditelj = '4327-4128'
WHERE id_odjel = 3;

UPDATE odjel
SET id_voditelj = '5362-4324'
WHERE id_odjel = 4;

UPDATE odjel
SET id_voditelj = '0001-0001'
WHERE id_odjel = 6;

INSERT INTO povijest_zaposlenja(id_policajac, id_odjel, id_cin, datum_pocetka, datum_zavrsetka)
VALUES
('5362-4324', 4, 5, '01.01.2000.', '01.02.2007.'),
('4325-5287', 4, 8, '01.04.2004.', '01.02.2007.'),
('3422-8732', 4, 8, '01.03.2003.', '01.02.2007.'),
('2432-5328', 4, 8, '01.05.2005.', '01.11.2007.'),
('7342-2738', 3, 8, '01.02.2003.', '01.10.2007.'),
('7342-2738', 2, 6, '01.10.2007.', '07.11.2013.'),
('4327-4128', 3, 8, '01.01.2015.', '15.07.2018.');

INSERT INTO povijest_zaposlenja(id_policajac, id_odjel, id_cin, datum_pocetka)
VALUES
('5362-4324', 4, 4, '01.02.2007.'),
('4325-5287', 4, 5, '01.02.2007.'),
('3422-8732', 4, 5, '01.02.2007.'),
('2432-5328', 4, 5, '01.11.2007.'),
('7342-2738', 2, 3, '07.11.2013.'),
('4327-4128', 3, 4, '15.07.2018.');

CALL dodaj_u_povijest('0001-0001', '01.01.2025.');
CALL dodaj_u_povijest('5463-1463', '02.10.2024.');
CALL dodaj_u_povijest('5321-2436', '02.10.2024.');
CALL dodaj_u_povijest('4322-4713', '02.10.2024.');

INSERT INTO zavrsena_skola (naziv)
VALUES
('Policijska škola Josip Jović, Zagreb'),
('Veleučiliste Lavoslav Ružička, Vukovar'),
('Veleučilište kriminalistike i javne sigurnosti, Zagreb'),
('Pravni fakultet, Zagreb'),
('Pravni fakultet, Osijek'),
('Pravni fakultet, Rijeka'),
('Fakultet za forenzičke znanosti, Split');

INSERT INTO policajac_skola(id_policajac, id_skola, godina_zavrsetka)
VALUES
('5362-4324', 3, 1989),
('4325-5287', 1, 1999),
('4325-5287', 3, 2006),
('3422-8732', 6, 2005),
('2432-5328', 7, 2005),
('0001-0001', 1, 2024),
('0001-0001', 3, 2025),
('0001-0001', 4, 2025),
('7342-2738', 5, 1999),
('7342-2738', 3, 2002),
('5463-1463', 1, 2023),
('5321-2436', 1, 2023),
('4322-4713', 1, 2023),
('4327-4128', 1, 2014),
('4327-4128', 2, 2018);

INSERT INTO vozilo (id_vozilo, registracija, tip_vozila)
VALUES
('TMBOC9NE720197532', '060-123', 'automobil'),
('TMBOC9NE720216232', '130-129', 'automobil'),
('TMBOC9NE720224271', '232-323', 'automobil'),
('WVWCCW98420203328', '140-150', 'marica'),
('WVWCVFSD820178429', '231-428', 'kombi'),
('WBAFW8EF320184242', '070-102', 'motor'),
('WBAGRE8G820195178', '050-235', 'motor');

INSERT INTO policajac_vozilo (id_policajac, id_vozilo, datum, smjena)
VALUES
('4325-5287', 'TMBOC9NE720216232', '11.09.2011.', 1),
('2432-5328', 'TMBOC9NE720216232', '11.09.2011.', 2),
('5321-2436', 'TMBOC9NE720197532', '24.10.2023.', 1),
('4322-4713', 'WBAGRE8G820195178', '07.12.2023.', 3),
('5362-4324', 'WVWCCW98420203328', '10.11.2021.', 3),
('5463-1463', 'WVWCVFSD820178429', '13.06.2024.', 2);

INSERT INTO ilegalna_djela(naziv)
VALUES
('Ubojstvo'),
('Pokušaj ubojstva'),
('Lakša krađa'),
('Teška krađa'),
('Primanje mita'),
('Remećenje javnog reda i mira'),
('Distribucija opojnih sredstava'),
('Vandalizam');

INSERT INTO mjesto(naziv, post_broj)
VALUES
('Osijek', '31000'),
('Brijest', '31107'),
('Briješće', '31107'),
('Josipovac', '31107'),
('Klisa', '31000'),
('Nemetin', '31000'),
('Podravlje', '31000'),
('Sarvaš', '31000'),
('Tvrđavica', '31000'),
('Tenja', '31207'),
('Višnjevac', '31220'),
('Bilje', '31327'),
('Zagreb', '10000'),
('Split', '21000');

INSERT INTO uhicene_osobe(id_uhic_osoba, ime, prezime, dat_rodj, spol, adresa_preb, id_mjesto_preb)
VALUES
('64283746243', 'Tatjana', 'Stranjak', '24.10.1972.', 'F', 'Retfala Nova 10', 1),
('42387763428', 'Ivo', 'Sanader', '08.06.1953.', 'M', 'Remetinec 10', 13),
('56132878734', 'Jadranko', 'Lešina', '15.07.1963.', 'M', 'Strma ulica 25', 1);

INSERT INTO uhicene_osobe(id_uhic_osoba, ime, prezime, dat_rodj, spol, adresa_preb, id_mjesto_preb, adresa_bor, id_mjesto_bor)
VALUES
('46328764183', 'Mihaela', 'Šego', '04.10.2001.', 'F', 'Zagrebačka ulica 15', 1, 'Osječka ulica 51', 13),
('99327017582', 'Ana', 'Ivanović', '06.08.1999.', 'F', 'Splitska ulica 34', 1, 'Osječka ulica 43', 14);

INSERT INTO uhicenja(id_policajac, id_uhic_osoba, datum_uhicenja, id_djelo, opis)
VALUES
('4325-5287', '64283746243', '27.11.2022.', 2, 'Optužena pokušala prebiti učenika Marka Kovačića.'),
('5362-4324', '42387763428', '13.11.2009.', 5, 'U zatvor š njim!'),
('2432-5328', '46328764183', '25.01.2021.', 8, 'Optužena pucala po Novom Zagrebu.');

INSERT INTO uhicenja(id_policajac, id_uhic_osoba, datum_uhicenja, id_djelo)
VALUES
('0001-0001', '99327017582', '01.06.2025.', 7),
('5463-1463', '56132878734', '10.04.2025.', 6);

SELECT * FROM odjel;
SELECT * FROM cin;
SELECT * FROM policajac;
SELECT * FROM povijest_zaposlenja;
SELECT * FROM zavrsena_skola;
SELECT * FROM policajac_skola;
SELECT * FROM vozilo;
SELECT * FROM policajac_vozilo;
SELECT * FROM ilegalna_djela;
SELECT * FROM mjesto;
SELECT * FROM uhicene_osobe;
SELECT * FROM uhicenja;

COMMIT;