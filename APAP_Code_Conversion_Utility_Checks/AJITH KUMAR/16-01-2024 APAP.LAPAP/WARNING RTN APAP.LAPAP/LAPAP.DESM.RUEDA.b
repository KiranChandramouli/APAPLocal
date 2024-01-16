* @ValidationCode : MjotMTM1ODIzMDk5OkNwMTI1MjoxNzA0ODYxNzE4MDMxOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Jan 2024 10:11:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.DESM.RUEDA(AA.ARR.ID)

*----------------------------------------------
* ET-5437 - Desmonte Rueda tu cuota           *
*----------------------------------------------
*Realizar mantenimiento en el CURACCOUNT por el valor capturado en el paso 1 con signo POSITIVO.
*Realizar mantenimiento en el ACCPRINCIPALINT por el valor capturado en el paso 1 con signo NEGATIVO.
*Realizar recalculo de la cuota luego de ejecutar el paso 3.
*Incorporar un valor en el campo CUOTA PROG en el plan de pagos, solo para los casos que aplique, estos serán detectados previo análisis. Este valor será indicado mediante un archivo plano donde tendrá el número de préstamo y el valor a colocar.
*Realizar cambio de tasa a los préstamos identificados.
*Realizar mantenimiento al saldo ACCPRINCIPALINT por el valor indicado mediante archivo de texto con signo POSITIVO.
* Se agrega el GROUP-EMP al GROP.POLICY de la etapa de poliza. 21-04-2021.
*----------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 13-JULY-2023      Harsha                R22 Auto Conversion  - VM to @VM , FM to @FM ,SM to @SM and J to J.VAR
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
  *  $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.DATES
    $INSERT I_LAPAP.DESM.RUEDA.COMO
    $USING APAP.AA
   $USING EB.LocalReferences
   $USING AA.Framework
    GOSUB MAIN.PROCESS

RETURN


MAIN.PROCESS:
************

    Y.ARRANGEMENT.ID = '';
*Monto para disminuir el CURACCOUNT. valor en POSITIVO
    Y.MONTO.CURACCOUNT.IN = '';
*Aumento intereses vigente (ACCPRINCIPALINT). Valor negativo
    Y.ACCPRINCIPALINT.IN  = '';
*Disminuir valor del capital CURACCOUNT (ajuste intereses y cargos a favor del cliente si corresponde). Valor positivo
    Y.MONTO.CURACCOUNT2.IN = '';
*Ajuste intereses y cargos a favor de APAP. Valor negativo
    Y.ACCPRINCIPALINT2.IN  = '';

    Y.NUEVA.TASA.IN = '';
    Y.CUOTA.PROG.IN = '';
    Y.INFO.SEGURO.IN = '';
    Y.SEGURO.MULTIVALOR = '';
    Y.PROPIEDAD.SEGURO  = '';
    Y.ID.POLIZA = '';
    Y.VALOR.PRIMA = '';
    Y.VALOR.EXTRA.PRIMA = '';
    Y.FECHA.VENC.POLIZA = '';
    Y.MONTO.ASEGURADO = '';
    Y.MONTO.PRELACION = 0;
    INFILE.MONTO.PRELACION = "";

    LOOP
        REMOVE Y.REGISTRO FROM AA.ARR.ID SETTING PROCESO.POS
    WHILE  Y.REGISTRO DO

        Y.REGISTRO.POS = CHANGE(Y.REGISTRO,'|',@FM);

        Y.ARRANGEMENT.ID             = Y.REGISTRO.POS<2>

        Y.MONTO.CURACCOUNT.IN        = Y.REGISTRO.POS<3>
        Y.ACCPRINCIPALINT.IN         = Y.REGISTRO.POS<4>

        Y.MONTO.CURACCOUNT2.IN       = Y.REGISTRO.POS<5>
        Y.ACCPRINCIPALINT2.IN        = Y.REGISTRO.POS<6>

        Y.NUEVA.TASA.IN              = Y.REGISTRO.POS<7>
        Y.CUOTA.PROG.IN              = Y.REGISTRO.POS<8>
        Y.MONTO.PRELACION            = (Y.ACCPRINCIPALINT.IN + Y.ACCPRINCIPALINT2.IN);
        Y.MONTO.PRELACION            = ABS(Y.MONTO.PRELACION);

