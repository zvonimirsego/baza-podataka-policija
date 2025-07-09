DROP INDEX IF EXISTS idx_mjesto_post_broj;
DROP INDEX IF EXISTS idx_cin;
DROP INDEX IF EXISTS idx_djela;
DROP TRIGGER IF EXISTS povijest_zaposlenja_trigger ON policajac;
DROP TRIGGER IF EXISTS preb_bor_trigger ON uhicene_osobe;
DROP TRIGGER IF EXISTS ranije_uhicen_trigger ON uhicenja;
DROP TRIGGER IF EXISTS voditelj_odjel_trigger ON odjel;
DROP FUNCTION IF EXISTS povijest_zaposlenja_chk;
DROP FUNCTION IF EXISTS preb_bor;
DROP FUNCTION IF EXISTS ranije_uhicen;
DROP FUNCTION IF EXISTS odjel_voditelj;
DROP PROCEDURE IF EXISTS dodaj_u_povijest;
DROP PROCEDURE IF EXISTS dodaj_mjesto;
DROP TABLE IF EXISTS uhicenja;
DROP TABLE IF EXISTS uhicene_osobe;
DROP TABLE IF EXISTS ilegalna_djela;
DROP TABLE IF EXISTS mjesto;
DROP TABLE IF EXISTS povijest_zaposlenja;
DROP TABLE IF EXISTS policajac_vozilo;
DROP TABLE IF EXISTS policajac_skola;
DROP TABLE IF EXISTS policajac CASCADE;
DROP TABLE IF EXISTS vozilo;
DROP TABLE IF EXISTS zavrsena_skola;
DROP TABLE IF EXISTS odjel;
DROP TABLE IF EXISTS cin;

CREATE TABLE cin (
	id_cin SERIAL PRIMARY KEY,
	naziv VARCHAR(50) NOT NULL
);

CREATE TABLE zavrsena_skola (
	id_skola SERIAL PRIMARY KEY,
	naziv VARCHAR(100) NOT NULL
);

CREATE TABLE vozilo (
	id_vozilo VARCHAR(20) PRIMARY KEY, -- broj šasije
	registracija VARCHAR(7) NOT NULL,
	tip_vozila VARCHAR(20) NOT NULL CONSTRAINT tip_vozila_check CHECK (tip_vozila IN ('automobil', 'motor', 'marica', 'kombi', 'brod'))
);

CREATE TABLE policajac (
	id_policajac VARCHAR(9) PRIMARY KEY,
	ime VARCHAR(20) NOT NULL,
	prezime VARCHAR(30) NOT NULL,
	dat_rodj DATE NOT NULL,
	spol VARCHAR(1) NOT NULL CONSTRAINT spol_chk CHECK (spol in ('M', 'F')),
	id_cin INTEGER NOT NULL CONSTRAINT cin_fk REFERENCES cin(id_cin),
	id_odjel INTEGER NOT NULL
);

CREATE TABLE policajac_skola(
	id_policajac VARCHAR(9) NOT NULL CONSTRAINT policajac_fk REFERENCES policajac(id_policajac),
	id_skola INTEGER NOT NULL CONSTRAINT skola_fk REFERENCES zavrsena_skola(id_skola),
	godina_zavrsetka INTEGER NOT NULL CONSTRAINT godina_chk CHECK (godina_zavrsetka > 1900),
	PRIMARY KEY (id_policajac, id_skola)
);

CREATE TABLE policajac_vozilo(
	id_policajac VARCHAR(9) NOT NULL CONSTRAINT policajac_vozilo_fk REFERENCES policajac(id_policajac),
	id_vozilo VARCHAR(20) NOT NULL CONSTRAINT vozilo_fk REFERENCES vozilo(id_vozilo),
	datum DATE NOT NULL,
	smjena INTEGER NOT NULL CONSTRAINT smjena_ck CHECK (smjena IN (1, 2, 3)),
	PRIMARY KEY (id_policajac, id_vozilo, datum)
);

