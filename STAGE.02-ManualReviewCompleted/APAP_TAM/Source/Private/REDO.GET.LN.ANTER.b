* @ValidationCode : MjotMTkwOTA1MTcxOkNwMTI1MjoxNjgwNzE4ODA2NDA3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:50:06
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
SUBROUTINE REDO.GET.LN.ANTER
    
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, SM TO @SM
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*------------------------------------------------------------------------------------------------------
    

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON


    Y.AA.IDS = O.DATA

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    CALL OPF(FN.AA,F.AA)


    Y.AA.IDS = CHANGE(Y.AA.IDS,@SM,@VM)


    Y.CNT = DCOUNT(Y.AA.IDS,@VM)
    FLG = '' ; Y.PREV.LN.NUM = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.ID = Y.AA.IDS<1,FLG>
        CALL F.READ(FN.AA,Y.ID,R.AA,F.AA,AA.ERR)
        Y.AC.ID = R.AA<AA.ARR.LINKED.APPL.ID>
        CALL F.READ(FN.AC,Y.AC.ID,R.AC,F.AC,AC.ERR)
        Y.PREV.LN.NUM<1,-1> = R.AC<AC.ALT.ACCT.ID>
        Y.CNT -= 1
    REPEAT

    O.DATA = Y.PREV.LN.NUM

RETURN

END
