SUBROUTINE REDO.B.TAXPAYER.SERVICES.SELECT
*---------------------------------------------------------------------------------------------
*
* Description           : Batch routine to report information about Sales of Goods and / or Services made by the taxpayer during the fiscal period ended

* Developed By          : Thilak Kumar K
*
* Development Reference : RegN9
*
* Attached To           : Batch - BNK/APAP.B.TAXPAYER.SERVICES
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
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* PACS00350484          Ashokkumar.V.P                  18/12/2014           Report changed to run on all frequency
* PACS00463470          Ashokkumar.V.P                  23/06/2015           Mapping change to display for RNC and Cedula.
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_F.BATCH
    $INSERT I_REDO.B.TAXPAYER.SERVICES.COMMON
*
    GOSUB SELECT.PROCESS
*
RETURN
*---------------------------------------------------------------------------------------------
*
SELECT.PROCESS:
*--------------
*
    SEL.CMD = "SELECT ":FN.REDO.NCF.ISSUED:" WITH DATE LIKE ":Y.DATE.REQ:"..."
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
*
RETURN
*---------------------------------------------------------------------------------------------
END
*---------------------------------------------------------------------------------------------
