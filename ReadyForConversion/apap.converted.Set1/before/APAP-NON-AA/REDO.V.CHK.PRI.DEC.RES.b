*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.CHK.PRI.DEC.RES
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is attached as validation routine for the field Arrangement in FUNDS.TRANSFER,AA.LS.LC.ACPD
* This routine checks whether any PRINCIPAL DECREASE restriction exists on the arrangement
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : REDO.V.DEF.FT.LOAN.STATUS.COND, REDO.V.CHK.NO.OVERDUE
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 07-JUN-2010   N.Satheesh Kumar   ODR-2009-10-0331      Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_EB.TRANS.COMMON


  IF MESSAGE EQ 'VAL' THEN
    RETURN
  END
  IF OFS$OPERATION EQ 'VALIDATE' THEN
    RETURN
  END
*Return in Commit stage
  IF cTxn_CommitRequests EQ '1' THEN
    RETURN
  END



  ARR.ID =  ECOMI
  PROP.CLASS = 'ACTIVITY.RESTRICTION'
  PROPERTY = ''
  R.Condition = ''
  ERR.MSG = ''
  EFF.DATE = ''
  CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)

  IF R.Condition NE '' THEN
    V$ERROR = 1
    MESSAGE = 'ERROR'
    ETEXT = "En este momento su transaccisn no puede ser realizada, favor contactar  Servicio al Cliente al Telif. 809-687-2727. "
    ETEXT := "(estos mensajes deben poder mantenerse)"
    CALL STORE.END.ERROR
  END ELSE
    CALL REDO.V.DEF.FT.LOAN.STATUS.COND
    CALL REDO.V.CHK.NO.OVERDUE
  END
  RETURN

END
