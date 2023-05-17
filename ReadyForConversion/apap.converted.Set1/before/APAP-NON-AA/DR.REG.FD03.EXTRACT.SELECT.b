*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.FD03.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.FD03.EXTRACT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the transactions over 1000 USD made by individual customer
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES

    $INCLUDE REGREP.BP I_DR.REG.FD03.EXTRACT.COMMON
    $INCLUDE REGREP.BP I_F.DR.REG.FD03.PARAM

    GOSUB SEL.PROCESS

    RETURN

*-----------------------------------------------------------------------------
SEL.PROCESS:
************

    CALL EB.CLEAR.FILE(FN.DR.REG.FD03.WORKFILE, F.DR.REG.FD03.WORKFILE)         ;* Clear the WORK file before building for Today

    SEL.CMD = ''
    BUILD.LIST = ''
    Y.SEL.CNT = ''
    Y.ERR = ''
    SEL.CMD = "SELECT ":FN.DR.REG.FD03.CONCAT:" WITH @ID GE ":REP.STRT.DATE:" AND WITH @ID LE ":REP.END.DATE
    CALL EB.READLIST(SEL.CMD,BUILD.LIST,'',Y.SEL.CNT,Y.ERR)
    CALL BATCH.BUILD.LIST('',BUILD.LIST)

    RETURN

*-----------------------------------------------------------------------------
END
