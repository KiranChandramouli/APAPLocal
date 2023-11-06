$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.213IF01.RTE.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.213IF01.RTE.EXTRACT.SELECT
* Date           : 07-Mar-2018
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 15000 USD made by individual customer
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
* 07-Mar-2018     Bernard Gladin S    Initial Version
*  06-11-2023      HARISHVIKRAM C   R22 Manual Conversion  / removed in INSERT file "I_DR.REG.213IF01.RTE.EXTRACT.COMMON"
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.CURRENCY

    $INSERT I_DR.REG.213IF01.RTE.EXTRACT.COMMON
    $INSERT I_F.DR.REG.213IF01.PARAM

    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
*
* Clear workfile before build for this run.
    CALL EB.CLEAR.FILE(FN.REDO.RTE.IF.WORKFILE,F.REDO.RTE.IF.WORKFILE)

    SEL.CMD = ''; BUILD.LIST = ''; Y.SEL.CNT = ''; Y.ERR = ''; YID.VAL = ''
*    Y.START.DATE = '20170915'
    IF ymend EQ 1 THEN
        YID.VAL = 'FIELD(@ID,".",2)'
        SEL.CMD = "SELECT ":FN.REDO.RTE.CUST.CASHTXN:" WITH (EVAL'":YID.VAL:"' GE ":Y.START.DATE:" AND EVAL'":YID.VAL:"' LE ":Y.END.DATE:")"
    END ELSE
        SEL.CMD = "SELECT ":FN.REDO.RTE.CUST.CASHTXN:" WITH @ID LIKE ....":Y.START.DATE
    END

    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)
RETURN

END
