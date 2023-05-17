SUBROUTINE  REDO.ATH.STLMT.FILE.PROCESS.SELECT
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ATH.STLMT.FILE.PROCESS.SELECT
*Date              : 06.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*06/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.ATH.STLMT.FILE.PROCESS.COMMON

    GOSUB PROCESS

RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------


    SEL.CMD="SELECT ":FN.REDO.ATH.STLMT.CNCT.FILE

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.SEL,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN

END
