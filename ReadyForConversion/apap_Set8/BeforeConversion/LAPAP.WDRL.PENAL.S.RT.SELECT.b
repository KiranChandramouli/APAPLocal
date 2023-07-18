*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.WDRL.PENAL.S.RT.SELECT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT T24.BP I_F.DATES
    $INSERT BP I_F.ST.LAPAP.DECREASE.CHG.PAR
    $INSERT LAPAP.BP I_LAPAP.WDRL.PENAL.S.RT.COMMON

    GOSUB DO.SELECT
    RETURN

DO.SELECT:
    P.CATEGORIES = Y.PA.CATEGORY;
    CHANGE @VM TO ' ' IN P.CATEGORIES
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.AC : " WITH CATEGORY EQ " : P.CATEGORIES

    CALL OCOMO("RUNNING WITH SELECT LIST : " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.REC)

    RETURN

END
