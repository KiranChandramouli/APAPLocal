* @ValidationCode : MjotODk2MTQ4MzA1OkNwMTI1MjoxNjgxMjgzOTMxMzEwOklUU1M6LTE6LTE6MTE2MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1160
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.ACH.APAP.FT.REVERSAL
*-------------------------------------------------------

*Comments
*-------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FILE.DATE.PROCESS
    $INSERT I_System

    GOSUB OPEN.FILES
    GOSUB LOCAL.REF.DET
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER.HIST = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIST  =''
    CALL OPF(FN.FUNDS.TRANSFER.HIST,F.FUNDS.TRANSFER.HIST)

    FN.REDO.FILE.DATE.PROCESS = 'F.REDO.FILE.DATE.PROCESS'
    F.REDO.FILE.DATE.PROCESS  = ''
    CALL OPF(FN.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS)

    FN.ACCOUNT  = 'F.ACCOUNT'
    F.ACCOUNT   = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*-----------------------------------------------------------------------------
LOCAL.REF.DET:
*-----------------------------------------------------------------------------
    LREF.APP ='FUNDS.TRANSFER'
    LREF.FIELDS  = "BENEFIC.NAME":@VM:"L.FT.ADD.INFO":@VM:"L.FT.COMM.CODE":@VM:"L.TT.TAX.CODE"
    LREF.FIELDS : =  @VM:"L.TT.WV.TAX":@VM:"L.TT.TAX.AMT":@VM:"L.TT.WV.COMM":@VM:"L.TT.COMM.AMT"
    LREF.FIELDS : =  @VM:"L.NCF.NUMBER":@VM:"L.NCF.TAX.NUM":@VM:"L.ACTUAL.VERSIO":@VM:"L.TT.COMM.CODE":@VM:"L.COMMENTS"
    LOCAL.REF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LOCAL.REF.POS)
    L.AC.STATUS1.POS = LOCAL.REF.POS<1,1>

    POS.BENEFIC.NAME   = LOCAL.REF.POS<1,1>
    POS.L.FT.ADD.INFO  = LOCAL.REF.POS<1,2>
    POS.L.FT.COMM.CODE = LOCAL.REF.POS<1,3>
    POS.L.TT.TAX.CODE  = LOCAL.REF.POS<1,4>
    POS.L.TT.WV.TAX    = LOCAL.REF.POS<1,5>
    POS.L.TT.TAX.AMT   = LOCAL.REF.POS<1,6>
    POS.L.TT.WV.COMM   = LOCAL.REF.POS<1,7>
    POS.L.TT.COMM.AMT  = LOCAL.REF.POS<1,8>
    POS.L.NCF.NUMBER   = LOCAL.REF.POS<1,9>
    POS.L.NCF.TAX.NUM  = LOCAL.REF.POS<1,10>
    POS.L.ACTUAL.VERSIO= LOCAL.REF.POS<1,11>
    POS.L.TT.COMM.CODE = LOCAL.REF.POS<1,12>
    POS.L.COMMENTS     = LOCAL.REF.POS<1,13>

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    IF COMI THEN
        IF MESSAGE NE "VAL" THEN
            Y.FT.ID=COMI
            COMI='REVERSO-':Y.FT.ID
        END
        ELSE
            RETURN
        END
    END

    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)

    Y.ARC.FILE.NAME  = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.COMMENTS>
    CALL F.READ(FN.REDO.FILE.DATE.PROCESS,Y.ARC.FILE.NAME,R.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS,REDO.FILE.DATE.PROCESS.ERR)
    Y.ARC.FILE.AC.NO = FIELD(R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.COMMENTS>,'.',5)

    Y.FILE.AC.NO=R.NEW(FT.CREDIT.ACCT.NO)
    Y.FILE.AMT  =R.NEW(FT.CREDIT.AMOUNT)
    IF R.FUNDS.TRANSFER THEN
        GOSUB FT.LIVE.PROCESS
    END ELSE
        GOSUB FT.HIST.PROCESS
    END
    Y.FT.AC.NO=R.NEW(FT.CREDIT.ACCT.NO)
    Y.FT.AMT=R.NEW(FT.CREDIT.AMOUNT)

    IF R.REDO.FILE.DATE.PROCESS AND Y.ARC.FILE.AC.NO EQ Y.FILE.AC.NO THEN
        Y.FT.AC.NO = Y.ARC.FILE.AC.NO
    END
    IF Y.FILE.AC.NO NE Y.FT.AC.NO OR Y.FILE.AMT NE Y.FT.AMT THEN
        ETEXT='EB-DATA.MIMATCH'
        CALL STORE.END.ERROR
    END

