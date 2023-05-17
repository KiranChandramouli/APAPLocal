*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.BLD.OPER.DIVISAS.SELECT
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date        Author             Modification Description
* 12-Sep-2014   V.P.Ashokkumar     PACS00318671 - Rewritten to create 2 reports.
* 24-Jun-2015   Ashokkumar.V.P     PACS00466000 - Mapping changes - Fetch customer details to avoid blank.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INCLUDE REGREP.BP I_DR.BLD.OPER.DIVISAS
    $INCLUDE TAM.BP I_F.REDO.FX.CCY.POSN

    IF NOT(CONTROL.LIST) THEN
        GOSUB BUILD.CONTROL.LIST
    END

    GOSUB SEL.PROCESS
    RETURN

BUILD.CONTROL.LIST:
*******************

    CALL EB.CLEAR.FILE(FN.DR.OPER.DIVISAS.FILE,F.DR.OPER.DIVISAS.FILE)

    CONTROL.LIST<-1> = "FOREX"
    CONTROL.LIST<-1> = "POS.MVMT.HST"
    RETURN

SEL.PROCESS:
************
    YLCCY = LCCY
    SEL.LIST =  '' ; SEL.STS = ''; SEL.IDS = ''
    BEGIN CASE
    CASE CONTROL.LIST<1,1> EQ 'FOREX'
        SEL.CMD = "SELECT ":FN.FOREX:" WITH VALUE.DATE.BUY EQ ":Y.LAST.WRK.DAY:" OR WITH VALUE.DATE.SELL EQ ":Y.LAST.WRK.DAY
    CASE CONTROL.LIST<1,1> EQ 'POS.MVMT.HST'
        SEL.CMD = "SELECT ":FN.POS.MVMT.HST:" WITH SYSTEM.ID EQ 'TT' 'FT' AND BOOKING.DATE EQ ":Y.LAST.WRK.DAY:" AND CURRENCY NE ":YLCCY
    END CASE

    CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SELLIST,SEL.STS)
    CALL BATCH.BUILD.LIST('',SEL.IDS)
    RETURN
END
