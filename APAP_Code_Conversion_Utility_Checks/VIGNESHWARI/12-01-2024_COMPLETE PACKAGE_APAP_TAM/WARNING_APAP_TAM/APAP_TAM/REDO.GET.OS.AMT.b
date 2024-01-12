* @ValidationCode : Mjo2MTM1MDI3OkNwMTI1MjoxNzA1MDM4MTY0OTMxOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 11:12:44
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
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           VM TO @VM, SM TO @SM
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*12-01-2024         VIGNESHWARI S    R22 MANUAL CODE CONVERSION         AA.FRAMEWORK IS CHANGED
*-----------------------------------------------------------------------------------

SUBROUTINE REDO.GET.OS.AMT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*    $INSERT I_F.AA.ARRANGEMENT
   $USING AA.Framework


    Y.AA.IDS = O.DATA

    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    CALL OPF(FN.AA,F.AA)

    Y.AA.IDS = CHANGE(Y.AA.IDS,@SM,@VM) ; Y.CNT = DCOUNT(Y.AA.IDS,@VM)

    Y.OVR.ST = 'CUR':@VM:'DE1':@VM:'DE3':@VM:'DEL':@VM:'NAB'
    Y.OVR.ST.I = 'ACC':@VM:'DE1':@VM:'DE3':@VM:'DEL':@VM:'NAB'
    REQUEST.TYPE<2> = 'ALL';REQUEST.TYPE<4> = 'ECB'

    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.A.ID = Y.AA.IDS<1,FLG>
        CALL F.READ(FN.AA,Y.A.ID,R.AA,F.AA,AA.ERR)
        *Y.AC.ID = R.AA<AA.ARR.LINKED.APPL.ID>
        Y.AC.ID = R.AA<AA.Framework.ArrangementSim.ArrLinkedApplId> ;*R22 MANUAL CODE CONVERSION-AA.FRAMEWORK IS CHANGED
        GOSUB CAL.OS.AMT
        Y.TOT.OS.BAL<1,-1> = Y.PRIN.BAL + Y.IN.BAL
        Y.CNT -= 1
    REPEAT

    O.DATA = Y.TOT.OS.BAL

RETURN

CAL.OS.AMT:

    Y.CNT.L = DCOUNT(Y.OVR.ST,@VM) ; Y.PRIN.BAL = '' ; Y.IN.BAL = ''
    LOOP
    WHILE Y.CNT.L GT 0 DO
        FLG.P += 1
        Y.PRO = Y.OVR.ST<1,FLG.P>:'ACCOUNT'
*        CALL AA.GET.PERIOD.BALANCES(Y.AC.ID, Y.PRO, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE)
AA.Framework.GetPeriodBalances(Y.AC.ID, Y.PRO, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE);* R22 UTILITY AUTO CONVERSION
        Y.BT.CNT = DCOUNT(BAL.DETAILS<4>,@VM)
        Y.PRIN.BAL += ABS(BAL.DETAILS<4,Y.BT.CNT>)

        Y.PRO.I = Y.OVR.ST.I<1,FLG.P>:'PRINCIPALINT'
*        CALL AA.GET.PERIOD.BALANCES(Y.AC.ID, Y.PRO.I, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE)
AA.Framework.GetPeriodBalances(Y.AC.ID, Y.PRO.I, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE);* R22 UTILITY AUTO CONVERSION
        Y.BB.CNT = DCOUNT(BAL.DETAILS<4>,@VM)
        Y.IN.BAL += ABS(BAL.DETAILS<4,Y.BB.CNT>)

        Y.CNT.L -= 1
    REPEAT

RETURN

END
