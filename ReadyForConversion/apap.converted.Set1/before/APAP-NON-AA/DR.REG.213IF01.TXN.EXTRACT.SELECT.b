*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.213IF01.TXN.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.TXN.EXTRACT
* Date           : 2-May-2013
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
* 28-Jul-2014     V.P.Ashokkumar      PACS00309079 - Changed the selection to get correct amount
* 14-Oct-2014     V.P.Ashokkumar      PACS00309079 - Updated to filter AML transaction
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.CURRENCY

    $INCLUDE REGREP.BP I_DR.REG.213IF01.TXN.EXTRACT.COMMON
    $INCLUDE REGREP.BP I_F.DR.REG.213IF01.PARAM

    GOSUB SEL.PROCESS
    RETURN

SEL.PROCESS:
************
*
* Clear workfile before build for this run.
    CALL EB.CLEAR.FILE(FN.DR.REG.213IF01.WORKFILE,F.DR.REG.213IF01.WORKFILE)
*
    AMT.LCY = ''; THRESHOLD.FCY = ''; R.CURRENCY = ''; CURR.ERR = ''
    CUR.AMLBUY.RATE = ''; YTHRESHOLD.CCY = ''
    THRESHOLD.FCY = R.DR.REG.213IF01.PARAM<DR.213IF01.THRESHOLD.AMT>
    YTHRESHOLD.CCY = R.DR.REG.213IF01.PARAM<DR.213IF01.THRESHOLD.CCY>

    CALL CACHE.READ(FN.CURRENCY,YTHRESHOLD.CCY,R.CURRENCY,CURR.ERR)
    CUR.AMLBUY.RATE = R.CURRENCY<EB.CUR.LOCAL.REF,L.CU.AMLBUY.RT.POS>
    AMT.LCY = THRESHOLD.FCY * CUR.AMLBUY.RATE

    SEL.CMD = ''; BUILD.LIST = ''; Y.SEL.CNT = ''; Y.ERR = ''
    SEL.CMD = "SELECT ":FN.DR.REG.213IF01.CONCAT:" WITH CR.AMOUNT GE ":AMT.LCY:" AND WITH CR.DATE GE ":Y.START.DATE:" AND CR.DATE LE ":Y.END.DATE:" AND WITH CUST.RTE.FORM EQ 'YES'"
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
    RETURN

END
