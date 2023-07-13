$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.DESM.RUEDA.TWO(AA.ARR.ID)

*----------------------------------------------
* ET-5437 - Desmonte Rueda tu cuota V2          *
*----------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - VM to @VM , FM to @FM ,SM to @SM
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.DATES
    $INSERT I_LAPAP.DESM.RUEDA.TWO.COMO

    GOSUB MAIN.PROCESS

RETURN


MAIN.PROCESS:
************

    Y.ARRANGEMENT.ID = '';
    Y.MONTO.CURACCOUNT.IN = '';
    Y.ACCPRINCIPALINT.IN  = '';
    Y.NUEVA.TASA.IN = '';
    Y.CUOTA.PROG.IN = '';
    Y.MONTO.PRELACION = 0;
    INFILE.MONTO.PRELACION = "";
    INFILE.DELETE.FROM.PRELAC.TABLE = "";

    LOOP
        REMOVE Y.REGISTRO FROM AA.ARR.ID SETTING PROCESO.POS
    WHILE  Y.REGISTRO DO

        Y.REGISTRO.POS = CHANGE(Y.REGISTRO,'|',@FM);

        Y.ARRANGEMENT.ID             = Y.REGISTRO.POS<1>
        Y.MONTO.CURACCOUNT.IN        = Y.REGISTRO.POS<2>
        Y.ACCPRINCIPALINT.IN         = Y.REGISTRO.POS<3>
        Y.NUEVA.TASA.IN              = Y.REGISTRO.POS<4>
        Y.CUOTA.PROG.IN              = Y.REGISTRO.POS<5>
        Y.MONTO.PRELACION            = Y.REGISTRO.POS<6>

        IF Y.ARRANGEMENT.ID EQ '' THEN
            CONTINUE
        END

        CRT "PROCESANDO: ":Y.ARRANGEMENT.ID;

        CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(Y.ARRANGEMENT.ID,OUT.RECORD)
        R.AA.TERM.AMOUNT          = FIELD(OUT.RECORD,"*",1)
        R.AA.PAYMENT.SCHEDULE.APP = FIELD(OUT.RECORD,"*",3)
        R.AA.INTEREST             = FIELD(OUT.RECORD,"*",7)

        GOSUB GET.ARRAGEMENT
        GOSUB STRING.MONTO.PRELACION
        GOSUB STRING.DELETE.FROM.PRELAC.TABLE
        GOSUB GET.AA.PAYMENT.SHEDULE

**********************************
        GOSUB GRUPO1.AJUSTAR.CURAC.ACCPRIN
        GOSUB GRUPO2.CAMBIO.TASA
        GOSUB GRUPO3.ACTUALIZAR.CUOTA.PROG
**********************************

    REPEAT


RETURN

STRING.MONTO.PRELACION:
***********************
    INFILE.MONTO.PRELACION<-1> = Y.ARRANGEMENT.ID:"|":Y.ARRANGEMENT.ID:"|":Y.NUMERO.PRESTAMO:"|":Y.MONTO.PRELACION :"|";

    Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO4";
    R.LAPAP.DESM.RUEDA.TWO = INFILE.MONTO.PRELACION;
    GOSUB CHECK.ARCHIVO.FILES

RETURN

STRING.DELETE.FROM.PRELAC.TABLE:
***********************
    INFILE.DELETE.FROM.PRELAC.TABLE<-1> = Y.ARRANGEMENT.ID;

    Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO5";
    R.LAPAP.DESM.RUEDA.TWO = INFILE.DELETE.FROM.PRELAC.TABLE;
    GOSUB CHECK.ARCHIVO.FILES

RETURN


GET.ARRAGEMENT:
***************

    R.ARRANGEMENT = ''; ERR.ARRAGEMENT = ''; CLIENTE.ID = '';
    CALL AA.GET.ARRANGEMENT(Y.ARRANGEMENT.ID,R.ARRANGEMENT,ERR.ARRAGEMENT)

    Y.COMPANY          = R.ARRANGEMENT<AA.ARR.CO.CODE>
    Y.ARR.STATUS       = R.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.PRODUCT.GROUP    = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.NUMERO.PRESTAMO  = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>

    IF Y.ARR.STATUS EQ 'CLOSE' THEN

        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.DESM.RUEDA.TWO = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO - PRESTAMO CANCELADO|";
        GOSUB CHECK.ARCHIVO.FILES

        RETURN
    END

