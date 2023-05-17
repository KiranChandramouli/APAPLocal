*-------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.INITIAL.PROCESS.LOAD
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VISA.INITIAL.PROCESS.LOAD
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
$INSERT I_F.REDO.VISA.STLMT.FILE.DETAILS
$INSERT I_F.REDO.VISA.PROCESS.INFO
$INSERT I_REDO.VISA.INITIAL.PROCESS.COMMON

  GOSUB INIT
  GOSUB OPEN.FILES

  RETURN
*------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------
  FN.REDO.VISA.STLMT.FILE.DETAILS='F.REDO.VISA.STLMT.FILE.DETAILS'
  F.REDO.VISA.STLMT.FILE.DETAILS=''

  FN.REDO.VISA.PROCESS.INFO='F.REDO.VISA.PROCESS.INFO'
  F.REDO.VISA.PROCESS.INFO=''

  FN.REDO.STLMT.CNCT.PROCESS='F.REDO.STLMT.CNCT.PROCESS'
  F.REDO.STLMT.CNCT.PROCESS=''

  FN.REDO.VISA.CNCT.DATE='F.REDO.VISA.CNCT.DATE'
  F.REDO.VISA.CNCT.DATE=''

  RETURN
*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------
  CALL OPF(FN.REDO.VISA.STLMT.FILE.DETAILS,F.REDO.VISA.STLMT.FILE.DETAILS)
  CALL OPF(FN.REDO.VISA.PROCESS.INFO,F.REDO.VISA.PROCESS.INFO)
  CALL OPF(FN.REDO.STLMT.CNCT.PROCESS,F.REDO.STLMT.CNCT.PROCESS)
  CALL OPF(FN.REDO.VISA.CNCT.DATE,F.REDO.VISA.CNCT.DATE)

  RETURN
END
