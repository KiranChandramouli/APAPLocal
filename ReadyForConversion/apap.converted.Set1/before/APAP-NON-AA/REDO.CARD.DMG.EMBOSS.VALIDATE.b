*--------------------------------------------------------------------------------------------------------
* <Rating>-63</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.DMG.EMBOSS.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE.VIRGIN.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : Defaulting the Values for the REDO.CARD.DAMAGE.VIRGIN
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 MAY 2011     JEEVA T               ODR-2010-03-0400        Initail Draft
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COMPANY
$INSERT I_F.REDO.CARD.DMG.EMBOSS


$INSERT I_F.REDO.CARD.SERIES.PARAM
$INSERT I_F.REDO.STOCK.REGISTER
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

  FN.CARD.TYPE = 'F.CARD.TYPE'
  F.CARD.TYPE = ''
  CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

  FN.REDO.STOCK.REGISTER = 'F.REDO.STOCK.REGISTER'
  F.REDO.STOCK.REGISTER = ''
  CALL OPF(FN.REDO.STOCK.REGISTER,F.REDO.STOCK.REGISTER)

  FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
  F.REDO.CARD.SERIES.PARAM = ''
  CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section

  GOSUB GET.SERIES.PARAM.VALUE

  Y.ID = 'CARD.':FINAL.COMP:"-":EMBOSS.DEPT.CODE
*    Y.ID = 'CARD.':FINAL.COMP:"-":'3455'
  CALL F.READU(FN.REDO.STOCK.REGISTER,Y.ID,R.REDO.STOCK.REGISTER,F.REDO.STOCK.REGISTER,Y.ERR,'')

  R.NEW(DMG.LST.REG.ID) = Y.ID
  Y.LOST.LIST = R.NEW(DMG.LST.LOST)
  Y.DAMAGE.LIST = R.NEW(DMG.LST.DAMAGE)
  GOSUB CARD.TYPE.CHECK

  RETURN
*--------------------------------------------------------------------------------------------------------
GET.SERIES.PARAM.VALUE:
*--------------------------------------------------------------------------------------------------------
  CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)

  Y.PARAM.CARD.TYPE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
  Y.CARD.SERIES = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES>
  FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)
  EMBOSS.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.EMBOSS.DEPT.CODE>

  RETURN
*--------------------------------------------------------------------------------------------------------
CARD.TYPE.CHECK:
*--------------------------------------------------------------------------------------------------------
  Y.FALG = ''
  Y.CARD.TYPE.NEW = R.NEW(DMG.LST.CARD.TYPE)
  Y.COUNT = DCOUNT(Y.CARD.TYPE.NEW,VM)
  Y.CNT = 1

  CARD.REQ=ID.NEW
  CARD.TYPES=Y.CARD.TYPE.NEW
  TOT.DMG.LOST=''



  DMG.LOST=R.NEW(DMG.LST.DAMAGE)
  DMG.DAMAGE= R.NEW(DMG.LST.LOST)

  LOOP.CNT=1
  LOOP
  WHILE LOOP.CNT LE Y.COUNT
    TOT.DMG.LOST<LOOP.CNT>=R.NEW(DMG.LST.DAMAGE)<1,LOOP.CNT> + R.NEW(DMG.LST.LOST)<1,LOOP.CNT>

    LOOP.CNT=LOOP.CNT+1
  REPEAT
  TOT.CARD.CNT=TOT.DMG.LOST
  CARD.TYPE.FLD=DMG.LST.CARD.TYPE

  CALL REDO.V.CHK.ACCEPT.QTY(CARD.REQ,CARD.TYPES,TOT.CARD.CNT,CARD.TYPE.FLD)

  LOOP
  WHILE Y.CNT LE Y.COUNT
    LOCATE Y.CARD.TYPE.NEW<1,Y.CNT> IN Y.PARAM.CARD.TYPE<1,1> SETTING POS THEN
      Y.SERIES.VAL =  Y.CARD.SERIES<1,POS>
      R.NEW(DMG.LST.SERIES)<1,Y.CNT> = Y.SERIES.VAL
      Y.LOST.VAL = Y.LOST.LIST<1,Y.CNT>
      Y.DAMAGE.VAL = Y.DAMAGE.LIST<1,Y.CNT>
      GOSUB CHECK.STOCK.REG
    END ELSE
      AF = DMG.LST.CARD.TYPE
      AV = Y.CNT
      ETEXT = "EB-SERIES.PARAM"
      CALL STORE.END.ERROR
      RETURN
    END
    Y.LOST.VAL = '' ; Y.DAMAGE.VAL = ''
    Y.CNT = Y.CNT + 1
  REPEAT
  AF.LIST = DMG.LST.CARD.TYPE
  CALL DUP.FLD.SET(AF.LIST)
  RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.STOCK.REG:
*--------------------------------------------------------------------------------------------------------




  Y.STOCK.SERIES.ID = R.REDO.STOCK.REGISTER<STK.REG.SERIES.ID>
  Y.STOCK.SERIES.BAL = R.REDO.STOCK.REGISTER<STK.REG.SERIES.BAL>
  LOCATE Y.SERIES.VAL IN Y.STOCK.SERIES.ID<1,1> SETTING POS1 THEN
    Y.STCK.SER.VAL = Y.STOCK.SERIES.BAL<1,POS1>
    IF Y.LOST.VAL AND NOT(Y.DAMAGE.VAL) AND Y.LOST.VAL GT Y.STCK.SER.VAL  THEN
      AF = DMG.LST.LOST
      AV = Y.CNT
      ETEXT = "AC-QTY.REGISTER.L.QTY.ENTRY"
      CALL STORE.END.ERROR

      RETURN
    END
    IF NOT(Y.LOST.VAL) AND Y.DAMAGE.VAL AND Y.DAMAGE.VAL GT Y.STCK.SER.VAL  THEN
      AF = DMG.LST.DAMAGE
      AV = Y.CNT
      ETEXT = "AC-QTY.REGISTER.L.QTY.ENTRY"
      CALL STORE.END.ERROR

      RETURN
    END
    IF Y.LOST.VAL AND Y.DAMAGE.VAL THEN
      Y.TOT = Y.LOST.VAL + Y.DAMAGE.VAL
      IF Y.TOT GT Y.STCK.SER.VAL THEN

        AF = DMG.LST.LOST
        AV = Y.CNT
        ETEXT = "AC-QTY.REGISTER.L.QTY.ENTRY"
        CALL STORE.END.ERROR

        RETURN
      END
    END
  END ELSE
    AF = DMG.LST.SERIES
    AV = Y.CNT
    ETEXT = "AC-SERIES.ID.NOT.STOCKED.STOCK.REGISTER"
    CALL STORE.END.ERROR
    RETURN
  END
  RETURN
END
