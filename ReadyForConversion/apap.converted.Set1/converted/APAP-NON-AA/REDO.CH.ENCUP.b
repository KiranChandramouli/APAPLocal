SUBROUTINE REDO.CH.ENCUP
**************************************************************************
*------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RMONDRAGON
* Program Name : REDO.CH.ENCUP
*------------------------------------------------------------------------

* Description: This subroutine is performed in REDO.CH.PREV.DBCM,INPUT version
* as before authorization subroutine when the unique record SYSTEM is authorized
* once it was parameterized
* The functionality is to encrypt user and password used in the
* database connection
* linked with : Version REDO.CH.PREV.DBCM,INPUT as Authorisation routine
* In Parameter : None
* Out Parameter : None

*--------------------------------------------------------------------
*--------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CH.PREV.DBCM
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

    USER.ENC = ENCRYPT(R.NEW(REDO.PREV.DB.USER),KEY1,JBASE_CRYPT_DES_BASE64)
    PWD.ENC = ENCRYPT(R.NEW(REDO.PREV.DB.PWD),KEY1,JBASE_CRYPT_DES_BASE64)

    R.NEW(REDO.PREV.DB.USER) = USER.ENC
    R.NEW(REDO.PREV.DB.PWD) = PWD.ENC

RETURN

END
