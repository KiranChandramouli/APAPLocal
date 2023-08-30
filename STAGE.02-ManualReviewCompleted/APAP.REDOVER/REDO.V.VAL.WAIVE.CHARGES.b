* @ValidationCode : MjotMTAxNzIyMDk2MjpDcDEyNTI6MTY4MTczNTY1ODgxNTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 17 Apr 2023 18:17:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.WAIVE.CHARGES
*----------------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.VAL.WAIVE.CHARGES
* ODR NO      : ODR-2009-12-0275
*---------------------------------------------------------------------------------------------------
* DESCRIPTION: If the field WAIVE.CHARGES is YES, an Override message has to be displayed
* IN PARAMETER:NONE
* OUT PARAMETER:NONE
* LINKED WITH: Attach this routine to REDO.H.SOLICITUD.CK,INPUT.PF and REDO.H.SOLICITUD.CK,INPUT.PJ
*------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO           REFERENCE         DESCRIPTION
*26.02.2010 S SUDHARSANAN    ODR-2009-12-0275  INITIAL CREATION
*----------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.SOLICITUD.CK
    GOSUB PROCESS
RETURN
*********************************************************
********
PROCESS:
*********


    CURR.NO=''
    Y.WAIVE.CHARGES=R.NEW(REDO.H.SOL.WAIVE.CHARGES)
    IF Y.WAIVE.CHARGES EQ 'YES' THEN
        CURR.NO=DCOUNT(R.NEW(REDO.H.SOL.OVERRIDE),@VM) + 1
        TEXT='REDO.WAIVE.CHARGES'
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
******************************************************
END
