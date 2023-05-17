*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.HIGH.GCI(GCI.ID,Y.CUR,Y.RATE)

*--------------------------------------------------------------------------------
* Company Name : ASOCIGCION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.GET.HIGH.GCI
*--------------------------------------------------------------------------------
* Description: This is a call routine to get the highest rate of GCI record.
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 31-May-2011    H GANESH       PACS00072194      INITIAL CREATION
*
*----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.GROUP.CREDIT.INT


  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
  Y.RATE=0
  Y.TOTAL.BASIC=''
  FN.GCI='F.GROUP.CREDIT.INT'
  F.GCI=''
  CALL OPF(FN.GCI,F.GCI)

  CALL F.READ(FN.GCI,GCI.ID,R.GCI,F.GCI,GCI.ERR)
  IF SUM(R.GCI<IC.GCI.CR.BASIC.RATE>) THEN
    GOSUB CHECK.BASIC.RATE
  END
  Y.INT.IDS=R.GCI<IC.GCI.CR.INT.RATE>
  CHANGE VM TO FM IN Y.INT.IDS
  Y.FINAL.IDS=Y.TOTAL.BASIC:FM:Y.INT.IDS
  Y.RATE=MAXIMUM(Y.FINAL.IDS)

  RETURN
*---------------------------------------------------------------------------------
CHECK.BASIC.RATE:
*---------------------------------------------------------------------------------
  Y.BASIC.IDS=R.GCI<IC.GCI.CR.BASIC.RATE>
  Y.BASIC.ID.CNT=DCOUNT(Y.BASIC.IDS,VM)
  Y.VAR1=1
  LOOP
  WHILE Y.VAR1 LE Y.BASIC.ID.CNT
    IF Y.BASIC.IDS<1,Y.VAR1> THEN
      Y.BASIC.AND.CURR=Y.BASIC.IDS<1,Y.VAR1>:Y.CUR:TODAY
      CALL EB.GET.INTEREST.RATE(Y.BASIC.AND.CURR, BASIC.INT.RATE)
      Y.TOTAL.BASIC<-1>=BASIC.INT.RATE
    END
    Y.VAR1++
  REPEAT

  RETURN
END