*Informacion de seguros
        Y.INFO.SEGURO.IN             = Y.REGISTRO.POS<9>
        IF Y.INFO.SEGURO.IN NE '' THEN
            Y.SEGURO.MULTIVALOR      = CHANGE(Y.INFO.SEGURO.IN,',',@FM);
        END

        IF Y.ARRANGEMENT.ID EQ '' THEN
            CONTINUE
        END

        CRT "PROCESANDO: ":Y.ARRANGEMENT.ID;

*       CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(Y.ARRANGEMENT.ID,OUT.RECORD)
        APAP.AA.redoBConLnsByDebtorAaRecs(Y.ARRANGEMENT.ID,OUT.RECORD) ;* R22 Manual Code Conversion
        R.AA.TERM.AMOUNT          = FIELD(OUT.RECORD,"*",1)
        R.AA.PAYMENT.SCHEDULE.APP = FIELD(OUT.RECORD,"*",3)
        R.AA.INTEREST             = FIELD(OUT.RECORD,"*",7)

        GOSUB GET.ARRAGEMENT
        GOSUB STRING.MONTO.PRELACION
        GOSUB GET.AA.PAYMENT.SHEDULE

**********************************
        GOSUB GRUPO1.AJUSTAR.CURAC.ACCPRIN
        GOSUB GRUPO2.CAMBIO.TASA
        GOSUB GRUPO3.AJUSTE.PRIMAS.SEGUROS
        GOSUB GRUPO4.ACTUALIZAR.CUOTA.PROG
        GOSUB GRUPO5.ACTUALIZAR.POLIZA
**********************************

    REPEAT


RETURN

STRING.MONTO.PRELACION:
***********************
    INFILE.MONTO.PRELACION<-1> = Y.ARRANGEMENT.ID:"|":Y.MONTO.PRELACION :"|";

    Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO6";
    R.LAPAP.DESM.RUEDA = INFILE.MONTO.PRELACION;
    GOSUB CHECK.ARCHIVO.FILES

RETURN


GET.ARRAGEMENT:
***************

    R.ARRANGEMENT = ''; ERR.ARRAGEMENT = ''; CLIENTE.ID = '';
*    CALL AA.GET.ARRANGEMENT(Y.ARRANGEMENT.ID,R.ARRANGEMENT,ERR.ARRAGEMENT)
AA.Framework.GetArrangement(Y.ARRANGEMENT.ID,R.ARRANGEMENT,ERR.ARRAGEMENT);* R22 UTILITY AUTO CONVERSION

  *  Y.COMPANY          = R.ARRANGEMENT<AA.ARR.CO.CODE>
   * Y.ARR.STATUS       = R.ARRANGEMENT<AA.ARR.ARR.STATUS>
   * Y.PRODUCT.GROUP    = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
   * Y.NUMERO.PRESTAMO  = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
       Y.COMPANY          = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrCoCode >
    Y.ARR.STATUS       = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrArrStatus>
    Y.PRODUCT.GROUP    = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProductGroup>
    Y.NUMERO.PRESTAMO  = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId>

    

    IF Y.ARR.STATUS EQ 'CLOSE' THEN

        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.DESM.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO - PRESTAMO CANCELADO|";
        GOSUB CHECK.ARCHIVO.FILES

        RETURN
    END

RETURN

VERIFICAR.BACK.TO.BACK:
***********************

    Y.PRESTAMO.BACK.TO.BACK = 'NO';
*    CALL GET.LOC.REF("AA.PRD.DES.INTEREST","L.AA.REV.RT.TY",REVRATE.POS)
EB.LocalReferences.GetLocRef("AA.PRD.DES.INTEREST","L.AA.REV.RT.TY",REVRATE.POS);* R22 UTILITY AUTO CONVERSION

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


