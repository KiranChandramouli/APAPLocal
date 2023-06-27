* @ValidationCode : MjotNDA4NzY1MjI2OkNwMTI1MjoxNjgxMjk5OTE0MDkxOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:15:14
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
SUBROUTINE REDO.V.INP.UPDATE.VALUE.DATE
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :
*Program   Name    :REDO.V.INP.UPDATE.VALUE.DATE
*---------------------------------------------------------------------------------
*DESCRIPTION       : This routine is a validation routine to be attached for both FT,
*                    TELLER to update the value date based on the Transaction code used
*LINKED WITH       : NA
* ----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,F.READ TO CACHE.READ
*12-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.CLEARING.RULES.PARAM
    $INSERT I_F.REDO.H.ROUTING.NUMBER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.EB.CONTRACT.BALANCES                ;*TUS S/E
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
****
INIT:
****
    FN.CLEARING.RULES.PARAM = 'F.REDO.H.CLEARING.RULES.PARAM'
    F.CLEARING.RULES.PARAM = ''
    R.CLEARING.RULES.PARAM = ""
    E.CLEARING.RULES.PARAM = ""
    CALL OPF(FN.CLEARING.RULES.PARAM,F.CLEARING.RULES.PARAM)
*
    FN.ROUTING.NUMBER = 'F.REDO.H.ROUTING.NUMBER'
    F.ROUTING.NUMBER = ''
    R.ROUTING.NUMBER = ''
    E.ROUTING.NUMBER = ''
    CALL OPF(FN.ROUTING.NUMBER,F.ROUTING.NUMBER)
*
    FN.FT.TXN.COND = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.COND = ''
    R.FT.TXN.COND = ''
    E.FT.TXN.COND = ''
    CALL OPF(FN.FT.TXN.COND,F.FT.TXN.COND)
*
    FN.TELLER.TXN = 'F.TELLER.TRANSACTION'
    F.TELLER.TXN = ''
    R.TELLER.TXN = ''
    E.TELLER.TXN = ''
    CALL OPF(FN.TELLER.TXN,F.TELLER.TXN)
*
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''
    E.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
****************
MULTI.GET.LOCAL:
****************
    APPLR.ROUTING.NUMBERNS = 'TELLER.TRANSACTION':@FM:'FT.TXN.TYPE.CONDITION'
    LOC.FIELDS = 'L.CU.CHQ.CLEAR':@FM:'L.CU.CHQ.CLEAR'
    GET.POS = ""
    CALL MULTI.GET.LOC.REF(APPLR.ROUTING.NUMBERNS,LOC.FIELDS,GET.POS)
    FIELD1.VAL = GET.POS<1,1>
    FIELD2.VAL = GET.POS<2,1>
RETURN
********
PROCESS:
********
    GOSUB MULTI.GET.LOCAL
    SEL.CMD = 'SELECT ':FN.ROUTING.NUMBER:' WITH BANK.CODE EQ ':ID.COMPANY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,R.NUM.ERR)
*
    CALL F.READ(FN.ROUTING.NUMBER,SEL.LIST,R.ROUTING.NUMBER,F.ROUTING.NUMBER,ROUT.ERR)
    Y.APAP = R.ROUTING.NUMBER<REDO.ROUT.APAP>

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB FT.PROCESS
    END
    IF APPLICATION EQ 'TELLER' THEN
        GOSUB TT.PROCESS
    END
RETURN
***********
FT.PROCESS:
***********
    Y.TXN.TYPE = R.NEW(FT.TRANSACTION.TYPE)
    CALL CACHE.READ(FN.FT.TXN.COND, Y.TXN.TYPE, R.FT.TXN.COND, FT.TXN.ERR)      ;*R22 AUTO CODE CONVERSION
    IF Y.APAP EQ 'YES' THEN
        R.FT.TXN.COND<FT6.LOCAL.REF,FIELD2.VAL> = 'YES'
        CALL F.WRITE(FN.FT.TXN.COND,Y.TXN.TYPE,R.FT.TXN.COND)

        Y.DEBIT.CURRENCY = R.NEW(FT.DEBIT.CURRENCY)
        CALL F.READ(FN.CLEARING.RULES.PARAM,Y.DEBIT.CURRENCY,R.CLEARING.RULES.PARAM,F.CLEARING.RULES.PARAM,PARAM.ERR)


        Y.CHECK.ISSUER = R.CLEARING.RULES.PARAM<CLR.RULE.CHECK.ISSUER>
        Y.CHECK.ISSUER = CHANGE(Y.CHECK.ISSUER,@VM,@FM)
        LOCATE 'APAP' IN Y.CHECK.ISSUER SETTING POS.APAP THEN
            Y.FWD.DAYS = R.CLEARING.RULES.PARAM<CLR.RULE.FWD.DAYS,POS.APAP>
            Y.PROCESS.DATE = R.NEW(FT.PROCESSING.DATE)
            NO.OF.DAYS = '+':Y.FWD.DAYS:'C'
            CALL CDT('',Y.PROCESS.DATE,NO.OF.DAYS)
            R.NEW(FT.DEBIT.VALUE.DATE) = Y.PROCESS.DATE
        END
    END ELSE
        R.FT.TXN.COND<FT6.LOCAL.REF,FIELD2.VAL> = 'NO'
        CALL F.WRITE(FN.FT.TXN.COND,Y.TXN.TYPE,R.FT.TXN.COND)
    END
    Y.DEBIT.ACC = R.NEW(FT.IN.DEBIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    CALL EB.READ.HVT ('EB.CONTRACT.BALANCES', Y.DEBIT.ACC, R.ECB, ECB.ERR)                ;*TUS START

*IF R.ACCOUNT<AC.OPEN.AVAILABLE.BAL> LT 0 THEN
    IF R.ECB<ECB.OPEN.AVAILABLE.BAL> LT 0 THEN                ;*TUS END
        TEXT = 'AVAIL.BAL.NEG'
        CNT.CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),@VM)
        CALL STORE.OVERRIDE(CNT.CURR.NO+1)
    END
RETURN
***********
TT.PROCESS:
***********
    Y.TXN.TYPE = R.NEW(TT.TE.TRANSACTION.CODE)
    CALL CACHE.READ(FN.TELLER.TXN, Y.TXN.TYPE, R.TELLER.TXN, TELLER.TXN.ERR)       ;*R22 AUTO CODE CONVERSION
    IF Y.APAP EQ 'YES' THEN
        R.TELLER.TXN<TT.TR.LOCAL.REF,FIELD1.VAL> = 'YES'
        CALL F.WRITE(FN.TELLER.TXN,Y.TXN.TYPE,R.TELLER.TXN)
    END ELSE
        R.TELLER.TXN<TT.TR.LOCAL.REF,FIELD1.VAL> = 'NO'
        CALL F.WRITE(FN.TELLER.TXN,Y.TXN.TYPE,R.TELLER.TXN)
    END
RETURN
END
