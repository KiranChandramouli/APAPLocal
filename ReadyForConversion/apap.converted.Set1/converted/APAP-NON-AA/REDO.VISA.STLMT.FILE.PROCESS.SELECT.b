SUBROUTINE  REDO.VISA.STLMT.FILE.PROCESS.SELECT
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.STLMT.FILE.PROCESS.SELECT
*Date              : 23.11.2010
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
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.REDO.CARD.BIN


    GOSUB INIT
RETURN

*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------

    SEL.CMD="SELECT ":FN.REDO.STLMT.CNCT.PROCESS
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.SEL,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
