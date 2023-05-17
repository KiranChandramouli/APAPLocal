*---------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.NON.CONFIRM.PAY(CHQ.DETAILS.ID)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.NON.CONFIRM.PAY
*-------------------------------------------------------------------------

* Description :This routine will change the status of selected record to
*              ISSUED

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_F.USER
$INSERT I_F.REDO.ADMIN.CHQ.PARAM
$INSERT I_F.REDO.ADMIN.CHQ.DETAILS
$INSERT I_REDO.B.NON.CONFIRM.PAY.COMMON

  GOSUB PROCESS
  RETURN
************
PROCESS:
************

  R.CHQ.DETAILS=''
  CALL F.READ(FN.REDO.ADMIN.CHQ.DETAILS,CHQ.DETAILS.ID,R.CHQ.DETAILS,F.REDO.ADMIN.CHQ.DETAILS,CHQ.ERR)
  R.CHQ.DETAILS<ADMIN.CHQ.DET.STATUS>='ISSUED'
  Y.CURR.NO=R.CHQ.DETAILS<ADMIN.CHQ.DET.CURR.NO>
  R.CHQ.DETAILS<ADMIN.CHQ.DET.CURR.NO>=Y.CURR.NO+1
  R.CHQ.DETAILS<ADMIN.CHQ.DET.INPUTTER>=TNO:'_':OPERATOR
  TEMPTIME = OCONV(TIME(),"MTS")
  TEMPTIME = TEMPTIME[1,5]
  CONVERT ':' TO '' IN TEMPTIME
  CHECK.DATE = DATE()
  R.CHQ.DETAILS<ADMIN.CHQ.DET.DATE.TIME>= OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
  R.CHQ.DETAILS<ADMIN.CHQ.DET.CO.CODE> = ID.COMPANY
  R.CHQ.DETAILS<ADMIN.CHQ.DET.AUTHORISER>=TNO:'_':OPERATOR
  R.CHQ.DETAILS<ADMIN.CHQ.DET.DEPT.CODE> =R.USER<EB.USE.DEPARTMENT.CODE>
  CALL F.WRITE(FN.REDO.ADMIN.CHQ.DETAILS,CHQ.DETAILS.ID,R.CHQ.DETAILS)
  RETURN
END
