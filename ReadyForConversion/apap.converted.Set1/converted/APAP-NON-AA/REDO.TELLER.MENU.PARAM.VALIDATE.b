SUBROUTINE REDO.TELLER.MENU.PARAM.VALIDATE
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.TELLER.MENU.PARAM.VALIDATE
*-------------------------------------------------------------------------
* Description: This routine is a .VALIDATE routine
*-------------------------------------------------------------------------
* Linked with   :
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 16-10-11            ODR-2011-08-0055
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TELLER.MENU.PARAM

    GOSUB PROCESS

RETURN

PROCESS:
*------

    FN.REDO.TELLER.MENU.PARAM='F.REDO.TELLER.MENU.PARAM'
    F.REDO.TELLER.MENU.PARAM=''

    CALL OPF(FN.REDO.TELLER.MENU.PARAM,F.REDO.TELLER.MENU.PARAM)

    AF = TT.MENU.VERSION.NAME

    CALL DUP

    IF ETEXT THEN
        CALL STORE.END.ERROR
    END

RETURN

END
