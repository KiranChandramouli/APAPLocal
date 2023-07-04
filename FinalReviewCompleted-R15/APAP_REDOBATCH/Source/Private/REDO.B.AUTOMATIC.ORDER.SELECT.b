* @ValidationCode : MjotMTk2NjM0MzQ5NzpDcDEyNTI6MTY4MDc5MDEwNjk4NDpJVFNTOi0xOi0xOi0xOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AUTOMATIC.ORDER.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.AUTOMATIC.ORDER.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the Stock register table with @ID equal to CARD.ID-COMPANY
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.AUTOMATIC.ORDER
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*31-07-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*17 MAY 2010      JEEVA T             ODR-2010-03-0400      fix for PACS00036010
*                                                           select command had been changed
* 04-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AUTOMATIC.ORDER.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.REORDER.DEST
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.CARD.TYPE

*    SEL.LIST.SR = 1

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>PACS00036010<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


    SEL.CMD.SR = "SELECT ":FN.REDO.CARD.REORDER.DEST
    CALL EB.READLIST(SEL.CMD.SR,SEL.LIST.SR,'',NO.REC,PGM.ERR)

*>>>>>>>>>>>>>>>>>>>>>>>>>>>PACS00036010<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    CALL BATCH.BUILD.LIST('',SEL.LIST.SR)
RETURN

END
