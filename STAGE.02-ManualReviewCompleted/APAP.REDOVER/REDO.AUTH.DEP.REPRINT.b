* @ValidationCode : MjoxMjA2OTg1OTE5OkNwMTI1MjoxNjgwNjgxNTg1NTQzOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:29:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.DEP.REPRINT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.APAP.H.REPRINT.DEP
*----------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*05-04-2023       Samaran T              Manual R22 Code Conversion        No Changes
*------------------------------------------------------------------------------------------

    GOSUB PROCESS
RETURN
*------------
PROCESS:
*-----------
    R.NEW(REDO.REP.DEP.REPRINT.SEQ) = R.NEW(REDO.REP.DEP.REPRINT.SEQ) + 1
    R.NEW(REDO.REP.DEP.REPRINT.FLAG) = ''
    R.NEW(REDO.REP.DEP.OVERRIDE) = ''

    VAR.ID = FIELD(ID.NEW,"-",1)

    VEROPR ="ENQ REDO.DEP.REPRINT.LIST @ID EQ ":VAR.ID
    IF VEROPR THEN
        CALL EB.SET.NEW.TASK(VEROPR)
    END

RETURN
*-------------
END
