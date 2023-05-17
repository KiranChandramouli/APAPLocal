SUBROUTINE REDO.BANK.NAME.CORRECTION
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.BANK.NAME.CORRECTION
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 18.06.2012          ODR-2010-09-0251                 Initial Creation

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.H.ROUTING.NUMBER

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

OPEN.FILES:
    FN.REDO.OTH.BANK.NAME = 'F.REDO.OTH.BANK.NAME'
    F.REDO.OTH.BANK.NAME  = ''
    CALL OPF(FN.REDO.OTH.BANK.NAME,F.REDO.OTH.BANK.NAME)

    FN.REDO.H.ROUTING.NUMBER = 'F.REDO.H.ROUTING.NUMBER'
    F.REDO.H.ROUTING.NUMBER  = ''
    CALL OPF(FN.REDO.H.ROUTING.NUMBER,F.REDO.H.ROUTING.NUMBER)
RETURN

PROCESS:
    SEL.CMD = "SELECT ":FN.REDO.H.ROUTING.NUMBER
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,RET.ERR)
    Y.INIT = 1
    LOOP
        REMOVE REC.ID FROM SEL.LIST SETTING REC.POS
    WHILE Y.INIT LE NO.REC
        CALL F.READ(FN.REDO.H.ROUTING.NUMBER,REC.ID,R.REDO.H.ROUTING.NUMBER,F.REDO.H.ROUTING.NUMBER,REDO.H.ROUTING.NUMBER.ERR)
        IF R.REDO.H.ROUTING.NUMBER THEN
            Y.ROUTE.ID = R.REDO.H.ROUTING.NUMBER<REDO.ROUT.BANK.CODE>
            R.REDO.OTH.BANK.NAME = R.REDO.H.ROUTING.NUMBER<REDO.ROUT.BANK.NAME>:'*':REC.ID
            CALL F.WRITE(FN.REDO.OTH.BANK.NAME,Y.ROUTE.ID,R.REDO.OTH.BANK.NAME)
        END
        Y.INIT += 1
    REPEAT
RETURN
