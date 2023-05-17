SUBROUTINE REDO.DS.CPTY.NAME(Y.RET)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Pradeep S
* PROGRAM NAME: REDO.DS.CPTY.NAME
* PACS REF    : PACS00062654
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Counterparty Name

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14-May-2011    Pradeep S     PACS00062654      Initial Creation
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

    LOC.REF.APPLICATION = 'CUSTOMER':@FM:'SEC.TRADE'
    LOC.REF.FIELDS = 'L.CU.RNC':@FM:'L.ST.CPTY':@VM:'L.ST.CPTY.TRDR'
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,FIELD.POS)
    POS.RNC = FIELD.POS<1,1>
    POS.CPTY = FIELD.POS<2,1>
    POS.CPTY.NAME = FIELD.POS<2,2>

RETURN

OPENFILES:
**********
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

PROCESS:
********

    BROKER.TYPE = R.NEW(SC.SBS.BROKER.TYPE)
    Y.RET = ''

    BEGIN CASE
        CASE BROKER.TYPE EQ 'COUNTERPARTY'
            Y.CUS.ID  = R.NEW(SC.SBS.BROKER.NO)
            GOSUB GET.CUS.NAME
            Y.RET = Y.CUS.NAME
        CASE BROKER.TYPE NE 'COUNTERPARTY'
            Y.CUS.ID = R.NEW(SC.SBS.LOCAL.REF)<1,POS.CPTY>

*IF NOT(Y.CUS.ID) THEN
*Y.CUS.ID  = R.NEW(SC.SBS.BROKER.NO)
*END
            GOSUB GET.CUS.NAME
            Y.RET = Y.CUS.NAME
    END CASE

RETURN

GET.CUS.NAME:
**************

    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
RETURN
END
