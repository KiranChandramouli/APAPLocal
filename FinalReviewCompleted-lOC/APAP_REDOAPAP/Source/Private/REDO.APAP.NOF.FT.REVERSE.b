* @ValidationCode : MjotMTk4ODIxMDM1NTpDcDEyNTI6MTY4MTcyODQ5NjI1MDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 16:18:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOF.FT.REVERSE(Y.FIN.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.APAP.NOF.FT.REVERSE
* ODR NUMBER    : ODR-2010-03-0131
*-----------------------------------------------------------------------------
* Description   : This is nofile routine, will fetch the values to pass to enquiry
* In parameter  : none
* out parameter : Y.FIN.ARR
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*17-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM
*17-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.REVERSAL.FTTC

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.FIELD.POS
    GOSUB PROCESS
    GOSUB PROGRAM.END
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

    FN.REDO.APAP.REVERSAL.FTTC = 'F.REDO.APAP.REVERSAL.FTTC'
    F.REDO.APAP.REVERSAL.FTTC  = ''
    CALL OPF(FN.REDO.APAP.REVERSAL.FTTC,F.REDO.APAP.REVERSAL.FTTC)


    FN.REDO.FT.REVERSE.LIST = 'F.REDO.FT.REVERSE.LIST'
    F.REDO.FT.REVERSE.LIST  =  ''
    CALL OPF(FN.REDO.FT.REVERSE.LIST,F.REDO.FT.REVERSE.LIST)


    CALL CACHE.READ(FN.REDO.APAP.REVERSAL.FTTC,'SYSTEM',R.REDO.APAP.REVERSAL.FTTC,FTTC.REV.ERR)
    Y.REV.FTTC.CODES = R.REDO.APAP.REVERSAL.FTTC<REDO.FT.REV.FTTC.CODES>
    Y.HIST.DAYS      = R.REDO.APAP.REVERSAL.FTTC<REDO.FT.REV.HIST.DAYS>
    CHANGE @VM TO @FM IN Y.REV.FTTC.CODES

    LOCATE 'PROCESSING.DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
        Y.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
    END


    IF Y.DATE THEN
        CALL CDD('',Y.DATE,TODAY,NO.OF.DAYS)
        IF (NO.OF.DAYS GT Y.HIST.DAYS) OR (Y.DATE GT TODAY) THEN
            ENQ.ERROR = "EB-DATE.RANGE.EXCEED"
            GOSUB PROGRAM.END
        END
    END ELSE
        Y.HIST.DAYS = '-':Y.HIST.DAYS:'C'
        Y.HIST.DATE = TODAY
        CALL CDT('',Y.HIST.DATE,Y.HIST.DAYS)
    END
RETURN
*-----------------------------------------------------------------------------
GET.LOCAL.FIELD.POS:
*-----------------------------------------------------------------------------
    APPLN = 'FUNDS.TRANSFER'
    FIELD.NAMES = 'L.FT.CR.CARD.NO'
    CALL MULTI.GET.LOC.REF(APPLN,FIELD.NAMES,FIELD.POS)
    Y.POS.FT.CR = FIELD.POS<1,1>
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------


    CALL REDO.E.FORM.SEL.STMT(FN.FUNDS.TRANSFER, '', '', SEL.LIVE.CMD)
    CALL REDO.E.FORM.SEL.STMT(FN.FUNDS.TRANSFER.HIST, '', '', SEL.HIST.CMD)
    IF D.RANGE.AND.VALUE AND NOT(Y.DATE) THEN
        SEL.LIVE.CMD := ' AND PROCESSING.DATE GE ':Y.HIST.DATE
        SEL.HIST.CMD := ' AND PROCESSING.DATE GE ':Y.HIST.DATE
    END
    IF NOT(D.RANGE.AND.VALUE) AND NOT(Y.DATE) THEN
        SEL.LIVE.CMD := ' WITH PROCESSING.DATE GE ':Y.HIST.DATE
        SEL.HIST.CMD := ' WITH PROCESSING.DATE GE ':Y.HIST.DATE
    END

    CALL EB.READLIST(SEL.LIVE.CMD,SEL.LIVE.FT.LIST,'',NO.OF.REC.LIVE.FT,SEL.FT.LIVE.ERR)
    CALL EB.READLIST(SEL.HIST.CMD,SEL.HIST.FT.LIST,'',NO.OF.REC.HIST.FT,SEL.FT.HIST.ERR)
    SEL.FT.LIST = SEL.LIVE.FT.LIST:@FM:SEL.HIST.FT.LIST

    LOOP
        REMOVE Y.FT.ID FROM SEL.FT.LIST SETTING POS.LIST
    WHILE Y.FT.ID:POS.LIST
        Y.FT.ID = FIELD(Y.FT.ID,';',1)
        CALL F.READ(FN.REDO.FT.REVERSE.LIST,Y.FT.ID,R.REDO.FT.REVERSE.LIST,F.REDO.FT.REVERSE.LIST,REV.ERR)
        IF NOT(REV.ERR) THEN
            CONTINUE
        END
        CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)

        IF R.FUNDS.TRANSFER THEN
            GOSUB FT.LIVE.PROCESS
        END ELSE
            GOSUB FT.HIST.PROCESS
        END

    REPEAT
