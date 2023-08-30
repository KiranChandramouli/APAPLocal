* @ValidationCode : MjoxNTcwMDczNzQ5OkNwMTI1MjoxNjgxMjg2NDEzMDgwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 13:30:13
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
*   Date               who               Reference                     Description
* 16-SEP-2011        Marimuthu S       PACS000123125                 Initial Creation
*12-04-2023         Conversion Tool    R22 Auto Code conversion      FM TO @FM VM TO @VM
*12-04-2023          Samaran T         R22 Manual Code conversion      No Changes
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
