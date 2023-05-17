SUBROUTINE REDO.DS.BENEFICIRY(Y.BENEFICY)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :BTORRESALBORNOZ
*Program Name :REDO.DS.SEL.DST
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the BENEFICIARYS NAMES
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.USER
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********

    LOC.REF.FIELD = 'L.TT.BENEFICIAR'
    LOC.REF.APP = 'TELLER'
    LOC.POS = ''
    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)


    Y.BENEFICY = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>

    Y.BENEFICY=Y.BENEFICY<1,1,1>


    Y.BENEFICY=Y.BENEFICY[1,27]


    Y.BENEFICY=FMT(Y.BENEFICY,'R#27')
RETURN
END
