SUBROUTINE REDO.B.CREATE.RENEWAL.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.CREATE.RENEWAL.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the expiry date equal to last working day
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.CREATE.RENEWAL
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*12-08-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*27 MAY 2011   KAVITHA                PACS00063156          PACS00063156 FIX
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CREATE.RENEWAL.COMMON
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_GTS.COMMON

*PACS00063156-S
    SEL.CMD.CR = "SELECT ":FN.REDO.CARD.RENEWAL
    CALL EB.READLIST(SEL.CMD.CR,SEL.LIST.CR,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST.CR)
RETURN
*PACS00063156-E

END
