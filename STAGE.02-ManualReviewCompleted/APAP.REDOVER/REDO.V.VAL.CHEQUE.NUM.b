* @ValidationCode : MjotNzUxNzAxNTI5OkNwMTI1MjoxNjgxMzc0MTIyODI0OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:52:02
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
SUBROUTINE REDO.V.VAL.CHEQUE.NUM
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine is used to validate the cheque number , Upon input of the Cheque No in the PAYMENT.STOP
*Application, the Routine has to check the PAYMENT.STOP.HIST file and if an entry is there in this file, then
*default the value .CONFIRMED. to the field .STOPPAYMENT.STATUS. (newly created local reference field).  In
*this case, rest of the fields should be made non-modifiable, and the data to the fields in the Application to be
*populated from the History file

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
*-----------------------------------------------------------------------------------------
*   Date               who           Reference            Description
* 27-Nov-2009         HARISH.Y                            Initial Creation
*------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,++ TO +=1
*13-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.PAYMENT.STOP.HIST
* Tus Start
    $INSERT I_F.CHEQUE.REGISTER.SUPPLEMENT
    $INSERT I_F.CHEQUE.TYPE.ACCOUNT
* Tus End
    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END
    GOSUB INIT

    GOSUB PROCESSCHEQ

RETURN

***************
INIT:
**************
    FN.PAYMENT.STOP.HIST='F.PAYMENT.STOP.HIST'
    F.PAYMENT.STOP.HIST=''
    FN.PAYMENT.STOP = 'F.PAYMENT.STOP'
    F.PAYMENT.STOP = ''
*FN.CHEQUES.STOP = 'F.CHEQUES.STOPPED';*Tus Start
* F.CHEQUES.STOP = '';*Tus End
    FOUND = ''
    CHQ.ARR = ''
    STOP.POS = ''
    CALL OPF(FN.PAYMENT.STOP.HIST,F.PAYMENT.STOP.HIST)
    CALL OPF(FN.PAYMENT.STOP,F.PAYMENT.STOP)
* CALL OPF(FN.CHEQUES.STOP,F.CHEQUES.STOP);*Tus Start

    FN.CHEQUE.REGISTER.SUPPLEMENT="F.CHEQUE.REGISTER.SUPPLEMENT"
    F.CHEQUE.REGISTER.SUPPLEMENT=''
    CALL OPF(FN.CHEQUE.REGISTER.SUPPLEMENT,F.CHEQUE.REGISTER.SUPPLEMENT)

    FN.CHEQUE.TYPE.ACCOUNT="F.CHEQUE.TYPE.ACCOUNT"
    F.CHEQUE.TYPE.ACCOUNT=''
    CALL OPF(FN.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT);*Tus End
    L.REF.APPL = 'PAYMENT.STOP'
    L.REF.FIELDS = 'L.PS.STP.PMT.ST':@VM:'L.PS.ISSUE.DATE':@VM:'L.PS.EXP.DATE':@VM:'L.PS.STOP.TIME':@VM:'L.PS.CHQ.VALTIM':@VM:'L.PS.STP.CHQVLD'
    L.REF.POS = ''
    CALL MULTI.GET.LOC.REF(L.REF.APPL,L.REF.FIELDS,L.REF.POS)
    STP.PMT.POS = L.REF.POS<1,1>
    ISS.DATE.POS = L.REF.POS<1,2>
    EXP.DATE.POS = L.REF.POS<1,3>
    STOP.TIME.POS = L.REF.POS<1,4>
    CHQ.VAL.POS = L.REF.POS<1,5>
    STP.CHQ.VLD.POS = L.REF.POS<1,6>

RETURN

