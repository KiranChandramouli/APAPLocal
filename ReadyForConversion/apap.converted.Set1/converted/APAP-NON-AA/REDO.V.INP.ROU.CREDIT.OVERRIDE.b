SUBROUTINE REDO.V.INP.ROU.CREDIT.OVERRIDE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Program   Name    :REDO.V.INP.ROU.CREDIT.OVERRIDE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine will be used to throw the override depends on credit card status

*LINKED WITH       :

*------------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-SEP-2011        Marimuthu S    PACS000123125      Initial Creation
*----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER


MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

PROCESS:

    APPLN = 'FUNDS.TRANSFER'
    LREF.FIELDS = 'L.FT.CR.CRD.STS':@VM:'L.FT.AC.STATUS'
    CALL MULTI.GET.LOC.REF(APPLN,LREF.FIELDS,LOC.POS)
    Y.CR.POS = LOC.POS<1,1>
    Y.CR.AC.POS = LOC.POS<1,2>

    Y.CREDIT.CARD.ST = R.NEW(FT.LOCAL.REF)<1,Y.CR.POS>
    Y.CR.ACCT.ST = R.NEW(FT.LOCAL.REF)<1,Y.CR.AC.POS>
    IF Y.CREDIT.CARD.ST NE 'CANCELADA' AND Y.CREDIT.CARD.ST NE 'ACTIVA' THEN
        AF = FT.LOCAL.REF
        AV = Y.CR.POS
        CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1
        TEXT = 'REDO.CR.CRD.ST':@FM:Y.CREDIT.CARD.ST
        CALL STORE.OVERRIDE(CURR.NO)
    END

    IF Y.CR.ACCT.ST NE 'CANCELADA' AND Y.CR.ACCT.ST NE 'ACTIVA' AND Y.CR.ACCT.ST NE 'CERRADO' THEN
        AF = FT.LOCAL.REF
        AV = Y.CR.AC.POS
        CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM) + 1
        TEXT = 'REDO.CR.CRD.AC.ST':@FM:Y.CR.ACCT.ST
        CALL STORE.OVERRIDE(CURR.NO)
    END


RETURN

PGM.END:

END