RETURN
*-----------------------------------------------------------------------------
FT.LIVE.PROCESS:
*-----------------------------------------------------------------------------

    R.NEW(FT.CREDIT.ACCT.NO)    = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
    R.NEW(FT.DEBIT.CUSTOMER)    = R.FUNDS.TRANSFER<FT.CREDIT.CUSTOMER>
    R.NEW(FT.CREDIT.CUSTOMER)   = R.FUNDS.TRANSFER<FT.DEBIT.CUSTOMER>
    R.NEW(FT.DEBIT.CURRENCY)    = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
    R.NEW(FT.CREDIT.CURRENCY)   = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>
    IF R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT> THEN
        R.NEW(FT.CREDIT.AMOUNT)     = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
    END
    ELSE
        R.NEW(FT.CREDIT.AMOUNT)     = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
    END

*   R.NEW(FT.DEBIT.VALUE.DATE)  = R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>
*   R.NEW(FT.CREDIT.VALUE.DATE) = R.FUNDS.TRANSFER<FT.CREDIT.VALUE.DATE>
    R.NEW(FT.DEBIT.THEIR.REF)   = R.FUNDS.TRANSFER<FT.DEBIT.THEIR.REF>
    R.NEW(FT.CREDIT.THEIR.REF)  = R.FUNDS.TRANSFER<FT.CREDIT.THEIR.REF>


    Y.DR.ACCT = R.NEW(FT.DEBIT.ACCT.NO)
    Y.CR.ACCT = R.NEW(FT.CREDIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,Y.DR.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    IF Y.CUSTOMER THEN
        R.NEW(FT.ORDERING.CUST) = Y.CUSTOMER

    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.CR.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
        R.NEW(FT.ORDERING.CUST)     = Y.CUSTOMER
        IF NOT(Y.CUSTOMER) THEN
            CALL F.READ(FN.ACCOUNT,Y.ARC.FILE.AC.NO,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
            Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
            R.NEW(FT.ORDERING.CUST)     = Y.CUSTOMER
        END
    END
    R.NEW(FT.ORDERING.BANK)     = R.FUNDS.TRANSFER<FT.ORDERING.BANK>
    R.NEW(FT.PAYMENT.DETAILS)   = 'REVERSO-':Y.FT.ID

    R.NEW(FT.LOCAL.REF)<1,POS.BENEFIC.NAME>   = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.BENEFIC.NAME>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.ADD.INFO>  = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.FT.ADD.INFO>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.COMM.CODE> = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.FT.COMM.CODE>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.CODE>  = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.TT.TAX.CODE>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.TAX>    = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.TT.WV.TAX>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.AMT>   = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.TT.TAX.AMT>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COMM.CODE> = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.TT.COMM.CODE>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.COMM>   = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.TT.WV.COMM>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COMM.AMT>  = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.TT.COMM.AMT>
    R.NEW(FT.LOCAL.REF)<1,POS.L.NCF.NUMBER>   = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.NCF.NUMBER>
    R.NEW(FT.LOCAL.REF)<1,POS.L.NCF.TAX.NUM>  = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.NCF.TAX.NUM>
    R.NEW(FT.LOCAL.REF)<1,POS.L.ACTUAL.VERSIO>= R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.ACTUAL.VERSIO>
    R.NEW(FT.LOCAL.REF)<1,POS.L.COMMENTS>     = R.FUNDS.TRANSFER<FT.LOCAL.REF,POS.L.COMMENTS>

RETURN

*-----------------------------------------------------------------------------
FT.HIST.PROCESS:
*-----------------------------------------------------------------------------
    CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIST,Y.FT.ID,R.FUNDS.TRANSFER.HIST,FT.HIST.ERR)
    R.NEW(FT.CREDIT.ACCT.NO)    = R.FUNDS.TRANSFER.HIST<FT.DEBIT.ACCT.NO>
    R.NEW(FT.DEBIT.CUSTOMER)    = R.FUNDS.TRANSFER.HIST<FT.CREDIT.CUSTOMER>
    R.NEW(FT.CREDIT.CUSTOMER)   = R.FUNDS.TRANSFER.HIST<FT.DEBIT.CUSTOMER>
    R.NEW(FT.DEBIT.CURRENCY)    = R.FUNDS.TRANSFER.HIST<FT.CREDIT.CURRENCY>
    R.NEW(FT.CREDIT.CURRENCY)   = R.FUNDS.TRANSFER.HIST<FT.DEBIT.CURRENCY>
    IF R.FUNDS.TRANSFER.HIST<FT.CREDIT.AMOUNT> THEN
        R.NEW(FT.CREDIT.AMOUNT)      = R.FUNDS.TRANSFER.HIST<FT.CREDIT.AMOUNT>
    END
    ELSE
        R.NEW(FT.CREDIT.AMOUNT)     = R.FUNDS.TRANSFER.HIST<FT.DEBIT.AMOUNT>
    END
*    R.NEW(FT.DEBIT.VALUE.DATE)  = R.FUNDS.TRANSFER.HIST<FT.DEBIT.VALUE.DATE>
*    R.NEW(FT.CREDIT.VALUE.DATE) = R.FUNDS.TRANSFER.HIST<FT.CREDIT.VALUE.DATE>
    R.NEW(FT.DEBIT.THEIR.REF)   = R.FUNDS.TRANSFER.HIST<FT.DEBIT.THEIR.REF>
    R.NEW(FT.CREDIT.THEIR.REF)  = R.FUNDS.TRANSFER.HIST<FT.CREDIT.THEIR.REF>

    Y.DR.ACCT = R.NEW(FT.DEBIT.ACCT.NO)
    Y.CR.ACCT = R.NEW(FT.CREDIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT,Y.DR.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    IF Y.CUSTOMER THEN
        R.NEW(FT.ORDERING.CUST) = Y.CUSTOMER

    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.CR.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
        R.NEW(FT.ORDERING.CUST)     = Y.CUSTOMER
        IF NOT(Y.CUSTOMER) THEN
            CALL F.READ(FN.ACCOUNT,Y.ARC.FILE.AC.NO,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
            Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
            R.NEW(FT.ORDERING.CUST)     = Y.CUSTOMER
        END
    END

    R.NEW(FT.ORDERING.BANK)     = R.FUNDS.TRANSFER.HIST<FT.ORDERING.BANK>
    Y.FT.ID = FIELD(Y.FT.ID,';',1)
    R.NEW(FT.PAYMENT.DETAILS)   = 'REVERSO-':Y.FT.ID


    R.NEW(FT.LOCAL.REF)<1,POS.BENEFIC.NAME>   = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.BENEFIC.NAME>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.ADD.INFO>  = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.FT.ADD.INFO>
    R.NEW(FT.LOCAL.REF)<1,POS.L.FT.COMM.CODE> = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.FT.COMM.CODE>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.CODE>  = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.TT.TAX.CODE>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.TAX>    = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.TT.WV.TAX>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.TAX.AMT>   = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.TT.TAX.AMT>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COMM.CODE> = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.TT.COMM.CODE>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.WV.COMM>   = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.TT.WV.COMM>
    R.NEW(FT.LOCAL.REF)<1,POS.L.TT.COMM.AMT>  = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.TT.COMM.AMT>
    R.NEW(FT.LOCAL.REF)<1,POS.L.NCF.NUMBER>   = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.NCF.NUMBER>
    R.NEW(FT.LOCAL.REF)<1,POS.L.NCF.TAX.NUM>  = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.NCF.TAX.NUM>
    R.NEW(FT.LOCAL.REF)<1,POS.L.ACTUAL.VERSIO>= R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.ACTUAL.VERSIO>
    R.NEW(FT.LOCAL.REF)<1,POS.L.COMMENTS>     = R.FUNDS.TRANSFER.HIST<FT.LOCAL.REF,POS.L.COMMENTS>

RETURN
*---------------------------------------------------------------
END
