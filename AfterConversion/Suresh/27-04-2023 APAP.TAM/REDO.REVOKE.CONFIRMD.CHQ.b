* @ValidationCode : Mjo2NzU5Mzc4NjQ6Q3AxMjUyOjE2ODI0OTcxNjQ0ODE6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 13:49:24
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.REVOKE.CONFIRMD.CHQ
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This service is used to REVOKE all the cheques of STOP.PAYMENT.STATUS EQ
* CONFIRMED into NONE, if the time given in EXPIRY.TIME greater than
* equal to SYSTEM.TIME
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*-----------------------------------------------------------------------------
*   Date               who           Reference            Description
* 25-Nov-2009       SHANKAR RAJU                            Initial Creation
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, = START.COUNT + TO +=, = COUNT.MOD.CHQ + TO +=, = FIRST.CHEQUE + TO  +=, = Y.FIRST.CHEQ.STOP + TO +=, Y.CS.CNT + TO +=
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - CALL routine format modified
*
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.DATES
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT
    $INSERT I_F.REDO.CHEQUE.STOP.PARA

*------------------------------MAIN-------------------------------------------
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

INIT:


    FN.PAYSTOP='F.PAYMENT.STOP'
    F.PAYSTOP=''
    LREF.APPLN="PAYMENT.STOP"
    FN.REDO.CHEQUE.STOP.PARA ='F.REDO.CHEQUE.STOP.PARA'
    F.REDO.CHEQUE.STOP.PARA = ''
    LREF.FLDS="L.PS.STP.PMT.ST":@VM:"L.PS.EXP.DATE":@VM:"L.PS.STOP.TIME"
    LREF.POS=''
    FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT.STOP.ACCOUNT = ''
    Y.CHQ.FLAG = ''
RETURN
*-----------------------------------------------------------------------------
OPENFILE:

    CALL OPF(FN.PAYSTOP,F.PAYSTOP)
    CALL OPF(FN.REDO.CHEQUE.STOP.PARA,F.REDO.CHEQUE.STOP.PARA)
    CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)
RETURN
*-----------------------------------------------------------------------------

UPDT.FLDS:
*-----------------------------------------------------------------------------

    APP.NAME = 'PAYMENT.STOP'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'PAYMENT.STOP,UPDATE'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = Y.ACCT.ID
    OFSRECORD = ''
    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'PAYMENT.STOP.UPDATE'
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.PAYSTOP,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
*-----------------------------------------------------------------------------
CHEQUE.FIND:
*-----------

    ALL.EXPIRY.DATE=R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXPIRY.DATE>
    COUNT.EXP.DATE = DCOUNT(ALL.EXPIRY.DATE,@VM)

    START.COUNT = 1

    LOOP
    WHILE START.COUNT LE COUNT.EXP.DATE
        IF R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.PAY.STOP.STATUS,START.COUNT> EQ 'CONFIRMED' THEN

            EXPIRY.DATE=R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXPIRY.DATE,START.COUNT>
            STOP.TIME=R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXP.TIME,START.COUNT>
            TIME.NOW=OCONV(TIME(),"MT")
            FIRST.CHEQUE   = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CHEQUE.FIRST,START.COUNT>
            Y.NO.OF.LEAVES = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.NO.OF.LEAVES,START.COUNT>
            Y.CHQ.TYPE     = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CHEQUE.TYPE,START.COUNT>

*            IF EXPIRY.DATE NE '' AND TODAY EQ EXPIRY.DATE THEN
            IF EXPIRY.DATE NE '' AND TODAY EQ EXPIRY.DATE THEN
                GOSUB EQ.EXP.DATE
            END ELSE
                IF EXPIRY.DATE NE '' AND TODAY GT EXPIRY.DATE THEN
*                IF EXPIRY.DATE AND EXPIRY.DATE LT Y.NEXT.WRKN AND EXPIRY.DATE GT TODAY THEN
                    GOSUB GT.EXP.DATE
                END
            END

        END
        START.COUNT += 1                  ;** R22 Auto conversion - = START.COUNT + TO +=
    REPEAT


RETURN
*-----------------------------------------------------------------------------
EQ.EXP.DATE:

    IF TIME.NOW GE STOP.TIME THEN
        R.PAYSTOP<AC.PAY.CUSTOMER.NO>                   =  R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CUSTOMER>
        R.PAYSTOP<AC.PAY.CURRENCY>                      =  R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CURRENCY>
        COUNT.MOD.CHQ = 1
        LOOP
        WHILE COUNT.MOD.CHQ LE Y.NO.OF.LEAVES

            R.PAYSTOP<AC.PAY.MOD.PS.CHQ.NO,COUNT.MOD.CHQ> = FIRST.CHEQUE
            R.PAYSTOP<AC.PAY.MOD.CHQ.TYPE,COUNT.MOD.CHQ> = Y.CHQ.TYPE
            R.PAYSTOP<AC.PAY.MOD.PS.DATE,COUNT.MOD.CHQ> = TODAY
            COUNT.MOD.CHQ += 1                ;** R22 Auto conversion -  = COUNT.MOD.CHQ + TO +=
            FIRST.CHEQUE += 1                 ;** R22 Auto conversion - = FIRST.CHEQUE + TO  +=
        REPEAT
        R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,START.COUNT> = 'NONE'

        R.PAYSTOP<AC.PAY.LOCAL.REF,POS.EXPIRY.DATE,START.COUNT> = ''
        R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOP.TIME,START.COUNT> = ''
        Y.CHQ.FLAG = '1'
        R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.PAY.STOP.STATUS,START.COUNT> = 'NONE'
        R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXPIRY.DATE,START.COUNT> = TODAY
    END
