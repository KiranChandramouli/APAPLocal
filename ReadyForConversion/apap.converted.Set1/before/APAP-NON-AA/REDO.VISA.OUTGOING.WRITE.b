*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.OUTGOING.WRITE(Y.ID,R.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.VISA.OUTGOING.WRITE
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is write the VISA.OUTGOING with Audit Fields



*IN PARAMETER: Y.ARRAY
*OUT PARAMETER: NA
*LINKED WITH: VISA.SETTLEMENT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*1.12.2010  H GANESH     ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.USER
$INSERT I_F.REDO.VISA.OUTGOING



  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


  FN.REDO.VISA.OUTGOING='F.REDO.VISA.OUTGOING'
  F.REDO.VISA.OUTGOING=''
  CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING)

  R.ARRAY<VISA.OUT.PROCESS.DATE>=TODAY
  TEMPTIME = OCONV(TIME(),"MTS")
  TEMPTIME = TEMPTIME[1,5]
  CHANGE ':' TO '' IN TEMPTIME
  CHECK.DATE = DATE()
  R.ARRAY<VISA.OUT.VISA.CPY.REQ>=''
  R.ARRAY<VISA.OUT.RECORD.STATUS>=''
  R.ARRAY<VISA.OUT.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
  R.ARRAY<VISA.OUT.CURR.NO>=R.ARRAY<VISA.OUT.CURR.NO>+1
  R.ARRAY<VISA.OUT.INPUTTER>=TNO:'_':OPERATOR
  R.ARRAY<VISA.OUT.AUTHORISER>=TNO:'_':OPERATOR
  R.ARRAY<VISA.OUT.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
  R.ARRAY<VISA.OUT.CO.CODE>=ID.COMPANY
*Tus Start
  CALL F.WRITE(FN.REDO.VISA.OUTGOING,Y.ID,R.ARRAY)
  IF NOT(RUNNING.UNDER.BATCH) AND NOT(PGM.VERSION) THEN
    CALL JOURNAL.UPDATE('')
  END
*Tus End

  RETURN

END
