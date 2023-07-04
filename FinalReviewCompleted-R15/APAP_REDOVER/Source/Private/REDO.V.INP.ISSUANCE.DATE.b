* @ValidationCode : MjotMTA5NDY2MDY4NDpDcDEyNTI6MTY4NDg0NTYyMDA5ODpJVFNTOi0xOi0xOjM3NzoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 18:10:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 377
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.ISSUANCE.DATE
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This subroutine would serve as a cross validation level validation routine
* The purpose of this routine is to check the field STOPPAYMENT.STATUS,
* depending upon the value of STOP.PAYMENT.STATUS system should populate
*  the EXPIRY.DATE and  STOP.CHEQ.VALIDITY
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
*   Date               who           Reference            Description
* 25-Nov-2009     SHANKAR RAJU                            Initial Creation
*------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                      VM TO @VM,SM TO @SM, START.COUNT + 1 TO +=1
*12-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.PAYMENT.STOP.HIST
    $INSERT I_F.REDO.CHQ.VALID.PERIOD

*------------------------------MAIN--------------------------------------
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------


*------------------------------INIT--------------------------------------
INIT:

    POS=''
    OLD.DATE = ''
    POS.STOPPAYMENT.STATUS=''
    R.CHQ.VAL=''
    FN.REDO.CHQ.VALID='F.REDO.CHQ.VALID.PERIOD'
    F.REDO.CHQ.VALID=''
    VALIDITY=''
    F.PAYMENT.STOP=''
    FN.PAYMENT.STOP='F.PAYMENT.STOP'
    LREF.APPLN="PAYMENT.STOP"
    LREF.FIELDS="L.PS.STP.PMT.ST":@VM:"L.PS.ISSUE.DATE":@VM:"L.PS.EXP.DATE":@VM:"L.PS.STOP.TIME":@VM:"L.PS.STP.CHQVLD":@VM:"L.PS.CHQ.VALTIM"
    LREF.POS=''

RETURN
*------------------------------------------------------------------------

*------------------------------------------------------------------------
OPENFILE:
    CALL OPF(FN.PAYMENT.STOP,F.PAYMENT.STOP)
    CALL OPF(FN.REDO.CHQ.VALID,F.REDO.CHQ.VALID)
RETURN
*------------------------------------------------------------------------
PROCESS:
    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FIELDS,LREF.POS)
    POS.STOPPAYMENT.STATUS=LREF.POS<1,1>
    POS.ISSUE.DATE=LREF.POS<1,2>
    POS.EXPIRY.DATE=LREF.POS<1,3>
    POS.STOP.TIME =LREF.POS<1,4>
    POS.STP.CHQVLD =LREF.POS<1,5>
    POS.CHQ.VALTIM=LREF.POS<1,6>

    CHQ.STATUS=R.NEW(AC.PAY.LOCAL.REF)<1,POS.STOPPAYMENT.STATUS>

    START.COUNT = 1
    STATUS.NOS = DCOUNT(CHQ.STATUS,@SM)
    LOOP
    WHILE START.COUNT LE STATUS.NOS

        ISSUE.DATE=R.NEW(AC.PAY.LOCAL.REF)<1,POS.ISSUE.DATE,START.COUNT>
        ISSUE.DAT = ISSUE.DATE<1,1,START.COUNT>
        STAT.CHQ = CHQ.STATUS<1,1,START.COUNT>
        IF CHQ.STATUS<1,1,START.COUNT> EQ 'CONFIRMED' AND ISSUE.DATE NE '' THEN

            CALL F.READ(FN.REDO.CHQ.VALID,'CONFIRMED',R.CHQ.VAL,F.REDO.CHQ.VALID,ERR.REDO)

            VALIDITY=R.CHQ.VAL<REDO.CHQ.VAL.VALIDITY>
            ADV.MONTH=VALIDITY:'M'

            CALL CALENDAR.DAY(ISSUE.DATE,'+',ADV.MONTH)

            OLD.DATE = R.OLD(AC.PAY.LOCAL.REF)<1,POS.ISSUE.DATE,START.COUNT>

            IF OLD.DATE NE ISSUE.DATE THEN

                R.NEW(AC.PAY.LOCAL.REF)<1,POS.EXPIRY.DATE,START.COUNT>=ADV.MONTH

                TIME.NOW=OCONV(TIME(),"MT")
                R.NEW(AC.PAY.LOCAL.REF)<1,POS.STOP.TIME,START.COUNT>=TIME.NOW

                R.NEW(AC.PAY.LOCAL.REF)<1,POS.STP.CHQVLD,START.COUNT>=ADV.MONTH

                R.NEW(AC.PAY.LOCAL.REF)<1,POS.CHQ.VALTIM,START.COUNT>=TIME.NOW

            END

        END
        ELSE
            ISSUE.DAT = ISSUE.DATE<1,1,START.COUNT>
            STAT.CHQ = CHQ.STATUS<1,1,START.COUNT>
            IF CHQ.STATUS<1,1,START.COUNT> EQ 'NONCONFIRMED' AND ISSUE.DATE NE '' THEN

                CALL F.READ(FN.REDO.CHQ.VALID,'NONCONFIRMED',R.CHQ.VAL,F.REDO.CHQ.VALID,ERR.REDO)

                VALIDITY=R.CHQ.VAL<REDO.CHQ.VAL.VALIDITY>

*VALIDITY IN HOURS(ONLY IN MULTIPLES OF 24-HOURS) WILL BE CONVERTED INTO DAYS

                VAL.DAY=VALIDITY/24
                ADV.DAY=VAL.DAY:'D'
                CALL CALENDAR.DAY(ISSUE.DATE,'+',ADV.DAY)
                IF OLD.DATE NE ISSUE.DATE THEN
                    R.NEW(AC.PAY.LOCAL.REF)<1,POS.EXPIRY.DATE,START.COUNT>=ADV.DAY

                    TIME.NOW=OCONV(TIME(),"MT")
                    R.NEW(AC.PAY.LOCAL.REF)<1,POS.STOP.TIME,START.COUNT>=TIME.NOW

                    R.NEW(AC.PAY.LOCAL.REF)<1,POS.STP.CHQVLD,START.COUNT>=ADV.DAY

                    R.NEW(AC.PAY.LOCAL.REF)<1,POS.CHQ.VALTIM,START.COUNT>=TIME.NOW
                END
            END
        END
        START.COUNT += 1
    REPEAT
RETURN
*------------------------------------------------------------------------

END
*------------------------------------------------------------------------
