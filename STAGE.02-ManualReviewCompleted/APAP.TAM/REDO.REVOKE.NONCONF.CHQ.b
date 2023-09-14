* @ValidationCode : MjotMTg2NTAwNTQ1MzpDcDEyNTI6MTY4MTA1NjQ4NTg3OTpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.REVOKE.NONCONF.CHQ
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This service is used to REVOKE all the cheques of STOP.PAYMENT.STATUS EQ
* NONCONFIRMED into NONE, if the time given in EXPIRY.TIME greater than
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
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - = START.COUNT + TO +=, = COUNT.MOD.CHQ + TO +=, = FIRST.CHEQUE + TO  +=, = Y.FIRST.CHEQ.STOP + TO +=, Y.CS.CNT + TO +=, VM TO @VM
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.DATES
    $INSERT I_TSS.COMMON
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
    FN.REDO.CHEQUE.STOP.PARA = 'F.REDO.CHEQUE.STOP.PARA'
    F.REDO.CHEQUE.STOP.PARA = ''
    FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
    F.REDO.PAYMENT.STOP.ACCOUNT = ''
    LREF.APPLN="PAYMENT.STOP"
    LREF.FLDS="L.PS.STP.PMT.ST":@VM:"L.PS.EXP.DATE":@VM:"L.PS.STOP.TIME"
    LREF.POS='' ; R.PAYSTOP = ''
    Y.CHQ.FLAG = ''
RETURN
*-----------------------------------------------------------------------------
OPENFILE:

    CALL OPF(FN.PAYSTOP,F.PAYSTOP)
    CALL OPF(FN.REDO.CHEQUE.STOP.PARA,F.REDO.CHEQUE.STOP.PARA)
    CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)
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

            Y.FIRST.CHEQ.STOP += 1               ;** R22 Auto conversion - = Y.FIRST.CHEQ.STOP + TO +=
        REPEAT

        Y.CS.CNT += 1                        ;** R22 Auto conversion - = Y.CS.CNT + TO +=
    REPEAT
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

        EXPIRY.DATE=R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXPIRY.DATE,START.COUNT>
        STOP.TIME=R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXP.TIME,START.COUNT>
        TIME.NOW=OCONV(TIME(),"MT")
        FIRST.CHEQUE   = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CHEQUE.FIRST,START.COUNT>
        Y.NO.OF.LEAVES = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.NO.OF.LEAVES,START.COUNT>
        Y.CHQ.TYPE     = R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CHEQUE.TYPE,START.COUNT>

        IF EXPIRY.DATE NE '' AND TODAY EQ EXPIRY.DATE THEN
            GOSUB EQ.EXP.DATE
        END ELSE
            IF EXPIRY.DATE NE '' AND TODAY GT EXPIRY.DATE THEN
*            IF EXPIRY.DATE AND EXPIRY.DATE LT Y.NEXT.WRKN AND EXPIRY.DATE GT TODAY THEN
                GOSUB GT.EXP.DATE
            END
        END

        START.COUNT += 1      ;** R22 Auto conversion -  = START.COUNT + TO +=

    REPEAT

RETURN
*------------------------------------
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
            COUNT.MOD.CHQ += 1             ;** R22 Auto conversion -  = COUNT.MOD.CHQ + TO +=
            FIRST.CHEQUE += 1              ;** R22 Auto conversion - = FIRST.CHEQUE + TO  +=
        REPEAT

        R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,START.COUNT> = 'NONE'

        R.PAYSTOP<AC.PAY.LOCAL.REF,POS.EXPIRY.DATE,START.COUNT> = ''
        R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOP.TIME,START.COUNT> = ''
        R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.PAY.STOP.STATUS,START.COUNT> = 'NONE'
        R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXPIRY.DATE,START.COUNT> = TODAY
        Y.CHQ.FLAG = '1'

        GOSUB SUCCESSLOG
    END ELSE
        GOSUB REJECTEDLOG
    END
