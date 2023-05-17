*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ATH.INITIAL.PROCESS.LOAD
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.ATH.INITIAL.PROCESS.LOAD
*Date              : 6.12.2010
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
$INSERT I_REDO.ATH.INITIAL.PROCESS.COMMON

  GOSUB INITIALISE

  RETURN
*------------------------------------------------------------------------------------
INITIALISE:
*------------------------------------------------------------------------------------

  FN.REDO.ATH.PROCESS.INFO='F.REDO.ATH.PROCESS.INFO'
  F.REDO.ATH.PROCESS.INFO=''
  CALL OPF(FN.REDO.ATH.PROCESS.INFO,F.REDO.ATH.PROCESS.INFO)

  FN.REDO.STLMT.CNCT.FILE='F.REDO.STLMT.CNCT.FILE'
  F.REDO.STLMT.CNCT.FILE=''
  CALL OPF(FN.REDO.STLMT.CNCT.FILE,F.REDO.STLMT.CNCT.FILE)

  FN.REDO.ATH.STLMT.CNCT.FILE='F.REDO.ATH.STLMT.CNCT.FILE'
  F.REDO.ATH.STLMT.CNCT.FILE=''
  CALL OPF(FN.REDO.ATH.STLMT.CNCT.FILE,F.REDO.ATH.STLMT.CNCT.FILE)

  FN.REDO.ATH.STLMT.FILE.DETAILS='F.REDO.ATH.STLMT.FILE.DETAILS'

  RETURN

END
