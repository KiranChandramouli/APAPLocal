* @ValidationCode : MjotMTU5NzA3NjMzOkNwMTI1MjoxNjg0ODQyMDk3Mzg1OklUU1M6LTE6LTE6LTE3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -17
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE

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
