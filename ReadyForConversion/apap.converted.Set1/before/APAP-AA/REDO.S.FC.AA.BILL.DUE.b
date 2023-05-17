*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FC.AA.BILL.DUE(AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.INTEREST>L.AA.REV.RT.TY  field
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.ACCOUNT.DETAILS

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

  CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARRG.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.ACT.DET.ERR)
  IF R.AA.ACCOUNT.DETAILS NE '' THEN

    Y.CONT = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>,VM)
    FOR I=1 TO Y.CONT
      IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,I,1> EQ 'PAYMENT' AND R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS,I,1> EQ 'UNPAID' THEN
        B.CONT ++
      END
    NEXT
  END

  IF B.CONT THEN
    AA.ARR = B.CONT
  END
  RETURN
*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  B.CONT = 0
  Y.ARRG.ID = AA.ID
  FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS  = ''
  R.AA.ACCOUNT.DETAILS = ''
  AA.ARR = 'NULO'
  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

  RETURN
*------------
END
