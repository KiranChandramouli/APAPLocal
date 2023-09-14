* @ValidationCode : MjoxOTk1NDg5OTk5OkNwMTI1MjoxNjgwNjkxMDA4ODMxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 16:06:48
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
SUBROUTINE REDO.INP.ACC.OVER.SUPPRESS
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.INP.ACC.OVER.SUPPRESS
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to suppress the particular override from the account while
*                   set the posting restriction
*LINKED WITH       : ACCOUNT,REDO.PO
* ----------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*05-04-2023            Samaran T         Manual R22 Code Conversion        No Changes
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON

    GOSUB PROCESS
RETURN
*---------
PROCESS:
*----------

    IF APPLICATION EQ "ACCOUNT" AND PGM.VERSION EQ ",REDO.PO" THEN
        GOSUB SUPPRESS.OVRIDE
    END

RETURN
*-----------------------------------------------------------------------
SUPPRESS.OVRIDE:
*-----------------------------------------------------------------------
    Y.STORED.OVERRIDES = R.NEW(AC.OVERRIDE)
    IF V$FUNCTION EQ 'I' AND OFS$OPERATION EQ 'PROCESS' AND NOT(OFS.VAL.ONLY) THEN
        FINDSTR 'LD.JOINT.DIF.REL.CUSTOMER' IN Y.STORED.OVERRIDES SETTING POS.FM.REP,POS.VM.REP THEN
            DEL R.NEW(AC.OVERRIDE)<POS.FM.REP,POS.VM.REP>
            OFS$OVERRIDES<2,POS.VM.REP> = "YES"
        END
    END
RETURN
*-----------------
END