****************
PROCESSCHEQ:
****************
    ACC.ID = ID.NEW
    ALL.FIRST.CHEQ.NUM = R.NEW(AC.PAY.FIRST.CHEQUE.NO)
    CHQ.OCCUR = DCOUNT(ALL.FIRST.CHEQ.NUM,@VM)

    START.COUNT = 1

    LOOP
    WHILE START.COUNT LE CHQ.OCCUR
        IF ETEXT THEN
            EXIT
        END
        FIRST.CHEQ.NUM = R.NEW(AC.PAY.FIRST.CHEQUE.NO)<1,START.COUNT>
        LAST.CHEQ.NUM = R.NEW(AC.PAY.LAST.CHEQUE.NO)<1,START.COUNT>

        IF LAST.CHEQ.NUM EQ '' THEN
            LAST.CHEQ.NUM = FIRST.CHEQ.NUM
        END
        LOOP
        WHILE FIRST.CHEQ.NUM LE LAST.CHEQ.NUM
*      STOP.CHEQUE.ID = ACC.ID:'*':FIRST.CHEQ.NUM
*     CALL F.READ(FN.CHEQUES.STOP,STOP.CHEQUE.ID,R.STOP.CHEQUE,F.CHEQUES.STOP,CHEQUE.ERR);*Tus Start
            REC.CHEQUE.TYPE.ACCOUNT='';R.CHEQUE.REGISTER.SUPPLEMENT='';CHQ.TYPE.ERR='';CH.STOPPED.ERR=''
            CALL F.READ(FN.CHEQUE.TYPE.ACCOUNT,ACC.ID,REC.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT,CHQ.TYPE.ERR)
            CHQ.TYPE=REC.CHEQUE.TYPE.ACCOUNT<CHQ.TYP.CHEQUE.TYPE,1>
* Y.ID.CH.STOPPED=CHQ.TYPE:".":ACC.ID:".":FIRST.CHEQ.NUM
            STOP.CHEQUE.ID=CHQ.TYPE:".":ACC.ID:".":FIRST.CHEQ.NUM
*  CALL F.READ(FN.CHEQUE.REGISTER.SUPPLEMENT,Y.ID.CH.STOPPED,R.CHEQUE.REGISTER.SUPPLEMENT,F.CHEQUE.REGISTER.SUPPLEMENT,CH.STOPPED.ERR)
            CALL F.READ(FN.CHEQUE.REGISTER.SUPPLEMENT,STOP.CHEQUE.ID,R.CHEQUE.REGISTER.SUPPLEMENT,F.CHEQUE.REGISTER.SUPPLEMENT,CH.STOPPED.ERR)
            IF NOT(CH.STOPPED.ERR) THEN
                IF R.CHEQUE.REGISTER.SUPPLEMENT THEN
*     IF NOT(CHEQUE.ERR) THEN
*       IF R.STOP.CHEQUE THEN ;*Tus End
                    ETEXT = 'EB-CHQ.SUSPENDED'
                    CALL STORE.END.ERROR
                END

            END
            FIRST.CHEQ.NUM += 1
        REPEAT
        IF ETEXT THEN
            EXIT
        END

        IF FIRST.CHEQ.NUM EQ LAST.CHEQ.NUM THEN
            GOSUB SINGLE.CHEQ.PROCESS
        END ELSE
            GOSUB MULTI.CHEQ.PROCESS
        END
        START.COUNT += 1
    REPEAT

RETURN

********************
SINGLE.CHEQ.PROCESS:
********************

    CALL F.READ(FN.PAYMENT.STOP.HIST,ACC.ID,R.PAY.STOP.HIST,F.PAYMENT.STOP.HIST,HIST.ERR)

    IF R.PAY.STOP.HIST THEN

        REV.CHEQS = R.PAY.STOP.HIST<AC.PAY.HIST.FIRST.CHEQUE.NO>

        CHANGE @VM TO @FM IN REV.CHEQS

        LOCATE FIRST.CHEQ.NUM IN REV.CHEQS SETTING CHEQ.POS THEN

            STOP.POS = CHEQ.POS

        END

        IF STOP.POS THEN

            R.NEW(AC.PAY.LOCAL.REF)<1,STP.PMT.POS,START.COUNT> = "CONFIRMED"

            CHQ.ARR<-1> = FIRST.CHEQ.NUM
            CHQ.ARR<-1> = "ALREADY STOPPED"

            CHANGE @FM TO ' ' IN CHQ.ARR

            AF = AC.PAY.FIRST.CHEQUE.NO
            AV = START.COUNT
            ETEXT = CHQ.ARR
            CALL STORE.END.ERROR
            GOSUB SINGLE.CHECK.FOUND

        END

    END

