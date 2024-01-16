* @ValidationCode : MjotMTM3ODYwMDY1NDpDcDEyNTI6MTY5Mjg4MTcwNTkxMTpJVFNTOi0xOi0xOi01OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Aug 2023 18:25:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -5
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CARDNO.MIG.RT.SELECT
*-----------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion     BP is removed from insert file.
*-------------------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE  ;*R22 MANUAL CODE CONVERSION.START
    $INSERT I_F.COMPANY
    $INSERT I_F.LAPAP.BIN.SEQ.CTRL
    $INSERT I_F.LAPAP.CARD.GEN.CARDS
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_LAPAP.CARDNO.MIG.COMMON ;*R22 MANUAL CODE CONVERSION.END
   $USING EB.Service
    GOSUB SELECTOR

RETURN

SELECTOR:
    SEL.CMD = 'SELECT ' : FN.REDO.CARD.NUMBERS
    CALL EB.READLIST(SEL.CMD,KEY.LIST,'',SELECTED,SYSTEM.RET.CODE)
*    CALL BATCH.BUILD.LIST('',KEY.LIST)
EB.Service.BatchBuildList('',KEY.LIST);* R22 UTILITY AUTO CONVERSION
RETURN
END
