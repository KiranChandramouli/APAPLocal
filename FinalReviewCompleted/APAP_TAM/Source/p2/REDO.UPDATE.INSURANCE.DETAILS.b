* @ValidationCode : MjotMTc1MjMyODc1MjpDcDEyNTI6MTY4NDQ5MTA0MjE2MDpJVFNTOi0xOi0xOjE5MjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 192
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPDATE.INSURANCE.DETAILS(INSURANCE.ID)

*------------------------------------------------------------------------
* Description: This routine is to update the insurance details as cancelled.
*------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_REDO.B.LOAN.CLOSURE.COMMON

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
    SEL.CMD = 'SELECT ':FN.APAP.H.INSURANCE.DETAILS:' WITH POLICY.NUMBER EQ ':INSURANCE.ID
    SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)

    Y.INSURANCE.ID = SEL.LIST<1>
    CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,Y.INSURANCE.ID,R.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS,INSURANCE.ERR)

    IF R.INSURANCE.DETAILS THEN
        R.INSURANCE.DETAILS<INS.DET.POLICY.STATUS> = 'CANCELADA'
*CALL F.WRITE(FN.APAP.H.INSURANCE.DETAILS,Y.INSURANCE.ID,R.INSURANCE.DETAILS)
        WRITE R.INSURANCE.DETAILS TO F.APAP.H.INSURANCE.DETAILS,Y.INSURANCE.ID
    END
RETURN
END
