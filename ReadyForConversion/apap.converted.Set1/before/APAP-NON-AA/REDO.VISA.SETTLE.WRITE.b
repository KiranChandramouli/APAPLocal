*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.SETTLE.WRITE(Y.ID,R.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.VISA.SETTLE.WRITE
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is write the VISA.SETTLE with Audit Fields



*IN PARAMETER: R.ARRAY
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
$INSERT I_F.REDO.VISA.STLMT.05TO37



  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------



  FN.REDO.VISA.STLMT.05TO37='F.REDO.VISA.STLMT.05TO37'
  F.REDO.VISA.STLMT.05TO37=''
  CALL OPF(FN.REDO.VISA.STLMT.05TO37,F.REDO.VISA.STLMT.05TO37)
  R.ARRAY<VISA.SETTLE.PROCESS.DATE>=TODAY
  TEMPTIME = OCONV(TIME(),"MTS")
  TEMPTIME = TEMPTIME[1,5]
  CHANGE ':' TO '' IN TEMPTIME
  CHECK.DATE = DATE()
  R.ARRAY<VISA.SETTLE.RECORD.STATUS>=''
  R.ARRAY<VISA.SETTLE.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
  R.ARRAY<VISA.SETTLE.CURR.NO>=R.ARRAY<VISA.SETTLE.CURR.NO>+1
  R.ARRAY<VISA.SETTLE.INPUTTER>=TNO:'_':OPERATOR
  R.ARRAY<VISA.SETTLE.AUTHORISER>=TNO:'_':OPERATOR
  R.ARRAY<VISA.SETTLE.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
  R.ARRAY<VISA.SETTLE.CO.CODE>=ID.COMPANY
*Tus Start
  CALL F.WRITE(FN.REDO.VISA.STLMT.05TO37,Y.ID,R.ARRAY)
  IF NOT(RUNNING.UNDER.BATCH) AND NOT(PGM.VERSION) THEN
    CALL JOURNAL.UPDATE('')
  END
*Tus End

  RETURN

END
