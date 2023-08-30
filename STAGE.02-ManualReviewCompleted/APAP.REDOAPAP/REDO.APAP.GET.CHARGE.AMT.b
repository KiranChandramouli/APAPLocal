* @ValidationCode : MjotMTM0NjY3NDQyMzpDcDEyNTI6MTY4MTM2ODU0NTkxNjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 12:19:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
* Version 3 02/06/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.APAP.GET.CHARGE.AMT(ARR.ID,Y.PROD.ID,Y.START.DATE,Y.END.DATE,CHARGE.AMT,Y.PENAL.AMT)
*-----------------------------------------------------------------------------
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.GET.CHARGE.AMT
* ODR NO      : ODR-2010-03-0176

*----------------------------------------------------------------------
*DESCRIPTION: This routine calculates the charge amount for the arrangement ID passed (Scheduled & Activity charges)


*IN PARAMETER:   ARR.ID
*OUT PARAMETER:  CHARGE.AMT
*LINKED WITH:    REDO.APAP.OUTSTANDING.LOAN.DETAILS
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.11.2010  H GANESH      ODR-2010-03-0176    INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , FM to @FM, SM to @SM, ++ to +=
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*----------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.AA.OVERDUE
*-----------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    Y.TOTAL.CHARGE.AMT=0
    Y.PENAL.AMT=0
    CALL CACHE.READ('F.REDO.APAP.PROPERTY.PARAM',Y.PROD.ID,R.REDO.APAP.PROPERTY.PARAM,PARA.ERR)
    Y.PENAL.PROP=R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PENALTY.ARREAR>
    CHANGE @VM TO @FM IN Y.PENAL.PROP

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB OVERDUE.STATUS
*  CHANGE VM TO FM IN Y.OVERDUE.STATUS
    CHANGE @SM TO @FM IN Y.OVERDUE.STATUS
    Y.OVERDUE.STATUS = 'DUE':@FM:Y.OVERDUE.STATUS
    Y.BAL.TYPE.CNT=DCOUNT(Y.OVERDUE.STATUS,@FM)
    GOSUB GET.CHARGE.PROPERTY
    Y.CHRG.CNT=DCOUNT(Y.CHARGE.PROPERTY,@FM)
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,Y.ACCT.NO,ERR.TEXT)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.CHRG.CNT
        Y.CHARGE.ID=Y.CHARGE.PROPERTY<Y.VAR1>
        GOSUB GET.BALANCE.CHARGE
        Y.VAR1 += 1   ;*R22 AUTO CONVERSION
    REPEAT

    CHARGE.AMT=Y.TOTAL.CHARGE.AMT

RETURN
*-----------------------------------------------------------------------------
OVERDUE.STATUS:
*-----------------------------------------------------------------------------
* This part gets the Overdue Status of that Arrangement

    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.OVERDUE.CONDITION,ERR.MSG)
**************** changes made 9th dec ******************
    Y.OVERDUE.STATUS=R.OVERDUE.CONDITION<AA.OD.OVERDUE.STATUS>
********************* changes made 9th dec ******************
RETURN
*-----------------------------------------------------------------------------
GET.CHARGE.PROPERTY:
*-----------------------------------------------------------------------------
* This part get the charge properties for that loan

    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHARGE.PROPERTY,OUT.ERR)

RETURN
*-----------------------------------------------------------------------------
GET.BALANCE.CHARGE:
*-----------------------------------------------------------------------------
* This part calculates the charges for each balance type and also calculates the charge amt for penalty due to arrears

    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.BAL.TYPE.CNT
        Y.BALANCE.TYPE=Y.OVERDUE.STATUS<Y.VAR2>:Y.CHARGE.ID
        BALANCE.AMOUNT = ''
        CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ACCT.NO,Y.BALANCE.TYPE,TODAY,BALANCE.AMOUNT,RET.ERROR)
        Y.TOTAL.CHARGE.AMT+=ABS(BALANCE.AMOUNT)
        LOCATE Y.CHARGE.ID IN Y.PENAL.PROP SETTING POS1 THEN
            Y.PENAL.AMT+=ABS(BALANCE.AMOUNT)
        END
        Y.VAR2 += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT
RETURN
END
