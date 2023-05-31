* @ValidationCode : MjotNzEyMjM3NTA1OkNwMTI1MjoxNjg0ODQyMDk3MjE0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:11:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.ENC.SAP.KEY
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.ENC.SAP.KEY
*--------------------------------------------------------------------------------------------------------
*Description  : Encrypt the key for SAPRPT
*In Parameter :
*Out Parameter:
*
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27/08/2014    PRABHU N              Initial Creation
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE

*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT JBC.h
    $INSERT I_F.REDO.INTERFACE.PARAM


    Y.KEY1=R.NEW(REDO.INT.PARAM.ENCRIP.KEY)

    yEncripKey=ID.NEW
    yLine = ENCRYPT(Y.KEY1,yEncripKey,JBASE_CRYPT_3DES_BASE64)

    R.NEW(REDO.INT.PARAM.ENCRIP.KEY) =yLine
    R.NEW(REDO.INT.PARAM.CON.ENC.KEY)=yLine

RETURN
END
