SUBROUTINE REDO.V.AUTH.ROUTE.TABLE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.AUTH.ROUTE.TABLE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       :
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    19 04 2012           Ganesh R          ODR-2010-03-0103           Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ROUTING.NUMBER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

* This is the para from where the execution of the code starts
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    FN.REDO.OTH.BANK.NAME = 'F.REDO.OTH.BANK.NAME'
    F.REDO.OTH.BANK.NAME  = ''
    CALL OPF(FN.REDO.OTH.BANK.NAME,F.REDO.OTH.BANK.NAME)

    Y.BANK.CODE = R.NEW(REDO.ROUT.BANK.CODE)
    CALL F.READ(FN.REDO.OTH.BANK.NAME,Y.BANK.CODE,R.REDO.OTH.BANK.NAME,F.REDO.OTH.BANK.NAME,RET.ERR)
    R.REDO.OTH.BANK.NAME<1> = R.NEW(REDO.ROUT.BANK.NAME):'*':ID.NEW
    CALL F.WRITE(FN.REDO.OTH.BANK.NAME,Y.BANK.CODE,R.REDO.OTH.BANK.NAME)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
