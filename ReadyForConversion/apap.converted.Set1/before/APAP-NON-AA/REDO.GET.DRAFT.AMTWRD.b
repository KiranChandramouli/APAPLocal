*-----------------------------------------------------------------------------
* <Rating>-37</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.DRAFT.AMTWRD(Y.AMT)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.AMOUNT.LETTER
* ODR NUMBER    : ODR-2009-10-0795
*-----------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the amount in letters in spanish
* In parameter  :
* out parameter : Y.AMT
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 14-01-2011     MARIMUTHU S       ODR-2009-10-0795   Initial Creation
* 03-06-2011     Bharath G         PACS00071471       Number to words Conversion Routine changed
* 22/04/2014     Vignesh Kumaar R  PACS00273064       USD Cheque
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.PRINT.CHQ.LIST

  GOSUB PROCESS

  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*=======

* PACS00071471 - S

  IF Y.AMT EQ 'CONCEPT' THEN
    Y.CONCEPT = R.NEW(PRINT.CHQ.LIST.CONCEPT)
    Y.CONCEPT = CHANGE(Y.CONCEPT,FM,' ')
    Y.CONCEPT = CHANGE(Y.CONCEPT,VM,' ')
    Y.AMT = FMT(Y.CONCEPT,"65L")
  END ELSE

    GOSUB USD.CHEQUE.WORDING
    GOSUB LCY.CHEQUE.WORDING

    IF Y.AMT EQ 'UNO' OR Y.AMT EQ 'ONE' THEN
      IF OUT.AMT.LINE2 THEN
        Y.AMT = UPCASE(OUT.AMT.LINE1)
      END ELSE
        Y.AMT = ''
      END
    END

    IF Y.AMT EQ 'DOS' OR Y.AMT EQ 'TWO' THEN
      IF OUT.AMT.LINE2 THEN
        Y.AMT = UPCASE(OUT.AMT.LINE2)
      END ELSE
        Y.AMT = UPCASE(OUT.AMT.LINE1)
      END
    END
  END

  RETURN

*------------------------------------------------------------------------------------------------------------------

LCY.CHEQUE.WORDING:
*-----------------*

  Y.WORD.LENGTH = LEN(OUT.AMT)
  IF Y.WORD.LENGTH GT 84 THEN
    GET.NO.OF.WORDS = COUNT(OUT.AMT,' ')
    Y.AMT.WORD = OUT.AMT
    Y.SPACE = GET.NO.OF.WORDS
    FOR I = 1 TO GET.NO.OF.WORDS STEP 1
      Y.SPACE = Y.SPACE - 1
      Y.AMT.SPANISH = INDEX(OUT.AMT,' ',Y.SPACE)
      Y.LEAVE.SPACE = '    '
      IF Y.AMT.SPANISH LE 84 THEN
        LF = CHAR(10)
        Y.LAST.WORD = Y.WORD.LENGTH - Y.AMT.SPANISH
*                    OUT.AMT = OUT.AMT[1,Y.AMT.SPANISH]:LF:Y.LEAVE.SPACE:OUT.AMT[Y.AMT.SPANISH+1,Y.LAST.WORD]
        OUT.AMT.LINE1 = OUT.AMT[1,Y.AMT.SPANISH]
*                    OUT.AMT.LINE2 = Y.LEAVE.SPACE:OUT.AMT[Y.AMT.SPANISH+1,Y.LAST.WORD]
        OUT.AMT.LINE2 = OUT.AMT[Y.AMT.SPANISH+1,Y.LAST.WORD]
        BREAK
      END
    NEXT I
  END ELSE
    OUT.AMT.LINE1 = OUT.AMT
  END
*        Y.AMT = UPCASE(OUT.AMT)

  RETURN

USD.CHEQUE.WORDING:
*-----------------*

* Fix for PACS00273064 [USD Cheque]

  IF Y.AMT EQ 'ONE' OR Y.AMT EQ 'TWO' THEN

    IN.AMT = R.NEW(PRINT.CHQ.LIST.AMOUNT)
    BFR.DEC = FIELD(IN.AMT,'.',1)
    AFT.DEC = FIELD(IN.AMT,'.',2)

    OUT.AMT = '' ; LG.CODE = 'GB' ; LENGTH = '' ; ER = ''
    CALL DE.O.PRINT.WORDS(BFR.DEC,OUT.AMT,LG.CODE,LENGTH,1,ER)
    OUT.AMT = CHANGE(OUT.AMT,'*',' ')
    FINAL.AMT = OUT.AMT

    IF AFT.DEC NE '' THEN

      OUT.AMT = '' ; LG.CODE = 'GB' ; LENGTH = '' ; ER = ''
      CALL DE.O.PRINT.WORDS(AFT.DEC,OUT.AMT,LG.CODE,LENGTH,1,ER)
      OUT.AMT = CHANGE(OUT.AMT,'*',' ')
      IF OUT.AMT EQ '' THEN
        FINAL.AMT := 'DOLLARS ZERO CENTS'
      END ELSE
        FINAL.AMT := 'DOLLARS ':OUT.AMT:'CENTS'
      END
      OUT.AMT = FINAL.AMT
    END

* End of Fix

  END ELSE
    IN.AMT = 'CHQ':R.NEW(PRINT.CHQ.LIST.AMOUNT)
    CALL REDO.CONVERT.NUM.TO.WORDS(IN.AMT, OUT.AMT, LINE.LENGTH, NO.OF.LINES, ERR.MSG)

    OUT.AMT = CHANGE(OUT.AMT,VM,' ')
    OUT.AMT = CHANGE(OUT.AMT,'  ',' ')
    OUT.AMT = CHANGE(OUT.AMT,'*','')
*            OUT.AMT = CHANGE(OUT.AMT,'pesos ','')
  END

  RETURN

*-----------------------------------------------------------------------------
END
