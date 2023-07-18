*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.V.ASAMBLEA.CED
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.ACCOUNT
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.VOTANTE
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.PARTIC
    $INSERT BP I_F.ST.L.APAP.ASAMBLEA.PARAM

    Y.CEDULA = COMI

    FN.CUS = "FBNK.CUSTOMER"
    FV.CUS = ""

    CALL OPF(FN.CUS,FV.CUS)

    IF V$FUNCTION EQ 'I' THEN

        IF R.OLD(1) EQ '' THEN
            SEL.CMD = "SELECT " : FN.CUS : " WITH L.CU.CIDENT EQ " : Y.CEDULA : " SAMPLE 1"
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,SEL.ERR)
            LOOP REMOVE CUSTOMER.ID FROM SEL.LIST SETTING STMT.POS

            WHILE CUSTOMER.ID DO
                GOSUB READ.CUSTOMER
            REPEAT

            IF R.CUS EQ '' THEN
                E = "CEDULA INVALIDA, FAVOR VERIFICAR."
                CALL ERR
                MESSAGE = 'REPEAT'
                V$ERROR = 1
                RETURN
            END

        END
    END

    RETURN

READ.CUSTOMER:
    CALL F.READ(FN.CUS, CUSTOMER.ID, R.CUS, FV.CUS, CUS.ERR)
    RETURN

END
