*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.BULK.PR.NAU.P.RT.SELECT
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_GTS.COMMON
    $INSERT T24.BP I_System
    $INSERT T24.BP I_F.DATES
    $INSERT BP I_F.LAPAP.BULK.PAYROLL
    $INSERT BP I_F.ST.LAPAP.BULK.PAYROLL.DET
    $INSERT LAPAP.BP I_LAPAP.BULK.PR.NAU.P.RT.COMMON

    GOSUB GET.IHLD.FT

    RETURN

GET.IHLD.FT:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.FTNAU : " WITH @ID LIKE FT" : Y.JULIAN.DATE : "... AND RECORD.STATUS EQ IHLD"

    CALL OCOMO("RUNNING WITH SELECT LIST : " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.REC)

    RETURN
END
