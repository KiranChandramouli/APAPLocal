* @ValidationCode : Mjo0MzkxMDYyMDE6Q3AxMjUyOjE2ODE4MDYyNDk4ODk6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 13:54:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.APAP.INTERFACE.ERR
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at Input Routines for Nomina files to Raise Errors
*------------------------------------------------------------------------------------------
*
* COMPANY NAME : APAP
* DEVELOPED BY : Riyas
* PROGRAM NAME : REDO.VAL.APAP.INTERFACE.ERR
*
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*       DATE             WHO                REFERENCE         DESCRIPTION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             VM TO @VM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    Y.VERSION.LIST = ',NOMINAERR':@VM:',BACENERR':@VM:',ORANGERR'
    IF PGM.VERSION MATCHES Y.VERSION.LIST THEN
        ETEXT ='EB-INVALID.ACCT'
        CALL STORE.END.ERROR
    END
END
