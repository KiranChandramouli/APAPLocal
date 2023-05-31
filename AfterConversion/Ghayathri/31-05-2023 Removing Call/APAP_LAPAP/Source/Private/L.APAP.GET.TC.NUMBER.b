* @ValidationCode : MjotOTIzNDMzMzU6Q3AxMjUyOjE2ODU1MzA4NTA3MDg6aGFpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 16:30:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.GET.TC.NUMBER(Y.INP.DEAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , Include to Insert and T24.BP is removed from Insert
* 21-APRIL-2023      Harsha                R22 Manual Conversion - CALL ROUTINE FORMAT MODIFIED
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY

    GOSUB PROCESS
RETURN

PROCESS:

    Y.FIELD.NAME = Y.INP.DEAL

    FN.REDO.CASHIER.DEALSLIP.INFO = 'F.REDO.CASHIER.DEALSLIP.INFO'
    F.REDO.CASHIER.DEALSLIP.INFO = ''

    CALL OPF(FN.REDO.CASHIER.DEALSLIP.INFO,F.REDO.CASHIER.DEALSLIP.INFO)

    GET.TXN.ID = System.getVariable("CURRENT.WTM.FIRST.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        GET.TXN.ID = ""
    END

    IF GET.TXN.ID EQ 'CURRENT.WTM.FIRST.ID' THEN
        GET.TXN.ID = ID.NEW:'-NV.INFO'
    END ELSE
        GET.TXN.ID = GET.TXN.ID:'-NV.INFO'
    END

    READ R.REDO.CASHIER.DEALSLIP.INFO FROM F.REDO.CASHIER.DEALSLIP.INFO, GET.TXN.ID THEN
        IF R.REDO.CASHIER.DEALSLIP.INFO NE '' OR R.REDO.CASHIER.DEALSLIP.INFO NE 0 THEN
            R.DEAL.ARRAY = R.REDO.CASHIER.DEALSLIP.INFO
        END
    END

    LOCATE ID.NEW IN R.DEAL.ARRAY<1,1> SETTING POS1 THEN
        GOSUB GET.VALUES
    END

RETURN

GET.VALUES:

*PARA ABRIR EL ACHIVO DE ACCOUNT
    FN.ACC = "FBNK.ACCOUNT"
    FV.ACC = ""
    RS.ACC = ""
    ACC.ERR = ""

    CALL OPF(FN.ACC, FV.ACC)
    CALL F.READ(FN.ACC, R.DEAL.ARRAY<2,POS1>, RS.ACC, FV.ACC, ACC.ERR)
    Y.CATEG = RS.ACC<AC.CATEGORY>
    Y.CUSTOMER = RS.ACC<AC.CUSTOMER>

*PARA ABRIR EL ACHIVO DE ACCOUNT
    FN.CUS = "FBNK.CUSTOMER"
    FV.CUS = ""
    RS.CUS = ""
    CUS.ERR = ""
    OUT.ARR = ''

    CALL OPF(FN.CUS, FV.CUS)
    CALL F.READ(FN.CUS, Y.CUSTOMER, RS.CUS, FV.CUS, CUS.ERR)

*CALL DR.REG.GET.CUST.TYPE(RS.CUS, OUT.ARR)
    APAP.LAPAP.drRegGetCustType(RS.CUS, OUT.ARR) ;*R22 MANUAL CODE CONVERSION
    Y.CUS.IDENT = EREPLACE(OUT.ARR<2>, "-", "")

*--DETERMINAMOS LA ETIQUETA QUE SE VA A MOSTRAR
    IF Y.FIELD.NAME EQ 'Y.CREDIT.NUMBER' THEN

        IF Y.CATEG EQ '3173' OR Y.CATEG EQ '3174' THEN
            Y.INP.DEAL = FMT('No. TC / ID:', "13L")
            RETURN
        END ELSE
            Y.INP.DEAL = FMT('No. PR / ID:', "13L")
            RETURN
        END

    END

*--DETERMINAMOS SI SE MUESTRA EL PRESTAMO O LA TARJETA
    IF Y.FIELD.NAME EQ 'Y.LOAN.ACCOUNT' THEN

        IF Y.CATEG EQ '3173' OR Y.CATEG EQ '3174' THEN

            Y.TC.NUMBER = RS.ACC<AC.ALT.ACCT.ID,3>

            Y.TC.NUMBER = SUBSTRINGS(Y.TC.NUMBER,0,6) : "******" : SUBSTRINGS(Y.TC.NUMBER,13,4) : " / " : Y.CUS.IDENT

            Y.INP.DEAL = FMT(Y.TC.NUMBER, "29R")

            RETURN

        END ELSE

            Y.INP.DEAL = R.DEAL.ARRAY<2,POS1> : " / " : Y.CUS.IDENT
            Y.INP.DEAL = FMT(Y.INP.DEAL, "29R")

            RETURN
        END

    END

*--DETERMINAMOS QUE SE MOSTRARA EN LA COLETILLA
    IF Y.FIELD.NAME EQ 'Y.COLETILLA1' THEN

        IF Y.CATEG EQ '3173' OR Y.CATEG EQ '3174' THEN
            Y.INP.DEAL = FMT(" ", "36L")
            RETURN
        END ELSE
            Y.INP.DEAL = FMT("Las transacciones en fines de semana", "36L")
            RETURN
        END

    END

    IF Y.FIELD.NAME EQ 'Y.COLETILLA2' THEN

        IF Y.CATEG EQ '3173' OR Y.CATEG EQ '3174' THEN
            Y.INP.DEAL = FMT(" ", "34L")
            RETURN
        END ELSE
            Y.INP.DEAL = FMT("y días feriados serán aplicadas el", "34L")
            RETURN
        END

    END

    IF Y.FIELD.NAME EQ 'Y.COLETILLA3' THEN

        IF Y.CATEG EQ '3173' OR Y.CATEG EQ '3174' THEN
            Y.INP.DEAL = FMT(" ", "22L")
            RETURN
        END ELSE
            Y.INP.DEAL = FMT("próximo día laborable.", "22L")
            RETURN
        END

    END


END
