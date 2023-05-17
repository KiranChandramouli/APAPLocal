*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FORM.MESSAGE(VAR.AC.ID)

*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This deal slip routine to form the message for loan rate change.
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : TXN.ARRAY
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : H GANESH
* PROGRAM NAME : REDO.FORM.MESSAGE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10 Sep 2011     H Ganesh        PACS00113076 - B.16  INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER


  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------

  FN.REDO.NOTIFY.RATE.CHANGE = 'F.REDO.NOTIFY.RATE.CHANGE'
  F.REDO.NOTIFY.RATE.CHANGE = ''
  CALL OPF(FN.REDO.NOTIFY.RATE.CHANGE,F.REDO.NOTIFY.RATE.CHANGE)


  Y.ARR.ID = ''
  CALL REDO.CONVERT.ACCOUNT(VAR.AC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
  VAR.AA.ID = OUT.ID
  CALL F.READ(FN.REDO.NOTIFY.RATE.CHANGE,VAR.AA.ID,R.NOTIFY.DETAIL,F.REDO.NOTIFY.RATE.CHANGE,NOTIFY.ERR)

  Y.MSG = R.NOTIFY.DETAIL<1>

  VAR.AC.ID = Y.MSG[1,65]:VM:'    ':Y.MSG[66,65]:VM:'    ':Y.MSG[132,25]


  RETURN
END
