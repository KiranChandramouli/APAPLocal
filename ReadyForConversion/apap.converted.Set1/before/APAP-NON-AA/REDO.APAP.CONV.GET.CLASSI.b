*-----------------------------------------------------------------------------
* <Rating>-15</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CONV.GET.CLASSI
*************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: PRADEEP P
* PROGRAM NAME: REDO.APAP.CONV.GET.CLASSI
* ODR NO      : ODR-2010-03-0144
*----------------------------------------------------------------------
* DESCRIPTION:   This is a conversion routine attached to the Enquiry
*                REDO.GARNISH.SEIZURE.ENQ and REDO.GARNISH.SEIZURE.ENQ.RPT
*                which display the selection fields based on Values inputted by the USER
*
* IN PARAMETER : O.DATA
* OUT PARAMETER: 0.DATA
* LINKED WITH  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE        WHO           REFERENCE         DESCRIPTION
* 19.Nov.2010  PRADEEP P    ODR-2010-03-0144  INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.USER
$INSERT I_F.EB.LOOKUP

  GOSUB PROCESS
  RETURN
*
PROCESS:
*-------
  Y.FINAL = ''

  LOCATE 'RECEP.DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
    Y.SEL.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>

    IF D.LOGICAL.OPERANDS<Y.DATE.POS> EQ 2 THEN
      Y.START.DATE = FIELD(Y.SEL.DATE, SM, 1)
      Y.END.DATE = FIELD(Y.SEL.DATE, SM, 2)
      CALL EB.DATE.FORMAT.DISPLAY(Y.START.DATE, Y.FMT.START.DATE, '','')
      CALL EB.DATE.FORMAT.DISPLAY(Y.END.DATE, Y.FMT.END.DATE, '','')
      Y.FINAL := "Fecha de Recepcion - ":Y.START.DATE:" a ":Y.END.DATE:"; "
    END ELSE
      CALL EB.DATE.FORMAT.DISPLAY(Y.SEL.DATE, Y.FMT.SEL.DATE, '', '')
      Y.FINAL := "Fecha de Recepcion - ":Y.FMT.SEL.DATE:"; "
    END

  END

*LOCATE 'CUSTOMER' IN D.FIELDS<1> SETTING Y.CUS.POS THEN
*Y.CLIENT = D.RANGE.AND.VALUE<Y.CUS.POS>
*IF Y.FINAL THEN
*Y.FINAL := ",":"Codigo Cliente - ":Y.CLIENT
*END ELSE
*Y.FINAL = "Codigo Cliente - ":Y.CLIENT
*END
*END

  LOCATE "LOCKED.DEL.TYPE" IN D.FIELDS<1> SETTING Y.AT.POS THEN
    Y.SEL.ACT.TYPE  = D.RANGE.AND.VALUE<Y.AT.POS>
    Y.LOOKUP.ID = 'GAR.LOCKED.DEL.TYPE*':Y.SEL.ACT.TYPE

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP, F.EB.LOOKUP)

    CALL CACHE.READ(FN.EB.LOOKUP, Y.LOOKUP.ID, R.LOOKUP, Y.READ.ERR)

    Y.SEL.ACT.TYPE = R.LOOKUP<EB.LU.DESCRIPTION,  LNGG>
    IF NOT(Y.SEL.ACT.TYPE) THEN
      Y.SEL.ACT.TYPE = R.LOOKUP<EB.LU.DESCRIPTION,1>
    END

    Y.FINAL = "Tipo de Acto - ":Y.SEL.ACT.TYPE:'; '

  END

  LOCATE "CUSTOMER" IN D.FIELDS<1> SETTING Y.CN.POS THEN
    Y.SEL.CLIENT = D.RANGE.AND.VALUE<Y.CN.POS>
    Y.FINAL = "Cliente de APAP - ":Y.SEL.CLIENT:'; '
  END

  LOCATE "ID.NUMBER" IN D.FIELDS<1> SETTING Y.SEZ.POS THEN
    Y.SEL.SEIZURE = D.RANGE.AND.VALUE<Y.SEZ.POS>
    Y.FINAL = "Doc.Ident.Embargado - ":Y.SEL.SEIZURE:'; '
  END
  LOCATE "CATEGORY" IN D.FIELDS<1> SETTING Y.AI.POS THEN
    Y.SEL.ACCT = D.RANGE.AND.VALUE<Y.AI.POS>
    Y.FINAL = "Tipo Cta/Inversion - ":Y.SEL.ACCT:'; '
  END
  IF Y.FINAL EQ '' THEN
    Y.FINAL = 'TODO'
  END
  O.DATA = Y.FINAL

  RETURN
END
