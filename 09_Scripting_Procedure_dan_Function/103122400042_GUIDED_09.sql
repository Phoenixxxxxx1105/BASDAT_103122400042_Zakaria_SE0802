-- ================================================================
--  MODUL 9 - SCRIPTING PROCEDURE DAN FUNCTION
--  Disusun runtut mengikuti sub-bab modul praktikum
--  Jalankan: SET SERVEROUTPUT ON; sebelum semua blok di bawah!
-- ================================================================

SET SERVEROUTPUT ON;
SET SERVEROUTPUT OFF;


-- ================================================================
-- SUB-BAB 9.1.1 — PROCEDURE DASAR
-- ================================================================

-- Contoh procedure paling sederhana (tanpa parameter)
CREATE OR REPLACE PROCEDURE cetak AS
    d VARCHAR2(8);
BEGIN
    d := q'(Cobalagi)';
    DBMS_OUTPUT.PUT_LINE(d);
END;
/

-- Jalankan procedure
EXEC cetak;
EXECUTE cetak;


-- ================================================================
-- SUB-BAB 9.1.1.1 — PARAMETER PROCEDURE (IN, OUT, IN OUT)
-- ================================================================

-- 1. Parameter IN — kirim nilai ke procedure
CREATE OR REPLACE PROCEDURE sapa (nama IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Halo, ' || nama || '!');
END;
/

EXEC sapa('Budi');
EXEC sapa('Siti');


-- 2. Parameter OUT — ambil nilai dari procedure
CREATE OR REPLACE PROCEDURE hitung_luas_persegi (
    sisi    IN  NUMBER,
    luas    OUT NUMBER
) AS
BEGIN
    luas := sisi * sisi;
END;
/

-- Panggil procedure dengan OUT parameter
DECLARE
    hasil NUMBER;
BEGIN
    hitung_luas_persegi(7, hasil);
    DBMS_OUTPUT.PUT_LINE('Luas persegi sisi 7 = ' || hasil);
END;
/


-- 3. Parameter IN OUT — kirim dan terima kembali nilai
CREATE OR REPLACE PROCEDURE format_phone
    (phone_num IN OUT VARCHAR2) IS
BEGIN
    phone_num := '(' || SUBSTR(phone_num, 1, 3) || ')' ||
                 SUBSTR(phone_num, 4, 3) || '-' ||
                 SUBSTR(phone_num, 7);
END format_phone;
/

-- Panggil procedure IN OUT
DECLARE
    phone VARCHAR2(21) := '234676ASDA';
BEGIN
    format_phone(phone);
    DBMS_OUTPUT.PUT_LINE(phone);
    -- Output: (234)234-ASDA
END;
/


-- ================================================================
-- SUB-BAB 9.1.1.2 — PASSING PARAMETER
-- ================================================================

-- Procedure untuk demo passing parameter
CREATE OR REPLACE PROCEDURE add_dept (
    name IN VARCHAR2,
    loc  IN NUMBER
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Dept: ' || name || ', Loc: ' || loc);
END;
/

-- 1. Positional — urutan sesuai definisi
EXECUTE add_dept('EDUCATION', 2400);

-- 2. Named — pakai => untuk spesifikasi nama
EXECUTE add_dept(loc=>2400, name=>'EDUCATION');

-- 3. Combination — gabungan positional dan named
EXECUTE add_dept('EDUCATION', loc=>2400);

EXECUTE add_dept(loc=>2400, 'EDUCATION');


-- ================================================================
-- SUB-BAB 9.1.1.3 — PROCEDURE DALAM PROCEDURE
-- ================================================================

-- Procedure 1: cetak angka 1 sampai x
CREATE OR REPLACE PROCEDURE cetak_angka (x IN INTEGER) AS
    j INTEGER;
BEGIN
    FOR j IN 1..x LOOP
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(j));
    END LOOP;
END;
/

-- Procedure 2: memanggil procedure di atas
CREATE OR REPLACE PROCEDURE panggil AS
BEGIN
    cetak_angka(5);
END;
/

EXECUTE panggil;
EXECUTE cetak_angka(6);


-- ================================================================
-- SUB-BAB 9.2 — TUTORIAL PROCEDURE
-- ================================================================

-- Tutorial 1: Procedure Fibonacci
CREATE OR REPLACE PROCEDURE fibo AS
    k INT;
    i INT;
    j INT;
BEGIN
    k := 1;
    i := 1;
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(k));
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(i));
    LOOP
        j := k + i;
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(j));
        k := i;
        i := j;
        EXIT WHEN j > 20;
    END LOOP;
END;
/

EXECUTE fibo;
-- Output: 1, 1, 2, 3, 5, 8, 13, 21


-- Tutorial 2: Procedure dengan tabel MHS
CREATE TABLE mhs (
    nama  VARCHAR2(20),
    nim   VARCHAR2(8) PRIMARY KEY,
    kelas VARCHAR2(5)
);

