SUBROUTINE REDO.IVR.ENCPWD
**************************************************************************
*------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RMONDRAGON
* Program Name : REDO.IVR.ENCPWD
*------------------------------------------------------------------------

* Description: This subroutine is performed in REDO.IVR.PARAMS,CREATE version
* as before authorization subroutine when the unique record SYSTEM is authorized
* once it was parameterized
* The functionality is to encrypt user and password used in the
* connection
* linked with : Version REDO.IVR.PARAMS,CREATE as Before Authorisation routine
* In Parameter : None
* Out Parameter : None

*--------------------------------------------------------------------
*--------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.IVR.PARAMS
    $INSERT JBC.h

    GOSUB INITIALIZE
    GOSUB ENCRYPT.AND.UPDATE

RETURN
*-------------------------------------------------
INITIALIZE:
* Description : Encryption key value is assigned here
*-------------------------------------------------
    KEY1="456123"
RETURN
*-------------------------------------------------------------------------
ENCRYPT.AND.UPDATE:

* Description : The values got from the version are encrypted and then
* username and password are updated
*-------------------------------------------------------------------------

    USER.ENC = ENCRYPT(R.NEW(REDO.IVR.PAR.USER),KEY1,JBASE_CRYPT_DES_BASE64)
    PWD.ENC = ENCRYPT(R.NEW(REDO.IVR.PAR.PWD),KEY1,JBASE_CRYPT_DES_BASE64)

    R.NEW(REDO.IVR.PAR.USER) = USER.ENC
    R.NEW(REDO.IVR.PAR.PWD) = PWD.ENC

RETURN
END
