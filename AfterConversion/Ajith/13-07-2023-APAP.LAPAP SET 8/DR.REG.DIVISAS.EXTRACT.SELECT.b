$PACKAGE APAP.LAPAP
SUBROUTINE DR.REG.DIVISAS.EXTRACT.SELECT
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Program Name   : DR.REG.DIVISAS.EXTRACT
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the Buying and selling currencies
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 05-Dec-2017  Ashokkumar.V.P      CN007023 - Initial Version.
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INCLUDE to INSERT
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_DR.REG.DIVISAS.EXTRACT.COMMON ;*R22 Auto code conversion
    $INSERT I_F.DR.REG.FD01.PARAM


    GOSUB SEL.PROCESS
RETURN

SEL.PROCESS:
************
    CALL EB.CLEAR.FILE(FN.DR.REG.DIVIAS.WORKFILE, F.DR.REG.DIVIAS.WORKFILE)
    R.DR.REG.FD01.CONCAT = ''; ERR.DR.REG.FD01.CONCAT = ''
    CALL F.READ(FN.DR.REG.FD01.CONCAT,Y.LAST.DATE.TIME,R.DR.REG.FD01.CONCAT,F.DR.REG.FD01.CONCAT,ERR.DR.REG.FD01.CONCAT)
    CALL BATCH.BUILD.LIST('',R.DR.REG.FD01.CONCAT)
RETURN

END
