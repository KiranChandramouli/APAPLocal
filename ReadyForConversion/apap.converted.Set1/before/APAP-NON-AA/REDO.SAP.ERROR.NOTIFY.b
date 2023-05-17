*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SAP.ERROR.NOTIFY(Y.OFS.MSG)
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* To log and send mail when error occurs in T24-SAP communication and transaction through web service
*------------------------------------------------------------------------------------------------------
*APPLICATION
* attached as OUT.RTN in OFS.SOURCE GCS
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : Y.OFS.MSG
* OUT    : Y.OFS.MSG
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.SAP.ERROR.NOTIFY
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*23.08.2010      Janani     ODR-2010-08-0102    INITIAL CREATION
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

  GOSUB PROCESS
  RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

  Y.ERR = FIELD(Y.OFS.MSG,'/',3)
  IF Y.ERR EQ '-1' THEN
    ERR.DESP = FIELD(Y.OFS.MSG,',',2)

    CHANGE "=" TO " " IN ERR.DESP

    INT.CODE = 'SAP001'
    INT.TYPE = 'ONLINE'
    BAT.NO = ''
    BAT.TOT = ''
    INFO.OR = 'SAP'
    INFO.DE = 'T24'
    ID.PROC = FIELD(Y.OFS.MSG,'/',1)
    MON.TP = '04'
    DESC = ERR.DESP
    REC.CON = 'REJECT: ':DESC
    EX.USER = ''
    EX.PC = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
  END
  RETURN
*------------------------------------------------------------
END