GET.LOC.REF:
************

    Y.APPLN = "AA.ARR.TERM.AMOUNT";
    Y.FLD = "L.AA.COL":@VM:"L.AA.COL.VAL";
    Y.POS = "";

    CALL MULTI.GET.LOC.REF(Y.APPLN,Y.FLD,Y.POS)
    L.AA.COL.POS        = Y.POS<1,1>
    L.AA.COL.VAL.POS    = Y.POS<1,2>

RETURN

GET.MAX.COLLATERAL.ID:
**********************

    COLLATERAL.ID = '';
    COLLATERAL.VALUE = '';
    COLLATERAL.VALUE.MAX= "";
    COLLATERAL.ID.MAX= "";

*   CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(Y.ARRANGEMENT.ID,OUT.RECORD)
    APAP.AA.redoBConLnsByDebtorAaRecs(Y.ARRANGEMENT.ID,OUT.RECORD) ;*R22 Manual Code Conversion

    R.AA.TERM.AMOUNT.APP      = FIELD(OUT.RECORD,"*",1)

    COLLATERAL.ID = R.AA.TERM.AMOUNT.APP<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    COLLATERAL.ID  = CHANGE(COLLATERAL.ID ,@SM,@FM)
    COLLATERAL.ID  = CHANGE(COLLATERAL.ID ,@VM,@FM)

    COLLATERAL.VALUE = R.AA.TERM.AMOUNT.APP<AA.AMT.LOCAL.REF,L.AA.COL.VAL.POS>
    COLLATERAL.VALUE = CHANGE(COLLATERAL.VALUE,@SM,@FM)
    COLLATERAL.VALUE = CHANGE(COLLATERAL.VALUE,@VM,@FM)

*Obtener el ID.GARANTIA que contenga el mayor valor
    COLL.ID.COUNT = DCOUNT(COLLATERAL.ID,@FM);

    IF COLL.ID.COUNT GT 1 THEN

        COLLATERAL.VALUE.POS = SORT(COLLATERAL.VALUE)
        COLLATERAL.VALUE.MAX = COLLATERAL.VALUE.POS<COLL.ID.COUNT>

        LOCATE COLLATERAL.VALUE.MAX IN COLLATERAL.VALUE SETTING POS.L.LOCAL THEN
            COLLATERAL.ID.MAX =  COLLATERAL.ID<POS.L.LOCAL>
        END

    END ELSE
        COLLATERAL.ID.MAX    = COLLATERAL.ID;
        COLLATERAL.VALUE.MAX = COLLATERAL.VALUE
    END

RETURN

GRUPO1.AJUSTAR.CURAC.ACCPRIN:
****************************
*ajuste intereses y cargos a favor del cliente si corresponde

    GRUPO1 = "";

    IF Y.MONTO.CURACCOUNT.IN EQ '0' OR Y.MONTO.CURACCOUNT.IN EQ '0.00' THEN

        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.DESM.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO DE LA ETAPA #2 - CURRACCOUNT IGUAL A 0. MINIMO 0.1|";
        GOSUB CHECK.ARCHIVO.FILES

    END ELSE

        IF Y.MONTO.CURACCOUNT.IN NE '' AND Y.ACCPRINCIPALINT.IN NE '' THEN

            GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:1:1::ADJ.BAL.AMT:2:1||":Y.MONTO.CURACCOUNT.IN:"::":Y.ACCPRINCIPALINT.IN:"||";
            GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:1:1::ADJ.BAL.AMT:2:1||":Y.MONTO.CURACCOUNT2.IN:"::":Y.ACCPRINCIPALINT2.IN:"||";

        END ELSE

            IF Y.MONTO.CURACCOUNT.IN EQ '' AND Y.ACCPRINCIPALINT.IN NE '' THEN
                GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:2:1||":Y.ACCPRINCIPALINT.IN:"||";
                GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:2:1||":Y.ACCPRINCIPALINT2.IN:"||";
            END

            IF Y.MONTO.CURACCOUNT.IN NE '' AND Y.ACCPRINCIPALINT.IN EQ '' THEN
                GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:1:1||":Y.MONTO.CURACCOUNT.IN:"||";
                GRUPO1<-1> = "||":Y.ARRANGEMENT.ID:"||LENDING-ADJUST.BALANCE-MANT.SALD.CUOTA||":Y.COMPANY:"||MANT.SALD.CUOTA||ADJ.BAL.AMT:1:1||":Y.MONTO.CURACCOUNT2.IN:"||";
            END

        END

        IF GRUPO1 NE '' THEN
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO1";
            R.LAPAP.DESM.RUEDA = GRUPO1;
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
        R.LAPAP.DESM.RUEDA = GRUPO2;
        GOSUB CHECK.ARCHIVO.FILES
    END

