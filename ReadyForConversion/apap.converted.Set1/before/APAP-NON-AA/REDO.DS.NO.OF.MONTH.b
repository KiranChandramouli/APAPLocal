*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.NO.OF.MONTH(Y.NO.OF.MONTH)
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.DS.NO.OF.MONTH
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display the duration period of deposit
*               in words
*Linked With  :
*In Parameter : NA
*Out Parameter: Y.NO.OF.MONTH
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 10.11.2011      SUDHARSANAN S           CR.18                  INITIAL CREATION
*--------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT

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
  START.DATE= R.NEW(AZ.VALUE.DATE)
  END.DATE = R.NEW(AZ.MATURITY.DATE)
  NO.OF.MONTHS = ''
  CALL EB.NO.OF.MONTHS(START.DATE,END.DATE,NO.OF.MONTHS)

  Y.MONTH = NO.OF.MONTHS

  IF Y.MONTH LT '1' THEN
    REGION.CODE = ''
    Y.DIFF = 'C'
    CALL CDD(REGION.CODE,START.DATE,END.DATE,Y.DIFF)
    Y.MONTH = Y.DIFF
    GOSUB SPAN.LETTERS
    Y.NO.OF.MONTH= Y.MONTH:"(":TRIM(Y.OUT.MONTH,"",E):")":" DIAS"
  END ELSE
    GOSUB SPAN.LETTERS
    Y.NO.OF.MONTH= NO.OF.MONTHS:"(":TRIM(Y.OUT.MONTH,"",E):")"
  END
  RETURN
*----------------
SPAN.LETTERS:
*----------------
  CALL REDO.CONVERT.NUM.TO.WORDS(Y.MONTH, OUT.MONTH, LINE.LENGTH, NO.OF.LINES, ERR.MSG)

  Y.OUT.MONTH= UPCASE(FIELD(OUT.MONTH,"peso",1))

  RETURN
*-------------------
END
