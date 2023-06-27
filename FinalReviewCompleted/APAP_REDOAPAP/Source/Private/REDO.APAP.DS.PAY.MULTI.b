* @ValidationCode : MjoxOTcxMzUyNDc6Q3AxMjUyOjE2ODQ4MzYwMzcwMjY6SVRTUzotMTotMTozODQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 384
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.DS.PAY.MULTI(Y.MULTI)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 16-SEP-2011         RIYAS      ODR-2011-07-0162     Initial Creation

*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   ++ to += , VM to @VM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT
    $INSERT I_F.PAYMENT.STOP.TYPE
    $INSERT I_F.REDO.STOP.DESCRIPTION
    GOSUB INITIALSE
    GOSUB CHECK.NOTES

RETURN
*-------------------------------------------------------------------------
INITIALSE:
*~~~~~~~~~
    FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT.STOP.ACCOUNT = ''
    CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)

    FN.REDO.STOP.DESCRIPTION = 'F.REDO.STOP.DESCRIPTION'
    F.REDO.STOP.DESCRIPTION = ''
    CALL OPF(FN.REDO.STOP.DESCRIPTION,F.REDO.STOP.DESCRIPTION)

    FN.PAYMENT.STOP.TYPE = 'F.PAYMENT.STOP.TYPE'
    F.PAYMENT.STOP.TYPE  = ''
    CALL OPF(FN.PAYMENT.STOP.TYPE,F.PAYMENT.STOP.TYPE)


RETURN
*-------------------------------------------------------------------------
CHECK.NOTES:
*~~~~~~~~~~~
    Y.REASON = R.NEW(REDO.PS.ACCT.PAY.REASON)
    T.TOT.REASON = DCOUNT(Y.REASON,@VM)
    Y.INT = 1
    LOOP
    WHILE Y.INT LE T.TOT.REASON
        Y.LINE = '-----------------------------------------------------------'
        Y.ID1 = "SYSTEM"
        CALL CACHE.READ(FN.REDO.STOP.DESCRIPTION,Y.ID1,R.REDO.STOP.DESCRIPTION,F.ERR)
        Y.HEADER1 = R.REDO.STOP.DESCRIPTION<REDO.STOP.HEADER1>
        Y.FIRST.CHEQUE = R.REDO.STOP.DESCRIPTION<REDO.STOP.FIRST.CHQ>
        Y.LAST.CHEQUE =  R.REDO.STOP.DESCRIPTION<REDO.STOP.LAST.CHQ>
        Y.QTY.CHEQUE = R.REDO.STOP.DESCRIPTION<REDO.STOP.QTY.CHQ>
        Y.DESC.CHQ.AMOUNT = R.REDO.STOP.DESCRIPTION<REDO.STOP.CHQ.AMT>
        Y.FMT.CHQ.AMOUNT = R.NEW(REDO.PS.ACCT.AMT.FROM)<1,Y.INT>
        Y.CHQ.AMOUNT = TRIMB(FMT(Y.FMT.CHQ.AMOUNT,'L2,#19'))
        Y.DESC.PAY.REASON = R.REDO.STOP.DESCRIPTION<REDO.STOP.PAY.REASON>
        Y.ID.REASON = R.NEW(REDO.PS.ACCT.PAY.REASON)<1,Y.INT>
        CALL F.READ(FN.PAYMENT.STOP.TYPE,Y.ID.REASON,R.PAYMENT.STOP.TYPE,F.PAYMENT.STOP.TYPE1,Y.ACC.ERR)
        Y.PAY.REASON = R.PAYMENT.STOP.TYPE<AC.PAT.DESCRIPTION,2>
        IF NOT(Y.PAY.REASON) THEN
            Y.PAY.REASON = R.PAYMENT.STOP.TYPE<AC.PAT.DESCRIPTION,1>
        END
        Y.DESC.CHARGE.AMOUNT = R.REDO.STOP.DESCRIPTION<REDO.STOP.CHARGE.AMT>
        Y.FMT.CHARGE.AMT = R.NEW(REDO.PS.ACCT.CHARGE.AMOUNT)<1,Y.INT>
        Y.CHARGE.AMOUNT = TRIMB(FMT(Y.FMT.CHARGE.AMT,'L2,#19'))
        Y.STOP.BENF = R.REDO.STOP.DESCRIPTION<REDO.STOP.BENIFY>
        Y.FIRST.CHEQUE =  Y.FIRST.CHEQUE:'      :':R.NEW(REDO.PS.ACCT.CHEQUE.FIRST)<1,Y.INT>
        Y.LAST.CHEQUE = Y.LAST.CHEQUE:'      :':R.NEW(REDO.PS.ACCT.CHEQUE.LAST)<1,Y.INT>
        Y.QTY.CHEQUE = Y.QTY.CHEQUE:'          :':R.NEW(REDO.PS.ACCT.NO.OF.LEAVES)<1,Y.INT>
        Y.CHQ.AMOUNT = Y.DESC.CHQ.AMOUNT:'          :':Y.CHQ.AMOUNT
        Y.PAY.REASON = Y.DESC.PAY.REASON:'      :':Y.PAY.REASON
        Y.CHARGE.AMOUNT = Y.DESC.CHARGE.AMOUNT:'      :':Y.CHARGE.AMOUNT
        Y.STOP.BENF = Y.STOP.BENF:'   :':R.NEW(REDO.PS.ACCT.BENIFICIARY)<1,Y.INT>
        Y.TOTAL = Y.LINE:@VM:Y.HEADER1:@VM:Y.FIRST.CHEQUE:@VM:Y.LAST.CHEQUE:@VM:Y.QTY.CHEQUE:@VM:Y.CHQ.AMOUNT:@VM:Y.PAY.REASON:@VM:Y.CHARGE.AMOUNT:@VM:Y.STOP.BENF
        IF Y.MULTI THEN
            Y.MULTI<1,-1> = Y.TOTAL
        END ELSE
            Y.MULTI = Y.TOTAL
        END
        Y.INT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
    Y.HEADER2='Uso Interno APAP'
    Y.CUS.SIGNATURE = R.REDO.STOP.DESCRIPTION<REDO.STOP.CUS.SIGN>:'             :'
    Y.STOP.REQUES = R.REDO.STOP.DESCRIPTION<REDO.STOP.REQUESTOR>:'            :'
    Y.AUT.SIGNATURE = R.REDO.STOP.DESCRIPTION<REDO.STOP.AUT.SIGN>:'          :'
    Y.MULTI := @VM:Y.LINE:@VM:Y.CUS.SIGNATURE:@VM:Y.LINE:@VM:Y.HEADER2:@VM:Y.STOP.REQUES:@VM:Y.AUT.SIGNATURE


RETURN
*-------------------------------------------------------------------------
END