RETURN

VERIFICAR.BACK.TO.BACK:
***********************

    Y.PRESTAMO.BACK.TO.BACK = 'NO';
    CALL GET.LOC.REF("AA.PRD.DES.INTEREST","L.AA.REV.RT.TY",REVRATE.POS)

    Y.L.AA.REV.RT.TY = R.AA.INTEREST<AA.INT.LOCAL.REF,REVRATE.POS>

    IF Y.L.AA.REV.RT.TY EQ "Back.To.Back" OR Y.L.AA.REV.RT.TY EQ "BACK.TO.BACK" THEN
        Y.PRESTAMO.BACK.TO.BACK = 'SI';
    END

RETURN

GET.AA.PAYMENT.SHEDULE:
***********************

    Y.PAYMENT.TYPE =  R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.TYPE>
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,@SM,@FM)
    Y.PAYMENT.TYPE = CHANGE(Y.PAYMENT.TYPE,@VM,@FM)

    Y.PAYMENT.METHOD = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.METHOD>
    Y.PAYMENT.METHOD = CHANGE(Y.PAYMENT.METHOD,@SM,@FM)
    Y.PAYMENT.METHOD = CHANGE(Y.PAYMENT.METHOD,@VM,@FM)

    Y.ACTUAL.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.ACTUAL.AMT>
    Y.ACTUAL.AMT = CHANGE(Y.ACTUAL.AMT,@SM,@FM)
    Y.ACTUAL.AMT = CHANGE(Y.ACTUAL.AMT,@VM,@FM)

    Y.PROPERTY = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PROPERTY>

RETURN


GRUPO1.AJUSTAR.CURAC.ACCPRIN:
****************************
*ajuste intereses y cargos a favor del cliente si corresponde

    GRUPO1 = "";

    IF Y.MONTO.CURACCOUNT.IN EQ '0' OR Y.MONTO.CURACCOUNT.IN EQ '0.00' THEN

        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.DESM.RUEDA.TWO = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO DE LA ETAPA #2 - CURRACCOUNT IGUAL A 0. MINIMO 0.1|";
        GOSUB CHECK.ARCHIVO.FILES

    END ELSE

        IF Y.MONTO.CURACCOUNT.IN NE '' AND Y.ACCPRINCIPALINT.IN NE '' THEN

            GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:1:1::ADJ.BAL.AMT:2:1||":Y.MONTO.CURACCOUNT.IN:"::":Y.ACCPRINCIPALINT.IN:"||";

        END ELSE

            IF Y.MONTO.CURACCOUNT.IN EQ '' AND Y.ACCPRINCIPALINT.IN NE '' THEN
                GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:2:1||":Y.ACCPRINCIPALINT.IN:"||";
            END

            IF Y.MONTO.CURACCOUNT.IN NE '' AND Y.ACCPRINCIPALINT.IN EQ '' THEN
                GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:1:1||":Y.MONTO.CURACCOUNT.IN:"||";
            END

        END

        IF GRUPO1 NE '' THEN
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO1";
            R.LAPAP.DESM.RUEDA.TWO = GRUPO1;
            GOSUB CHECK.ARCHIVO.FILES
        END
    END

RETURN

GRUPO2.CAMBIO.TASA:
*******************

    GOSUB VERIFICAR.BACK.TO.BACK

    GRUPO2 = "";

    IF Y.PRESTAMO.BACK.TO.BACK EQ 'SI' THEN

        GRUPO2<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-CHANGE-PRINCIPALINT||":Y.COMPANY:"||PRINCIPALINT||MARGIN.RATE:1:1||":Y.NUEVA.TASA.IN:"||";
        GRUPO2<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-CHANGE-PENALTINT||":Y.COMPANY:"||PENALTINT||MARGIN.RATE:1:1||":Y.NUEVA.TASA.IN:"||";

    END ELSE
        GRUPO2<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-CHANGE-PRINCIPALINT||":Y.COMPANY:"||PRINCIPALINT||FIXED.RATE||":Y.NUEVA.TASA.IN:"||";
        GRUPO2<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-CHANGE-PENALTINT||":Y.COMPANY:"||PENALTINT||FIXED.RATE||":Y.NUEVA.TASA.IN:"||";
    END

    IF GRUPO2 NE '' THEN
        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO2";
        R.LAPAP.DESM.RUEDA.TWO = GRUPO2;
        GOSUB CHECK.ARCHIVO.FILES
    END

