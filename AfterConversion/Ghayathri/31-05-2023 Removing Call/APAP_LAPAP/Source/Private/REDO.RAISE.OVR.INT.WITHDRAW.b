* @ValidationCode : MjotMjkzODI4NjQwOkNwMTI1MjoxNjg0MjIyODMzOTYxOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:33
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
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            VM TO @VM
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.RAISE.OVR.INT.WITHDRAW
*-----------------------------------------------------------

*-----------------------------------------------------------
* Input  Arg: N/A
* Output Arg: N/A
* Deals With: TO Raise Override to have an approval for the withdraw from an internal account using the version TELLER,REDO.EFC.PAG.OTROS
*--------------------------------------------------------------
* Who           Date           Dev Ref           Modification
* APAP          22 May 2017    RTE Fix           Initial Draft
*--------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.VERSION
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER

    IF OFS$OPERATION NE 'PROCESS' THEN
        RETURN
    END

    CURR.NO = DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM)
    VAR.OVERRIDE.ID = 'REDO.AUTH.REQUIRED'
    TEXT    = VAR.OVERRIDE.ID
    CALL STORE.OVERRIDE(CURR.NO+1)

RETURN

END
