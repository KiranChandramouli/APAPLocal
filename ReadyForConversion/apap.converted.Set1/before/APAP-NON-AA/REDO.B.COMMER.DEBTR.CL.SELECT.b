*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.COMMER.DEBTR.CL.SELECT
*
* Description           : This is the Batch Main Process Routine used to process the all AA Customer Id
*                         and get the Report Related details and Write the details in file.
*
* Development Reference : CL01
*
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* PACS00466001           Ashokkumar.V.P                 29/06/2016            Initial Release
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT TAM.BP I_F.REDO.CUSTOMER.ARRANGEMENT
    $INSERT TAM.BP I_REDO.B.COMMER.DEBTR.CL.COMMON

    GOSUB INIT
    GOSUB PROCESS
    RETURN

INIT:
*---
    SEL.LIST = ''; SEL.CMD = ''; NO.OF.REC = ''; SEL.ERR = ''
    RETURN

PROCESS:
*------
    CALL EB.CLEAR.FILE(FN.DR.REG.CL01.WORKFILE, F.DR.REG.CL01.WORKFILE)
    SEL.CMD.CUS = "SELECT ":FN.REDO.CUSTOMER.ARRANGEMENT
    CALL EB.READLIST(SEL.CMD.CUS,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST("",SEL.LIST)
    RETURN
END