RETURN


GRUPO3.AJUSTE.PRIMAS.SEGUROS:
****************************

    GRUPO3 = "";
    Y.STRING.GRUPO3  = '';
    Y.FIELD.NAME  = "";
    Y.FIELD.VALUE = "";

    IF Y.INFO.SEGURO.IN NE '' THEN

        Y.FIELD.NAME ="||":Y.ARRANGEMENT.ID:"||LENDING-CHANGE-REPAYMENT.SCHEDULE||":Y.COMPANY:"||REPAYMENT.SCHEDULE||";
        Y.FIELD.VALUE = "";
        Y.SEGURO.MULTIVALOR    = CHANGE(Y.SEGURO.MULTIVALOR,',',@FM);
        Y.CNT.POLIZA           = DCOUNT(Y.SEGURO.MULTIVALOR,@FM);

        IF Y.CNT.POLIZA GT 0 THEN

            J.VAR = 0;
            FOR J.VAR = 1 TO Y.CNT.POLIZA

                Y.TIPO.POLIZA.SELECT = ""; Y.DATA.PRIMA = '';
                Y.DATA.PRIMA  = CHANGE(Y.SEGURO.MULTIVALOR<J.VAR>,'*',@FM);
                Y.TIPO.POLIZA.SELECT  = Y.DATA.PRIMA<1>;
                Y.MONTO.PRIMA.CARGO.FINAL = 0;
                Y.MONTO.EXTRA.PRIMA.CARGO = 0;
                Y.MONTO.PRIMA.CARGO  = 0;
                Y.DATA.POLIZA = '';


                FINDSTR Y.TIPO.POLIZA.SELECT IN Y.PROPERTY SETTING V.FLD, V.VAL THEN

                    Y.PROPERTY.POS = "";
                    Y.PROPERTY.POS             = Y.PROPERTY<1,V.VAL,1>;
                    Y.DATA.POLIZA              = CHANGE(Y.SEGURO.MULTIVALOR<J.VAR>,'*',@FM);
                    Y.MONTO.PRIMA.CARGO        = Y.DATA.POLIZA<2>
                    Y.MONTO.EXTRA.PRIMA.CARGO  = Y.DATA.POLIZA<3>
                    Y.MONTO.PRIMA.CARGO.FINAL  = ABS(Y.MONTO.PRIMA.CARGO) + ABS(Y.MONTO.EXTRA.PRIMA.CARGO);

                    Y.FIELD.NAME := "PAYMENT.TYPE:":V.VAL:":1::PAYMENT.METHOD:":V.VAL:":1::PROPERTY:":V.VAL:":1::ACTUAL.AMT:":V.VAL:":1::";
                    Y.FIELD.VALUE := Y.PAYMENT.TYPE<V.VAL>:"::":Y.PAYMENT.METHOD<V.VAL>:"::":Y.PROPERTY.POS:"::":Y.MONTO.PRIMA.CARGO.FINAL:"::";

                    IF J.VAR EQ Y.CNT.POLIZA THEN
                        IF RIGHT(Y.FIELD.NAME,2) EQ "::" AND RIGHT(Y.FIELD.VALUE,2) EQ "::" THEN
                            Y.FIELD.NAME = SUBSTRINGS (Y.FIELD.NAME, 0, (LEN(Y.FIELD.NAME)-2));
                            Y.FIELD.VALUE = SUBSTRINGS (Y.FIELD.VALUE, 0, (LEN(Y.FIELD.VALUE)-2));
                            Y.FIELD.NAME := "||";
                            Y.FIELD.VALUE := "||";
                        END
                    END

                END ELSE

                    IF J.VAR EQ Y.CNT.POLIZA THEN
                        IF RIGHT(Y.FIELD.NAME,2) EQ "::" AND RIGHT(Y.FIELD.VALUE,2) EQ "::" THEN
                            Y.FIELD.NAME = SUBSTRINGS (Y.FIELD.NAME, 0, (LEN(Y.FIELD.NAME)-2));
                            Y.FIELD.VALUE = SUBSTRINGS (Y.FIELD.VALUE, 0, (LEN(Y.FIELD.VALUE)-2));
                            Y.FIELD.NAME := "||";
                            Y.FIELD.VALUE := "||";
                        END
                    END

                END

            NEXT J.VAR

        END

        Y.STRING.GRUPO3 = Y.FIELD.NAME:Y.FIELD.VALUE;

        IF Y.FIELD.VALUE NE '' THEN
            GRUPO3<-1> = Y.STRING.GRUPO3;
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO3";
            R.LAPAP.DESM.RUEDA = GRUPO3;
            GOSUB CHECK.ARCHIVO.FILES
        END

    END ELSE
        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.DESM.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO DE LA ETAPA #3 - NO TIENE INFO DE CARGOS/SEGUROS|";
        GOSUB CHECK.ARCHIVO.FILES
    END