RETURN
*-----------------------------------------------------------------------------
FT.LIVE.PROCESS:
*-----------------------------------------------------------------------------
    Y.TXN.CODE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
    LOCATE Y.TXN.CODE IN Y.REV.FTTC.CODES SETTING TXN.POS THEN
    END ELSE
        RETURN
    END
    Y.DR.ACCT = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
    Y.CR.ACCT = R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>

    Y.FT.AMT = R.FUNDS.TRANSFER<FT.DEBIT.AMOUNT>
    IF NOT(Y.FT.AMT) THEN
        Y.FT.AMT = R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>
    END

    Y.FT.CUR = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>
    IF NOT(Y.FT.CUR) THEN
        Y.FT.CUR = R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>
    END

    Y.FT.DATE  = R.FUNDS.TRANSFER<FT.PROCESSING.DATE>
    Y.FT.INP   = FIELD(R.FUNDS.TRANSFER<FT.INPUTTER>,'_',2)
    Y.FT.AUT   = FIELD(R.FUNDS.TRANSFER<FT.AUTHORISER>,'_',2)
    Y.FT.COM   = R.FUNDS.TRANSFER<FT.CO.CODE>

    Y.FIN.ARR<-1> = Y.FT.ID:'*':Y.DR.ACCT:'*':Y.CR.ACCT:'*':Y.FT.AMT:'*':Y.FT.CUR:'*':Y.FT.DATE:'*':Y.FT.INP:'*':Y.FT.AUT:'*':Y.FT.COM

RETURN
*-----------------------------------------------------------------------------
FT.HIST.PROCESS:
*-----------------------------------------------------------------------------
    CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIST,Y.FT.ID,R.FUNDS.TRANSFER.HIST,FT.HIST.ERR)

    Y.TXN.CODE = R.FUNDS.TRANSFER.HIST<FT.TRANSACTION.TYPE>
    LOCATE Y.TXN.CODE IN Y.REV.FTTC.CODES SETTING TXN.POS THEN
    END ELSE
        RETURN
    END
    Y.DR.ACCT = R.FUNDS.TRANSFER.HIST<FT.DEBIT.ACCT.NO>
    Y.CR.ACCT = R.FUNDS.TRANSFER.HIST<FT.CREDIT.ACCT.NO>

    Y.FT.AMT = R.FUNDS.TRANSFER.HIST<FT.DEBIT.AMOUNT>
    IF NOT(Y.FT.AMT) THEN
        Y.FT.AMT = R.FUNDS.TRANSFER.HIST<FT.CREDIT.AMOUNT>
    END

    Y.FT.CUR = R.FUNDS.TRANSFER.HIST<FT.DEBIT.CURRENCY>
    IF NOT(Y.FT.CUR) THEN
        Y.FT.CUR = R.FUNDS.TRANSFER.HIST<FT.CREDIT.CURRENCY>
    END

    Y.FT.DATE  = R.FUNDS.TRANSFER.HIST<FT.PROCESSING.DATE>
    Y.FT.INP   = FIELD(R.FUNDS.TRANSFER.HIST<FT.INPUTTER>,'_',2)
    Y.FT.AUT   = FIELD(R.FUNDS.TRANSFER.HIST<FT.AUTHORISER>,'_',2)
    Y.FT.COM   = R.FUNDS.TRANSFER.HIST<FT.CO.CODE>
    Y.FT.ID = FIELD(Y.FT.ID,';',1)

    Y.FIN.ARR<-1> = Y.FT.ID:'*':Y.DR.ACCT:'*':Y.CR.ACCT:'*':Y.FT.AMT:'*':Y.FT.CUR:'*':Y.FT.DATE:'*':Y.FT.INP:'*':Y.FT.AUT:'*':Y.FT.COM

RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
