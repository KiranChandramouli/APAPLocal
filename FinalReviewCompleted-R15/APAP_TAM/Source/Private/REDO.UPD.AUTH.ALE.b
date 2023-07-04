* @ValidationCode : MjotNzc3NTE2NjM0OkNwMTI1MjoxNjg0NDkxMDQxNjE2OklUU1M6LTE6LTE6Mjc3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 277
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
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
    CALL F.READ(FN.REDO.CONCAT.ARR.ALE,Y.ACTIVITY.ID,R.REDO.CONCAT.ARR.ALE,F.REDO.CONCAT.ARR.ALE,ERR)
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
