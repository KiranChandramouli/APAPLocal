*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.V.LEGAL.ID

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP I_F.ST.REDO.LEGAL.CUSTOMER

    FN.LE = "F.ST.REDO.LEGAL.CUSTOMER"
    FV.LE= ""
    R.LE = ""
    LE.ERR = ""

    CALL OPF(FN.LE,FV.LE)
    SELECT.STATEMENT = 'SELECT ':FN.LE :' WITH @ID NE ' : ID.NEW
    LEGAL.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,LEGAL.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)
    LOOP
        REMOVE LEGAL.ID FROM LEGAL.LIST SETTING LEGAL.MARK
    WHILE LEGAL.ID : LEGAL.MARK

        R.LEGAL = ''
        YERR = ''
        CALL F.READ(FN.LE,LEGAL.ID,R.LE,FV.LE,YERR)

        Y.LG.IDENT = COMI
        Y.IDENT = R.LE<ST.RED58.IDENTIFICATION>

        IF Y.LG.IDENT <> "" THEN

            IF Y.LG.IDENT = Y.IDENT THEN

                ETEXT = "Esta identificacion le fue ingresada a otro registro previamente "

                CALL STORE.END.ERROR

            END

        END


    REPEAT



END
