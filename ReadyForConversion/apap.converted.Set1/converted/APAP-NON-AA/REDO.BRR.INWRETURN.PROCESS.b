SUBROUTINE REDO.BRR.INWRETURN.PROCESS(BUILD.LIST)

********************************************************************************************************
*-------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : NATCHIMUTHU
* Program Name  : REDO.BRR.INWRETURN.PROCESS
* ODR           : ODR-2010-09-0148
*------------------------------------------------------------------------------------------------------
* DESCRIPTION  : REDO.BRR.INWRETURN.PROCESS Multithreading routine responsible for generates
*                flat file with DIN,TASK CODE,TRANSACTION DATE,ACCOUNT NUMBER,CHEQUE NUMBER,ROUTE NO,
*                AMOUNT,CATEGORY,CR.AMT,CHQ.DIGIT,FILLER name obtained from file REDO.APAP.CLEARING.INWARD.
*--------------------------------------------------------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*-------------------------------------------------------------------------------------------------------------
* MODIFICATION HISTORY
*----------------------------------------------------------------------------------------------------------
*   DATE            ODR                      WHO                       DESCRIPTION
* 30-09-10          ODR-2010-09-0148         NATCHIMUTHU               Initial Creation
*------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.MAPPING.TABLE
    $INSERT I_REDO.BRR.INWRETURN.PROCESS.COMMON
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_F.REDO.REJECT.REASON


    Y.DIN  = ''
    Y.TASK = ''
    Y.TRANS.DATE = ''
    Y.ACCOUNT.NO = ''
    Y.CHEQUE.NO = ''
    Y.AMOUNT = ''
    Y.CATEGORY = ''
    Y.CR.AMT = ''
    Y.CHQ.DIGIT = ''
    Y.FILLE = ''
    Y.N = ''


    CALL F.READ(FN.REDO.CLEARING.PROCESS,'B143.PROCESS',R.REDO.CLEARING.PROCESS,F.REDO.CLEARING.PROCESS.ID,PARAM.ERR)
    IF PARAM.ERR EQ '' THEN
        CCY.FILE.NAME = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.RETURN.NAME>
        CCY.OUT.PATH = R.REDO.CLEARING.PROCESS<PRE.PROCESS.IN.RETURN.PATH>
    END

    REDO.APAP.CLEARING.INWARD.ID = BUILD.LIST

    CALL F.READ(FN.REDO.APAP.CLEARING.INWARD,REDO.APAP.CLEARING.INWARD.ID,R.REDO.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD,REDO.CLEAR.ERR)
*Y.ROUTE.NO     =    R.REDO.CLEARING.INWARD<CLEAR.CHQ.OTH.ROUTE.NO>
    Y.ROUTE.NO     =    FMT(R.REDO.CLEARING.INWARD<CLEAR.CHQ.BANK.CODE>,'9"0"R')
    Y.FILLER       =    R.REDO.CLEARING.INWARD<CLEAR.CHQ.TRANS.REFERENCE>

    CCY.TEMPORARY.FILE = "TEMP.":CCY.FILE.NAME:"1":".":Y.ROUTE.NO:".":AGENT.NUMBER

    Y.DIN          =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.DIN>
    Y.DIN          =   FMT(Y.DIN,'10"0"R')

*Y.TASK         =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.TASK.CLEARING>
    Y.TASK         =   '20'     ;* inward return is same as outward file : PACS00296304
    Y.TASK         =   FMT(Y.TASK,'2"0"R')

    Y.TRANS.DATE   =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.TRANS.DATE>
    Y.TRANS.DATE   =   Y.TRANS.DATE[7,2]:Y.TRANS.DATE[5,2]:Y.TRANS.DATE[1,4]
    Y.TRANS.DATE   =   FMT(Y.TRANS.DATE,'8"0"R')

    Y.LOTE         =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.LOTE>
    Y.LOTE         =   FMT(Y.LOTE,'10"0"R')

    Y.ACCOUNT.NO   =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.ACCOUNT.NO>
    Y.CUR.ACC.NO   =   Y.ACCOUNT.NO[1,3]

    IF NUM(Y.CUR.ACC.NO) THEN
        Y.ACCOUNT.NO   =   FMT(Y.ACCOUNT.NO,'11"0"R')
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        Y.ACCOUNT.NO = R.ACCOUNT<AC.ALT.ACCT.ID,1>
    END

    Y.CHEQUE.NO    =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.CHEQUE.NO>
    Y.CHEQUE.NO    =   FMT(Y.CHEQUE.NO,'10"0"R')

    Y.AMOUNT       =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.AMOUNT>
    VAR.AMT1       =   FIELD(Y.AMOUNT,'.',1)
    VAR.AMT2       =   FIELD(Y.AMOUNT,'.',2)
    IF NOT(VAR.AMT2) THEN
        VAR.AMT2   = '00'
    END
    VAR.TOT.AMT    =   VAR.AMT1:VAR.AMT2
    Y.AMOUNT       =   FMT(VAR.TOT.AMT,'R%15')


    Y.CATEGORY     =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.CATEGORY>
    Y.CATEGORY     =   FMT(Y.CATEGORY,'4"0"R')

    Y.CR.AMT       =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.CANT.CREDIT>
    Y.CR.AMT       =   FMT(Y.CR.AMT,'4"0"R')