INSERT ALL
    INTO mhs VALUES ('CHOGI KIM',   '10118042', 'RPL01')
    INTO mhs VALUES ('TAEYEON KIM', '10118009', 'RPL01')
    INTO mhs VALUES ('YURI KWON',   '10118021', 'RPL01')
SELECT * FROM dual;
COMMIT;

-- Procedure untuk menampilkan data mahasiswa berdasarkan NIM
CREATE OR REPLACE PROCEDURE cetak_mhs (p_nim IN VARCHAR2) AS
    v_nama  VARCHAR2(20);
    v_nim   VARCHAR2(8);
    v_kelas VARCHAR2(5);
BEGIN
    SELECT nama, nim, kelas
    INTO   v_nama, v_nim, v_kelas
    FROM   mhs
    WHERE  nim = p_nim;

    DBMS_OUTPUT.PUT_LINE('NAMA  : ' || v_nama);
    DBMS_OUTPUT.PUT_LINE('NIM   : ' || v_nim);
    DBMS_OUTPUT.PUT_LINE('KELAS : ' || v_kelas);
END;
/

EXECUTE cetak_mhs('10118042');
EXECUTE cetak_mhs('10118009');
EXECUTE cetak_mhs('10118021');


-- Tutorial 3: Procedure tambah data mahasiswa
CREATE OR REPLACE PROCEDURE tambah_mhs (
    p_nim   VARCHAR2,
    p_nama  VARCHAR2,
    p_kelas VARCHAR2
) AS
BEGIN
    INSERT INTO mhs VALUES (p_nama, p_nim, p_kelas);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Data berhasil ditambahkan: ' || p_nama);
END;
/

EXECUTE tambah_mhs('10118099', 'JESSICA JUNG', 'RPL02');
SELECT * FROM mhs;


-- ================================================================
-- SUB-BAB 9.3 — FUNCTION
-- ================================================================

-- Perbedaan Procedure vs Function:
-- Procedure : tidak mengembalikan nilai (tidak ada RETURN di header)
-- Function  : WAJIB mengembalikan nilai (ada RETURN di header)


-- Function tanpa parameter
CREATE OR REPLACE FUNCTION tulis
RETURN VARCHAR2 AS
BEGIN
    RETURN 'Hello Hello';
END;
/

-- Panggil function
SELECT tulis FROM dual;
EXECUTE DBMS_OUTPUT.PUT_LINE(tulis);


-- Function dengan parameter — lihat gaji employee
CREATE OR REPLACE FUNCTION lihat_gaji (
    p_id employees.employee_id%TYPE
)
RETURN NUMBER IS
    gaji NUMBER;
BEGIN
    SELECT salary INTO gaji
    FROM   employees
    WHERE  employee_id = p_id;
    RETURN gaji;
END;
/

-- Panggil function
SELECT employees from dual;
EXECUTE DBMS_OUTPUT.PUT_LINE(lihat_gaji(145));

-- Pakai dalam SELECT
SELECT employee_id, last_name, lihat_gaji(employee_id) AS gaji
FROM   employees;


-- Function naik gaji
CREATE OR REPLACE FUNCTION naik_gaji (p_salary NUMBER)
RETURN NUMBER IS
    gaji_sekarang NUMBER;
BEGIN
    gaji_sekarang := p_salary + 1000;
    RETURN gaji_sekarang;
END;
/

-- Pakai dalam SELECT dengan filter department
SELECT employee_id, last_name, salary,
       naik_gaji(salary) AS "Gaji Setelah Naik"
FROM   employees
WHERE  department_id = 60;

select * from employees;


-- Function cek bilangan prima
CREATE OR REPLACE FUNCTION is_prime (bil INTEGER)
RETURN VARCHAR2 AS
    prima  BOOLEAN := TRUE;
    j      INTEGER;
BEGIN
    IF bil <= 1 THEN
        prima := FALSE;
    END IF;
    FOR j IN 2..(bil/2) LOOP
        IF MOD(bil, j) = 0 THEN
            prima := FALSE;
            EXIT;
        END IF;
    END LOOP;

    IF prima THEN
        RETURN 'PRIMA';
    ELSE
        RETURN 'BUKAN PRIMA';
    END IF;
END;
/

-- Test function
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('7  = ' || is_prime(7));
    DBMS_OUTPUT.PUT_LINE('10 = ' || is_prime(10));
    DBMS_OUTPUT.PUT_LINE('13 = ' || is_prime(13));
END;
/



-- Function pangkat
CREATE OR REPLACE FUNCTION pangkat (bil INTEGER, n INTEGER)
RETURN INTEGER AS
    hasil INTEGER;
    i     INTEGER;
BEGIN
    hasil := 1;
    FOR i IN 1..n LOOP
        hasil := hasil * bil;
    END LOOP;
    RETURN hasil;
END;
/

-- Test function pangkat
DECLARE
    h INTEGER;
BEGIN
    h := pangkat(3, 8);
    DBMS_OUTPUT.PUT_LINE('2 pangkat 8 = ' || TO_CHAR(h));
END;
/