CREATE TABLE odjel(
	id_odjel SERIAL PRIMARY KEY,
	naziv VARCHAR(50) NOT NULL,
	id_voditelj VARCHAR(9) CONSTRAINT voditelj_fk REFERENCES policajac(id_policajac)
);

ALTER TABLE odjel
ADD CONSTRAINT voditelj_uq UNIQUE (id_voditelj);

ALTER TABLE policajac
ADD CONSTRAINT odjel_fk FOREIGN KEY (id_odjel) REFERENCES odjel(id_odjel);

CREATE TABLE ilegalna_djela(
	id_djelo SERIAL PRIMARY KEY,
	naziv VARCHAR(50) NOT NULL
);

CREATE TABLE mjesto(
	id_mjesto SERIAL PRIMARY KEY,
	naziv VARCHAR(50) NOT NULL,
	post_broj VARCHAR(5) NOT NULL
);

CREATE TABLE uhicene_osobe(
	id_uhic_osoba VARCHAR(11) PRIMARY KEY,  -- oib
	ime VARCHAR(20) NOT NULL,
	prezime VARCHAR(30) NOT NULL,
	dat_rodj DATE NOT NULL,
	spol VARCHAR(1) NOT NULL CONSTRAINT spol_chk CHECK (spol in ('M', 'F')),
	adresa_preb VARCHAR(100) NOT NULL,
	id_mjesto_preb INTEGER NOT NULL CONSTRAINT mjesto_preb_fk REFERENCES mjesto(id_mjesto),
	adresa_bor VARCHAR(100),
	id_mjesto_bor INTEGER CONSTRAINT mjesto_bor_fk REFERENCES mjesto(id_mjesto)
);

