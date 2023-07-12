SUBROUTINE LAPAP.CASTIGADOS.RUEDA(AA.ARR.ID)

*----------------------------------------------
* ET-5532 - RtC Castigados Rueda                *
*----------------------------------------------
*Ajuste del Penalty de las cuotas de los prestamos
*Ticket: https://apap-software.atlassian.net/browse/ET-5532
*----------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.DATES
    $INSERT I_LAPAP.CASTIGADOS.RUEDA.COMO

    GOSUB MAIN.PROCESS
    GOSUB GET.ARRAGEMENT
    GOSUB CHECK.AA.BILL.DETAILS

RETURN


MAIN.PROCESS:
************

    Y.ARRANGEMENT.ID  = '';
    Y.PROPIEDAD.LIST  = '';

    LOOP
        REMOVE Y.REGISTRO FROM AA.ARR.ID SETTING PROCESO.POS
    WHILE  Y.REGISTRO DO

        Y.REGISTRO.POS = CHANGE(Y.REGISTRO,'|',@FM);

        Y.ARRANGEMENT.ID     = Y.REGISTRO.POS<2>
        Y.PROPIEDAD          = Y.REGISTRO.POS<3>

        IF Y.PROPIEDAD NE '' THEN
            Y.PROPIEDAD.LIST = CHANGE(Y.PROPIEDAD,',',@FM);
        END

        IF Y.ARRANGEMENT.ID EQ '' THEN
            CONTINUE
        END

        GOSUB GET.ARRAGEMENT
        GOSUB CHECK.AA.BILL.DETAILS

    REPEAT

RETURN

GET.ARRAGEMENT:
***************

    R.ARRANGEMENT = ''; ERR.ARRAGEMENT = '';
    CALL AA.GET.ARRANGEMENT(Y.ARRANGEMENT.ID,R.ARRANGEMENT,ERR.ARRAGEMENT)

    Y.COMPANY          = R.ARRANGEMENT<AA.ARR.CO.CODE>
    Y.ARR.STATUS       = R.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.PRODUCT.GROUP    = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>

    IF Y.ARR.STATUS EQ 'CLOSE' OR Y.ARR.STATUS EQ 'PENDING.CLOSURE' THEN
        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.CASTIGADOS.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO - PRESTAMO CANCELADO|";
        GOSUB CHECK.ARCHIVO.FILES
        RETURN
    END ELSE
        IF Y.PRODUCT.GROUP NE 'PRODUCTOS.WOF' THEN
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
            R.LAPAP.CASTIGADOS.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO - PRODUCTO NO ES WOF >":Y.PRODUCT.GROUP:"|";
            GOSUB CHECK.ARCHIVO.FILES
            RETURN
        END
    END

RETURN


CHECK.AA.BILL.DETAILS:
**************************
    OR.PROP.AMOUNT  = '';
    PAY.PROPERTY  = '';

    IF Y.PROPIEDAD.LIST NE '' THEN

        AA.BILL.ID = ''; AA.BILL.CNT = 0;  NO.OF.REC = ''; SEL.ERR = '' ;
        SEL.CMD = "SELECT ":FN.AA.BILL:" @ID ARRANGEMENT.ID PAYMENT.DATE PAY.PROPERTY PAYMENT.TYPE OR.PROP.AMOUNT WITH ARRANGEMENT.ID EQ ":Y.ARRANGEMENT.ID: "  AND OS.TOTAL.AMOUNT GT 0 BY PAYMENT.DATE";
        CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
        AA.BILL.CNT = DCOUNT(SEL.LIST,@FM);

        IF AA.BILL.CNT GT 0 THEN

            LOOP
                REMOVE AA.BILL.ID FROM SEL.LIST SETTING INSUR.POS
            WHILE AA.BILL.ID DO

                ERR.AA.BILL = ''; R.AA.BILL = '';
                CALL F.READ(FN.AA.BILL,AA.BILL.ID,R.AA.BILL,F.AA.BILL,ERR.AA.BILL)

                OR.PROP.AMOUNT    = R.AA.BILL<AA.BD.OR.PROP.AMOUNT>

                PAY.PROPERTY      = R.AA.BILL<AA.BD.PAY.PROPERTY>
                PAY.PROPERTY      = CHANGE(PAY.PROPERTY,@SM,@FM)
                PAY.PROPERTY      = CHANGE(PAY.PROPERTY,@VM,@FM)

                GOSUB BUSCAR.PROPIEDAD.FACTURA

            REPEAT

        END ELSE
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
            R.LAPAP.CASTIGADOS.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO - PRODUCTO WOF NO POSEE FACTURA PENDIENTE DE PAGO|";
            GOSUB CHECK.ARCHIVO.FILES
        END

    END ELSE
        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.CASTIGADOS.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO - PRESTAMO NO POSEE LAS PROPIEDADES EN EL INFILE QUE SE VAN AJUSTAR|";
        GOSUB CHECK.ARCHIVO.FILES
    END

RETURN


