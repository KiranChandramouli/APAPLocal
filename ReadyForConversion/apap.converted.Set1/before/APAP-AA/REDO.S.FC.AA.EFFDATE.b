*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.S.FC.AA.EFFDATE (AA.ID, AA.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ACTIVITY.HISTORY>EFFECTIVE.DATE  field
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
$INSERT I_F.AA.ACTIVITY.HISTORY

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*********
  CALL F.READ(FN.AA.ACT.HISTORY,Y.ARRG.ID,R.AA.ACT.HISTORY,F.AA.ACT.HISTORY,"")
  IF R.AA.ACT.HISTORY THEN
    Y.CONT = DCOUNT(R.AA.ACT.HISTORY<AA.AH.EFFECTIVE.DATE>,VM)
    FOR I = 1 TO Y.CONT
      LOCATE V.ACTIVITY IN R.AA.ACT.HISTORY<AA.AH.ACTIVITY,I,1> SETTING POS.ACT THEN
        AA.ARR = R.AA.ACT.HISTORY<AA.AH.EFFECTIVE.DATE,I>
        BREAK
      END
    NEXT
    IF AA.ARR EQ "NULO" THEN
        
        ARC.RECORDS = R.AA.ACT.HISTORY<AA.AH.ARC.ID>
        ARC.COUNT = DCOUNT(ARC.RECORDS,VM)
        
        FOR ARC.POS = 1 TO ARC.COUNT
            ARC.ID = ARC.RECORDS<1,ARC.POS>
            
            R.AA.ACT.HISTORY.HIS = ""; R.AA.HIS.ERR = ""
            CALL F.READ(FN.AA.ACT.HISTORY.HIS, ARC.ID, R.AA.ACT.HISTORY.HIS, F.AA.ACT.HISTORY.HIS, R.AA.HIS.ERR)
            
            Y.CONT = DCOUNT(R.AA.ACT.HISTORY.HIS<AA.AH.EFFECTIVE.DATE>,VM)
            FOR ACT.POS = 1 TO Y.CONT
                    LOCATE V.ACTIVITY IN R.AA.ACT.HISTORY.HIS<AA.AH.ACTIVITY,ACT.POS,1> SETTING POS.ACT THEN
                        AA.ARR = R.AA.ACT.HISTORY.HIS<AA.AH.EFFECTIVE.DATE,ACT.POS>
                        BREAK
                    END
            NEXT
            
            IF AA.ARR NE "NULO" THEN
                BREAK
            END
        NEXT
    END
  END
  RETURN
*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  Y.ARRG.ID = AA.ID
  V.ACTIVITY = 'LENDING-DISBURSE-COMMITMENT'
*     V.ACTIVITY = 'LENDING-DISBURSE-TERM.AMOUNT'
  FN.AA.ACT.HISTORY = "F.AA.ACTIVITY.HISTORY"
  F.AA.ACT.HISTORY  = ""
  R.AA.ACT.HISTORY  = ""
  
  FN.AA.ACT.HISTORY.HIS = "F.AA.ACTIVITY.HISTORY.HIST"
  F.AA.ACT.HISTORY.HIS = ""
  R.AA.ACT.HISTORY.HIS = ""
  
  AA.ARR = 'NULO'
  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.AA.ACT.HISTORY, F.AA.ACT.HISTORY)
  CALL OPF(FN.AA.ACT.HISTORY.HIS, F.AA.ACT.HISTORY.HIS)
  RETURN
*------------
END
