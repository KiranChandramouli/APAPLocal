* @ValidationCode : MjoyMDQwMTIyMDA3OkNwMTI1MjoxNjg0ODQyMTMwMjMxOklUU1M6LTE6LTE6MzY4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 368
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.RPT.CLSE.WRITE.LOANS(AA.ARR.ID,R.AA.ARR,ARRAYGP.VAL)
*
* Description: The routine to display the loan status and closed status
*
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*-----------------------------------------------------------------------------------------------------------------
* PACS00460181          Ashokkumar.V.P                  09/06/2015           Initial release to show Loan status and closed status
** 17-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 17-04-2023 Skanda R22 Manual Conversion - added APAP.TAM, CALL routine format modified
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM ;* R22 Auto conversion

    GOSUB INIT
    GOSUB GET.LOC.VAL
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'; F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'; F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
RETURN

GET.LOC.VAL:
************
    Y.APPLN = "AA.PRD.DES.OVERDUE"
    Y.FLD = 'L.LOAN.STATUS.1'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPLN,Y.FLD,Y.POS)  ;*MANUAL R22 CODE CONVERSION
    Y.L.LOAN.STATUS.1.POS = Y.POS<1,1>
RETURN

PROCESS:
********
    ARRAYGP.VAL = ''; YCLOSE.LN.FLG = 0
    GOSUB GET.LOAN.STATUS
    GOSUB GET.CLOSED.LOAN.CHK
    ARRAYGP.VAL = LOAN.STATUS:@FM:YCLOSE.LN.FLG
RETURN

GET.LOAN.STATUS:
*--------------*
    ArrangementID = AA.ARR.ID
    idPropertyClass = 'OVERDUE'; LOAN.STATUS = ''
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.OVERDUE = RAISE(returnConditions)
    LOAN.STATUS = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
RETURN

GET.CLOSED.LOAN.CHK:
********************
    ERR.AA.ACTIVITY.HISTORY = ''; R.AA.ACTIVITY.HISTORY = ''; YACT.IS.STAT = ''; YACT.ID.ARR = ''
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,AA.ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ERR.AA.ACTIVITY.HISTORY)
    IF R.AA.ACTIVITY.HISTORY THEN
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
        YACT.IS.STAT = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS>
        CHANGE @VM TO @FM IN YACT.ID.ARR
        CHANGE @SM TO @FM IN YACT.ID.ARR
        CHANGE @VM TO @FM IN YACT.IS.STAT
        CHANGE @SM TO @FM IN YACT.IS.STAT
    END
    Y.PROD.GUP = R.AA.ARR<AA.ARR.PRODUCT.GROUP>
    ERR.REDO.APAP.PROPERTY.PARAM = ''; R.REDO.APAP.PROPERTY.PARAM = ''; YPAYOFF.ACT = ''; YPAY.CNT = 0
    CALL F.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PROD.GUP,R.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM,ERR.REDO.APAP.PROPERTY.PARAM)
    IF R.REDO.APAP.PROPERTY.PARAM THEN
        YPAYOFF.ACT = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY>
        YPAY.CNT = DCOUNT(YPAYOFF.ACT,@VM)
    END

    YCNT = 1
    LOOP
    WHILE YCNT LE YPAY.CNT
        YPAYOFF.ACT.1 = ''
        YPAYOFF.ACT.1 = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY,YCNT>
        LOCATE YPAYOFF.ACT.1 IN YACT.ID.ARR<1> SETTING CHG.POSN.1 THEN
            YARR.STAT = YACT.IS.STAT<CHG.POSN.1>
            IF YARR.STAT EQ 'AUTH' THEN
                YCLOSE.LN.FLG = 1
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
        END
        YCNT += 1 ;* R22 Auto conversion
    REPEAT
RETURN
END
