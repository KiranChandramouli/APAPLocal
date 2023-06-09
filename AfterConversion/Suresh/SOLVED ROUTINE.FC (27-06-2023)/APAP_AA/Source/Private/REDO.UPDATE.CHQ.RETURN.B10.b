* @ValidationCode : Mjo4MDYwMTY1OTY6Q3AxMjUyOjE2ODc4NDM4MzE0ODc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Jun 2023 11:00:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.UPDATE.CHQ.RETURN.B10(ARR.ID,Y.FT.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.UPDATE.CHQ.RETURN.B10
*--------------------------------------------------------------------------------------------------------
*Description       :

*In  Parameter     : ARR.ID
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 17 OCT 2011        MARIMUTHU S              PACS00146454             Initial Creation
*
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*26/06/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION       VM TO @VM, SM TO @SM
*26/06/2023      SURESH                     MANUAL R22 CODE CONVERSION     VARIABLE NAME MODIFIED,CALL routine format modified
*----------------------------------------------------------------------------------------
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.LOAN.CHQ.RETURN
    $INSERT I_F.REDO.LOAN.FT.TT.TXN
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB INIT
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
************
INIT:
*************


    FN.REDO.LOAN.CHQ.RETURN  = 'F.REDO.LOAN.CHQ.RETURN'
    F.REDO.LOAN.CHQ.RETURN = ''
    CALL OPF(FN.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN)

    FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
    F.REDO.LOAN.FT.TT.TXN = ''
    CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM = ''

    APPL = 'FUNDS.TRANSFER'
    F.POS = ''
    F.FIELDS = 'CERT.CHEQUE.NO'
    CALL MULTI.GET.LOC.REF(APPL,F.FIELDS,F.POS)

    Y.CHQ.POS = F.POS<1,1>

RETURN

*************
PROCESS.PARA:
*************

* This is the main processing para

    DEBIT.AMOUNT.VAL = R.NEW(FT.DEBIT.AMOUNT)
    IF DEBIT.AMOUNT.VAL EQ '' THEN
        DEBIT.AMOUNT.VAL = R.NEW(FT.CREDIT.AMOUNT)
    END
    CHEQUE.NO = R.NEW(FT.LOCAL.REF)<1,Y.CHQ.POS>
    CHEQUE.NO = CHANGE(CHEQUE.NO,@SM,@VM)
    Y.CNT.FL = DCOUNT(CHEQUE.NO,@VM)
    CHQ.RET.DATE = TODAY
    CHEQUE.STATUS.VAL = 'REVERSADO'
    TRANSACTION.REF.VAL = ID.NEW

    CNTR = ''
    CALL F.READ(FN.REDO.LOAN.CHQ.RETURN,ARR.ID,R.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN,RETURN.ERR)        ;*Get the record if available

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,CLR.PAR.ERR)

    CALL F.READ(FN.REDO.LOAN.FT.TT.TXN,Y.FT.ID,R.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN,LOAN.ERR)
*Y.CHEQS = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.NO>
    Y.CHEQS=""
    Y.SET = 1

    IF NOT(R.REDO.LOAN.CHQ.RETURN) THEN
        GOSUB PROCESS.NEW.REC
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RETAIN> = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CHEQUE.RETAIN>      ;*Parameterize the Cheque retain to 12
        R.REDO.LOAN.CHQ.RETURN=""
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.MAX.RET.CHEQUES> = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.MAX.RET.CHEQUES>  ;*Parameterize the Max. Retrun Cheque to 3
        R.REDO.LOAN.CHQ.RETURN=""
    END ELSE
        GOSUB PROCESS.OLD.REC
    END
    CON.DATE = OCONV(DATE(),"D-")
    DATE.TIME = CON.DATE[9,2]:CON.DATE[1,2]:CON.DATE[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.DATE.TIME> = DATE.TIME
    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CO.CODE> = ID.COMPANY
    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CURR.NO> = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CURR.NO> + 1

    CALL F.WRITE(FN.REDO.LOAN.CHQ.RETURN,ARR.ID,R.REDO.LOAN.CHQ.RETURN) ;*Write the record

*IF R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.CTR> EQ 3 THEN
    R.REDO.LOAN.CHQ.RETURN=""
*  CALL REDO.AA.UPDATE.OVERDUE.STATUS(ARR.ID)
    CALL APAP.AA.redoAaUpdateOverdueStatus(ARR.ID)
*END

RETURN

PROCESS.NEW.REC:

    LOOP
    WHILE Y.CNT.FL GT 0 DO
        FLG += 1
        Y.CQ.NO = CHEQUE.NO<1,FLG>
        LOCATE Y.CQ.NO IN Y.CHEQS<1,1> SETTING POS.AA THEN
*            Y.CQ.ST = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.STATUS,FLG> ;*R22 MANUAL CODE CONVERSION
*            IF Y.CQ.ST EQ 'RETURN' AND Y.SET EQ 1 THEN
            X.SET = 1 ; Y.SET = ''
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TRANSACTION.REF> = TRANSACTION.REF.VAL ;*R22 MANUAL CODE CONVERSION - START
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.NO> = Y.CQ.NO
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.AMT> = DEBIT.AMOUNT.VAL
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.DT> = CHQ.RET.DATE
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.STATUS> = CHEQUE.STATUS.VAL
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.CTR> += 1
*            END
*           IF Y.CQ.ST EQ 'RETURN' AND X.SET NE 1 THEN
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TRANSACTION.REF,-1> = TRANSACTION.REF.VAL
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.NO,-1> = Y.CQ.NO
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.AMT,-1> = DEBIT.AMOUNT.VAL
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.DT,-1> = CHQ.RET.DATE
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.STATUS,-1> = CHEQUE.STATUS.VAL
*                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.CTR> += CNTR + 1 ;*R22 MANUAL CODE CONVERSION- END
*       END
            X.SET += 1
        END
        Y.CNT.FL -= 1
    REPEAT

RETURN

PROCESS.OLD.REC:

    LOOP
    WHILE Y.CNT.FL GT 0 DO
        FLG += 1
        Y.CQ.NO = CHEQUE.NO<1,FLG>
        LOCATE Y.CQ.NO IN Y.CHEQS<1,1> SETTING POS.AA THEN
*               Y.CQ.ST = R.REDO.LOAN.FT.TT.TXN<LN.FT.TT.CHEQUE.STATUS,FLG> ;*R22 MANUAL CODE CONVERSION - START
*          IF Y.CQ.ST EQ 'RETURN' THEN
*                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TRANSACTION.REF,-1> = TRANSACTION.REF.VAL
*                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.NO,-1> = Y.CQ.NO
*                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.AMT,-1> = DEBIT.AMOUNT.VAL
*                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.DT,-1> = CHQ.RET.DATE
*                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.STATUS,-1> = CHEQUE.STATUS.VAL
*                    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.CTR> = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.CTR> + 1
*           END ;*R22 MANUAL CODE CONVERSION - ;*R22 MANUAL CODE CONVERSION- END
        END
        Y.CNT.FL -= 1
    REPEAT

RETURN

*************************************************
END
*END OF PROGRAM
