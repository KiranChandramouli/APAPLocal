* @ValidationCode : MjotNTA1NjIwMjkwOkNwMTI1MjoxNjgxMzY0NTQ5MDI5OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 11:12:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.BRANCH.LIMIT(Y.BRANCH.ID)

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.UPD.BRANCH.LIMIT
*--------------------------------------------------------------------------------
* Description: This is batch routine to clear the daily balance for each branch
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 20-Oct-2011    Pradeep S      PACS00149084      INITIAL CREATION
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.FX.BRN.POSN
    $INSERT I_REDO.B.UPD.BRANCH.LIMIT.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    R.REDO.APAP.FX.BRN.POSN = ''
    CALL F.READ(FN.REDO.APAP.FX.BRN.POSN,Y.BRANCH.ID,R.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN,ERR)
    IF R.REDO.APAP.FX.BRN.POSN THEN
        R.REDO.APAP.FX.BRN.POSN<REDO.BRN.POSN.BRN.TDY.TXN.VALUE> = ''
        CALL F.WRITE(FN.REDO.APAP.FX.BRN.POSN,Y.BRANCH.ID,R.REDO.APAP.FX.BRN.POSN)
    END

RETURN
END