RETURN

GRUPO3.ACTUALIZAR.CUOTA.PROG:
****************************

    GRUPO3 = "";
    Y.STRING.GRUPO3 = '';
    Y.APLICA.CUOTA.PROG = '';
    Y.CUOTA.PROG.ACTUALIZAR = '';

*Paso 1: Verificar que valor tiene el contrato para el tipo de pago CONSTANTE
    FINDSTR 'CONSTANTE' IN Y.PAYMENT.TYPE SETTING V.FLD, V.VAL THEN
*Y.CUOTA.PROG.PRESTAMO = Y.ACTUAL.AMT<V.VAL>;

*Si en el INFILE viene valor, actualizar el campo con el nuevo valor
        IF Y.CUOTA.PROG.IN NE '' THEN
            Y.APLICA.CUOTA.PROG = 'SI';
            Y.CUOTA.PROG.ACTUALIZAR = Y.CUOTA.PROG.IN;
        END

*Si INFILE trae BORRAR = quitará (limpiará) el Valor de Cuota_Progr que exista en el campo
        IF Y.CUOTA.PROG.IN EQ 'BORRAR' THEN
            Y.APLICA.CUOTA.PROG = 'SI';
            Y.CUOTA.PROG.ACTUALIZAR = '';
        END

*si NO cambia durante el Desmonte (INFILE = Vacío), NO deberá realizarse cambio al campo
        IF Y.CUOTA.PROG.IN EQ 'VACIO' THEN
            Y.APLICA.CUOTA.PROG = 'NO';
            Y.CUOTA.PROG.ACTUALIZAR = '';
        END

    END

    Y.FIELD.NAME  = "";
    Y.FIELD.VALUE = "";

    IF Y.APLICA.CUOTA.PROG EQ 'SI' THEN

        FINDSTR 'CONSTANTE' IN Y.PAYMENT.TYPE SETTING V.FLD, V.VAL THEN

            Y.FIELD.NAME ="||":Y.ARRANGEMENT.ID:"||LENDING-CHANGE-REPAYMENT.SCHEDULE||":Y.COMPANY:"||REPAYMENT.SCHEDULE||";

            Y.PROPERTY.POS = Y.PROPERTY<1,V.FLD,1>;
            Y.PROPERTY.POS.2 = Y.PROPERTY<1,V.FLD,2>;

            IF Y.PROPERTY.POS EQ 'ACCOUNT' THEN
                Y.FIELD.NAME := "PAYMENT.TYPE:":V.FLD:":1::PROPERTY:":V.FLD:":1::ACTUAL.AMT||";
                Y.FIELD.VALUE := Y.PAYMENT.TYPE<V.FLD>:"::":Y.PROPERTY.POS:"::":Y.CUOTA.PROG.ACTUALIZAR:"||";
            END ELSE
                Y.FIELD.NAME := "PAYMENT.TYPE:":V.FLD:":1::PROPERTY:":V.FLD:":2::ACTUAL.AMT||";
                Y.FIELD.VALUE := Y.PAYMENT.TYPE<V.FLD>:"::":Y.PROPERTY.POS.2:"::":Y.CUOTA.PROG.ACTUALIZAR:"||";
            END

        END

        Y.STRING.GRUPO3 = Y.FIELD.NAME:Y.FIELD.VALUE;

        IF Y.FIELD.VALUE NE '' THEN
            GRUPO3<-1> = Y.STRING.GRUPO3;
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO3";
            R.LAPAP.DESM.RUEDA.TWO = GRUPO3;
            GOSUB CHECK.ARCHIVO.FILES
        END

    END ELSE
        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.DESM.RUEDA.TWO = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO DE LA ETAPA #4 DE FORMA INTENCIONAL - POSEE VALOR [VACIO] EN LA POSICION [CUOTA.PROG] DEL INFILE|";
        GOSUB CHECK.ARCHIVO.FILES

    END

RETURN


CHECK.ARCHIVO.FILES:
********************
    CALL F.WRITE(FN.LAPAP.DESM.RUEDA.TWO,Y.ID.GRUPO,R.LAPAP.DESM.RUEDA.TWO);
RETURN
