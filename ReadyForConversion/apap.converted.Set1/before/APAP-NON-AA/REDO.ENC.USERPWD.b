*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ENC.USERPWD
**************************************************************************
*------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.ENC.USERPWD
*------------------------------------------------------------------------

* Description: This subroutine is performed in REDO.OFAC.DBCM,INPUT version
* as before authorization subroutine when the unique record SYSTEM is authorized
* once it was parameterized
* The functionality is to encrypt user and password used in the
* database connection
* linked with : Version REDO.OFAC.DBCM,INPUT as Before Authorisation routine
* In Parameter : None
* Out Parameter : None

*--------------------------------------------------------------------
*--------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.OFAC.DBCM
$INSERT JBC.h

  GOSUB INITIALIZE
  GOSUB ENCRYPT.AND.UPDATE

  RETURN
*-------------------------------------------------
INITIALIZE:
* Description : Encryption key value is assigned here
*-------------------------------------------------
  KEY1="123456"
  RETURN
*-------------------------------------------------------------------------
ENCRYPT.AND.UPDATE:

* Description : The values got from the version are encrypted and then
* username and password are updated
*-------------------------------------------------------------------------

  IPADD.ENC = ENCRYPT(R.NEW(REDO.DBCM.IP.ADD),KEY1,JBASE_CRYPT_DES)
  PORT.ENC = ENCRYPT(R.NEW(REDO.DBCM.PORT),KEY1,JBASE_CRYPT_DES)
  DBNAME.ENC = ENCRYPT(R.NEW(REDO.DBCM.DB.NAME),KEY1,JBASE_CRYPT_DES)
  TBNAME.ENC = ENCRYPT(R.NEW(REDO.DBCM.TB.NAME),KEY1,JBASE_CRYPT_DES)
  USER.ENC = ENCRYPT(R.NEW(REDO.DBCM.DB.USER),KEY1,JBASE_CRYPT_DES_BASE64)
  PWD.ENC = ENCRYPT(R.NEW(REDO.DBCM.DB.PWD),KEY1,JBASE_CRYPT_DES_BASE64)

  R.NEW(REDO.DBCM.DB.USER) = USER.ENC
  R.NEW(REDO.DBCM.DB.PWD) = PWD.ENC

  RETURN
END
