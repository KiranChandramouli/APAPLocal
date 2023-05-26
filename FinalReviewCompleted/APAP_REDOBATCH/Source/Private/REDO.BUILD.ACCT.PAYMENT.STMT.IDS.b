* @ValidationCode : MjotMTQ3MTE5NTM3NjpDcDEyNTI6MTY4NDg1NDQwNTE0NjpJVFNTOi0xOi0xOjU0OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 549
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BUILD.ACCT.PAYMENT.STMT.IDS(Y.FINAL.ARRAY)
*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.BUILD.TRANS.PERIOD
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.BUILD.TRANS.PERIOD
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  19-09-2011       PRABHUN             PACS00125978                MODIFICATION
* Date                   who                   Reference              
* 18-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND -- TO -= 1 AND ! TO *
* 18-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES

*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
*---------------------------------------------------------------------------------------------------------

    GOSUB INITIALISE.GET.VALUES
    GOSUB CHECK.MORE.THAN.180
    GOSUB ARCIB.PARAM.TRAN.DETAILS
    GOSUB PROCESS


RETURN

*----------------------------------------
INITIALISE.GET.VALUES:
*---------------------------------------

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY  = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)



    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS  = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.ARCIB.PARAM = 'F.AI.REDO.ARCIB.PARAMETER'
    F.ARCIB.PARAM = ''
    CALL OPF(FN.ARCIB.PARAM,F.ARCIB.PARAM)


    SYSTEM.ID = 'SYSTEM'
    TRANSFER.CODE = ''

    CALL CACHE.READ(FN.ARCIB.PARAM,SYSTEM.ID,R.ARCIB.PARAM,ARC.ERR)
    IF NOT(ARC.ERR) THEN
        AI.PARAM.PROD =R.ARCIB.PARAM<AI.PARAM.PRODUCT>
        AI.PARAM.TYPE=R.ARCIB.PARAM<AI.PARAM.TRANSACTION.TYPE>
    END

    DAYS = ''
    Y.BOOK.DATE.LEN = ''
    Y.FROM.DATE.VAL = ''
    Y.CURRENT.DAY = ''
    ST.RG.DATE=''
    END.RG.DATE=''
    END.TO.DATE=''
    Y.ID.LIST = ''
    START.FRM.DATE=''
    FLAG.ENQ = ''
    CR.DB.FLG=''
    CR.FLG=''
    DB.FLG=''
    Y.FINAL.ARRAY=''
    END.TO.DATE = TODAY

    LOCATE "START.DATE" IN ENQ.SELECTION<2,1> SETTING ST.DT.POS THEN
        ST.RG.DATE = ENQ.SELECTION<4,ST.DT.POS>
    END

    LOCATE "END.DATE" IN ENQ.SELECTION<2,1> SETTING END.DT.POS THEN
        END.RG.DATE = ENQ.SELECTION<4,END.DT.POS>
    END
    LOCATE "TRANS.PERIOD" IN ENQ.SELECTION<2,1> SETTING END.DT.POS THEN
        CR.DB.FLG = ENQ.SELECTION<4,END.DT.POS>
    END

    LOCATE "ACCT.NUM" IN ENQ.SELECTION<2,1> SETTING ACCT.NUM.POS THEN
        ACCT.ID = ENQ.SELECTION<4,ACCT.NUM.POS>
    END


    CR.DB.FLG = 'Debitos'
    BEGIN CASE
        CASE CR.DB.FLG EQ 'Todos'
            CR.ALL.FLG =1
        CASE CR.DB.FLG EQ 'Debitos'
            DB.FLG = 1
        CASE CR.DB.FLG EQ 'Creditos'
            CR.FLG = 1
    END CASE



RETURN
************************
ARCIB.PARAM.TRAN.DETAILS:
************************

    LOCATE 'STANDING.ORDER' IN AI.PARAM.PROD<1,1> SETTING AI.PARAM.PROD.POS THEN
        LOCATE 'OWN-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            OWN.PAYMENT.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>

        END
        LOCATE 'APAP-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            APAP.PAYMENT.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END

        LOCATE 'THIRD-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            OTHER.PAYMENT.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END

        LOCATE 'DIRECT.DEBIT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            DIRECT.DEBIT.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END


        LOCATE 'THIRDPARTY-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            THIRDPARTY.PAYMENT.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END
        LOCATE 'SERVICE-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            SERVICE.PAYMENT.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END

        LOCATE 'OWN-CARD-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            OWN.CARD.PAYMENT = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END

        LOCATE 'APAP-CARD-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            APAP.CARD.PAYMENT = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END

        LOCATE 'OTHER-CARD-PAYMENT' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            OTHER.CARD.PAYMENT = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END


    END

RETURN