RETURN
*-----------------------------------------------------------------------------
GT.EXP.DATE:

    R.PAYSTOP<AC.PAY.CUSTOMER.NO>                   =  R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CUSTOMER>
    R.PAYSTOP<AC.PAY.CURRENCY>                      =  R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CURRENCY>
    COUNT.MOD.CHQ = 1
    LOOP
    WHILE COUNT.MOD.CHQ LE Y.NO.OF.LEAVES
        R.PAYSTOP<AC.PAY.MOD.PS.CHQ.NO,COUNT.MOD.CHQ> = FIRST.CHEQUE
        R.PAYSTOP<AC.PAY.MOD.CHQ.TYPE,COUNT.MOD.CHQ> = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CHEQUE.TYPE,COUNT.MOD.CHQ>
        R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,START.COUNT> = 'NONE'
        R.PAYSTOP<AC.PAY.MOD.PS.DATE,COUNT.MOD.CHQ> = TODAY
        COUNT.MOD.CHQ += 1           ;** R22 Auto conversion -  = COUNT.MOD.CHQ + TO +=
        FIRST.CHEQUE += 1          ;** R22 Auto conversion - = FIRST.CHEQUE + TO  +=
    REPEAT

    R.PAYSTOP<AC.PAY.LOCAL.REF,POS.EXPIRY.DATE,START.COUNT> = ''
    R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOP.TIME,START.COUNT> = ''
    R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.PAY.STOP.STATUS,START.COUNT> = 'NONE'
    R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXPIRY.DATE,START.COUNT> = TODAY
    Y.CHQ.FLAG = '1'
RETURN
*-----------------------------------------------------------------------------
PROCESS:


    Y.NEXT.WRKN = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    CALL APAP.TAM.MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS) ;*MANUAL R22 CODE CONVERSION
    POS.STOPPAYMENT.STATUS=LREF.POS<1,1>
    POS.EXPIRY.DATE=LREF.POS<1,2>
    POS.STOP.TIME =LREF.POS<1,3>

    SEL.CMD="SELECT ":FN.REDO.PAYMENT.STOP.ACCOUNT : " WITH PAY.STOP.STATUS EQ 'CONFIRMED' AND EXPIRY.DATE LE ":TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR)

    LOOP

        TEMP.REC=''
        REMOVE Y.PS.ID FROM SEL.LIST SETTING POS
    WHILE Y.PS.ID:POS

        CALL F.READ(FN.REDO.PAYMENT.STOP.ACCOUNT,Y.PS.ID,R.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT,ERR.PS)

        IF R.REDO.PAYMENT.STOP.ACCOUNT THEN
            Y.ACCT.ID = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.ACCOUNT.NUMBER>
            GOSUB CHEQUE.FIND
        END

*        GOSUB UPDT.FLDS
        IF Y.CHQ.FLAG EQ '1' THEN
            GOSUB UPDT.FLDS
            GOSUB CHEQ.PARA.UPDATE
        END
        CALL F.WRITE(FN.REDO.PAYMENT.STOP.ACCOUNT,Y.PS.ID,R.REDO.PAYMENT.STOP.ACCOUNT)
    REPEAT

RETURN

*-----------------------------------------------------------------------
CHEQ.PARA.UPDATE:
*-----------------------------------------------------------------------

    Y.FRT.CHEQ.STOP = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CHEQUE.FIRST>
    Y.STATUS.CS = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.PAY.STOP.STATUS>
    Y.FIRST.CS.COUNT = DCOUNT(Y.FRT.CHEQ.STOP,@VM)
    Y.LST.CHEQ.STOP = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CHEQUE.LAST>
    Y.CS.CNT = 1
    LOOP
    WHILE Y.CS.CNT LE Y.FIRST.CS.COUNT
        Y.FIRST.CHEQ.STOP = Y.FRT.CHEQ.STOP<1,Y.CS.CNT>
        LOOP
        WHILE Y.FIRST.CHEQ.STOP LE Y.LST.CHEQ.STOP<1,Y.CS.CNT>
            Y.CHQ.STOP.PARA.ID = Y.ACCT.ID:"*":Y.FIRST.CHEQ.STOP
            IF Y.STATUS.CS<1,Y.CS.CNT> EQ 'NONE' THEN
                R.REDO.CHEQUE.STOP.PARA<CHQ.STOP.STATUS> = 'NONE'
                CALL F.WRITE(FN.REDO.CHEQUE.STOP.PARA,Y.CHQ.STOP.PARA.ID,R.REDO.CHEQUE.STOP.PARA)
                CALL F.DELETE(FN.REDO.CHEQUE.STOP.PARA,Y.CHQ.STOP.PARA.ID)

            END

            Y.FIRST.CHEQ.STOP += 1        ;** R22 Auto conversion - = Y.FIRST.CHEQ.STOP + TO +=
        REPEAT

        Y.CS.CNT += 1           ;** R22 Auto conversion - Y.CS.CNT + TO +=
    REPEAT
RETURN
END
*------------------------------------------------------------------------------
