*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.M.PROP.NONRES.SELECT

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_REDO.B.M.PROP.NONRES.COMMON
*
    GOSUB PROCESS.PARA
*
    RETURN
*
PROCESS.PARA:
*------------
    SEL.CMD = ''
    Y.CUST.IDS = ''
    NO.REC = ''
    SEL.CMD = 'SELECT ':FN.CUSTOMER:' WITH RESIDENCE NE ':FL.PARAM.RES.NE
    CALL EB.READLIST(SEL.CMD,Y.CUST.IDS,'',NO.REC,'')
*
    CALL BATCH.BUILD.LIST('',Y.CUST.IDS)
*
    RETURN
END
