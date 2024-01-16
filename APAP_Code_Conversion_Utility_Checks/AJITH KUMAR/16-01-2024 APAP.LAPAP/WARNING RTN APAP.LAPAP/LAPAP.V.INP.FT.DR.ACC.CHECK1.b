* @ValidationCode : MjotMTQxMjQ4Njk1NTpDcDEyNTI6MTY4NDIyMjgxNzI3ODpJVFNTOi0xOi0xOjM2NjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 366
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.INP.FT.DR.ACC.CHECK1
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as input routine in FUNDS.TRANSFER versions
* The functionality of this routine is to block the transaction when
* Debit account has block status or insufficient balance
* 2019-02-07 - COPIA DE LA RUTINA REDO.V.INP.FT.DR.ACC.CHECK1 - CN009521
* 2021-06-07 - sumar 0.15 al monto a debitar de la cuenta debito - MDP-1926
*-------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*21-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,= TO EQ, INSERT FILE MODIFIED,Y.TOTAL.AMT + TO +=
*21-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON     ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CHEQUE.COLLECTION
    $INSERT I_F.ACCOUNT    ;*R22 AUTO CODE CONVERSION.END
   $USING EB.LocalReferences

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------
INITIALISE:
*----------
*Initialise the Variables

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CHEQUE.COLLECTION = 'F.CHEQUE.COLLECTION'
    F.CHEQUE.COLLECTION = ''
    R.CHEQUE.COLLECTION = ''
    CALL OPF(FN.CHEQUE.COLLECTION,F.CHEQUE.COLLECTION)

    LREF.APPLN = 'ACCOUNT':@FM:'FUNDS.TRANSFER'
    LREF.FLDS = 'L.AC.STATUS2':@FM
    LREF.FLDS := 'L.LOAN.COND':@VM:'L.LOAN.STATUS.1'
    LREF.POS = ''

    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
    POS.STATUS.2 = LREF.POS<1,1>
    FT.LOAN.COND.POS =  LREF.POS<2,1>
    FT.LOAN.STATUS.POS = LREF.POS<2,2>
*MDP-1926
*    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.TT.TAX.CODE",L.TT.TAX.CODE.POS)
EB.LocalReferences.GetLocRef("FUNDS.TRANSFER", "L.TT.TAX.CODE",L.TT.TAX.CODE.POS);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF("FUNDS.TRANSFER", "L.TT.TAX.AMT",L.TT.TAX.AMT.POS)
EB.LocalReferences.GetLocRef("FUNDS.TRANSFER", "L.TT.TAX.AMT",L.TT.TAX.AMT.POS);* R22 UTILITY AUTO CONVERSION
RETURN
*-------------------------------------------------------------------------

GET.LOCKED.AMOUNT:
******************
    Y.LOCKED.AMOUNT = 0
    IF NOT(R.ACCOUNT<AC.FROM.DATE>) THEN
        Y.LOCKED.AMOUNT = 0
        RETURN
    END

    Y.DATE.COUNT = DCOUNT(R.ACCOUNT<AC.FROM.DATE>,@VM)
    Y.DATE.START = 1
    LOOP
    WHILE Y.DATE.START LE Y.DATE.COUNT
        IF R.ACCOUNT<AC.FROM.DATE,Y.DATE.START> LE TODAY THEN
            Y.LOCKED.AMOUNT += R.ACCOUNT<AC.LOCKED.AMOUNT,Y.DATE.START>
        END
        Y.DATE.START += 1
    REPEAT
RETURN


PROCESS:
*-------

    AF = FT.DEBIT.ACCT.NO
    LOAN.COND = R.NEW(FT.LOCAL.REF)<1,FT.LOAN.COND.POS>
    Y.LOAN.STATUS = R.NEW(FT.LOCAL.REF)<1,FT.LOAN.STATUS.POS>

    Y.L.TT.TAX.CODE = R.NEW(FT.LOCAL.REF)<1,L.TT.TAX.CODE.POS>
    Y.L.TT.TAX.AMT = R.NEW(FT.LOCAL.REF)<1,L.TT.TAX.AMT.POS>

    CHANGE @SM TO @VM IN Y.LOAN.STATUS
    CHANGE @SM TO @VM IN LOAN.COND

    IF ('JudicialCollection' MATCHES Y.LOAN.STATUS) OR ('Write-off' MATCHES Y.LOAN.STATUS) THEN
        ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
* CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),VM)
* IF CURR.NO EQ 0 THEN
*     CURR.NO = 1
* END
        AF = FT.LOCAL.REF
        AV = FT.LOAN.STATUS.POS
        CALL STORE.END.ERROR
    END

    IF ('Legal' MATCHES LOAN.COND) THEN
        ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
        AF = FT.LOCAL.REF
        AV = FT.LOAN.COND.POS
        CALL STORE.END.ERROR
    END

    Y.ACCOUNT.1 = R.NEW(FT.DEBIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.1,R.ACCOUNT,F.ACCOUNT,ERR.ACC)
    Y.STATUS.2 = R.ACCOUNT<AC.LOCAL.REF,POS.STATUS.2>
**---------------------------------------------------------------------------------------------
**MDP-1404 si estatus de bloqueo es GARANTIA debe permitir la transacion
    Y.STATUS.CUENTA = Y.STATUS.2
    Y.STATUS.CUENTA = CHANGE(Y.STATUS.CUENTA,@VM,@FM)
    Y.STATUS.CUENTA = CHANGE(Y.STATUS.CUENTA,@SM,@FM)
    Y.CNT = DCOUNT(Y.STATUS.CUENTA,@FM)
    IF Y.CNT LE 1 AND Y.STATUS.CUENTA MATCHES 'GUARANTEE.STATUS' THEN
        Y.STATUS.2 = ''
    END
**----------------------------------------------------------------------------------------------
    IF Y.STATUS.2 NE '' THEN
        ETEXT = 'EB-DEB.AC.BLOCK.STATUS'
        CALL STORE.END.ERROR
        RETURN
    END
    Y.ONLINE.ACT.BAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
*Y.LOCKED.AMOUNT = SUM(R.ACCOUNT<AC.LOCKED.AMOUNT>)
    GOSUB GET.LOCKED.AMOUNT
    Y.AVAIL.AMOUNT = Y.ONLINE.ACT.BAL - Y.LOCKED.AMOUNT

    Y.DEBIT.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)
    IF Y.DEBIT.AMOUNT EQ '' THEN
        Y.DEBIT.AMOUNT = R.NEW(FT.CREDIT.AMOUNT)
    END
    Y.CHARGE.AMOUNT = SUM(R.NEW(FT.TOTAL.CHARGE.AMOUNT)) + SUM(R.NEW(FT.TOTAL.TAX.AMOUNT))
    Y.TOTAL.AMT = Y.DEBIT.AMOUNT + Y.CHARGE.AMOUNT

*Si genero impuesto de 0.15 entoces se le suma tambien el impuesto
    IF Y.L.TT.TAX.CODE EQ 'IMP015%' THEN
        Y.TOTAL.AMT += Y.L.TT.TAX.AMT
    END
*------------------------------------------------------------------
* SI ES UNA CUENTA INTERNA NO HACEMOS LA VALIDACIONES DEL BALANCE
    IF SUBSTRINGS(Y.ACCOUNT.1 ,1,1) EQ '1' THEN
        IF Y.AVAIL.AMOUNT LT Y.TOTAL.AMT THEN
            ETEXT = 'EB-DR.COND.FAIL'
            CALL STORE.END.ERROR
            RETURN
        END
    END

    SELECT.CMD="SELECT ":FN.CHEQUE.COLLECTION:" WITH CREDIT.ACC.NO EQ ":Y.ACCOUNT.1:" AND EXPOSURE.DATE NE ":TODAY
    CALL EB.READLIST(SELECT.CMD,SELECT.LIS,'',NOR,ERR1)

    IF SELECT.LIS NE '' THEN
        ETEXT = 'EB-CHQUE.DEPOSIT'
        CALL STORE.END.ERROR
        RETURN
    END
RETURN
*-------------------------------------------------------------------------



END
