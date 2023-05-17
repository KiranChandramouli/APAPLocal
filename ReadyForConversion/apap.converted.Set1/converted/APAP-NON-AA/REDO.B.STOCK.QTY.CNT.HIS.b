SUBROUTINE REDO.B.STOCK.QTY.CNT.HIS(Y.SR.SEL.LIST)
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.STOCK.QTY.COUNT
*------------------------------------------------------------------------------
*DESCRIPTION:This routine is COB routine to select all STOCK.ENTRY and calculate destruction date. Attach to D990 stage
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.UPDATE.DESTRUCTION
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*31-07-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.DATES
    $INSERT I_REDO.B.STOCK.QTY.CNT.HIS.COMMON
    $INSERT I_F.REDO.STOCK.QTY.COUNT

    GOSUB PROCESS
RETURN

*---------
PROCESS:
*---------
*WRITE THE DAILY STOCK TO REDO.STOCK.QTY.COUNT TABLE
RETURN
END
