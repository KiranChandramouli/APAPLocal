*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PREVALANCE.STATUS.PROCESS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.PREVALANCE.STATUS.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a authorization routine for attaching the template REDO.PREVALANCE.STATUS.VALIDATE
*In Parameter      :
*Out Parameter     :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  21/09/2011      Riyas                         ODR-2010-08-0490                Initial Creation
*
*********************************************************************************************************

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.PREVALANCE.STATUS

  GOSUB OPEN.FILES
  GOSUB PROCESS
  GOSUB GOEND
  RETURN

************
OPEN.FILES:
************
  FN.REDO.PREVALANCE.STATUS = 'F.REDO.PREVALANCE.STATUS'
  F.REDO.PREVALANCE.STATUS = ''
  CALL OPF(FN.REDO.PREVALANCE.STATUS,F.REDO.PREVALANCE.STATUS)
  Y.FINAL.STATUS = ''; Y.FM.STATUS='';LOOP.SM.CNTR ='' ; LOOP.FM.CNTR = '' ; STAT.FM.CNTR = ''; STAT.SM.CNTR = ''; Y.FLAG = ''; Y.ERROR = ''
  RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------

  PARAM.STATUS = R.NEW(REDO.PRE.STATUS)
  Y.VM.ARRAY = DCOUNT(PARAM.STATUS,VM)
  Y.SM.ARRAY = DCOUNT(PARAM.STATUS,SM)

  Y.CNT = 1
  Y.FLAG1 = ''
  LOOP
  WHILE Y.CNT LE Y.VM.ARRAY
    Y.LIST.VAL = ''
    Y.CHECK.VAL = PARAM.STATUS<1,Y.CNT>

    GOSUB INNNER.LOOP
    IF  Y.FLAG AND Y.FLAG1 THEN
      AV =Y.CNT
      AF = REDO.PRE.STATUS
      ETEXT = "EB-AC.STATUS.DUPICATE"
      CALL STORE.END.ERROR
      Y.CNT = Y.CNT + Y.VM.ARRAY
    END
    Y.CNT = Y.CNT + 1
  REPEAT
  RETURN
*-----------
INNNER.LOOP:
*-----------
  Y.IN.CNT = Y.CNT + 1
  LOOP
  WHILE Y.IN.CNT LE Y.VM.ARRAY
    Y.LIST.VAL = PARAM.STATUS<1,Y.IN.CNT>
    Y.MY.CNT = DCOUNT(Y.LIST.VAL,SM)
    GOSUB CHEC.DUP
    Y.IN.CNT = Y.IN.CNT + 1
  REPEAT
  RETURN
*-----------
CHEC.DUP:
*-----------
  CHANGE VM TO FM IN Y.LIST.VAL
  CHANGE SM TO FM IN Y.LIST.VAL
  Y.COUNT = DCOUNT(Y.CHECK.VAL,SM)
  IF Y.COUNT EQ Y.MY.CNT THEN
    Y.FLAG1 = 1
  END ELSE
    Y.FLAG1 = ''
  END
  Y.CNT.SM = 1
  LOOP
  WHILE Y.CNT.SM LE Y.COUNT
    LOCATE Y.CHECK.VAL<1,1,Y.CNT.SM> IN Y.LIST.VAL SETTING POS THEN
      Y.FLAG = '1'
    END ELSE
      Y.FLAG = ''
      Y.CNT.SM = Y.CNT.SM + Y.COUNT
    END
    Y.CNT.SM = Y.CNT.SM + 1
  REPEAT
  IF  Y.FLAG AND Y.FLAG1 THEN
    AV =Y.CNT
    AF = REDO.PRE.STATUS
    ETEXT = "EB-AC.STATUS.DUPICATE"
    CALL STORE.END.ERROR
    GOSUB GOEND
  END
  RETURN
*----------------
GOEND:
*---------------_
END
