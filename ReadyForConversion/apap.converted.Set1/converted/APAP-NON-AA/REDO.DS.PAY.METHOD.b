SUBROUTINE REDO.DS.PAY.METHOD(PAY.METHOD)
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :SUDHARSANAN S
*Program Name :REDO.DS.PAY.METHOD
*Modify :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION :This program is used to get the PAY.METHOD value from EB.LOOKUP TABLE
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
    LOC.REF.FIELD = 'L.TT.PAY.METHOD'
    LOC.REF.APP = 'TELLER'
    LOC.POS = ''
    CALL GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.POS)
    VAR.PAY.METHOD = R.NEW(TT.TE.LOCAL.REF)<1,LOC.POS>

    VIRTUAL.TAB.ID='L.TT.PAY.METHOD'
    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
    Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
    CHANGE '_' TO @FM IN Y.LOOKUP.LIST
    CHANGE '_' TO @FM IN Y.LOOKUP.DESC

    LOCATE VAR.PAY.METHOD IN Y.LOOKUP.LIST SETTING POS1 THEN
        IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN ;* This is for english user
            PAY.METHOD=Y.LOOKUP.DESC<POS1,1>
        END
        IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
            PAY.METHOD=Y.LOOKUP.DESC<POS1,2> ;* This is for spanish user
        END ELSE
            PAY.METHOD=Y.LOOKUP.DESC<POS1,1>
        END
    END

    PAY.METHOD = FMT(PAY.METHOD,"29R")
RETURN
END