*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------
*PACS00125978-S


    IF ST.RG.DATE AND END.RG.DATE AND CR.DB.FLG AND ACCT.ID THEN
        D.FIELDS<1> = 'ACCOUNT'
        D.FIELDS<2> = 'BOOKING.DATE'
        D.LOGICAL.OPERANDS = 1:@FM:2
        D.RANGE.AND.VALUE<1> = ACCT.ID
        D.RANGE.AND.VALUE<2> = ST.RG.DATE:@VM:END.RG.DATE
        CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
        Y.TRANS.ID = FIELD(Y.ID.LIST,'*',2)
    END

    IF NOT(Y.TRANS.ID) THEN
        Y.ID.LIST = ''
    END

    IF ST.RG.DATE GT END.RG.DATE THEN
        Y.ID.LIST = ''
    END

    Y.CNT = 1
    Y.TOTAL.ID.LIST  = DCOUNT(Y.ID.LIST,@FM)
    LOOP
    WHILE Y.TOTAL.ID.LIST GE Y.CNT
        STMT.ARR.ID = Y.ID.LIST<Y.TOTAL.ID.LIST>
        Y.TRAN.REF.ID = FIELD(STMT.ARR.ID,'*',2)
        CALL F.READ(FN.STMT.ENTRY,Y.TRAN.REF.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
        Y.FT.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
        Y.FT.REF = FIELD(Y.FT.REF,'\',1)
        CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.REF,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
        Y.TXN.CODE =  R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
        IF NOT(Y.TXN.CODE) THEN
            CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.FT.REF,R.FUNDS.TRANSFER.HIS,FUNDS.TRANSFER.HIS.ERR)
            Y.TXN.CODE = R.FUNDS.TRANSFER.HIS<FT.TRANSACTION.TYPE>
        END
        GOSUB ENQUIRY.NAME.CHECK
        Y.TOTAL.ID.LIST -= 1
    REPEAT
RETURN
******************
ENQUIRY.NAME.CHECK:
*******************
    IF ENQ.SELECTION<1> EQ 'AI.REDO.STMT.ALL.LIST.MYPMT' THEN

        IF Y.TXN.CODE EQ OWN.PAYMENT.CODE OR Y.TXN.CODE EQ DIRECT.DEBIT.CODE THEN
            GOSUB DEBIT.CREDIT.PARA
        END

        IF Y.TXN.CODE EQ OWN.CARD.PAYMENT THEN
            GOSUB DEBIT.CREDIT.PARA
        END
    END

    IF ENQ.SELECTION<1> EQ 'AI.REDO.STMT.ALL.LIST.APAPPMT' THEN
        IF Y.TXN.CODE EQ APAP.PAYMENT.CODE THEN
            GOSUB DEBIT.CREDIT.PARA
        END
        IF Y.TXN.CODE EQ APAP.CARD.PAYMENT THEN
            GOSUB DEBIT.CREDIT.PARA
        END
    END

    IF ENQ.SELECTION<1> EQ 'AI.REDO.STMT.ALL.LIST.OTHERPMT' THEN
        IF Y.TXN.CODE EQ OTHER.PAYMENT.CODE THEN
            GOSUB DEBIT.CREDIT.PARA
        END
        IF Y.TXN.CODE EQ OTHER.CARD.PAYMENT THEN
            GOSUB DEBIT.CREDIT.PARA
        END
    END

    IF ENQ.SELECTION<1> EQ 'AI.REDO.STMT.ALL.LIST.THIRDPMT' THEN
        IF Y.TXN.CODE EQ THIRDPARTY.PAYMENT.CODE THEN
            GOSUB DEBIT.CREDIT.PARA
        END
    END

    IF ENQ.SELECTION<1> EQ 'AI.REDO.STMT.ALL.LIST.SERVPMT' THEN
        IF Y.TXN.CODE EQ SERVICE.PAYMENT.CODE THEN
            GOSUB DEBIT.CREDIT.PARA
        END
    END

RETURN
******************
DEBIT.CREDIT.PARA:
******************
    AMT.TO.CHECK = FIELD(STMT.ARR.ID,'*',6)
    IF AMT.TO.CHECK LT '0' AND DB.FLG EQ '1' THEN
        Y.FINAL.ARRAY<-1>= STMT.ARR.ID
    END
    IF AMT.TO.CHECK GT '0' AND CR.FLG EQ '1' THEN
        Y.FINAL.ARRAY<-1> = STMT.ARR.ID
    END
    IF NOT (CR.FLG) AND NOT(DB.FLG) AND CR.ALL.FLG EQ '1' THEN
        Y.FINAL.ARRAY<-1>  =STMT.ARR.ID
    END
RETURN
**************
GET.CALL.DATE:
****************
    CALL CALENDAR.DAY(END.TO.DATE,SIGN,START.FRM.DATE)
RETURN

*PACS00125978-E
********************
CHECK.MORE.THAN.180:
*******************


    IF ST.RG.DATE AND END.RG.DATE THEN
        REGION=''
        START.DATE=ST.RG.DATE
        END.DATE=END.RG.DATE
        DAYS='C'
        CALL CDD(REGION,START.DATE,END.DATE,DAYS)
    END
    IF DAYS GT 180 THEN
        ENQ.ERROR = "EB-ENTER.MONTHS.PAERIOD"
    END

RETURN
END
