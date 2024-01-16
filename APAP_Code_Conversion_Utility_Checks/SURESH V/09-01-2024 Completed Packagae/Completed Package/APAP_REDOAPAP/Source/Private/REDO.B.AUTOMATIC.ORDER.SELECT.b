* @ValidationCode : MjoyMDQwNzM5NTk1OkNwMTI1MjoxNzAzMTQyNTc3ODg0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Dec 2023 12:39:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
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
*20/12/2023         Suresh          R22 Manual Conversion      CALL routine modified
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AUTOMATIC.ORDER.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.REORDER.DEST
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_GTS.COMMON
*   $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_F.CARD.TYPE
    
    $USING EB.Service ;*R22 Manual Conversion

*    SEL.LIST.SR = 1

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>PACS00036010<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


    SEL.CMD.SR = "SELECT ":FN.REDO.CARD.REORDER.DEST
    CALL EB.READLIST(SEL.CMD.SR,SEL.LIST.SR,'',NO.REC,PGM.ERR)

*>>>>>>>>>>>>>>>>>>>>>>>>>>>PACS00036010<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

*    CALL BATCH.BUILD.LIST('',SEL.LIST.SR)
    EB.Service.BatchBuildList('',SEL.LIST.SR) ;*R22 Manual Conversion
RETURN

END
