SUBROUTINE REDO.B.UPD.SETT.RISK.SELECT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.UPD.SETT.RISK.SELECT
*--------------------------------------------------------------------------------------------------------
*Description       : The routine is the .SELECT routine for the multithreade batch routine
*                    REDO.B.UPD.SETT.RISK. The files of REDO.APAP.FX.LIMIT are selected in this section
*In Parameter      : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  11/11/2010   A.SabariKumar                     ODR-2010-07-0075                Initial Creation
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FX.PARAMETERS
    $INSERT I_F.REDO.APAP.FX.LIMIT
    $INSERT I_REDO.B.UPD.SETT.RISK.COMMON

    GOSUB SEL.REC
RETURN

*--------------------------------------------------------------------------------------------------------
SEL.REC:
*-------
* Calls the core routine EB.READLIST and selects the records of REDO.APAP.FX.LIMIT

    Y.TODAY = TODAY
    IF Y.TODAY GT Y.PARAMETER.DATE ELSE
        SEL.CMD = "SELECT ":FN.REDO.APAP.FX.LIMIT: " WITH PRE.SETT.RISK NE '' AND SETT.RISK EQ ''"
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        CALL BATCH.BUILD.LIST('',SEL.LIST)
    END
RETURN

*--------------------------------------------------------------------------------------------------------
END
