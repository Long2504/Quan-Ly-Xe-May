	CREATE DATABASE qlxm
GO
USE qlxm
GO
CREATE TABLE chucvu
(
	MACV INT IDENTITY PRIMARY KEY,
	tencv NVARCHAR(10) NOT NULL
)
GO
CREATE TABLE nhanvien
(
	MANV VARCHAR(5)  NOT NULL PRIMARY KEY DEFAULT dbo.AUTO_IDNV() ,
	tennv NVARCHAR(100) NOT NULL,
	namsinh DATE NOT NULL,
	gioitinh INT  ,
	sdt INT,
	email VARCHAR(100),
	diachi NVARCHAR(100),
	macv INT CONSTRAINT fk_NVvCV FOREIGN KEY (macv) REFERENCES dbo.chucvu(MACV) ON DELETE CASCADE ON UPDATE CASCADE ,
	luong int ,
	trangthai int
)
GO
CREATE TABLE nhasx
(
	MANHASX VARCHAR(10) NOT NULL PRIMARY KEY,
	tennhasx NVARCHAR(10) UNIQUE,
	email VARCHAR(100),
	sdt INT 
)
GO
CREATE TABLE XE
(
	MAXE VARCHAR(5) NOT NULL PRIMARY KEY DEFAULT dbo.AUTO_IDXE() ,
	tenxe NVARCHAR(100) UNIQUE NOT NULL,
	manhasx VARCHAR(10) CONSTRAINT fk_XEvNHASX FOREIGN KEY (manhasx) REFERENCES dbo.nhasx(MANHASX) ON DELETE NO ACTION ON UPDATE CASCADE,
	soluong INT DEFAULT 0,
	thongtinbaohanh NVARCHAR(100),
	mota NVARCHAR(100),
	giaban INT NOT NULL
)
GO
CREATE TABLE billnhap
(
	MANHAP varCHAR(5) NOT NULL PRIMARY KEY DEFAULT dbo.AUTO_IDBILLNHAP(),
	manvnhap VARCHAR(5) CONSTRAINT fk_BNvNV FOREIGN KEY (manvnhap) REFERENCES dbo.nhanvien(MANV) ON DELETE NO ACTION ON UPDATE CASCADE,
	manhasx VARCHAR(10) CONSTRAINT fk_BNvNSX FOREIGN KEY (manhasx) REFERENCES dbo.nhasx(MANHASX) ON DELETE NO ACTION ON UPDATE CASCADE,
	ngay DATE,
	tongtiennhap INT,
)
GO
CREATE TABLE billnhapinfor
(
	MANHAP VARCHAR(5)  CONSTRAINT fk_IFNvBN FOREIGN KEY (MANHAP) REFERENCES dbo.billnhap(MANHAP) ON DELETE CASCADE ON UPDATE CASCADE ,
	tongtien INT,
	maxe VARCHAR(5) CONSTRAINT fk_IFNvXE FOREIGN KEY (maxe) REFERENCES dbo.XE(MAXE) ON DELETE NO ACTION ON UPDATE NO ACTION  ,
	soluong INT,
)
GO
CREATE TABLE KHACHHANG
(
	MAKH VARCHAR(5) PRIMARY KEY DEFAULT dbo.AUTO_IDKH(),
	tenkh NVARCHAR(100),
	diachi NVARCHAR(100),
	sdt INT,
	email VARCHAR(100)
)
GO
CREATE TABLE billxuat
(
	MAXUAT varCHAR(5) NOT NULL PRIMARY KEY DEFAULT dbo.AUTO_IDBILLXUAT() ,
	ngay DATE,
	makh varCHAR(5) NOT NULL CONSTRAINT fk_BXvKH FOREIGN KEY (makh) REFERENCES dbo.KHACHHANG(MAKH) ON DELETE NO ACTION ON UPDATE CASCADE,
	manvxuat varCHAR(5) CONSTRAINT fk_BXvNV FOREIGN KEY (manvxuat) REFERENCES dbo.nhanvien(MANV) ON DELETE NO ACTION ON UPDATE CASCADE,
	tongtienxuat INT
)
GO
CREATE TABLE billxuatinfor
(
	MAXUAT varCHAR(5) CONSTRAINT fk_IFXvBX FOREIGN KEY (MAXUAT) REFERENCES dbo.billxuat(MAXUAT) ON DELETE CASCADE ON UPDATE CASCADE,
	manhasx varCHAR(10) CONSTRAINT fk_IFXvNSX FOREIGN KEY (manhasx) REFERENCES dbo.nhasx(MANHASX) ON DELETE NO ACTION ON UPDATE CASCADE,
	soluong INT,
	tongtien INT,
	maxe varCHAR(5) CONSTRAINT fk_IFXvXE FOREIGN KEY (maxe) REFERENCES dbo.XE(MAXE) ON DELETE NO ACTION ON UPDATE NO ACTION,
)
GO
CREATE TABLE account
(
	manv VARCHAR(5) CONSTRAINT fk_accVNV FOREIGN KEY (manv) REFERENCES dbo.nhanvien(MANV) ON DELETE CASCADE ON UPDATE CASCADE,
	tk VARCHAR(100) UNIQUE NOT NULL,
	mk VARCHAR(100) NOT NULL,
	tentk NVARCHAR(100) NOT NULL
)
INSERT dbo.billxuatinfor (MAXUAT,manhasx,soluong,tongtien,maxe) VALUES ( '7', 'ANH BA', 1, 3000, 'XE002')
SELECT * FROM dbo.nhasx
CREATE FUNCTION AUTO_IDNV()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MANV) FROM dbo.nhanvien) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MANV, 3)) FROM dbo.nhanvien
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'NV00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 AND @ID < 99 THEN 'NV0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 99 THEN 'NV' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
GO
CREATE FUNCTION AUTO_IDXE()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MAXE) FROM dbo.XE) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MAxe, 3)) FROM dbo.XE
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'XE00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 AND @ID < 99 THEN 'XE0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 99 THEN 'XE' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
GO
CREATE FUNCTION AUTO_IDBILLXUAT()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MAXUAT) FROM dbo.billxuat) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MAXUAT, 3)) FROM dbo.billxuat
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'BX00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 AND @ID < 99 THEN 'BX0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 99 THEN 'BX' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
GO
CREATE FUNCTION AUTO_IDBILLNHAP()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MANHAP) FROM dbo.billnhap) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MANHAP, 3)) FROM dbo.billnhap
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'BN00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 AND @ID < 99 THEN 'BN0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 99 THEN 'BN' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
GO
CREATE FUNCTION AUTO_IDKH()
RETURNS VARCHAR(5)
AS
BEGIN
	DECLARE @ID VARCHAR(5)
	IF (SELECT COUNT(MAKH) FROM dbo.KHACHHANG) = 0
		SET @ID = '0'
	ELSE
		SELECT @ID = MAX(RIGHT(MAKH, 3)) FROM dbo.KHACHHANG
		SELECT @ID = CASE
			WHEN @ID >= 0 and @ID < 9 THEN 'KH00' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 9 AND @ID < 99 THEN 'KH0' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
			WHEN @ID >= 99 THEN 'KH' + CONVERT(CHAR, CONVERT(INT, @ID) + 1)
		END
	RETURN @ID
END
GO
CREATE TRIGGER banxe ON dbo.billxuatinfor FOR INSERT
AS
BEGIN
	DECLARE @xe CHAR(5), @soluongco INT , @soluongban int
	SELECT @xe = maxe FROM Inserted
	SELECT @soluongco= soluong FROM dbo.XE WHERE MAXE=@xe
	SELECT @soluongban= soluong FROM Inserted
	IF(@soluongco-@soluongban < 0)
	ROLLBACK
	ELSE
	UPDATE dbo.XE SET soluong=soluong-( SELECT Inserted.soluong FROM Inserted WHERE Inserted.maxe=MAXE ) WHERE XE.MAXE = @xe
END
GO
GO
CREATE TRIGGER nhapxe ON dbo.billnhapinfor FOR INSERT
AS
BEGIN
	DECLARE @xe CHAR(5)
	SELECT @xe = maxe FROM Inserted
	UPDATE dbo.XE SET soluong=soluong+( SELECT Inserted.soluong FROM Inserted WHERE Inserted.maxe=MAXE ) WHERE XE.MAXE = @xe
END
GO
select * from NHANVIEN
