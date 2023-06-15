* @ValidationCode : MjotMjA3NjYwNjQ2MDpDcDEyNTI6MTY4MTk5NTk4NzEyODpJVFNTOi0xOi0xOjM2MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 360
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.ARRANGMENT.PROCESS(Y.AA.ID,Y.PAYMENT.AGENCY,Y.DISBURSED.AMOUNT)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.NOF.LOAN.EXP.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : CALL routine is used to calculate the payment agency and disbursed amount
*In Parameter : Y.AA.ID
*Out Parameter: Y.PAYMENT.AGENCY,Y.DISBURSED.AMOUNT
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
*  15th SEPT 2010   JEEVA T              ODR-2010-03-0152        Initial Creation

* 13-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, SM to @SM, ++ to +=
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.HISTORY

    GOSUB OPEN.FILE
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
OPEN.FILE:
*-----------------------------------------------------------------------------
    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,Y.ERR.ACT.HIS)
    IF R.AA.ACTIVITY.HISTORY THEN
        Y.CTR.ED = 1
        LOOP
            Y.EFFECTIVE.DATE.HIS = DCOUNT(R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE>,@VM)
        WHILE Y.CTR.ED LE Y.EFFECTIVE.DATE.HIS
            Y.ACTIVITY.HIS = DCOUNT(R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,Y.CTR.ED>,@SM)
            Y.CTR = 1
            LOOP
            WHILE Y.CTR LE Y.ACTIVITY.HIS
                Y.AAA.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,Y.CTR.ED,Y.CTR>
                CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.AAA.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ERR.AAA)
                GOSUB CLASS.CHECK
                Y.CTR += 1
            REPEAT
            Y.CTR.ED += 1

        REPEAT
    END

RETURN
*-----------------------------------------------------------------------------
CLASS.CHECK:
*-----------------------------------------------------------------------------
    IF R.AA.ARRANGEMENT.ACTIVITY NE '' THEN
        Y.ACTIVITY.CLASS = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ACTIVITY.CLASS>
* PACS00312713 - S
        IF Y.ACTIVITY.CLASS EQ 'LENDING-DISBURSE-TERM.AMOUNT' OR Y.ACTIVITY.CLASS EQ 'LENDING-ADJUST.BALANCE-BALANCE.MAINTENANCE' THEN
            GOSUB GET.DISB.AMT
        END

        IF Y.ACTIVITY.CLASS EQ 'LENDING-APPLYPAYMENT-PAYMENT.RULES' OR Y.ACTIVITY.CLASS EQ 'LENDING-CREDIT-ARRANGEMENT' THEN
            GOSUB PAYMEN.AGENCY     ;* PACS00313082 - 2015APR21 - S/E
        END
* PACS00312713 - E
    END

RETURN
*-----------------------------------------------------------------------------
GET.DISB.AMT:
*-----------------------------------------------------------------------------
    Y.DISBURSED.AMOUNT+= R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>
    IF Y.DISBURSED.AMOUNT EQ "" OR Y.DISBURSED.AMOUNT EQ 0 AND R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.FIELD.NAME> EQ "ADJ.BAL.AMT:1:1" THEN
        Y.DISBURSED.AMOUNT+= R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.FIELD.VALUE>
    END
*
    IF Y.ACTIVITY.CLASS EQ 'LENDING-ADJUST.BALANCE-BALANCE.MAINTENANCE' THEN
        GOSUB PAYMEN.AGENCY       ;* PACS00313082 - 2015APR21 - S/E
    END
RETURN
*-----------------------------------------------------------------------------
PAYMEN.AGENCY:
*-----------------------------------------------------------------------------
    Y.CO.CODE = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.CO.CODE>
    IF Y.PAYMENT.AGENCY NE '' THEN
        LOCATE Y.CO.CODE IN Y.PAYMENT.AGENCY SETTING CO.POS ELSE
            Y.PAYMENT.AGENCY := @VM:R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.CO.CODE>
        END
    END ELSE
        Y.PAYMENT.AGENCY = Y.CO.CODE
    END
RETURN
END
