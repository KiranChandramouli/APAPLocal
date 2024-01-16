$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION    T24.BP ,BP is Removed,<> TO NE,= to EQ
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*---------------------------------------------------------------------------------------	-
SUBROUTINE LAPAP.V.LEGAL.ID

    $INSERT I_COMMON
    $INSERT I_EQUATE ;*R22 Auto CODE CONVERSION
    $INSERT I_F.ST.REDO.LEGAL.CUSTOMER

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

        IF Y.LG.IDENT NE "" THEN

            IF Y.LG.IDENT EQ Y.IDENT THEN

                ETEXT = "Esta identificacion le fue ingresada a otro registro previamente "

                CALL STORE.END.ERROR

            END

        END


    REPEAT



END
