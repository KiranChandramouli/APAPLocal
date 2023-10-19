* @ValidationCode : MjotMjA3MjgwNDAyNzpDcDEyNTI6MTY4MTI4Mzk0MjExNjpJVFNTOi0xOi0xOjE5MzoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:49:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 193
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.AZ.ID.SMS.CHECK
*-------------------------------------------------------------------
* Description: This ID routine is to check whether any existing record is getting modified
*              through the creation version then it will throw the error.
*-------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    IF V$FUNCTION EQ "I" THEN
        GOSUB PROCESS
    END

RETURN
*-------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------

    FN.FILE = "F.":APPLICATION
    F.FILE  = ""
    CALL OPF(FN.FILE,F.FILE)

    Y.ID = COMI

    CALL F.READ(FN.FILE,Y.ID,R.RECORD,F.FILE,FILE.ERR)

    IF R.RECORD THEN
        E = "EB-TRANSACTION.NOT.ALLOWED"
        CALL STORE.END.ERROR
    END

RETURN
END
