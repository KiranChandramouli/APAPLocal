*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.BRANCH.LIMIT.SELECT

*-------------------------------------------------------------------L-------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.B.UPD.BRANCH.LIMIT.SELECT
*--------------------------------------------------------------------------------
* Description: This is batch routine to clear the daily balance for each branch.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 20-Oct-2011    Pradeep S      PACS00149084      INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.UPD.BRANCH.LIMIT.COMMON

  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  SEL.CMD = "SELECT ":FN.REDO.APAP.FX.BRN.POSN
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN
END
