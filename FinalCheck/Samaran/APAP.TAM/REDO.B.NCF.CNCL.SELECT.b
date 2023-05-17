$PACKAGE APAP.TAM
SUBROUTINE REDO.B.NCF.CNCL.SELECT
* ----------------------------------------------------------------------------------------------------------------
* Description           : To select the necessary files to extract the details that Contains
*                         the NCF that are cancelled for various reasons (bad impression, deterioration of the
*                         invoice, invoice duplication, etc..)
* Developed By          : Aravindhan B
* Development Reference : N10
* Attached To           : NA
* Attached As           : NA
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA

*-----------------------------------------------------------------------------------------------------------------
* Modification History
**********************
*---------------------------------------------------------------------------------------------
*   Date       Author              Modification Description
*
* 05/12/2014  Ashokkumar.V.P        PACS00350467 - selection changed based on DATE field.
** 21-04-2023 R22 Auto Conversion 
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_REDO.B.NCF.CNCL.COMMON ;* R22 Auto conversion
    $INSERT I_F.REDO.H.REPORTS.PARAM ;* R22 Auto conversion
    $INSERT I_F.REDO.L.NCF.CANCELLED ;* R22 Auto conversion
    $INSERT I_F.REDO.L.NCF.CANCEL ;* R22 Auto conversion

*--------------------------------------------------------------------------
    GOSUB SELECT.FILES
RETURN
*--------------------------------------------------------------------------
SELECT.FILES:
************* *** Select the table REDO.L.NCF.CANCELLED and pass the list ***
    SEL.CMD = "SELECT ":FN.REDO.L.NCF.CANCELLED:" WITH DATE LIKE ":Y.DATE.REQ:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
*--------------------------------------------------------------------------
END       ;* End of the Program
