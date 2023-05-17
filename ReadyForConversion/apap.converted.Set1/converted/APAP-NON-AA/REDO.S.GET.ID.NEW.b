SUBROUTINE REDO.S.GET.ID.NEW
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :MGUDINO
*Program   Name    :REDO.S.GET.ID.NEW
*---------------------------------------------------------------------------------

*DESCRIPTION       :GETS ID NEW.. IN ORDER TO POPULATE L.INITIAL.ID

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description

*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.TELLER
*GET THE id.new

    LREF.APP = 'TELLER'
    LREF.FIELDS = 'L.INITIAL.ID'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    POS.L.INITIAL.ID = LREF.POS<1,1>

    R.NEW(TT.TE.LOCAL.REF)<1,POS.L.INITIAL.ID> = ID.NEW


RETURN
