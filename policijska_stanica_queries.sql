--jednostavni upiti
SELECT naziv AS "Ime odjela"
FROM odjel;

SELECT post_broj || ' ' || naziv AS "Poštanski broj i mjesto"
FROM mjesto;

SELECT id_uhic_osoba AS "OIB", ime || ' ' || prezime AS "Ime i prezime"
FROM uhicene_osobe;

SELECT id_policajac, ime || ' ' || prezime AS "Ime i prezime"
FROM policajac
WHERE spol = 'F';

SELECT *
FROM policajac
WHERE id_odjel = 4;

--slozeni upiti
SELECT uo.ime || ' ' || uo.prezime AS "Ime i prezime", uo.id_uhic_osoba AS "OIB", u.datum_uhicenja, u.opis
FROM uhicenja u INNER JOIN uhicene_osobe uo USING (id_uhic_osoba);

SELECT p.ime || ' ' || p.prezime AS "Ime i prezime", o.naziv, c.naziv, pz.datum_pocetka, pz.datum_zavrsetka
FROM povijest_zaposlenja pz INNER JOIN odjel o USING (id_odjel)
INNER JOIN cin c USING (id_cin)
INNER JOIN policajac p USING (id_policajac)
WHERE id_policajac = '0001-0001';

SELECT uo.ime || ' ' || uo.prezime AS "Ime i prezime"
FROM uhicene_osobe uo INNER JOIN mjesto m
ON uo.id_mjesto_preb = m.id_mjesto
INNER JOIN mjesto m2
ON uo.id_mjesto_bor = m2.id_mjesto
WHERE NOT (uo.id_mjesto_preb = uo.id_mjesto_bor AND uo.adresa_preb = uo.adresa_bor);

SELECT p.ime || ' ' || p.prezime AS "Ime i prezime", o.naziv AS "Ime odjela"
FROM odjel o INNER JOIN policajac p
ON o.id_voditelj = p.id_policajac;

SELECT DISTINCT idj.naziv
FROM ilegalna_djela idj INNER JOIN uhicenja USING (id_djelo);

--agregirajuci upiti
SELECT spol, COUNT(*)
FROM policajac
GROUP BY spol;

SELECT p.ime || ' ' || p.prezime AS "Ime i prezime", MAX(current_date - pz.datum_pocetka)
FROM povijest_zaposlenja pz INNER JOIN policajac p USING (id_policajac)
GROUP BY "Ime i prezime";

SELECT m.naziv, COUNT(*)
FROM uhicene_osobe uo INNER JOIN mjesto m
ON uo.id_mjesto_preb = m.id_mjesto
GROUP BY m.naziv;

SELECT tip_vozila, COUNT(*)
FROM vozilo
GROUP BY tip_vozila
HAVING COUNT(*) > 1;

SELECT v.registracija, count(*)
FROM policajac_vozilo pv INNER JOIN vozilo v USING (id_vozilo)
GROUP BY v.registracija;

--podupiti
SELECT p.ime || ' ' || p.prezime AS "Ime i prezime"
FROM povijest_zaposlenja pz INNER JOIN policajac p USING (id_policajac)
WHERE current_date - pz.datum_pocetka = (
	SELECT MAX(current_date - pz.datum_pocetka)
	FROM povijest_zaposlenja pz INNER JOIN policajac p USING (id_policajac)
);

SELECT o.naziv
FROM odjel o INNER JOIN (
SELECT id_odjel, COUNT(*) broj
FROM policajac
GROUP BY id_odjel) sq
USING (id_odjel)
WHERE broj = (SELECT max(broj) FROM (SELECT id_odjel, COUNT(*) broj
FROM policajac
GROUP BY id_odjel));

SELECT m1.naziv
FROM mjesto m1 INNER JOIN uhicene_osobe uo
ON m1.id_mjesto = uo.id_mjesto_bor
EXCEPT
SELECT m2.naziv
FROM mjesto m2 INNER JOIN uhicene_osobe uo
ON m2.id_mjesto = uo.id_mjesto_preb;

SELECT p.ime, p.prezime, pv.datum, pv.smjena
FROM policajac p INNER JOIN policajac_vozilo pv USING (id_policajac)
WHERE pv.id_vozilo = (
SELECT id_vozilo
FROM policajac_vozilo pv INNER JOIN vozilo v USING (id_vozilo)
GROUP BY id_vozilo
HAVING COUNT(*) = 2);

SELECT p.ime || ' ' || p.prezime AS "Ime i prezime", s.naziv as "Skola"
FROM policajac p INNER JOIN policajac_skola ps USING (id_policajac)
INNER JOIN zavrsena_skola s USING (id_skola)
WHERE id_policajac IN (
SELECT id_policajac
FROM policajac INNER JOIN policajac_skola USING (id_policajac)
GROUP BY id_policajac
HAVING COUNT (*) > 1);

do
$$
DECLARE
	p_name policajac.ime%type;
	p_sur policajac.prezime%type;
	p_cursor CURSOR FOR
	SELECT ime, prezime
	FROM policajac;
BEGIN
	OPEN p_cursor;

	LOOP
		FETCH NEXT FROM p_cursor INTO p_name, p_sur;
		EXIT WHEN NOT FOUND;

		raise notice '% %', p_name, p_sur;
	END LOOP;
	
	CLOSE p_cursor;
END;
$$;