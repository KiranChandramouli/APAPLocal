*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.VISA.GEN.OUT.SELECT
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
**Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.GEN.ACQ.REC.SELECT
*Date              : 07.12.2010
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
*07/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
$INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON
*$INCLUDE TAM.BP I_REDO.VISA.GEN.OUT.COMMON

  GOSUB PROCESS

  RETURN


*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------


  SEL.CMD="SELECT ":FN.REDO.VISA.GEN.OUT
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
  CALL BATCH.BUILD.LIST('', SEL.LIST)
  RETURN
END
