SUBROUTINE REDO.V.VAL.TT.CHECK
*--------------------------------------------------------------------------------
*Company Name :Asociacion Popular de Ahorros y Prestamos
*Developed By :GANESH.R
*Program Name :REDO.V.VAL.TT.CHECK
*---------------------------------------------------------------------------------

*DESCRIPTION :This program is used to make the local field mandatory based on below check
*
*LINKED WITH :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    GOSUB INIT
    GOSUB PROCESS
RETURN

*----*
INIT:
*----*
    LOC.REF.APPLICATION='USER'
    LOC.REF.FIELDS='L.US.CASIER.ROL'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
RETURN

*------*
PROCESS:
*------*

    L.US.CASH.ROLE=LOC.REF.POS<1,1>
    CASHIER.ROLE=R.NEW(EB.USE.LOCAL.REF)<1,L.US.CASH.ROLE>
    COMP.RESTR=R.NEW(EB.USE.COMPANY.RESTR)
    VCOUNT=DCOUNT(COMP.RESTR,@VM)
    FOR I.VAR = 1 TO VCOUNT
        COMPANY.REST = R.NEW(EB.USE.COMPANY.RESTR)<1,I.VAR>
        IF COMPANY.REST EQ 'ALL' OR COMPANY.REST EQ ID.COMPANY THEN
            APPLN=R.NEW(EB.USE.APPLICATION)<1,I.VAR>
            IF APPLN EQ 'ALL.PG' OR APPLN EQ 'TELLER' THEN
                GOSUB CHECK:
            END
        END
    NEXT I.VAR
RETURN

*----*
CHECK:
*-----*
    IF CASHIER.ROLE EQ '' THEN
        AF=EB.USE.LOCAL.REF
        AV=L.US.CASH.ROLE
        ETEXT='EB-INPUT.MISSING'
        CALL STORE.END.ERROR
    END
RETURN
*---------*

END
