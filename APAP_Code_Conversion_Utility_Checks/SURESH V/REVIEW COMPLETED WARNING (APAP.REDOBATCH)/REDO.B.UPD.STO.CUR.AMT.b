* @ValidationCode : MjoyMDUxODQzNzI4OkNwMTI1MjoxNzAyOTYzODcyOTQ3OjMzM3N1Oi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:01:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.STO.CUR.AMT(STO.ID)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is the record routine of the batch job REDO.B.UPD.STO.CUR.AMT
* This routine updates the CURRENT.AMOUNT.BAL, L.LOAN.STATUS.1 & L.LOAN.COND fields of STANDING.ORDER
* ---------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  :
*  STO.ID - Standing order record id for which CURRENT.AMOUNT.BAL field needs to be updated
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 07-JUN-2010   N.Satheesh Kumar  TAM-ODR-2009-10-0331   Initial Creation
* Date                   who                   Reference
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO += 1 AND = TO EQ
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*18/12/2023         Suresh                R22 UTILITY AUTO CONVERSION   - CALL routine modified, Change F.READ to F.READU

*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_REDO.B.UPD.STO.CUR.AMT.COMMON
    $USING APAP.AA
    $USING AA.PaymentSchedule ;*R22 Manual Conversion

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

    LOAN.STATUS = ''
    LOAN.COND = ''
    CUR.AMT.BAL = 0

RETURN

*-------
PROCESS:
*-------

    R.STANDING.ORDER = ''
*    CALL F.READ(FN.STANDING.ORDER,STO.ID,R.STANDING.ORDER,F.STANDING.ORDER,STO.ERR)
    CALL F.READU(FN.STANDING.ORDER,STO.ID,R.STANDING.ORDER,F.STANDING.ORDER,STO.ERR,'');* R22 UTILITY AUTO CONVERSION
    R.OLD.STANDING.ORDER = R.STANDING.ORDER
    IF R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL> EQ '' THEN
        R.STANDING.ORDER<STO.COMM.FREQUENCY> = R.STANDING.ORDER<STO.CURRENT.FREQUENCY>
        R.STANDING.ORDER<STO.LAST.CHG.DATE,-1> = R.STANDING.ORDER<STO.LAST.RUN.DATE>
    END
    ARR.ID = R.STANDING.ORDER<STO.LOCAL.REF,STO.ARR.ID.POS>
    GOSUB GET.OD.STATUS.COND
    R.STANDING.ORDER<STO.LOCAL.REF,STO.LOAN.STATUS.POS> = LOAN.STATUS
    R.STANDING.ORDER<STO.LOCAL.REF,STO.LOAN.COND.POS> = LOAN.COND
    GOSUB GET.CUR.AMT.BAL
    R.STANDING.ORDER<STO.CURRENT.AMOUNT.BAL> = CUR.AMT.BAL
    GOSUB GET.MATURITY.DATE
    IF R.STANDING.ORDER NE R.OLD.STANDING.ORDER THEN
        CALL F.WRITE(FN.STANDING.ORDER,STO.ID,R.STANDING.ORDER)
    END
RETURN

*------------------
GET.OD.STATUS.COND:
*------------------
*----------------------------------------------------------------------------------------------------------------------
* This section gets the latest overdue record for the arrangement id and stores the value of loan status and condition
*----------------------------------------------------------------------------------------------------------------------

    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
*   CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG) ;*R22 Manual Code Conversion
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
    CHANGE @SM TO @VM IN LOAN.STATUS
    CHANGE @SM TO @VM IN LOAN.COND
RETURN

*-----------------
GET.MATURITY.DATE:
*-----------------
*----------------------------------------------------------------------------------------------------------------------
* This section gets the maturity date from prodeuct condition record
*----------------------------------------------------------------------------------------------------------------------

    PROP.CLASS = 'TERM.AMOUNT'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
*   CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG) ;*R22 Manual Code Conversion
    MATURITY.DATE = R.Condition<AA.AMT.MATURITY.DATE>
    R.STANDING.ORDER<STO.CURRENT.END.DATE> = MATURITY.DATE
RETURN

*---------------
GET.CUR.AMT.BAL:
*---------------
*---------------------------------------------------------------------------------------------
* This section computes the amount to be updated in CURRENT.AMOUNT.BAL field of STANDING.ORDER
*---------------------------------------------------------------------------------------------

    FIRST.DUE.DATE = ''
    DUE.DATE.CNT = 0
*    CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIM.REF, "", CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
    AA.PaymentSchedule.ScheduleProjector(ARR.ID, SIM.REF, "", CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS) ;*R22 Manual Conversion
    LOOP
        DUE.DATE.CNT += 1
        REMOVE DUE.DATE FROM DUE.DATES SETTING DUE.DATE.POS
    WHILE DUE.DATE:DUE.DATE.POS
        IF DUE.DATE GT TODAY THEN
            IF FIRST.DUE.DATE EQ '' THEN
                FIRST.DUE.DATE = DUE.DATE
                CUR.AMT.BAL += TOT.PAYMENT<DUE.DATE.CNT>
            END ELSE
                IF FIRST.DUE.DATE EQ DUE.DATE THEN
                    CUR.AMT.BAL += TOT.PAYMENT<DUE.DATE.CNT>
                END ELSE
                    BREAK
                END
            END
        END
    REPEAT
RETURN
END
