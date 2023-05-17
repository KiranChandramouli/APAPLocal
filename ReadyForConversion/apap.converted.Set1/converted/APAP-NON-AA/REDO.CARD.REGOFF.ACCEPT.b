SUBROUTINE REDO.CARD.REGOFF.ACCEPT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REGOFF.ACCEPT
*--------------------------------------------------------------------------------------------------------
*Description  : This is a check routine to default Reg off quantity
*Linked With  : Application REDO.CARD.REQUEST,REGOFF
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 18 SEP 2010    Swaminathan.S.R       ODR-2010-03-0400        Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.REQUEST
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
***************
PROCESS.PARA:
***************

    Y.TOT.CARD.TYPES = DCOUNT(R.NEW(REDO.CARD.REQ.CARD.TYPE),@VM)
    Y.INIT.COUNT = 1
    LOOP
    WHILE Y.INIT.COUNT LE Y.TOT.CARD.TYPES
        R.NEW(REDO.CARD.REQ.REGOFF.ACCEPTQTY)<1,Y.INIT.COUNT> = R.NEW(REDO.CARD.REQ.BRANCH.ORDERQTY)<1,Y.INIT.COUNT>
        Y.INIT.COUNT +=1
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------------------
END