RETURN
*------------------------------------
GT.EXP.DATE:

    R.PAYSTOP<AC.PAY.CUSTOMER.NO>                   =  R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CUSTOMER>
    R.PAYSTOP<AC.PAY.CURRENCY>                      =  R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.CURRENCY>
    COUNT.MOD.CHQ = 1
    LOOP
    WHILE COUNT.MOD.CHQ LE Y.NO.OF.LEAVES
        R.PAYSTOP<AC.PAY.MOD.PS.CHQ.NO,COUNT.MOD.CHQ> = FIRST.CHEQUE
        R.PAYSTOP<AC.PAY.MOD.CHQ.TYPE,COUNT.MOD.CHQ> = Y.CHQ.TYPE
        R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,START.COUNT> = 'NONE'
        R.PAYSTOP<AC.PAY.MOD.PS.DATE,COUNT.MOD.CHQ> = TODAY
        COUNT.MOD.CHQ += 1                     ;** R22 Auto conversion -  = COUNT.MOD.CHQ + TO +=
        FIRST.CHEQUE += 1                      ;** R22 Auto conversion - = FIRST.CHEQUE + TO  +=
    REPEAT

    R.PAYSTOP<AC.PAY.LOCAL.REF,POS.EXPIRY.DATE,START.COUNT> = ''
    R.PAYSTOP<AC.PAY.LOCAL.REF,POS.STOP.TIME,START.COUNT> = ''

    R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.PAY.STOP.STATUS,START.COUNT> = 'NONE'
    R.REDO.PAYMENT.STOP.ACCOUNT<REDO.PS.ACCT.EXPIRY.DATE,START.COUNT> = TODAY
    Y.CHQ.FLAG = '1'
RETURN
*------------------------------------
REJECTEDLOG:

    INT.CODE ='REV001'
    INT.TYPE ='SBATCH'
    BAT.NO =''
    BAT.TOT =''
    INFO.OR =''
    INFO.DE =''
    ID.PROC = Y.ACCT.ID
    MON.TP ='03'
    DESC = 'TIME DOESNOT MATCHED'
    REC.CON = ''
*    EX.USER = 'SHANKAR'
    EX.USER = OPERATOR
*    EX.PC = '10.93.1.37'
    EX.PC = TSS$CLIENTIP
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*** R22 Manual conversion
    CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)

RETURN
*--------------------------------------
SUCCESSLOG:

    INT.CODE ='REV001'
    INT.TYPE ='SBATCH'
    BAT.NO =''
    BAT.TOT =''
    INFO.OR =''
    INFO.DE =''
    ID.PROC = Y.ACCT.ID
    MON.TP ='01'
    DESC = 'TIME MATCHES'
    REC.CON = ''
*    EX.USER = 'SHANKAR'
    EX.USER = OPERATOR
*    EX.PC = '10.93.1.37'
    EX.PC = TSS$CLIENTIP
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
*** R22 Manual conversion
    CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN

*-----------------------------------------------------------------------------
PROCESS:


    Y.NEXT.WRKN = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FLDS,LREF.POS)
    POS.STOPPAYMENT.STATUS=LREF.POS<1,1>
    POS.EXPIRY.DATE=LREF.POS<1,2>
    POS.STOP.TIME =LREF.POS<1,3>

    SEL.CMD="SELECT ":FN.REDO.PAYMENT.STOP.ACCOUNT : " WITH PAY.STOP.STATUS EQ 'NONCONFIRMED' AND EXPIRY.DATE LE ":TODAY
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

        GOSUB UPDT.FLDS
        IF Y.CHQ.FLAG EQ '1' THEN
            GOSUB CHEQ.PARA.UPDATE
        END
        CALL F.WRITE(FN.REDO.PAYMENT.STOP.ACCOUNT,Y.PS.ID,R.REDO.PAYMENT.STOP.ACCOUNT)


    REPEAT

RETURN
END
*------------------------------------------------------------------------------