RETURN

*********************
MULTI.CHEQ.PROCESS:
*********************

    CALL F.READ(FN.PAYMENT.STOP.HIST,ACC.ID,R.PAY.STOP.HIST,F.PAYMENT.STOP.HIST,HIST.ERR)

    IF R.PAY.STOP.HIST THEN

        REV.CHEQS = R.PAY.STOP.HIST<AC.PAY.HIST.FIRST.CHEQUE.NO>
        CHANGE @VM TO @FM IN REV.CHEQS
        CHQ.ARR = ''

        LOOP
        WHILE FIRST.CHEQ.NUM LE LAST.CHEQ.NUM

            LOCATE FIRST.CHEQ.NUM IN REV.CHEQS SETTING CHEQ.POS THEN
                CHQ.ARR<-1> = FIRST.CHEQ.NUM
                FOUND += 1;
            END

            FIRST.CHEQ.NUM += 1

        REPEAT

        CHQ.ARR<-1> = "Status of the Cheque(s) is Confirmed"

    END

    IF FOUND GE 1 THEN

        R.NEW(AC.PAY.LOCAL.REF)<1,STP.PMT.POS,START.COUNT> = "CONFIRMED"

        CHANGE @FM TO ' ' IN CHQ.ARR

        ETEXT = CHQ.ARR
        AF = AC.PAY.FIRST.CHEQUE.NO
        AV = START.COUNT
        CALL STORE.END.ERROR
        GOSUB CHECK.FOUND

    END

RETURN

***************
CHECK.FOUND:
***************

    T(AC.PAY.LOCAL.REF)<3> = "NOINPUT"

RETURN
**********************
SINGLE.CHECK.FOUND:
********************

    T(AC.PAY.LOCAL.REF)<3> = "NOCHANGE"

    R.NEW(AC.PAY.PAYM.STOP.TYPE)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.PAYM.STOP.TYPE><1,CHEQ.POS>
    T(AC.PAY.PAYM.STOP.TYPE)<3> = "NOCHANGE"

    R.NEW(AC.PAY.FIRST.CHEQUE.NO)<1,START.COUNT>=FIRST.CHEQ.NUM

    T(AC.PAY.FIRST.CHEQUE.NO)<3> = "NOCHANGE"

    R.NEW(AC.PAY.LAST.CHEQUE.NO)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.LAST.CHEQUE.NO><1,CHEQ.POS>
    T(AC.PAY.LAST.CHEQUE.NO)<3> = "NOCHANGE"

    R.NEW(AC.PAY.CHEQUE.TYPE)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.CHEQUE.TYPE><1,CHEQ.POS>
    T(AC.PAY.CHEQUE.TYPE)<3> = "NOCHANGE"

    R.NEW(AC.PAY.STOP.DATE)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.STOP.DATE><1,CHEQ.POS>
    T(AC.PAY.STOP.DATE)<3> = "NOCHANGE"

    R.NEW(AC.PAY.AMOUNT.FROM)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.AMOUNT.FROM><1,CHEQ.POS>
    T(AC.PAY.AMOUNT.FROM)<3> = "NOCHANGE"

    R.NEW(AC.PAY.AMOUNT.TO)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.AMOUNT.TO><1,CHEQ.POS>
    T(AC.PAY.AMOUNT.TO)<3> = "NOCHANGE"

    R.NEW(AC.PAY.BENEFICIARY)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.BENEFICIARY><1,CHEQ.POS>
    T(AC.PAY.BENEFICIARY)<3> = "NOCHANGE"

    R.NEW(AC.PAY.STOP.END.FLAG)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.STOP.END.FLAG><1,CHEQ.POS>
    T(AC.PAY.STOP.END.FLAG)<3> = "NOCHANGE"

    R.NEW(AC.PAY.APPLY.DATE)<1,START.COUNT>=R.PAY.STOP.HIST<AC.PAY.HIST.APPLY.DATE><1,CHEQ.POS>
    T(AC.PAY.APPLY.DATE)<3> = "NOCHANGE"
RETURN
END
