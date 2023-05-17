SUBROUTINE REDO.V.AUTH.LOAN.ALIAS.NAME
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.V.AUTH.LOAN.ALIAS.NAME
*-----------------------------------------------------------------------------
* Description :
* Linked with :
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*16/10/11      PACS00102015           PRABHU N                   MODIFICATION
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AI.REDO.ARCIB.ALIAS.TABLE



    GOSUB OPEN.FILES
    GOSUB UPDATE.LOAN.SHORT.NAME
RETURN
*-----------*
OPEN.FILES:
*-----------*
    FN.ALIAS = 'F.AI.REDO.ARCIB.ALIAS.TABLE'
    F.ALIAS = ''
    CALL OPF(FN.ALIAS,F.ALIAS)


RETURN

*-----------------------*
UPDATE.LOAN.SHORT.NAME:
*-----------------------*

    CALL F.READ(FN.ALIAS,ID.NEW,R.ALIAS.REC,F.ALIAS,ACC.ERR)
    IF R.ALIAS.REC THEN
        Y.NEW.NAME = R.NEW(AC.SHORT.TITLE)
        Y.OLD.NAME = R.OLD(AC.SHORT.TITLE)
        IF Y.OLD.NAME NE Y.NEW.NAME THEN
            R.ALIAS.REC<AI.ALIAS.ALIAS.NAME,1> = R.NEW(AC.SHORT.TITLE)
            CALL F.WRITE(FN.ALIAS,ID.NEW,R.ALIAS.REC)
        END
    END ELSE
        R.ALIAS.REC<AI.ALIAS.ALIAS.NAME,1> = R.NEW(AC.SHORT.TITLE)
        CALL F.WRITE(FN.ALIAS,ID.NEW,R.ALIAS.REC)
    END
RETURN
END
