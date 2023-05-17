*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.DS.ST.TRADER(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.ST.SELLERS
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14-May-2011    Pradeep S     PACS00062654      Removed BROKER.TYPE validations
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SEC.TRADE
$INSERT I_F.CUSTOMER

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN

INIT:
*****

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  RETURN

OPENFILES:
**********
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN

PROCESS:
********

  SHORT.NAME = ''
  BROKER.TYPE = R.NEW(SC.SBS.BROKER.TYPE)
*IF BROKER.TYPE EQ 'BROKER' THEN
  BROKER.NO = R.NEW(SC.SBS.BROKER.NO)
  BROKER.COUNT = DCOUNT(BROKER.NO,VM)
  INIT = 1
  LOOP
  WHILE INIT LE BROKER.COUNT
    CALL F.READ(FN.CUSTOMER,BROKER.NO,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    SHORT.NAME<-1> = R.CUSTOMER<EB.CUS.SHORT.NAME>
    INIT ++
  REPEAT
  Y.RET = SHORT.NAME

*END ELSE
*SHORT.NAME = ''
*Y.RET = ''
*END

  RETURN
END