CREATE TABLE uhicenja(
	id_uhicenje SERIAL PRIMARY KEY,
	id_policajac VARCHAR(9) NOT NULL CONSTRAINT policajac_fk REFERENCES policajac(id_policajac),
	id_uhic_osoba VARCHAR(11) NOT NULL CONSTRAINT osoba_fk REFERENCES uhicene_osobe(id_uhic_osoba),
	datum_uhicenja DATE NOT NULL DEFAULT current_date,
	id_djelo INTEGER NOT NULL CONSTRAINT djelo_fk REFERENCES ilegalna_djela(id_djelo),
	opis TEXT,
	ranije_uhicenje BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE povijest_zaposlenja(
	id_policajac VARCHAR(9) NOT NULL CONSTRAINT policajac_fk REFERENCES policajac(id_policajac),
	id_odjel INTEGER NOT NULL CONSTRAINT odjel_fk REFERENCES odjel(id_odjel),
	id_cin INTEGER NOT NULL CONSTRAINT cin_fk REFERENCES cin(id_cin),
	datum_pocetka DATE NOT NULL DEFAULT current_date,
	datum_zavrsetka DATE,
	PRIMARY KEY (id_policajac, id_odjel, id_cin)
);

CREATE OR REPLACE FUNCTION povijest_zaposlenja_chk()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
BEGIN
	UPDATE povijest_zaposlenja
	SET old.datum_zavrsetka = current_date
	WHERE id_policajac = old.id_policajac AND
	id_odjel = old.id_odjel AND
	id_cin = old.id_cin;

	INSERT INTO povijest_zaposlenja (id_policajac, id_odjel, id_cin)
	VALUES
	(new.id_policajac, new.id_odjel, new.id_cin);

	RETURN new;
END;
$$;

CREATE TRIGGER povijest_zaposlenja_trigger
AFTER UPDATE
ON policajac
FOR EACH ROW
EXECUTE FUNCTION povijest_zaposlenja_chk();

CREATE OR REPLACE PROCEDURE dodaj_u_povijest(
	pol_id policajac.id_policajac%type,
	datum DATE
)
LANGUAGE PLPGSQL
AS
$$
DECLARE
	id_o policajac.id_odjel%type;
	id_c policajac.id_cin%type;
BEGIN
	SELECT id_odjel, id_cin
	INTO id_o, id_c
	FROM policajac
	WHERE id_policajac = pol_id;

	INSERT INTO povijest_zaposlenja(id_policajac, id_odjel, id_cin, datum_pocetka)
	VALUES
	(pol_id, id_o, id_c, datum);
END; $$;

CREATE OR REPLACE FUNCTION preb_bor()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
BEGIN
	IF (new.adresa_bor IS NULL AND new.id_mjesto_bor IS NULL) THEN
		UPDATE uhicene_osobe
		SET adresa_bor = adresa_preb
		WHERE id_uhic_osoba = id_uhic_osoba;

		UPDATE uhicene_osobe
		SET id_mjesto_bor = id_mjesto_preb
		WHERE id_uhic_osoba = id_uhic_osoba;

	END IF;
	RETURN new;
END;
$$;

CREATE TRIGGER preb_bor_trigger
AFTER INSERT
ON uhicene_osobe
FOR EACH ROW
EXECUTE FUNCTION preb_bor();

CREATE FUNCTION ranije_uhicen()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
BEGIN
	IF (new.id_uhic_osoba IN (SELECT id_uhic_osoba FROM uhicenja)) THEN
		new.ranije_uhicenje = true;
	END IF;
	RETURN new;
END; 
$$;

CREATE TRIGGER ranije_uhicen_trigger
BEFORE INSERT
ON uhicenja
FOR EACH ROW
EXECUTE FUNCTION ranije_uhicen();

CREATE FUNCTION odjel_voditelj()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS
$$
DECLARE
	id_o odjel.id_odjel%type;
BEGIN
	SELECT id_odjel
	INTO id_o
	FROM policajac
	WHERE id_policajac = new.id_voditelj;

	IF (id_o != new.id_odjel) THEN
		raise exception 'Policajac ne pripada danom odjelu!';
	END IF;
	RETURN new;
END;
$$;

CREATE TRIGGER voditelj_odjel_trigger
BEFORE UPDATE
ON odjel
FOR EACH ROW
EXECUTE FUNCTION odjel_voditelj();

CREATE PROCEDURE dodaj_mjesto(
	naz mjesto.naziv%type,
	pos_br mjesto.post_broj%type
)
LANGUAGE PLPGSQL
AS
$$
BEGIN
	INSERT INTO mjesto (naziv, post_broj)
	VALUES
	(naz, pos_br);
END; $$;

CREATE INDEX idx_mjesto_post_broj
ON mjesto (naziv, post_broj);

CREATE INDEX idx_cin
ON cin (naziv);

CREATE INDEX idx_djela
ON ilegalna_djela (naziv);

COMMENT ON TABLE cin IS 'Tablica činova';
COMMENT ON TABLE odjel IS 'Tablica svih odjela i svi bitni podatci';
COMMENT ON TABLE zavrsena_skola IS 'Tablica policijskih škola';
COMMENT ON TABLE vozilo IS 'Tablica svih vozila u policijskoj stanici';
COMMENT ON TABLE policajac IS 'Tablica svih podataka o policajcima';
COMMENT ON TABLE policajac_vozilo IS 'Vezna tablica između tablica policajac i vozilo';
COMMENT ON TABLE policajac_skola IS 'Vezna tablica između tablica policajac i zavrsena_skola';
COMMENT ON TABLE povijest_zaposlenja IS 'Tablica koja prati povijest zaposlenja svakog policajca';
COMMENT ON TABLE ilegalna_djela IS 'Tablica počinjenih ilegalnih djela';
COMMENT ON TABLE uhicenja IS 'Tablica u kojoj su podatci o svakom uhićenju';
COMMENT ON TABLE uhicene_osobe IS 'Tablica podataka o uhićenim osobama';
COMMENT ON TABLE mjesto IS 'Tablica mjesta';

COMMIT;