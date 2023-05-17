*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.REINV.AMT.TO.WORD(Y.AMT)
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.REINV.AMT.TO.WORD
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display deposit amount
*               in words
*Linked With  :
*In Parameter : NA
*Out Parameter: Y.AMT
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 04-04-2011        H GANESH             PACS00030247 - N.11    Initial Creation
*--------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CURRENCY
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER

*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB PROCESS.PARA
  RETURN
*--------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

  IF APPLICATION EQ 'TELLER' THEN
    Y.FULL.AMT=R.NEW(TT.TE.AMOUNT.LOCAL.1)
    Y.CUR=R.NEW(TT.TE.CURRENCY.1)
  END
  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
    Y.FULL.AMT=R.NEW(FT.DEBIT.AMOUNT)
    Y.CUR=R.NEW(FT.DEBIT.CURRENCY)
  END


*CALL CACHE.READ('F.CURRENCY',Y.CUR,R.CUR,CUR.ERR)
*IN.AMT=FIELD(Y.FULL.AMT,'.',1)
*Y.DECIMAL=FIELD(Y.FULL.AMT,'.',2)
*Y.DEC.OUT=''
*IF Y.DECIMAL NE 0 THEN
*    Y.DEC.OUT=' CON ':Y.DECIMAL:'/100'
*END
*OUT.AMT=''
*LANGUAGE='ES'
*LINE.LENGTH=100
*NO.OF.LINES=1
*ERR.MSG=''
*CALL DE.O.PRINT.WORDS(IN.AMT,OUT.AMT,LANGUAGE,LINE.LENGTH,NO.OF.LINES,ERR.MSG)
*CHANGE '*' TO ' ' IN OUT.AMT
*OUT.AMT = TRIMBS(OUT.AMT)
*IN.AMT=FMT(IN.AMT,"R2, #15")
*Y.AMT.IN.WORDS='(':OUT.AMT:' ':R.CUR<EB.CUR.CCY.NAME>:Y.DEC.OUT:') PARA SER'

  IN.AMT = Y.FULL.AMT

  CALL REDO.CONVERT.NUM.TO.WORDS(IN.AMT, OUT.AMT, LINE.LENGTH, NO.OF.LINES, ERR.MSG)


  Y.AMT.IN.WORDS = "( ":UPCASE(OUT.AMT):" ) PARA SER"
  Y.TOTAL.LEN=LEN(Y.AMT.IN.WORDS)
  IF Y.TOTAL.LEN GT 45 THEN
    Y.AMT.IN.WORDS= Y.AMT.IN.WORDS[1,45]:VM:'         ':Y.AMT.IN.WORDS[46,Y.TOTAL.LEN]
  END

  Y.AMT=TRIMF(Y.FULL.AMT):Y.AMT.IN.WORDS

  RETURN
*-------------------------------------------------------------------------------------
END
