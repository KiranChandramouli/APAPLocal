* @ValidationCode : Mjo5NTMwODY3MDI6Q3AxMjUyOjE3MDUwNDc1MzI1MzM6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2024 13:48:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
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
  *  $INSERT I_BATCH.FILES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_REDO.B.BCR.TC.REPORT.GEN.COMMON
    $INSERT I_F.REDO.INTERFACE.PARAM ;*R22 AUTO CODE CONVERSION.END
   $USING EB.Service
*

    GOSUB PROCESS
RETURN

PROCESS:
********
    LIST.PARAMETERS = '' ; ID.LIST = ''
    SEL.CMD = "SELECT ":FN.AA:" WITH PRODUCT.GROUP EQ 'LINEAS.DE.CREDITO.TC' AND ARR.STATUS EQ 'CURRENT' 'EXPIRED' 'PENDING.CLOSURE'"
    CALL EB.READLIST(SEL.CMD,AA.LIST,'',NO.REC,PGM.ERR)

    CALL OCOMO("Total of records to process " : NO.REC)
*    CALL BATCH.BUILD.LIST(LIST.PARAMETERS,AA.LIST)
EB.Service.BatchBuildList(LIST.PARAMETERS,AA.LIST);* R22 UTILITY AUTO CONVERSION
*    CALL EB.CLEAR.FILE(FN.DATA,F.DATA)
EB.Service.ClearFile(FN.DATA,F.DATA);* R22 UTILITY AUTO CONVERSION
RETURN

END
