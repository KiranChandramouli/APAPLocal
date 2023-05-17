*--------------------------------------------------------------------------------------------------------
* <Rating>-32</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.BRANCH.CARD.RETURN.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.BRANCH.CARD.RETURN.VALIDATE
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 29 MAR 2011    Mohammed Anies K       ODR-2010-03-0400        Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.REG.STOCK
$INSERT I_F.REDO.CARD.DAMAGE
$INSERT I_F.REDO.CARD.REQUEST
$INSERT I_F.CARD.TYPE
$INSERT I_F.ACCOUNT
$INSERT I_F.COMPANY
$INSERT I_F.REDO.CARD.NUMBERS
$INSERT I_F.REDO.BRANCH.CARD.RETURN
$INSERT I_F.REDO.CARD.BIN
$INSERT I_F.REDO.CARD.SERIES.PARAM
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

  FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
  F.REDO.CARD.NUMBERS = ''
  CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  Y.LRF.APPL = "CARD.TYPE"
  Y.LRF.FIELDS = 'L.CT.BIN'
  FIELD.POS = ''
  CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)
  Y.CT.BIN.POS = FIELD.POS<1,1>

  FN.CARD.TYPE = 'F.CARD.TYPE'
  F.CARD.TYPE = ''
  CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

  FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
  F.REDO.CARD.BIN = ''
  CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

  FN.REDO.BRANCH.CARD.RETURN = 'F.REDO.BRANCH.CARD.RETURN'
  F.REDO.BRANCH.CARD.RETURN = ''
  CALL OPF(FN.REDO.BRANCH.CARD.RETURN,F.REDO.BRANCH.CARD.RETURN)

  FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
  F.REDO.CARD.SERIES.PARAM = ''
  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)
  Y.ID.CARD.SERIES = 'SYSTEM'
  CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,Y.ID.CARD.SERIES,R.REDO.CARD.SERIES.PARAM,PARAM.ERR)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section

  Y.CARD.NUMBER = R.NEW(REDO.BRA.RTN.CARD.NUMBER)
  Y.COUNT = DCOUNT(Y.CARD.NUMBER,VM)
  CHANGE VM TO FM IN Y.CARD.NUMBER
  Y.CNT = 1
  LOOP
  WHILE Y.CNT LE Y.COUNT
    Y.CARD.NUM = Y.CARD.NUMBER<Y.CNT>
    LOCATE Y.CARD.NUM IN R.NEW(REDO.BRA.RTN.CARD.NUMBER.OLD)<1,1> SETTING PREV.POS THEN
      AF = REDO.BRA.RTN.CARD.NUMBER
      AV = Y.CNT
      ETEXT= "EB-CARD.NUMBER.DAMAGE"
      CALL STORE.END.ERROR
    END
    Y.AVAIL=''
    Y.BIN.NUMBER = Y.CARD.NUM[1,6]
    CALL F.READ(FN.REDO.CARD.BIN,Y.BIN.NUMBER,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.BIN.ERR)
    Y.CARD.TYPE.LIST = R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    Y.CARD.TYPE.TOT=DCOUNT(Y.CARD.TYPE.LIST,VM)
    Y.CARD.TYPE.CNT=1
    LOOP
    WHILE Y.CARD.TYPE.CNT LE Y.CARD.TYPE.TOT
      Y.CARD.NUMBER.ID = Y.CARD.TYPE.LIST<1,Y.CARD.TYPE.CNT>:'.':ID.COMPANY
      CALL F.READ(FN.REDO.CARD.NUMBERS,Y.CARD.NUMBER.ID,R.REDO.CARD.NUMBER,F.REDO.CARD.NUMBERS,Y.CARD.ERR)
      Y.ALL.CARD = R.REDO.CARD.NUMBER<REDO.CARD.NUM.CARD.NUMBER>
      CHANGE VM TO FM IN Y.ALL.CARD

      LOCATE Y.CARD.NUM IN Y.ALL.CARD SETTING POS THEN
        Y.AVAIL='1'
      END
      Y.CARD.TYPE.CNT+=1
    REPEAT
    IF NOT(Y.AVAIL) THEN
      AF = REDO.BRA.RTN.CARD.NUMBER
      AV = Y.CNT
      ETEXT= "EB-CARD.NUMBER"
      CALL STORE.END.ERROR
    END
    Y.CNT = Y.CNT + 1
  REPEAT
  RETURN
*--------------------------------------------------------------------------------------------------------

END
