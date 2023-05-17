SUBROUTINE REDO.DS.CLIENT.TYPE(CLIENT.TYPE)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :SUDHARSANAN S
*Program Name :REDO.DS.CLIENT.TYPE
*Modify :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the CLIENT TYPE value from EB.LOOKUP TABLE
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
    LOC.REF.FIELD = 'L.TT.CLNT.TYPE'
    LOC.REF.APP = 'TELLER'
    LOC.POS = ''
    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)

    VAR.CLIENT.TYPE = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>

    VIRTUAL.TAB.ID='L.TT.CLNT.TYPE'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC

    LOCATE VAR.CLIENT.TYPE IN Y.LOOKUP.LIST SETTING POS1 THEN
        IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN ;* This is for english user
            CLIENT.TYPE=Y.LOOKUP.DESC<POS1,1>
        END
        IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
            CLIENT.TYPE=Y.LOOKUP.DESC<POS1,2> ;* This is for spanish user
        END ELSE
            CLIENT.TYPE=Y.LOOKUP.DESC<POS1,1>
        END
    END
    CLIENT.TYPE = FMT(CLIENT.TYPE,'R#28')
RETURN

END
