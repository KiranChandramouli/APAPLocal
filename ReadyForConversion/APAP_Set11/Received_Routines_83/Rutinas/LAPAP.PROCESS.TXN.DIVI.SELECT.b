*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.PROCESS.TXN.DIVI.SELECT
***********************************************************
*----------------------------------------------------------
*
* COMPANY NAME    : APAP
* DEVELOPED BY    : ROQUEZADA
*
*----------------------------------------------------------
*
* DESCRIPTION     : AUTHORISATION routine to be used in FT versions
*                   to save USD/EUR transfer in historic table
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE       DESCRIPTION
*2022-09-12       ROQUEZADA                           CREATE
*----------------------------------------------------------------------
*
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_GTS.COMMON
    $INSERT T24.BP I_System
    $INSERT BP I_F.ST.LAPAP.TRANS.DIVISA.SDT
    $INSERT LAPAP.BP I_LAPAP.PROCESS.TXN.DIV.COMMON

    GOSUB SELECT

    RETURN

* ===
SELECT:
* ===

    NO.OF.REC = ''; SEL.ERR = ''; Y.COUNT.DIV = ''; DIV.POS = '';
    SEL.CMD = "SELECT ":FN.TRANS.DIVISA.SDT:" WITH STATUS.REG EQ ":Y.STATUS.REG;
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
    Y.COUNT.DIV = DCOUNT(SEL.LIST,FM);

    IF Y.COUNT.DIV GT 0 THEN
        Y.DATA = SEL.LIST;
        CALL BATCH.BUILD.LIST('',SEL.LIST)
    END

RETURN

END