RETURN

GRUPO4.ACTUALIZAR.CUOTA.PROG:
****************************

    GRUPO4 = "";
    Y.STRING.GRUPO4 = '';
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

        Y.STRING.GRUPO4 = Y.FIELD.NAME:Y.FIELD.VALUE;

        IF Y.FIELD.VALUE NE '' THEN
            GRUPO4<-1> = Y.STRING.GRUPO4;
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO4";
            R.LAPAP.DESM.RUEDA = GRUPO4;
            GOSUB CHECK.ARCHIVO.FILES
        END

    END ELSE
        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.DESM.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO DE LA ETAPA #4 DE FORMA INTENCIONAL - POSEE VALOR [VACIO] EN LA POSICION [CUOTA.PROG] DEL INFILE|";
        GOSUB CHECK.ARCHIVO.FILES

    END

RETURN


GRUPO5.ACTUALIZAR.POLIZA:
************************
    GOSUB GET.LOC.REF
    GOSUB GET.MAX.COLLATERAL.ID
    GOSUB GRUPO5.UPDATE.POLIZA.TABLE
RETURN

GRUPO5.UPDATE.POLIZA.TABLE:
**************************

    GRUPO5 = ''; POLIZA.ID = '';
    GRUPO5.REV = ""; Y.DATA = '';

    R.APAP.H.INSURANCE.ID.CONCAT =''; ERR.AHIC = ''; INSUR.REC = ''; INSUR.REC.CNT = 0; YGRP.CNT = 0;
    NO.OF.REC = ''; SEL.ERR = '' ;

    SEL.CMD = "SELECT ":FN.APAP.H.INSURANCE.DETAILS:" WITH ASSOCIATED.LOAN EQ ":Y.ARRANGEMENT.ID: " BY POL.EXP.DATE";
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR);
    Y.DATA = SEL.LIST;
    INSUR.REC.CNT = DCOUNT(SEL.LIST,@FM);

    IF INSUR.REC.CNT GT 0 THEN

        LOOP
            REMOVE POLIZA.ID FROM Y.DATA SETTING INSUR.POS
        WHILE POLIZA.ID DO

            Y.FECHA.VENC.POLIZA = ''; POLIZA.STATUS = ''; Y.INS.DET.INS.AMOUNT = '';
            ERR.APAP.H.INSURANCE.DETAILS = ''; R.APAP.H.INSURANCE.DETAILS = '';  TIPO.POLIZA = '';
            CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,POLIZA.ID,R.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS,ERR.APAP.H.INSURANCE.DETAILS)

            TIPO.POLIZA = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.POLICY.TYPE>
            POLIZA.STATUS = R.APAP.H.INSURANCE.DETAILS<INS.DET.POLICY.STATUS>
            Y.FECHA.VENC.POLIZA = R.APAP.H.INSURANCE.DETAILS<INS.DET.POL.EXP.DATE>

