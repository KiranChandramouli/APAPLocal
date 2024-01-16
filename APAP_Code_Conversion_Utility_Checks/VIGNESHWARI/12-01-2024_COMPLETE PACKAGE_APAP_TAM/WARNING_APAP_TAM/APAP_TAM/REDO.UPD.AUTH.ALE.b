* @ValidationCode : MjotMjA4NDE2MTU4NTpVVEYtODoxNzA0OTY4OTQ4Nzk0OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Jan 2024 15:59:08
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     FM TO @FM
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPD.AUTH.ALE
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.UPD.AUTH.ALE
*--------------------------------------------------------------------------------
* Description: This is an authorisation routine to update the concat table with AC.LOCKED.EVENTS
* with @id as AA.ARRANGEMENT.ACTIVITY. This will be helpfull during the reversal of LENDING-DISBURSE-COMMITMENT
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE              DESCRIPTION
* 12-May-2011     H GANESH      PACS00054299 - B.37  INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.LOCKED.EVENTS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.REDO.CONCAT.ARR.ALE='F.REDO.CONCAT.ARR.ALE'
    F.REDO.CONCAT.ARR.ALE=''
    CALL OPF(FN.REDO.CONCAT.ARR.ALE,F.REDO.CONCAT.ARR.ALE)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
* This part write in concat table with ac locked events ids

    Y.ACTIVITY.ID=R.NEW(AC.LCK.DESCRIPTION)
*    CALL F.READ(FN.REDO.CONCAT.ARR.ALE,Y.ACTIVITY.ID,R.REDO.CONCAT.ARR.ALE,F.REDO.CONCAT.ARR.ALE,ERR)
    CALL F.READU(FN.REDO.CONCAT.ARR.ALE,Y.ACTIVITY.ID,R.REDO.CONCAT.ARR.ALE,F.REDO.CONCAT.ARR.ALE,ERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.REDO.CONCAT.ARR.ALE EQ '' THEN
        R.REDO.CONCAT.ARR.ALE<1>=ID.NEW
        GOSUB CALL.WRITE

    END ELSE
        Y.LOCK.ID.CNT=DCOUNT(R.REDO.CONCAT.ARR.ALE,@FM) ;*R22 AUTO CONVERSION
        R.REDO.CONCAT.ARR.ALE<Y.LOCK.ID.CNT+1>=ID.NEW
        GOSUB CALL.WRITE

    END

RETURN

*---------------------------------------------------------------------------------
CALL.WRITE:
*---------------------------------------------------------------------------------

    CALL F.WRITE(FN.REDO.CONCAT.ARR.ALE,Y.ACTIVITY.ID,R.REDO.CONCAT.ARR.ALE)

RETURN


END
