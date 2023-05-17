*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.COMMER.DEBTOR.BAL.SELECT
*--------------------------------------------------------------------------------------------------
*
* Description           : This is the Batch Select Routine Used to select the required Files
*
*
* Developed On          : 11-Nov-2013
*
* Developed By          : Amaravathi Krithika B
*
* Development Reference : DE08
*
*--------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
*--------------------------------------------------------------------------------------------------
* PACS00361295           Ashokkumar.V.P                 15/05/2015            Added new fields to show customer loans.
* PACS00464363           Ashokkumar.V.P                 22/06/2015            Changed to avoid ageing problem and mapping changes
* PACS00466000           Ashokkumar.V.P                 24/06/2015            Mapping changes - Remove L.CU.DEBTOR field
*--------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.AA.ACCOUNT
    $INSERT TAM.BP I_F.REDO.H.REPORTS.PARAM
    $INSERT TAM.BP I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT TAM.BP I_REDO.B.COMMER.DEBTOR.BAL.COMMON

    GOSUB INIT
    GOSUB PROCESS
    RETURN

INIT:
*---
    SEL.LIST = ''; SEL.CMD = ''; NO.OF.REC = ''; SEL.ERR = ''
    RETURN

PROCESS:
*------
    CALL EB.CLEAR.FILE(FN.DR.REG.DE08.WORKFILE, F.DR.REG.DE08.WORKFILE)
    SEL.CMD.CUS = "SELECT ":FN.REDO.CUSTOMER.ARRANGEMENT
    CALL EB.READLIST(SEL.CMD.CUS,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
    RETURN
END