******** PARA REVERSO TECNICO *************
            COLLATERAL.ID.REV = "";
            Y.MONTO.PRIMA.REV        = R.APAP.H.INSURANCE.DETAILS<INS.DET.MON.POL.AMT>
            Y.MONTO.ASEGURADO.REVE   = R.APAP.H.INSURANCE.DETAILS<INS.DET.INS.AMOUNT>
            Y.FECHA.VENC.POLIZA.REVE = R.APAP.H.INSURANCE.DETAILS<INS.DET.POL.EXP.DATE>
*********************************************

            IF Y.FECHA.VENC.POLIZA AND Y.FECHA.VENC.POLIZA GT Y.TODAY AND POLIZA.STATUS EQ 'VIGENTE' THEN

                Y.TIPO.SEGURO = R.APAP.H.INSURANCE.DETAILS<INS.DET.CHARGE>
                Y.CLASE.POLIZA = R.APAP.H.INSURANCE.DETAILS<INS.DET.CLASS.POLICY>

                IF POLIZA.ID NE '' THEN

                    IF TIPO.POLIZA EQ 'VI' THEN
                        COLLATERAL.ID.MAX.TEMP = '';
                    END ELSE
                        COLLATERAL.ID.MAX.TEMP = COLLATERAL.ID.MAX;
                        COLLATERAL.ID.REV = R.APAP.H.INSURANCE.DETAILS<INS.DET.COLLATERAL.ID>
                    END

                    IF Y.CLASE.POLIZA EQ 'GROUP' OR Y.CLASE.POLIZA EQ 'GROUP-EMP' THEN
                        Y.DATA.SEG = '';
                        FINDSTR Y.TIPO.SEGURO IN Y.SEGURO.MULTIVALOR SETTING V.FLD, V.VAL THEN

                            Y.DATA.SEG                 = CHANGE(Y.SEGURO.MULTIVALOR<V.FLD>,'*',@FM);
                            TIPO.POLIZA                = Y.DATA.SEG<1>
                            Y.VALOR.PRIMA.TBL          = Y.DATA.SEG<2>
                            Y.FECHA.VENC.POLIZA.TBL    = Y.DATA.SEG<4>
                            Y.MONTO.ASEGURADO.TBL      = Y.DATA.SEG<5>

                            GRUPO5<-1> = POLIZA.ID:"|":COLLATERAL.ID.MAX.TEMP:"|":Y.VALOR.PRIMA.TBL:"|":Y.FECHA.VENC.POLIZA.TBL:"|":Y.MONTO.ASEGURADO.TBL:"|";
                            GRUPO5.REV<-1> = POLIZA.ID:"|":COLLATERAL.ID.REV:"|":Y.MONTO.PRIMA.REV:"|":Y.FECHA.VENC.POLIZA.REVE:"|":Y.MONTO.ASEGURADO.REVE:"|";

                        END

                    END

                END

            END

        REPEAT

        IF GRUPO5 NE '' THEN
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO5";
            R.LAPAP.DESM.RUEDA = GRUPO5;
            GOSUB CHECK.ARCHIVO.FILES
        END

        IF GRUPO5.REV NE '' THEN
            Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"GRUPO5.REV";
            R.LAPAP.DESM.RUEDA = GRUPO5.REV;
            GOSUB CHECK.ARCHIVO.FILES
        END

    END ELSE
        Y.ID.GRUPO = Y.ARRANGEMENT.ID:"*":"EXCLUIDO";
        R.LAPAP.DESM.RUEDA = Y.ARRANGEMENT.ID:"|PRESTAMO EXCLUIDO DE LA ETAPA #5 - NO TIENE INFO DE SEGUROS PARA ACTUALIZAR POLIZA|";
        GOSUB CHECK.ARCHIVO.FILES
    END

RETURN


CHECK.ARCHIVO.FILES:
********************
    CALL F.WRITE(FN.LAPAP.DESM.RUEDA,Y.ID.GRUPO,R.LAPAP.DESM.RUEDA);
RETURN
