* @ValidationCode : MjotMTkzNTk5NTE4MTpDcDEyNTI6MTY4NDQ5MTAzMDkxOTpJVFNTOi0xOi0xOjg1NDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 854
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHECK.INTEREST.AMT.NCF(ACC.ID,TXN.REF,Y.AMT.RET)
*--------------------------------------------------------------------------------
* Description: This routine is to get the Interest Balance for the arrangement
* that is repaid based on parameterization of REDO.L.NCF.STOCK.
*--------------------------------------------------------------------------------
* Modification History:
* Date              Reference            Who         Description
* 24 Jan 2012    PACS00175283 -N.45     H GANESH     INITIAL DRAFT
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - CALL RTN FORMAT MODIFIED
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.REFERENCE.DETAILS
    $INSERT I_F.AA.ACTIVITY.BALANCES
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.L.NCF.STOCK


    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*--------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------
    FN.REDO.L.NCF.STOCK = 'F.REDO.L.NCF.STOCK'
    F.REDO.L.NCF.STOCK  = ''
    CALL OPF(FN.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK)

    FN.AA.REFERENCE.DETAILS = 'F.AA.REFERENCE.DETAILS'
    F.AA.REFERENCE.DETAILS  = ''
    CALL OPF(FN.AA.REFERENCE.DETAILS,F.AA.REFERENCE.DETAILS)

    FN.AA.ACTIVITY.BALANCES = 'F.AA.ACTIVITY.BALANCES'
    F.AA.ACTIVITY.BALANCES = ''
    CALL OPF(FN.AA.ACTIVITY.BALANCES,F.AA.ACTIVITY.BALANCES)

    FN.AA.ARRANGEMENT.ACTIVITY$NAU = 'F.AA.ARRANGEMENT.ACTIVITY$NAU'
    F.AA.ARRANGEMENT.ACTIVITY$NAU  = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY$NAU,F.AA.ARRANGEMENT.ACTIVITY$NAU)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY  = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------

    Y.AMT.RET = 0
    IF ACC.ID AND TXN.REF ELSE
        RETURN
    END
    CALL CACHE.READ(FN.REDO.L.NCF.STOCK,'SYSTEM',R.NCF.STOCK,ST.ERR)
    Y.AA.IC.TYPE = R.NCF.STOCK<ST.AA.IC.TYPE>

    GOSUB CHECK.TXN

RETURN
*--------------------------------------------------------------------------------
CHECK.TXN:
*--------------------------------------------------------------------------------

*CALL REDO.CONVERT.ACCOUNT(ACC.ID,'',ARR.ID,ERR.TEXT) ;*R22 MANUAL CODE CONVERSION
    APAP.TAM.redoConvertAccount(ACC.ID,'',ARR.ID,ERR.TEXT)  ;*R22 MANUAL CODE CONVERSION
    CALL F.READ(FN.AA.REFERENCE.DETAILS,ARR.ID,R.AA.REFERENCE.DETAILS,F.AA.REFERENCE.DETAILS,AA.REF.ERR)
    LOCATE TXN.REF IN R.AA.REFERENCE.DETAILS<AA.REF.TRANS.REF,1> SETTING POS1 THEN
        Y.AAA.ID = R.AA.REFERENCE.DETAILS<AA.REF.AAA.ID,POS1>
        GOSUB GET.LIST.OF.AAA     ;* Including child activity
        CALL F.READ(FN.AA.ACTIVITY.BALANCES,ARR.ID,R.AA.ACTIVITY.BALANCES,F.AA.ACTIVITY.BALANCES,AA.ACT.ERR)
        Y.ACT.CNT = DCOUNT(Y.FINAL.AAA.ID,@FM)
        Y.LOOP1 = 1
        LOOP
        WHILE Y.LOOP1 LE Y.ACT.CNT
            Y.AAA.ID.INDV = Y.FINAL.AAA.ID<Y.LOOP1>
            LOCATE Y.AAA.ID.INDV IN R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.ACTIVITY.REF,1> SETTING POS2 THEN
                Y.PROPERTY     = R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.PROPERTY,POS2>
                Y.PROPERTY.BAL.TYPE = FIELDS(Y.PROPERTY,'.',2)
                Y.PROPERTY.AMT = R.AA.ACTIVITY.BALANCES<AA.ACT.BAL.PROPERTY.AMT,POS2>
                GOSUB CALC.AMT
            END
            Y.LOOP1 += 1 ;* R22 Auto conversion
        REPEAT
    END
RETURN
*--------------------------------------------------------------------------------
CALC.AMT:
*--------------------------------------------------------------------------------
    Y.AA.IC.TYPE.CNT = DCOUNT(Y.AA.IC.TYPE,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.AA.IC.TYPE.CNT
        Y.PARAM.BAL.TYPE = Y.AA.IC.TYPE<1,Y.VAR1>
        LOCATE Y.PARAM.BAL.TYPE IN Y.PROPERTY.BAL.TYPE<1,1,1> SETTING POS3 THEN
            Y.AMT.RET += Y.PROPERTY.AMT<1,1,POS3>
        END
        Y.VAR1 += 1 ;* R22 Auto conversion
    REPEAT
RETURN
*--------------------------------------------------------------------------------
GET.LIST.OF.AAA:
*--------------------------------------------------------------------------------
* We are looping till the each child activity, since the payoff master activity doesnt hold the child activity of payoff charge.

    Y.FINAL.AAA.ID = Y.AAA.ID
    Y.LOOP.MAX = 1    ;* We will initialize as 1 for MAX loop, later it will be increased based on no. of child in each activity.
    Y.LOOP.CNT = 1
    LOOP
    WHILE Y.LOOP.CNT LE Y.LOOP.MAX

        Y.AAA.ID = Y.FINAL.AAA.ID<Y.LOOP.CNT>
        R.AAA = ''
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY$NAU,Y.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY$NAU,AAA.ERR)
        IF R.AAA ELSE
            CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.ID,R.AAA,F.AA.ARRANGEMENT.ACTIVITY,AAA.ERR)
        END
        Y.CHILD.ACTIVITY = R.AAA<AA.ARR.ACT.CHILD.ACTIVITY>
        CHANGE @VM TO @FM IN Y.CHILD.ACTIVITY
        Y.CHILD.CNT = DCOUNT(Y.CHILD.ACTIVITY,@FM)
        IF Y.CHILD.ACTIVITY THEN
            Y.FINAL.AAA.ID<-1> = Y.CHILD.ACTIVITY
        END
        Y.LOOP.MAX += Y.CHILD.CNT ;* count is increased to loop through child activity. ;* R22 Auto conversion
        Y.LOOP.CNT += 1 ;* R22 Auto conversion
    REPEAT
RETURN
END
