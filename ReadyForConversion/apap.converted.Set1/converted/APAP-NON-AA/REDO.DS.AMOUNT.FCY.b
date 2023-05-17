SUBROUTINE REDO.DS.AMOUNT.FCY(AMT.FCY)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.DS.AMOUNT.FCY
*Modify            :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the credit amount details
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER

    GOSUB INIT
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
*
*    IF Y.CCY.1 NE LCCY THEN
*        VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)
*    END
*
*    IF Y.CCY.2 NE LCCY THEN
*        VAR.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.2)
*    END
*
    IF Y.DR.CR.MARKER EQ "DEBIT" THEN
        IF Y.CCY.1 NE LCCY THEN
            VAR.AMOUNT = R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>
        END
        ELSE
            VAR.AMOUNT = R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS>
        END
    END
*
    IF Y.DR.CR.MARKER EQ "CREDIT" THEN
        IF Y.CCY.1 NE LCCY THEN
            VAR.AMOUNT = R.NEW(TT.TE.LOCAL.REF)<1,CREDIT.POS>
        END
        ELSE
            VAR.AMOUNT = R.NEW(TT.TE.LOCAL.REF)<1,DEBIT.POS>
        END
    END
*
    AMT.FCY = FMT(VAR.AMOUNT,"R2,#21")

RETURN
*
*****
INIT:
*****
*
    Y.CCY.1        = ""
    Y.CCY.2        = ""
    VAR.AMOUNT     = ""
    Y.DR.CR.MARKER = ""
*
    IF APPLICATION EQ "TELLER" THEN
        Y.CCY.1  = R.NEW(TT.TE.CURRENCY.1)
        Y.CCY.2  = R.NEW(TT.TE.CURRENCY.2)
    END
*
    LOC.REF.APPLICATION = 'TELLER'
    LOC.REF.FIELDS      = 'L.DEBIT.AMOUNT'
    LOC.REF.FIELDS<2>   = 'L.CREDIT.AMOUNT'
    CHANGE @FM TO @VM IN LOC.REF.FIELDS
*
    LOC.REF.POS         = ''
*
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LREF.POS)
    DEBIT.POS        = LREF.POS<1,1>
    CREDIT.POS       = LREF.POS<1,2>
*
    Y.DR.CR.MARKER   = R.NEW(TT.TE.DR.CR.MARKER)
*
RETURN
*

END