BUSCAR.PROPIEDAD.FACTURA:
************************

    Y.PROPIEDAD.LIST.MULTI    = CHANGE(Y.PROPIEDAD.LIST,',',@FM);
    Y.CNT.PROPIEDAD           = DCOUNT(Y.PROPIEDAD.LIST,@FM);

    IF Y.CNT.PROPIEDAD GT 0 THEN

        Y.FIELD.NAME  = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BILL-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||";
        Y.FIELD.VALUE = "";

        J.VAR = 0;
        FOR J.VAR = 1 TO Y.CNT.PROPIEDAD

            Y.DATA              = CHANGE(Y.PROPIEDAD.LIST.MULTI<J.VAR>,'*',@FM);
            Y.PRODIEDAD.SELECT  = Y.DATA<1>;
            Y.PRODIEDAD.VALOR   = Y.DATA<2>;

            Y.POS.PROP = '';
            Y.PROP.AMOUNT = '';

            IF Y.PRODIEDAD.VALOR NE '' THEN

                FINDSTR Y.PRODIEDAD.SELECT IN PAY.PROPERTY SETTING V.FLD, V.VAL THEN

                    Y.POS.PROP      = ":":V.VAL:":":V.FLD;
                    Y.PROP.AMOUNT   = OR.PROP.AMOUNT<V.VAL, V.FLD>

*En caso de que el valor del INFILE sea mayor al pendiente en la propiedad x, solo se afectara el valor pendiente. Lo demas quedara como remanente.
                    IF Y.PRODIEDAD.VALOR GT Y.PROP.AMOUNT THEN

                        Y.PRODIEDAD.VALOR.2 = '';
                        Y.DIF.RESTAR      = (Y.PRODIEDAD.VALOR - Y.PROP.AMOUNT);
                        Y.PRODIEDAD.VALOR.2 = (Y.PRODIEDAD.VALOR - Y.DIF.RESTAR);

                        Y.FIELD.NAME  := "ADJ.PROP.AMT:":V.VAL:":":V.FLD:"::";
                        Y.FIELD.VALUE :=  Y.PRODIEDAD.VALOR.2:"::";

                        IF J.VAR EQ Y.CNT.PROPIEDAD THEN
                            IF RIGHT(Y.FIELD.NAME,2) EQ "::" AND RIGHT(Y.FIELD.VALUE,2) EQ "::" THEN
                                Y.FIELD.NAME = SUBSTRINGS (Y.FIELD.NAME, 0, (LEN(Y.FIELD.NAME)-2));
                                Y.FIELD.VALUE = SUBSTRINGS (Y.FIELD.VALUE, 0, (LEN(Y.FIELD.VALUE)-2));
                                Y.FIELD.NAME := "||";
                                Y.FIELD.VALUE := "||";
                            END
                        END

                        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
                        R.LAPAP.CASTIGADOS.RUEDA = Y.ARRANGEMENT.ID:"|EL VALOR [":Y.PRODIEDAD.VALOR:"] DEL INFILE ES > AL PENDIENTE [":Y.PROP.AMOUNT:"] DE LA PROPIEDAD [":Y.PRODIEDAD.SELECT:"] EN LA FACTURA [":AA.BILL.ID:"]| QUEDA UN REMANENTE DE: ":Y.DIF.RESTAR:"|";
                        GOSUB CHECK.ARCHIVO.FILES

                    END ELSE

                        Y.FIELD.NAME  := "ADJ.PROP.AMT:":V.VAL:":":V.FLD:"::";
                        Y.FIELD.VALUE :=  Y.PRODIEDAD.VALOR:"::";

                        IF J.VAR EQ Y.CNT.PROPIEDAD THEN
                            IF RIGHT(Y.FIELD.NAME,2) EQ "::" AND RIGHT(Y.FIELD.VALUE,2) EQ "::" THEN
                                Y.FIELD.NAME = SUBSTRINGS (Y.FIELD.NAME, 0, (LEN(Y.FIELD.NAME)-2));
                                Y.FIELD.VALUE = SUBSTRINGS (Y.FIELD.VALUE, 0, (LEN(Y.FIELD.VALUE)-2));
                                Y.FIELD.NAME := "||";
                                Y.FIELD.VALUE := "||";
                            END
                        END


                    END

                END ELSE

                    IF J.VAR EQ Y.CNT.PROPIEDAD THEN
                        IF RIGHT(Y.FIELD.NAME,2) EQ "::" AND RIGHT(Y.FIELD.VALUE,2) EQ "::" THEN
                            Y.FIELD.NAME = SUBSTRINGS (Y.FIELD.NAME, 0, (LEN(Y.FIELD.NAME)-2));
                            Y.FIELD.VALUE = SUBSTRINGS (Y.FIELD.VALUE, 0, (LEN(Y.FIELD.VALUE)-2));
                            Y.FIELD.NAME := "||";
                            Y.FIELD.VALUE := "||";
                        END
                    END

                END

            END ELSE
                Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
                R.LAPAP.CASTIGADOS.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO - VALOR EN BLANCO|";
                GOSUB CHECK.ARCHIVO.FILES
            END

        NEXT J.VAR

        IF Y.FIELD.VALUE NE '' THEN
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO1";
            R.LAPAP.CASTIGADOS.RUEDA =  Y.FIELD.NAME:Y.FIELD.VALUE;
            GOSUB CHECK.ARCHIVO.FILES
        END

    END ELSE
        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.CASTIGADOS.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO - PRESTAMO NO POSEE LAS PROPIEDADES QUE SE VAN AJUSTAR*|";
        GOSUB CHECK.ARCHIVO.FILES
    END

RETURN

CHECK.ARCHIVO.FILES:
********************
    CALL F.WRITE(FN.LAPAP.CASTIGADOS.RUEDA,Y.ID.GRUPO,R.LAPAP.CASTIGADOS.RUEDA);
RETURN