-- ================================================================
-- SUB-BAB 9.3 — NESTED FUNCTION
-- ================================================================

-- Function 1: hitung kuadrat
CREATE OR REPLACE FUNCTION kuadrat (x NUMBER)
RETURN NUMBER AS
    hasil NUMBER;
BEGIN
    hasil := x * x;
    RETURN hasil;
END;
/

-- Function 2: hitung determinan (memanggil kuadrat di dalamnya)
-- Rumus: D = b² - 4ac
CREATE OR REPLACE FUNCTION determinan (a NUMBER, b NUMBER, c NUMBER)
RETURN NUMBER AS
    d NUMBER;
BEGIN
    d := kuadrat(b) - (4 * a * c);
    RETURN d;
END;
/

-- Test nested function
DECLARE
    d NUMBER;
BEGIN
    d := determinan(1, 5, 6);
    DBMS_OUTPUT.PUT_LINE('Determinan (1,5,6) = ' || TO_CHAR(d));
    -- D = 5² - 4(1)(6) = 25 - 24 = 1
END;
/


-- Drop function (opsional)
-- DROP FUNCTION lihat_gaji;
-- DROP FUNCTION naik_gaji;
-- DROP FUNCTION is_prime;
-- DROP FUNCTION pangkat;
-- DROP FUNCTION kuadrat;
-- DROP FUNCTION determinan;
-- DROP FUNCTION tulis;


-- ================================================================
-- SUB-BAB 9.4 — STUDI KASUS
-- ================================================================

-- Studi Kasus: Procedure keliling lingkaran
-- Tebak outputnya sebelum dijalankan!
CREATE OR REPLACE PROCEDURE keliling_lingkaran AS
    r NUMBER(5);
    k NUMBER(10);
BEGIN
    r := 21;
    k := 2 * ((22/7) * r);
    DBMS_OUTPUT.PUT_LINE('Keliling Lingkaran = ' || k);
END;
/

EXECUTE keliling_lingkaran;
-- Output: Keliling Lingkaran = 132


-- Bonus studi kasus: Function luas lingkaran (variasi)
CREATE OR REPLACE FUNCTION luas_lingkaran (r NUMBER)
RETURN NUMBER AS
    luas NUMBER;
BEGIN
    luas := (22/7) * r * r;
    RETURN luas;
END;
/

DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Luas lingkaran r=7  = ' || luas_lingkaran(7));
    DBMS_OUTPUT.PUT_LINE('Luas lingkaran r=14 = ' || luas_lingkaran(14));
    DBMS_OUTPUT.PUT_LINE('Luas lingkaran r=21 = ' || luas_lingkaran(21));
END;
/


SET SERVEROUTPUT ON;

Create or replace procedure cetak as
    d VARCHAR2 (50);
BEGIN
    d := q'(coba lagi)';
    DBMS_output.put_line(d);
END;

EXECUTE cetak;

CREATE OR REPLACE PROCEDURE sapa (nama IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Halo, ' || nama || '!');
END;

EXECUTE sapa ('Budi');
EXECUTE sapa ('Siti');

CREATE OR REPLACE PROCEDURE hitung_luas_persegi (
    sisi IN NUMBER,
    luas OUT NUMBER
) AS
BEGIN
    luas := sisi * sisi;
END; 

DECLARE
    hasil NUMBER;
BEGIN
    hitung_luas_persegi(7, hasil);
    DBMS_OUTPUT.PUT_LINE('Luas persegi sisi 7 = ' || hasil);
END;

CREATE OR REPLACE PROCEDURE format_phone
    (phone_num IN OUT VARCHAR2) IS
BEGIN
    phone_num := '(' || SUBSTR(phone_num, 1, 3) || ')' ||
                SUBSTR(phone_num, 4, 3) || '-' ||
                SUBSTR (phone_num, 7);
END format_phone;

DECLARE
    phone VARCHAR2(21) := '234234ASDA';
BEGIN
    format_phone(phone);
    DBMS_OUTPUT.PUT_LINE(phone);
    -- OUTPUT: (234)234-ASDA
END;

CREATE OR REPLACE PROCEDURE add_dept(
    name IN VARCHAR2,
    loc IN NUMBER
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Dept: ' || name || ', Loc: ' || loc);
END;


EXECUTE add_dept('EDUCATION', 2400);

EXECUTE add_dept(loc=>2400, name=>'EDUCATION');

EXECUTE add_dept('EDUCATION', loc=>2400);

CREATE OR REPLACE PROCEDURE cetak_angka (x IN INTEGER) AS
    j INTEGER;
BEGIN
    FOR j IN 1..x LOOP
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(j));
    END LOOP;
END;

CREATE OR REPLACE PROCEDURE panggil AS
BEGIN
    cetak_angka(5);
END;

EXECUTE panggil;

CREATE OR REPLACE FUNCTION tulis
RETURN VARCHAR2 AS
BEGIN
    RETURN 'Hello Hello';
END;

SELECT tulis FROM dual;
EXECUTE DBMS_OUTPUT.PUT_LINE(tulis);x