$PACKAGE APAP.LAPAP
* @(#) REDO.B.CUS.TAX.RETENTIONS.SELECT Ported to jBASE 16:17:06  28 NOV 2017
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CUS.TAX.RETENTIONS.SELECT
*---------------------------------------------------------------------------------------------
*
* Description           : This is the Routine used to select the REDO.NCF.ISSUED Application with Based on the Date Value.

* Developed By          : Amaravathi Krithika B
*
* Development Reference : RegN11
*
* Attached To           : Batch - BNK/REDO.B.CUS.TAX.RETENTIONS
*
* Attached As           : Online Batch Routine to COB
*---------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#4 : NA
*
*---------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*---------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*-----------------------------------------------------------------------------------------------------------------
* PACS00375393           Ashokkumar.V.P                 11/12/2014            New mapping changes - Rewritten the whole source.
* APAP-132               Ashokkumar.V.P                 03/02/2016            Spliting the file based on customer identification.
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_BATCH.FILES ;* R22 Auto conversion
    $INSERT I_ENQUIRY.COMMON ;* R22 Auto conversion
    $INSERT I_F.STMT.ENTRY ;* R22 Auto conversion
    $INSERT I_REDO.B.CUS.TAX.RETENTIONS.COMMON ;* R22 Auto conversion
*

    GOSUB SELECT.PROCESS
RETURN
*
SELECT.PROCESS:
*--------------
    CALL EB.CLEAR.FILE(FN.DR.REG.REGN11.WORKFILE, F.DR.REG.REGN11.WORKFILE)
    YGP.STMT.ID.LIST = ''
    D.FIELDS = "ACCOUNT":@FM:"BOOKING.DATE"
    D.LOGICAL.OPERANDS = "1":@FM:"2"
    D.RANGE.AND.VALUE = YTAX.ACCT:@FM:Y.DATE.FROM:@SM:Y.DATE.TO
    CALL E.STMT.ENQ.BY.CONCAT(YGP.STMT.ID.LIST)
    CALL BATCH.BUILD.LIST('',YGP.STMT.ID.LIST)
RETURN
*---------------------------------------------------------------------------------------------
END
*---------------------------------------------------------------------------------------------
*
