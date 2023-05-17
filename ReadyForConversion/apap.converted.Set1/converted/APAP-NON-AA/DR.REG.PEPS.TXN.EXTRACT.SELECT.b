SUBROUTINE DR.REG.PEPS.TXN.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.PEPS.TXN.EXTRACT
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 10000 USD made by individual customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 15-Aug-2014     V.P.Ashokkumar       PACS00396224 - Initial Release
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.PEPS.TXN.EXTRACT.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM

    GOSUB INIT
    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*
* Clear workfile before build for this run.
    CALL EB.CLEAR.FILE(FN.DR.REG.PEPS.WORKFILE,F.DR.REG.PEPS.WORKFILE)
*
    SEL.CMD = "SELECT ":FN.DR.REG.213IF01.CONCAT:" WITH CUST.RELATION EQ 'PEP' AND WITH CR.DATE GE ":YST.DAT:" AND CR.DATE LE ":YED.DAT:" BY @ID"
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
*
RETURN

INIT:
*****

    LAST.WRK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    YLST.MTH = LAST.WRK.DATE
    BEGIN CASE
        CASE LAST.WRK.DATE[5,2] EQ '06'
            YST.DAT = YLST.MTH[1,4]:'0101'
            YED.DAT = YLST.MTH[1,4]:'0630'
        CASE LAST.WRK.DATE[5,2] EQ '12'
            YST.DAT = YLST.MTH[1,4]:'0701'
            YED.DAT = YLST.MTH[1,4]:'1231'
        CASE 1
            YST.DAT = LAST.WRK.DATE[1,6]:'01'
            YED.DAT = LAST.WRK.DATE
    END CASE
RETURN
END
