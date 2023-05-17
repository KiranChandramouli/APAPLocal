*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.INP.OFS.UPD.STATUS
*-----------------------------------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.INP.OFS.UPD.STATUS
*-----------------------------------------------------------------------------------------------------------
*DESCRIPTION       :It is the input routine to validate the credit and debit accounts
* ----------------------------------------------------------------------------------------------------------
*
*Modification Details:
*=====================
*   Date               who                     Reference            Description
*===========        ====================       ===============     ==================
* 05-06-2010       GANESH H                    PACS00072713         MODIFICATION
*-----------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.REDO.FILE.DATE.PROCESS
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TSA.SERVICE


  FN.REDO.FILE.DATE.PROCESS = 'F.REDO.FILE.DATE.PROCESS'
  F.REDO.FILE.DATE.PROCESS  = ''
  CALL OPF(FN.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS)

  FN.TSA.SERVICE = 'F.TSA.SERVICE'
  F.TSA.SERVICE  = ''
  CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)

  GOSUB PROCESS
  GOSUB GOEND
  RETURN
*********
PROCESS:
*********

  APPL.ARRAY = "FUNDS.TRANSFER"
  FIELD.ARRAY = "L.COMMENTS"
  FIELD.POS = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
  Y.LOC.COMMENTS.POS = FIELD.POS<1,1>
  Y.FILE.ID =  R.NEW(FT.LOCAL.REF)<1,Y.LOC.COMMENTS.POS>
  CALL F.READ(FN.REDO.FILE.DATE.PROCESS,Y.FILE.ID,R.REDO.FILE.DATE.PROCESS,F.REDO.FILE.DATE.PROCESS,REDO.FILE.DATE.PROCESS.ERR)
  IF  V$FUNCTION EQ 'D' THEN
    R.REDO.FILE.DATE.PROCESS<REDO.FILE.PRO.DEB.ACCT.STATUS> = 'RECHAZO POR AUTORIZADOR'
    R.REDO.FILE.DATE.PROCESS<REDO.FILE.PRO.OFS.PROCESS> = 'FAILURE'
  END ELSE
    R.REDO.FILE.DATE.PROCESS<REDO.FILE.PRO.OFS.PROCESS> = 'PROCESS'
  END
  CALL F.WRITE(FN.REDO.FILE.DATE.PROCESS,Y.FILE.ID,R.REDO.FILE.DATE.PROCESS)
  RETURN
******
GOEND:
******
END

*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
