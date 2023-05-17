*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.DEBTOR.PUNISH.SELECT
*-----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine selects files in REDO.ACCT.MRKWOF.HIST then check with conditions in AA.ARRANGEMENT
*                         whether status is expired or current and Product line equal to Lending and Product group
*                         equal to HIPOTECARIO, CONSUMO, COMERCIAL, LINEAS.DE.CREDITO, LINEA.CREDITO.TC
*
* Developed By          : Nowful Rahman M
*
* Development Reference : 202_DE05
*
* Attached To           : BNK/REDO.B.DEBTOR.PUNISH
*
* Attached As           : Batch Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* XXXX                   <<name of modifier>>                                 <<modification details goes here>>
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT TAM.BP I_REDO.B.DEBTOR.PUNISH.COMMON

    GOSUB SEL.THE.FILE
    RETURN
*-----------------------------------------------------------------------------------------------------------------
SEL.THE.FILE:
*-----------------------------------------------------------------------------------------------------------------
*Select REDO.ACCT.MRKWOF.HIST
*-----------------------------------------------------------------------------------------------------------------
    CALL EB.CLEAR.FILE(FN.DR.REG.DE05.WORKFILE, F.DR.REG.DE05.WORKFILE)
    SEL.CMD = "SELECT ":FN.REDO.ACCT.MRKWOF.HIST
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
    RETURN
*-----------------------------------------------------------Final End------------------------------------------------------
END
