SUBROUTINE REDO.TELLER.CASH.MENU.PARAM.VALIDATE
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.TELLER.CASH.MENU.PARAM.VALIDATE
*-------------------------------------------------------------------------
* Description: This routine is an .VALIDATE routine.
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
    $INSERT I_F.REDO.TELLER.CASH.MENU.PARAM
    $INSERT I_F.VERSION

    GOSUB PROCESS

RETURN

PROCESS:
*-------

    FN.REDO.TELLER.CASH.MENU.PARAM='F.REDO.TELLER.CASH.MENU.PARAM'
    F.REDO.TELLER.CASH.MENU.PARAM=''

    CALL OPF(FN.REDO.TELLER.CASH.MENU.PARAM,F.REDO.TELLER.CASH.MENU.PARAM)

    FN.VERSION='F.VERSION'
    F.VERSION=''

    CALL OPF(FN.VERSION,F.VERSION)


    AF = TT.CASH.VERSION.NAME

    CALL DUP

    IF ETEXT THEN
        CALL STORE.END.ERROR
    END

RETURN

END
