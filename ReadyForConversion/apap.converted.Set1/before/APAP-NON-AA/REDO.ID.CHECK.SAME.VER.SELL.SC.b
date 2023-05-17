*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------

  SUBROUTINE REDO.ID.CHECK.SAME.VER.SELL.SC

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SEC.TRADE
$INSERT I_F.REDO.SC.MM.VERSION.PARAM


  WAPP.LST = "SEC.TRADE"
  WCAMPO    = "L.NUM.OP.CEN"
  YPOS=''
  CALL MULTI.GET.LOC.REF(WAPP.LST,WCAMPO,YPOS)
  WPOSL1    = YPOS<1,1>


  IF NOT( R.OLD(SC.SBS.CURR.NO) ) THEN
    T.LOCREF<WPOSL1, 7> = 'NOINPUT'
  END ELSE
    T.LOCREF<WPOSL1, 7> = ''
  END

  IF R.NEW(SC.SBS.RECORD.STATUS) NE '' THEN
    Y.BUY.VAL = R.NEW(SC.SBS.CUST.TRANS.CODE)
    IF Y.BUY.VAL NE 'SEL' THEN          ;* updated as SEL from SELL
      E = 'EB-VERSION.DIFFERS'
      CALL STORE.END.ERROR
    END
  END
  RETURN

END
