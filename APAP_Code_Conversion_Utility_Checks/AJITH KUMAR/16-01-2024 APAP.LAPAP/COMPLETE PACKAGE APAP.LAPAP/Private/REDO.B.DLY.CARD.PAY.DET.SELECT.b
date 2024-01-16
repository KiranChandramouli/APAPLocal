$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.DLY.CARD.PAY.DET.SELECT

*******************************************************************************************
* Description: The REPORT to capture the vision plus transaction posted on last working day.
* Dev By:V.P.Ashokkumar
*
*******************************************************************************************
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion         INSERT FILE MODIFIED
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.VISION.PLUS.TXN
    $INSERT I_REDO.B.DLY.CARD.PAY.DET.COMMON  ;*R22 AUTO CODE CONVERSION.END
   $USING EB.Service


    GOSUB INIT
    GOSUB SELECT.DET
RETURN

INIT:
******
    SEL.VISION = ''; VISION.REC = ''; VISION.LST = ''; VISION.SERR = ''; YLOC.POSN = ''
RETURN

SELECT.DET:
************
*    CALL EB.CLEAR.FILE(FN.DR.OPER.VPLUS.WORKFILE,F.DR.OPER.VPLUS.WORKFILE)
EB.Service.ClearFile(FN.DR.OPER.VPLUS.WORKFILE,F.DR.OPER.VPLUS.WORKFILE);* R22 UTILITY AUTO CONVERSION
    SEL.VISION = "SELECT ":FN.REDO.VISION.PLUS.TXN:" WITH POSTING.DATE EQ ":YLWORK.DAY
    CALL EB.READLIST(SEL.VISION,VISION.REC,'',VISION.LST,VISION.SERR)
*    CALL BATCH.BUILD.LIST('',VISION.REC)
EB.Service.BatchBuildList('',VISION.REC);* R22 UTILITY AUTO CONVERSION
RETURN

END
