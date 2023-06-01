* @ValidationCode : MjoyMDEyNDMyMTAxOkNwMTI1MjoxNjg0ODU0Mzk1MjU0OklUU1M6LTE6LTE6MjkyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 292
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REINV.BAL.UPDATE(Y.AZ.ID)
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.REINV.BAL.UPDATE
*--------------------------------------------------------------------------------
* Description: This Batch routine is too update the balance of reinvest interest liq acc
* in AZ.ACCOUNT
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE          DESCRIPTION
* 05-Jul-2011    H GANESH      PACS00072695_N.11 INITIAL CREATION
* Date                  who                   Reference              
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_REDO.B.REINV.BAL.UPDATE.COMMON


    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    R.AZ.ACCOUNT = ''
    R.ACCOUNT = ''

    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    Y.INT.LIQ.ACC = R.AZ.ACCOUNT<AZ.INTEREST.LIQU.ACCT>
    IF Y.INT.LIQ.ACC THEN
        CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        Y.INT.LIQ.BAL = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.AV.BAL>
        R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.AZ.REIVSD.INT> = Y.INT.LIQ.BAL
        CALL F.WRITE(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACCOUNT)
*    CALL REDO.AZ.WRITE.TRACE("REDO.B.REINV.BAL.UPDATE",Y.AZ.ID)
    END
RETURN
END
