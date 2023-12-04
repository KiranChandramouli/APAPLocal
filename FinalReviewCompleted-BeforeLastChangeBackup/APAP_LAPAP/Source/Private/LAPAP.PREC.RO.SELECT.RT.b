* @ValidationCode : MjotMTc0ODA1ODQ2OkNwMTI1MjoxNzAwODQyNjc0Njc1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Nov 2023 21:47:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
*********************************************************************************************************
*Modification Details:
*=====================
*  Date              Who                 Reference                  Description
*  24/11/2023        Santosh          R22 Manual Conversion    BP Removed From Inserts, Changed FM/VM/ to @FM/@VM

*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.PREC.RO.SELECT.RT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_System
    $INSERT I_F.LAPAP.AZ.PENAL.RATE
    $USING APAP.REDORETAIL
    GOSUB INIT
    GOSUB MAIN.PROCESS

RETURN

INIT:
    FN.LAPAP.AZ.PENAL.RATE = 'F.ST.LAPAP.AZ.PENAL.RATE'
    F.LAPAP.AZ.PENAL.RATE = ''
    CALL OPF(FN.LAPAP.AZ.PENAL.RATE,F.LAPAP.AZ.PENAL.RATE)
RETURN

MAIN.PROCESS:
    Y.CATEGORY = R.NEW(AZ.CATEGORY)
    Y.CREATE.DATE = R.NEW(AZ.CREATE.DATE)

    GOSUB DO.READ.PARA
*DEBUG
*If AZ Create Date es greater or equal than the new penalty start date, lets use new schema, else old one...
    IF Y.REF.DATE NE '' AND Y.CREATE.DATE GE Y.REF.DATE THEN
*       CALL LAPAP.AZ.AC.PREC.REC.RO.RT
        APAP.LAPAP.lapapAzAcPrecRecRoRt() ;*R22 Manual Conversion
    END ELSE
*       CALL REDO.AZ.AC.PREC.REC.ROLL.OVER
        APAP.REDORETAIL.redoAzAcPrecRecRollOver() ;*R22 Manual Conversion
        
    END

RETURN

DO.READ.PARA:
    IF Y.CATEGORY NE '' THEN
        CALL F.READ(FN.LAPAP.AZ.PENAL.RATE,Y.CATEGORY,R.LAPAP.AZ.PENAL.RATE,F.LAPAP.AZ.PENAL.RATE,Y.AZ.P.ERR)

        Y.REF.DATE = R.LAPAP.AZ.PENAL.RATE<ST.LAP50.FROM.DATE>

    END
RETURN

END
