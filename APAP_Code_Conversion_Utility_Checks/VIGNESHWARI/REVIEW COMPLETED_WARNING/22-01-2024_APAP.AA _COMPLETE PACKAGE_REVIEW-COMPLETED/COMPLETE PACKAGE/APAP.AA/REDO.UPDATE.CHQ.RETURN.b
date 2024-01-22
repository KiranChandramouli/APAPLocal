* @ValidationCode : MjoxMjk1OTM5MzU5OkNwMTI1MjoxNzA0NDQyMTI5NjkwOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:38:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     ++ to +=
*14-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   VARIABLE NAME MODIFIED
*---------------------------------------------------------------------------------------	-
$PACKAGE APAP.AA
SUBROUTINE REDO.UPDATE.CHQ.RETURN(ARR.ID)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.UPDATE.CHQ.RETURN
*--------------------------------------------------------------------------------------------------------
*Description       :Post Routine in ACTIVITY.API for APPLY.PAYMENT Activity

*Linked With       : Post Routine in ACTIVITY.API for APPLY.PAYMENT Activity
*In  Parameter     : ARR.ID
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 09 DEC 2010        SRIRAMAN.C              ODR-2009-10-1678              Initial Creation
*05-01-2024      VIGNESHWARI S   R23 Manual Code Conversion        CHANGED "F.READ" TO "F.READU"

*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_AA.LOCAL.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_F.REDO.LOAN.CHQ.RETURN
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

RETURN

*************
PROCESS.PARA:
*************

* This is the main processing para

DEBIT.AMOUNT.VAL = R.NEW(FT.DEBIT.AMOUNT)
CHEQUE.NO = R.NEW(FT.CHEQUE.NUMBER)
CHQ.RET.DATE = TODAY
CHEQUE.STATUS.VAL = 'RETAINED'
TRANSACTION.REF.VAL = ID.NEW

*CALL F.READ(FN.REDO.LOAN.CHQ.RETURN,ARR.ID,R.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN,RETURN.ERR)        ;*Get the record if available
CALL F.READU(FN.REDO.LOAN.CHQ.RETURN,ARR.ID,R.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN,RETURN.ERR,'')        ;*Get the record if available;* R22 AUTO CONVERSION

IF (RETURN.ERR) THEN

* R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TRANSACTION.REF> = TRANSACTION.REF.VAL
* R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.NO> = CHEQUE.NO
R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.REF> = CHEQUE.NO ;*R22 MANUAL CONVERSION
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.AMT> = DEBIT.AMOUNT.VAL
R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.REV.RET.AMT> = DEBIT.AMOUNT.VAL ;*R22 MANUAL CONVERSION
* R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.DT> = CHQ.RET.DATE
R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.RET.DATE> = CHQ.RET.DATE ;*R22 MANUAL CONVERSION
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.STATUS> = CHEQUE.STATUS.VAL
R.REDO.LOAN.CHQ.RETURN< LN.CQ.RET.STATUS> = CHEQUE.STATUS.VAL ;*R22 MANUAL CONVERSION

CHEQUE.RET.CTR =  1       ;* Increment the cheque return counter by 1 if it is already available
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.CTR> = CHEQUE.RET.CTR

*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RETAIN> = '12'  ;*Parameterize the Cheque retain to 12
* R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.MAX.RET.CHEQUES> = '3' ;*Parameterize the Max. Retrun Cheque to 3
R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ> = '3' ;*R22 MANUAL CONVERSION

END ELSE

* R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TRANSACTION.REF,-1> = TRANSACTION.REF.VAL
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.NO,-1> = CHEQUE.NO
R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.REF,-1> = CHEQUE.NO ;*R22 MANUAL CONVERSION
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.AMT,-1> = DEBIT.AMOUNT.VAL
R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.REV.RET.AMT> = DEBIT.AMOUNT.VAL ;*R22 MANUAL CONVERSION
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.DT,-1> = CHQ.RET.DATE
R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.RET.DATE,-1> = CHQ.RET.DATE ;*R22 MANUAL CONVERSION
*R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.STATUS,-1> = CHEQUE.STATUS.VAL
R.REDO.LOAN.CHQ.RETURN< LN.CQ.RET.STATUS,-1> = CHEQUE.STATUS.VAL ;*R22 MANUAL CONVERSION


* CHEQUE.RET.CTR = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.CTR>
CHEQUE.RET.CTR += 1 ;* Increment the cheque return counter by 1 if it is already available

* R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.RET.CTR> = CHEQUE.RET.CTR


END

CALL F.WRITE(FN.REDO.LOAN.CHQ.RETURN,ARR.ID,R.REDO.LOAN.CHQ.RETURN) ;*Write the record


RETURN
*************************************************
END
* END OF PROGRAM
