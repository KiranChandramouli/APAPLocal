*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.TEMP.ROU.CREDIT.OVERRIDE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Program   Name    :REDO.V.TEMP.ROU.CREDIT.OVERRIDE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine will be used to throw the override depends on credit card status

*LINKED WITH       :

*------------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 06-Jun-2017       Edwin Charles D  R15 Upgrade         Initial Creation
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FT.TT.TRANSACTION

MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    Y.CREDIT.CARD.ST = R.NEW(FT.TN.L.FT.CR.CRD.STS)
    Y.CR.ACCT.ST = R.NEW(FT.TN.L.FT.AC.STATUS)
    IF Y.CREDIT.CARD.ST NE 'CANCELADA' AND Y.CREDIT.CARD.ST NE 'ACTIVA' THEN
        AF = FT.TN.L.FT.CR.CRD.STS
        CURR.NO = DCOUNT(R.NEW(FT.TN.OVERRIDE),VM) + 1
        TEXT = 'REDO.CR.CRD.ST':FM:Y.CREDIT.CARD.ST
        CALL STORE.OVERRIDE(CURR.NO)
    END

    IF Y.CR.ACCT.ST NE 'CANCELADA' AND Y.CR.ACCT.ST NE 'ACTIVA' AND Y.CR.ACCT.ST NE 'CERRADO' THEN
        AF = FT.TN.L.FT.AC.STATUS
        CURR.NO = DCOUNT(R.NEW(FT.TN.OVERRIDE),VM) + 1
        TEXT = 'REDO.CR.CRD.AC.ST':FM:Y.CR.ACCT.ST
        CALL STORE.OVERRIDE(CURR.NO)
    END


    RETURN

PGM.END:

END
