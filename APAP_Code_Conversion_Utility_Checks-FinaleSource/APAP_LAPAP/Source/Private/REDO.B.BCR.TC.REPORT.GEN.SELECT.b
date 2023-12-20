$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.BCR.TC.REPORT.GEN.SELECT
*-----------------------------------------------------------------------------
* Select routine to setup the common area for the multi-threaded Close of Business
*------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-07-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*13-07-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------


    $INSERT I_COMMON  ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_REDO.B.BCR.TC.REPORT.GEN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM ;*R22 AUTO CODE CONVERSION.END
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
