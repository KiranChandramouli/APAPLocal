*-----------------------------------------------------------------------------
* <Rating>-65</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.VAL.CURRENCY
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :ROUTINE
* Attached to     :CURRENCY HOLD.FIELD IN REDO.CREATE.ARRANGEMENT TEMPLATE
* Attached as     :HOLD.FIELD in CURRENCY field OF REDO.CREATE.ARRANGEMENT TEMPLATE
* Primary Purpose :VALIDATE WHAT KIND OF CURRENCY IS POSIBLE TO INPUT OF HEADER TO REDO.CREATE.ARRANGEMENT TEMPLATE
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 23 2011
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.PRODUCT.DESIGNER
$INSERT I_F.REDO.CREATE.ARRANGEMENT
$INSERT I_F.USER
$INSERT I_F.AA.TERM.AMOUNT
$INSERT I_GTS.COMMON

*
*************************************************************************
*
* -------------------------------------------------------------------------------
* PA20071025 Se debe ejecutar solo cuando es invocado desde el campo HOT.FIELD de
*CAMPO.ACTUAL = OFS$HOT.FIELD
*NOMBRE.CAMPO = "...LOAN.CURRENCY..."
*IF CAMPO.ACTUAL MATCH NOMBRE.CAMPO ELSE
*   RETURN
*END
* Fin PA20071025
*-------------------

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

*
  RETURN


*
* ======
PROCESS:
* ======
  GOSUB CURRENCY


  RETURN

* ======
CURRENCY:
* ======


  SEL.CMD  = 'SELECT ' :FN.AA.PRODUCT.DESIGNER
  SEL.CMD := '  LIKE ' :Y.PRODUCT: '-... BY-DSND @ID'
  SEL.LIST = ''
  NO.REC   = ''
  SEL.ERR  = ''
  CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.REC, SEL.ERR)
  IF SEL.LIST THEN
    REMOVE ID.PRODUCT FROM SEL.LIST SETTING POS
    CALL CACHE.READ(FN.AA.PRODUCT.DESIGNER, ID.PRODUCT, R.AA.PRODUCT.DESIGNER, Y.ERR)
    Y.CURRENCY =  R.AA.PRODUCT.DESIGNER<AA.PRD.CURRENCY>

    LOCATE  Y.ARR.CURRENCY IN Y.CURRENCY<1,1> SETTING YPOS ELSE

      AF = REDO.FC.LOAN.CURRENCY
      ETEXT = 'EB-FC-CURRENCY-NOTIN-PRODUCT'
      CALL STORE.END.ERROR

    END
  END


  RETURN




*
* =========
OPEN.FILES:
* =========
*
  CALL OPF(FN.AA.PRODUCT.DESIGNER,F.AA.PRODUCT.DESIGNER)

  RETURN
*
* =========
INITIALISE:
* =========
*
  LOOP.CNT        = 1
  MAX.LOOPS       = 1
  PROCESS.GOAHEAD = 1

  Y.PRODUCT = R.NEW(REDO.FC.PRODUCT)
  FN.AA.PRODUCT.DESIGNER= "F.AA.PRODUCT.DESIGNER"
  F.AA.PRODUCT.DESIGNER=""
  Y.ARR.CURRENCY = COMI
  RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1

    END CASE

    LOOP.CNT +=1
  REPEAT
*
  RETURN
*

END