*Y.DR.AMT       =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.CANT.DEBIT>
*Y.DR.AMT       =   FMT(Y.DR.AMT,'4"0"R')
    GOSUB GET.REASON.CODE
    Y.CHQ.DIGIT    =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.CHECK.DIGIT>
    Y.CHQ.DIGIT    =   FMT(Y.CHQ.DIGIT,'2"0"R')

    Y.FILLER       =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.TRANS.REFERENCE>
    Y.FILLER       =   FMT(Y.FILLER,'11"0"R')

    Y.IMG.REF      =   R.REDO.CLEARING.INWARD<CLEAR.CHQ.IMAGE.REFERENCE>
    Y.IMG.REF      =   FMT(Y.IMG.REF,'10"0"R'):'.TIF'

    Y.ACCOUNT.NO1   =     '00000000000'
    Y.CR.AMT1       =     '0000'
    Y.CHQ.DIGIT1    =     '00'
    Y.FILLER1       =     '00000000000'
    Y.CATEGORY1     =     '0303'
    Y.CHEQUE.NO1    =     '0000000000'
    Y.CHQ.DIGIT1    =     '00'

*Y.HEADER =  Y.DIN:",":Y.TASK:Y.TRANS.DATE:Y.ACCOUNT.NO1:Y.CHEQUE.NO:Y.ROUTE.NO:Y.AMOUNT:Y.CATEGORY1:Y.CR.AMT1:Y.CHQ.DIGIT1:Y.FILLER1
*Y.HEADER =  Y.TASK:Y.TRANS.DATE:Y.LOTE:Y.DIN:Y.ACCOUNT.NO1:Y.CHEQUE.NO1:Y.ROUTE.NO:Y.AMOUNT:Y.CATEGORY1:Y.CR.AMT:Y.DR.AMT:Y.FILLER1:Y.CHQ.DIGIT1:Y.IMG.REF

    Y.FINAL.ARRAY = ''
    Y.N1='    '
*------------------------------------------------------------------------------------------------------------------------------------------
    OPEN.ERR = ''
    OPENSEQ CCY.OUT.PATH,CCY.TEMPORARY.FILE TO FILE.PTR ELSE
        CREATE FILE.PTR ELSE
            OPEN.ERR = 'Unable to Open / Create ':CCY.TEMPORARY.FILE
        END
    END

    IF OPEN.ERR EQ '' THEN

        Y.FINAL.ARRAY<-1> = Y.TASK:Y.TRANS.DATE:Y.LOTE:Y.DIN:Y.ACCOUNT.NO:Y.CHEQUE.NO:Y.ROUTE.NO:Y.AMOUNT:Y.CATEGORY:Y.CR.AMT:Y.DR.AMT:Y.FILLER:Y.CHQ.DIGIT:Y.IMG.REF
        WRITESEQ Y.FINAL.ARRAY APPEND TO FILE.PTR ELSE
            WRITE.ERR = 'Unable to Write ':CCY.OUT.PATH:" ":CCY.TEMPORARY.FILE
        END
    END
RETURN

*-----------------------------------------------------------------------------------------------------------
GET.REASON.CODE:
*-----------------------------------------------------------------------------------------------------------
    Y.REJECT.REASON = R.REDO.CLEARING.INWARD<CLEAR.CHQ.REASON,1>        ;* There can only only reason for rejection.
    CALL F.READ(FN.REDO.REJECT.REASON,Y.REJECT.REASON,R.REDO.REJECT.REASON,F.REDO.REJECT.REASON,REJ.ERR)

    Y.DR.AMT = R.REDO.REJECT.REASON<REDO.REJ.RETURN.CODE>
    Y.DR.AMT = FMT(Y.DR.AMT,'4"0"R')

RETURN
END
*-----------------------------------------------------------------------------------------------------------------------------------------------
* PROGRAM END
*------------------------------------------------------------------------------------------------------------------------------------------
