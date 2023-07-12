SUBROUTINE REDO.B.AA.ACC.NEG.VAL.SELECT
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*                       Ashokkumar.V.P                  07/09/2015
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_REDO.B.AA.ACC.NEG.VAL.COMMON


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
