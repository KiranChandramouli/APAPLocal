*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.BCR.TC.REPORT.GEN.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business


    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_ENQUIRY.COMMON
    $INSERT LAPAP.BP I_REDO.B.BCR.TC.REPORT.GEN.COMMON
    $INSERT TAM.BP I_F.REDO.INTERFACE.PARAM
*

    GOSUB PROCESS
    RETURN

PROCESS:
********
    LIST.PARAMETERS = '' ; ID.LIST = ''
    SEL.CMD = "SELECT ":FN.AA:" WITH PRODUCT.GROUP EQ 'LINEAS.DE.CREDITO.TC' AND ARR.STATUS EQ 'CURRENT' 'EXPIRED' 'PENDING.CLOSURE'"
    CALL EB.READLIST(SEL.CMD,AA.LIST,'',NO.REC,PGM.ERR)

    CALL OCOMO("Total of records to process " : NO.REC)
    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,AA.LIST)
    CALL EB.CLEAR.FILE(FN.DATA,F.DATA)
    RETURN

END
