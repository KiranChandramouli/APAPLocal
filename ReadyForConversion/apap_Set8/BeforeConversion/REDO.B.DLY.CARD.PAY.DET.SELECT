*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.DLY.CARD.PAY.DET.SELECT

*******************************************************************************************
* Description: The REPORT to capture the vision plus transaction posted on last working day.
* Dev By:V.P.Ashokkumar
*
*******************************************************************************************
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_F.DATES
    $INCLUDE TAM.BP I_F.REDO.VISION.PLUS.TXN
    $INCLUDE LAPAP.BP I_REDO.B.DLY.CARD.PAY.DET.COMMON


    GOSUB INIT
    GOSUB SELECT.DET
    RETURN

INIT:
******
    SEL.VISION = ''; VISION.REC = ''; VISION.LST = ''; VISION.SERR = ''; YLOC.POSN = ''
    RETURN

SELECT.DET:
************
    CALL EB.CLEAR.FILE(FN.DR.OPER.VPLUS.WORKFILE,F.DR.OPER.VPLUS.WORKFILE)
    SEL.VISION = "SELECT ":FN.REDO.VISION.PLUS.TXN:" WITH POSTING.DATE EQ ":YLWORK.DAY
    CALL EB.READLIST(SEL.VISION,VISION.REC,'',VISION.LST,VISION.SERR)
    CALL BATCH.BUILD.LIST('',VISION.REC)
    RETURN

END
