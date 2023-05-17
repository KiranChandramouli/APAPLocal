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
