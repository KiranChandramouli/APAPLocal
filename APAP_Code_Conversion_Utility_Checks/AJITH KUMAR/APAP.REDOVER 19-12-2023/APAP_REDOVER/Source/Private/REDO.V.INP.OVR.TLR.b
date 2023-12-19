* @ValidationCode : MjoxNzQ2MDI2OTk4OkNwMTI1MjoxNjg0ODQ1NjIwNzU0OklUU1M6LTE6LTE6MjU1OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 255
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.OVR.TLR
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would show a override message, which would deliver
* the user a message if the option for the field, STOPPAYMENT.STATUS has been
* selected as Non-Confirmed or Confirmed
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
*------------------------------------------------------------------------------------------
* Date who Reference Description
* 25-Nov-2009 SHANKAR RAJU Initial Creation
*------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM,++ TO +=1
*12-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.TELLER

*------------------------------MAIN------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------

*------------------------------INIT------------------------------------------
INIT:

    POS=''
    CURR.NO=''
    POS.STOPPAYMENT.STATUS=''
    FN.PAYMENT.STOP='F.PAYMENT.STOP'
    FN.TELLER='F.TELLER'
    F.PAYMENT.STOP=''
    F.TELLER=''
    CALL OPF(FN.PAYMENT.STOP,F.PAYMENT.STOP)
    CALL OPF(FN.TELLER,F.TELLER)
    R.PAYMENT.STOP=''

    CHEQUE.NO = ''; DEBT.AC.NO = ''

RETURN
*----------------------------------------------------------------------------

*----------------------------------------------------------------------------
PROCESS:


    CALL GET.LOC.REF('PAYMENT.STOP','L.PS.STP.PMT.ST',POS)
    POS.STOPPAYMENT.STATUS=POS

    CHEQUE.NO1=R.NEW(TT.TE.CHEQUE.NUMBER)
    Y.CHEQ.NUM = DCOUNT(CHEQUE.NO1,@VM)

    IF CHEQUE.NO1 NE '' THEN

        DEBT.AC.NO = R.NEW(TT.TE.ACCOUNT.1)


        CALL F.READ(FN.PAYMENT.STOP,DEBT.AC.NO,R.PAYMENT.STOP,F.PAYMENT.STOP,ERR.PS)

        FIRST.CHEQUE.NOS=R.PAYMENT.STOP<AC.PAY.FIRST.CHEQUE.NO>
        LAST.CHEQUE.NOS=R.PAYMENT.STOP<AC.PAY.LAST.CHEQUE.NO>

        COUNTER.LOOP = 1
        COUNT.PAY.STOP=DCOUNT(FIRST.CHEQUE.NOS,@VM)

        LOOP
        WHILE COUNTER.LOOP LE COUNT.PAY.STOP

            FIRST.CHQ.NO=FIRST.CHEQUE.NOS<1,COUNTER.LOOP>
            LAST.CHQ.NO=LAST.CHEQUE.NOS<1,COUNTER.LOOP>
            GOSUB CHEQ.CHECK
            COUNTER.LOOP += 1

        REPEAT
    END

RETURN

*-----------------------------------------------------------------------------------------------------
CHEQ.CHECK:

    Y.CNT = 1
    LOOP

    WHILE Y.CNT LE Y.CHEQ.NUM
        CHEQUE.NO = CHEQUE.NO1<1,Y.CNT>

        IF CHEQUE.NO EQ FIRST.CHQ.NO THEN

            GOSUB DISPLAY.MESSAGE

        END ELSE

            IF CHEQUE.NO GT FIRST.CHQ.NO AND CHEQUE.NO LT LAST.CHQ.NO THEN

                GOSUB DISPLAY.MESSAGE

            END
        END
        Y.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------
DISPLAY.ERROR:

    AF = TT.TE.CHEQUE.NUMBER
    AV = Y.CNT
    ETEXT='EB-DESC.CHEQUE.STATUS':@FM:CHEQUE.NO
    CALL STORE.END.ERROR
    GOSUB END.ROU

RETURN
*----------------------------------------------------------------------------------------------------
DISPLAY.OVERRIDE:

    TEXT='STATUS.OF.CHEQUE':@FM:CHEQUE.NO
    CALL STORE.OVERRIDE(CURR.NO+1)
    GOSUB END.ROU
RETURN
*---------------------------------------------------------------------------------------------------
DISPLAY.MESSAGE:

    CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
    IF R.PAYMENT.STOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,COUNTER.LOOP> EQ 'NONCONFIRMED' THEN

        GOSUB DISPLAY.OVERRIDE

    END ELSE
        IF R.PAYMENT.STOP<AC.PAY.LOCAL.REF,POS.STOPPAYMENT.STATUS,COUNTER.LOOP> EQ 'CONFIRMED' THEN

            GOSUB DISPLAY.ERROR
        END
    END
RETURN

*---------------------------------------------------------------------------------------------------
END.ROU:

END
*-----------------------------------------------------------------------------------------------------
