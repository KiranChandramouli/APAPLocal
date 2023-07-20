*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.AA.ACC.NEG.VAL.SELECT
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*                       Ashokkumar.V.P                  07/09/2015      
*--------------------------------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE T24.BP I_ENQUIRY.COMMON
    $INCLUDE T24.BP I_F.AA.ARRANGEMENT
    $INCLUDE T24.BP I_F.EB.CONTRACT.BALANCES
    $INCLUDE LAPAP.BP I_REDO.B.AA.ACC.NEG.VAL.COMMON


    GOSUB MAIN.PROCESS
    RETURN

MAIN.PROCESS:
*************
    CALL EB.CLEAR.FILE(FN.DR.REG.AA.PROB.WORKFILE, F.DR.REG.AA.PROB.WORKFILE)
    SEL.CMD = ''; SEL.LIST = ''; SEL.CNT = ''; ERR.SEL = ''
    SEL.CMD = "SSELECT ":FN.AA.ARR:" WITH PRODUCT.LINE EQ 'LENDING'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.CNT,ERR.SEL)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
    RETURN
END
