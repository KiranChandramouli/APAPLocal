SUBROUTINE DR.REG.FD01.LASTD.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Program Name   : DR.REG.FD01.LASTD.EXTRACT
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Buying and selling currencies
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 14-May-2015  Ashokkumar.V.P          PACS00309078 - Initial Version.
* 24-Jun-2015   Ashokkumar.V.P     PACS00466000 - Mapping changes - Fetch customer details to avoid blank
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_DR.REG.FD01.LASTD.EXTRACT.COMMON
    $INSERT I_F.DR.REG.FD01.PARAM


    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
*******************
    YLCCY = LCCY
    CALL EB.CLEAR.FILE(FN.DR.REG.FD01.WORKFILE, F.DR.REG.FD01.WORKFILE)
    SEL.CMD = ''; SEL.IDS = ''; SELLIST = '';  SEL.STS = ''
    SEL.CMD = "SELECT ":FN.POS.MVMT.HST:" WITH SYSTEM.ID EQ 'TT' 'FT' 'FX' AND BOOKING.DATE EQ ":Y.LAST.DATE.TIME:" AND CURRENCY NE ":YLCCY
    CALL EB.READLIST(SEL.CMD,SEL.IDS,'',SELLIST,SEL.STS)
    CALL BATCH.BUILD.LIST('',SEL.IDS)
RETURN

END
