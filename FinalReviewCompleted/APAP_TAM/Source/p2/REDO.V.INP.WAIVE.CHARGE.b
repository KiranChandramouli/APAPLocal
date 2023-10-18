* @ValidationCode : MjotMTc1ODI4MDI2MDpDcDEyNTI6MTY4NDQ5MTA0NDgzMDpJVFNTOi0xOi0xOi03OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.V.INP.WAIVE.CHARGE
*-------------------------------------------------------------------------
*DESCRIPTION:
*~~~~~~~~~~~~
* This routine is attached as the Input routine for the versions REDO.ADMIN.CHQ.DETAILS,STOP.PAY
*

*-------------------------------------------------------------------------
*DEVELOPMENT DETAILS:
*~~~~~~~~~~~~~~~~~~~~
*
*   Date          who           Reference            Description
*   ~~~~          ~~~           ~~~~~~~~~            ~~~~~~~~~~~
* 12-02-2011     Ganeeh R        HD1052250     Initial Creation
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ADMIN.CHQ.DETAILS
    $INSERT I_GTS.COMMON

    GOSUB PROCESS

RETURN
*---------------------------------------------------------------------------
PROCESS:

    VAR.WAIVE.CHG = R.NEW(ADMIN.CHQ.DET.WAIVE.CHG)

    IF VAR.WAIVE.CHG EQ 'YES' THEN
        TEXT = "REDO.WAIVE.CHARGE"
        CURR.NO = DCOUNT(R.NEW(ADMIN.CHQ.DET.OVERRIDE),@VM) + 1 ;*R22 AUTO CONVERSION
        CALL STORE.OVERRIDE(CURR.NO)
    END

RETURN
END
