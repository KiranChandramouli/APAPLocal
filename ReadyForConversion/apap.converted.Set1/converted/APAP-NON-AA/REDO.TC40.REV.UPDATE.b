SUBROUTINE  REDO.TC40.REV.UPDATE
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.TC40.REV.UPDATE
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --REC.ID--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010           H GANESH             ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS
RETURN



*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    FN.REDO.VISA.GEN.OUT='F.REDO.VISA.GEN.OUT'
    F.REDO.VISA.GEN.OUT=''
    CALL OPF(FN.REDO.VISA.GEN.OUT,F.REDO.VISA.GEN.OUT)

    Y.WRITE.ID=ID.NEW:'*':APPLICATION
    R.ARR=''
    CALL F.WRITE(FN.REDO.VISA.GEN.OUT,Y.WRITE.ID,R.ARR)

RETURN

END
