* @ValidationCode : Mjo0NzczNDE4NjpDcDEyNTI6MTcwNDQ0NTg2NDg5MTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:41:04
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
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
*    CALL F.READ(FN.REDO.APAP.FX.BRN.POSN,Y.BRANCH.ID,R.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN,ERR)
    CALL F.READU(FN.REDO.APAP.FX.BRN.POSN,Y.BRANCH.ID,R.REDO.APAP.FX.BRN.POSN,F.REDO.APAP.FX.BRN.POSN,ERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.REDO.APAP.FX.BRN.POSN THEN
        R.REDO.APAP.FX.BRN.POSN<REDO.BRN.POSN.BRN.TDY.TXN.VALUE> = ''
        CALL F.WRITE(FN.REDO.APAP.FX.BRN.POSN,Y.BRANCH.ID,R.REDO.APAP.FX.BRN.POSN)
    END
 
RETURN
END
