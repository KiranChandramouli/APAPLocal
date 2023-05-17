*-----------------------------------------------------------------------------
* <Rating>-62</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.LIST.MTH.TRANS(Y.FINAL.ARRAY)

*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE              ODR                   DEVELOPER                    VERSION
*--------          ----------------      --------------------      ----------------
* 15.Dec.2010     SUNNEL                 Krishna Murthy T.S        Initial creation
*---------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_System
$INSERT I_ENQUIRY.COMMON

$INSERT I_F.REDO.CARD.BIN

  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------

  LOCATE "FROM.DATE" IN D.FIELDS<1> SETTING FIELD1.POS THEN
    ST.RG.DATE = D.RANGE.AND.VALUE<FIELD1.POS>
  END

  LOCATE "TO.DATE" IN D.FIELDS<1> SETTING FIELD2.POS THEN
    END.RG.DATE = D.RANGE.AND.VALUE<FIELD2.POS>
    IF END.RG.DATE GT TODAY  THEN
      END.RG.DATE = TODAY
    END
  END

  LOCATE "CURRENCY" IN D.FIELDS<1> SETTING FIELD3.POS THEN
    DR.CR.TYPE = D.RANGE.AND.VALUE<FIELD3.POS>
  END

  LOCATE "VP.CCY" IN D.FIELDS<1> SETTING FIELD4.POS THEN
    GET.CCY = D.RANGE.AND.VALUE<FIELD4.POS>
  END

  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  CREDIT.CARD.ID = System.getVariable('CURRENT.CARD.ID')

  Y.CARD.NO = CREDIT.CARD.ID
  Y.CARD.ID = CREDIT.CARD.ID[1,6]

  CREDIT.CARD.ID = FMT(CREDIT.CARD.ID, 'R%19')

  FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
  F.REDO.CARD.BIN = ''
  CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

  CALL F.READ(FN.REDO.CARD.BIN,Y.CARD.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,CARD.ERR)

  IF NOT(CARD.ERR) THEN

    ACTIVATION = 'WS_T24_VPLUS'
    WS.DATA = ''
    WS.DATA<1> = 'CONSULTA_MOVIMIENTOS_X_RANGO'
    WS.DATA<2> = CREDIT.CARD.ID
    WS.DATA<3> = ST.RG.DATE
    WS.DATA<4> = END.RG.DATE
    WS.DATA<5> = 'AL'

    Y.CCY.LIST = R.REDO.CARD.BIN<REDO.CARD.BIN.T24.CURRENCY>

    LOCATE GET.CCY IN Y.CCY.LIST<1,1> SETTING Y.CCY.POS ELSE
      RETURN
    END

    IF GET.CCY EQ 'DOP' THEN
      Y.CCY = 1
    END ELSE
      Y.CCY = 2
    END

    WS.DATA<6> = Y.CCY

* Invoke VisionPlus Web Service
    CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)

* Credit Card exits - Info obtained OK
    IF WS.DATA<1> EQ 'OK' THEN

      IF Y.CCY EQ '1' THEN
        Y.CCY.MNE = 'RD$'
      END ELSE
        Y.CCY.MNE = 'US$'
      END

      GOSUB GET.TXN.MOVEMENTS
    END ELSE
* 'ERROR/OFFLINE'
      ENQ.ERROR<1> = WS.DATA<2>
    END
  END

  RETURN

GET.TXN.MOVEMENTS:
*----------------*

  WS.DATA = CHANGE(WS.DATA,'*',VM)
  Y.CNT = DCOUNT(WS.DATA<8>,VM)
  Y.POS = 1
  Y.TEMP = 2

  IF WS.DATA<8,Y.CNT> EQ '' THEN
    Y.CNT = Y.CNT -1
  END

  BEGIN CASE

  CASE DR.CR.TYPE[1,1] EQ 'D'
    GOSUB GET.ONLY.DEBIT

  CASE DR.CR.TYPE[1,1] EQ 'C'
    GOSUB GET.ONLY.CREDIT

  CASE OTHERWISE
    GOSUB GET.EVERYTHING

  END CASE

  RETURN

GET.ONLY.DEBIT:
*-------------*

  LOOP
  WHILE Y.CNT GT 0
    IF WS.DATA<6,Y.CNT> EQ 'D' THEN
      Y.FINAL.ARRAY<-1> = WS.DATA<4,Y.CNT>:'###':WS.DATA<3,Y.CNT>:'###':WS.DATA<8,Y.CNT>:'###':Y.CCY.MNE:'###':WS.DATA<7,Y.CNT>:'###':'0':'###':Y.CARD.NO
    END
    Y.CNT--
    Y.POS++
  REPEAT
  RETURN

GET.ONLY.CREDIT:
*--------------*

  LOOP
  WHILE Y.CNT GT 0
    IF WS.DATA<6,Y.CNT> EQ 'C' THEN
      Y.FINAL.ARRAY<-1> = WS.DATA<4,Y.CNT>:'###':WS.DATA<3,Y.CNT>:'###':WS.DATA<8,Y.CNT>:'###':Y.CCY.MNE:'###':'0':'###':WS.DATA<7,Y.CNT>:'###':Y.CARD.NO
    END
    Y.CNT--
    Y.POS++
  REPEAT
  RETURN

GET.EVERYTHING:
*-------------*

  LOOP
  WHILE Y.CNT GT 0

    IF WS.DATA<6,Y.CNT> EQ 'D' THEN
      Y.AMT = WS.DATA<7,Y.CNT>:'###':'0'
    END ELSE
      Y.AMT = '0':'###':WS.DATA<7,Y.CNT>
    END
    Y.FINAL.ARRAY<-1> = WS.DATA<5,Y.CNT>:'###':WS.DATA<3,Y.CNT>:'###':WS.DATA<8,Y.CNT>:'###':Y.CCY.MNE:'###':Y.AMT:'###':Y.CARD.NO
    Y.CNT--
    Y.POS++
  REPEAT

  RETURN
