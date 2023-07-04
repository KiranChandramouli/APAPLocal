* @ValidationCode : MjotOTM0MDQyMTQ3OkNwMTI1MjoxNjg2Njc0MjU1NDE3OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:07:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RET.10.PRC.RT(Y.FINAL)
*----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date       Author                  Modification Description
* 07-06-2023   Ghayathri T             R22 Manual Conversion - T.CANT.VM.REL.CO and RC variabl initialised
* 24-05-2023   Conversion Tool         R22 Auto Conversion - Changed $INCLUDE to $INSERT
* 24-05-2023   Conversion Tool         R22 Auto Conversion - Changed = Y.TMP.TOTAL.GANADO.LQD + toY.TMP.TOTAL.GANADO.LQD,
*                                                             = Y.TMP.TOTAL.GANADO.LQD+ to Y.TMP.TOTAL.GANADO.LQD +=
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CUST.PRD.LIST


**---------------------------------------------------------------------------------------------
**ABRIR LA TABLA CUSTOMER.ACCOUNT
**---------------------------------------------------------------------------------------------

    FN.CU.ACC = "F.CUSTOMER.ACCOUNT"
    FV.CUS.ACC = ""
    R.CUS.ACC = ""
    CUS.ACC.ERR = ""
    CALL OPF(FN.CU.ACC,FV.CUS.ACC)
**----------------------------------------
**ABRIR LA TABLA FBNK.REDO.CUST.PRD.LIST
**----------------------------------------
    FN.CUS.PRD = "F.REDO.CUST.PRD.LIST"
    FV.CUS.PRD = ""
    R.CUS.PRD = ""
    CUS.PRD.ERR = ""
**---------------------------------------
**ABRIR LA TABLA CUSTOMER
**---------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)
**---------------------------------------
**ABRIR LA TABLA STMT.ACCT.CR
**---------------------------------------
    FN.STMT = "F.STMT.ACCT.CR"
    FV.STMT = ""
    R.STMT = ""
    STMT.ERR = ""
    CALL OPF(FN.STMT,FV.STMT)
**---------------------------------------
**ABRIR LA TABLA STMT.ENTRY
**---------------------------------------
    FN.STMT.EN = "F.STMT.ENTRY"
    FV.STMT.EN = ""
    R.STMT.EN = ""
    STMT.EN.ERR = ""
    CALL OPF(FN.STMT.EN,FV.STMT.EN)
**---------------------------------------
**ABRIR LA TABLA FBNK.REDO.CUST.PRD.LIST
**---------------------------------------
    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""
    FN.ACC.C = "F.ACCOUNT.CLOSED"
    FV.ACC.C = ""
    R.ACC.C = ""
    ACC.ERR.C = ""
    CALL OPF(FN.ACC.C,FV.ACC.C)


**---------------------------------------------------------------------------------------------
**SENTENCIA LOCATE
**---------------------------------------------------------------------------------------------
    LOCATE "CUSTOMER.NUMBER" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.ID = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "PERIOD.FIRST.DATE" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.FECHA.INI.PERIOD = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "PERIOD.LAST.DATE" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.FECHA.FIN.PERIOD = D.RANGE.AND.VALUE<CUS.POS>
    END

**---------------------------------------------------------------------------------------------
**Periodo amigable
**---------------------------------------------------------------------------------------------
    T.ANO.INI = F.FECHA.INI.PERIOD[1,4]
    T.MES.INI = F.FECHA.INI.PERIOD[5,2]
    T.MES.INI.LIT = ""
    T.ANO.FIN = F.FECHA.FIN.PERIOD[1,4]
    T.MES.FIN = F.FECHA.FIN.PERIOD[5,2]
    T.MES.FIN.LIT = ""
    IF T.ANO.INI NE T.ANO.FIN THEN
        ENQ.ERROR = "EL RANGO DE FECHA SELECCIONADO NO PERTENECE A UN MISMO AÑO."
        ENQ.ERROR<1,2> = 1
        RETURN
    END
    BEGIN CASE
        CASE T.MES.INI EQ 1
            T.MES.INI.LIT = "Ene-"
        CASE T.MES.INI EQ 2
            T.MES.INI.LIT = "Feb-"
        CASE T.MES.INI EQ 3
            T.MES.INI.LIT = "Mar-"
        CASE T.MES.INI EQ 4
            T.MES.INI.LIT = "Abr-"
        CASE T.MES.INI EQ 5
            T.MES.INI.LIT = "May-"
        CASE T.MES.INI EQ 6
            T.MES.INI.LIT = "Jun-"
        CASE T.MES.INI EQ 7
            T.MES.INI.LIT = "Jul-"
        CASE T.MES.INI EQ 8
            T.MES.INI.LIT = "Ago-"
        CASE T.MES.INI EQ 9
            T.MES.INI.LIT = "Sep-"
        CASE T.MES.INI EQ 10
            T.MES.INI.LIT = "Oct-"
        CASE T.MES.INI EQ 11
            T.MES.INI.LIT = "Nov-"
        CASE T.MES.INI EQ 12
            T.MES.INI.LIT = "Dic-"
    END CASE

    BEGIN CASE
        CASE T.MES.FIN EQ 1
            T.MES.FIN.LIT = T.MES.INI.LIT:"Ene. ":T.ANO.FIN
        CASE T.MES.FIN EQ 2
            T.MES.FIN.LIT = T.MES.INI.LIT:"Feb. ":T.ANO.FIN
        CASE T.MES.FIN EQ 3
            T.MES.FIN.LIT = T.MES.INI.LIT:"Mar. ":T.ANO.FIN
        CASE T.MES.FIN EQ 4
            T.MES.FIN.LIT = T.MES.INI.LIT:"Abr. ":T.ANO.FIN
        CASE T.MES.FIN EQ 5
            T.MES.FIN.LIT = T.MES.INI.LIT:"May. ":T.ANO.FIN
        CASE T.MES.FIN EQ 6
            T.MES.FIN.LIT = T.MES.INI.LIT:"Jun. ":T.ANO.FIN
        CASE T.MES.FIN EQ 7
            T.MES.FIN.LIT = T.MES.INI.LIT:"Jul. ":T.ANO.FIN
        CASE T.MES.FIN EQ 8
            T.MES.FIN.LIT = T.MES.INI.LIT:"Ago. ":T.ANO.FIN
        CASE T.MES.FIN EQ 9
            T.MES.FIN.LIT = T.MES.INI.LIT:"Sep. ":T.ANO.FIN
        CASE T.MES.FIN EQ 10
            T.MES.FIN.LIT = T.MES.INI.LIT:"Oct. ":T.ANO.FIN
        CASE T.MES.FIN EQ 11
            T.MES.FIN.LIT = T.MES.INI.LIT:"Nov. ":T.ANO.FIN
        CASE T.MES.FIN EQ 12
            T.MES.FIN.LIT = T.MES.INI.LIT:"Dic. ":T.ANO.FIN
    END CASE
    Y.PERIOD = T.MES.FIN.LIT
**---------------------------------------------------------------------------------------------
**VARIABLES PARA LA SELECCION DE LA EJECUCION
**---------------------------------------------------------------------------------------------
    SEL.CMD = ""
    SEL.LIST = ""
    SEL.LIST2 = ""
    NO.OF.RECS = ""
    NO.OF.RECS2 = ""
    SEL.ERR = ""
    SEL.ERR2 = ""
    CU.AC.POS = ""
    STMT.POS = ""
    Y.ARR.STMT.ACC = ""
    Y.ARR.STMT.AZ.ACC = ""
    Y.TOTAL.GANADO = 0
    Y.TOTAL.RETENIDO = 0
    Y.TMP.GANADO = 0
    Y.TMP.RETENIDO = 0
    Y.CONTADOR = 0
    Y.ALL.ACCOUNTS = ""
    Y.TMP.TOTAL.GANADO.LQD = 0
    Y.TMP.TOTAL.RETENIDO.LQD = 0

**---------------------------------------------------------------------------------------------
**VARIABLES PARA EL PERIODO DE X CUENTA
**---------------------------------------------------------------------------------------------
    T.MES.OD = 0
    T.MES.CD = 0
    T.PERIODO.ACT = ""
**------------------------------------------------------------------------------------------------------------------------------------------------
**PRIMERO LEO DESDE LA TABLA CUSTOMER
**------------------------------------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUS,F.ID,R.CUS, FV.CUS, CUS.ERR)
    Y.CUS.NAME.1 = R.CUS<EB.CUS.NAME.1>
    Y.CUS.NAME.2 = R.CUS<EB.CUS.NAME.2>
    
    T.RELATION.CODE  = R.CUS<EB.CUS.RELATION.CODE>
    T.CANT.VM.REL.CO = DCOUNT(T.RELATION.CODE,@VM);* R22 Manual Conversion T.CANT.VM.REL.CO variabl initialised

    CALL GET.LOC.REF("CUSTOMER", "L.CU.CIDENT",CUS.POS)
    Y.CUS.CIDENT = R.CUS<EB.CUS.LOCAL.REF,CUS.POS>
    CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC",CUS.POS.1)
    Y.CUS.RNC = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.1>
    Y.IDENTIFICACION = ""
**-------------------------------------------------------------------------------------------------------------------------------------------------
**VALIDACION 1, SI LA CEDULA ESTA VACIO NO ES CLIENTE FISICO, POR LO TANTO MUESTRO ERROR
**-------------------------------------------------------------------------------------------------------------------------------------------------
    IF Y.CUS.CIDENT EQ "" THEN
        ENQ.ERROR = "EL CLIENTE SOLICITADO NO ES FISICO, REVISE EL CODIGO DE CLIENTE."
        ENQ.ERROR<1,2> = 1
        RETURN
    END
    IF Y.CUS.RNC NE "" THEN
        Y.IDENTIFICACION = Y.CUS.RNC
    END
    IF Y.CUS.CIDENT NE "" THEN
        Y.IDENTIFICACION = Y.CUS.CIDENT
    END

**------------------------------------------------------------------------------------------------------------------------------------
**SEGUNDO PARA DICHO CLIENTE OBTENGO TODAS SUS CUENTAS, Y A SU VEZ PARA CADA CUENTA OBTENGO
**LOS REGISTROS DE RETENCION EN LA TABLA STMT.ACCT.CR
**------------------------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUS.PRD,F.ID,R.CUS.PRD, FV.CUS.PRD, CUS.PRD.ERR)
    Y.CUS.PRD = R.CUS.PRD<PRD.PRODUCT.ID>
    Y.CAN.CUS.PRD = DCOUNT(Y.CUS.PRD,@VM)
    FOR P = 1 TO Y.CAN.CUS.PRD STEP 1
        Y.CTA.ACTUAL = R.CUS.PRD<PRD.PRODUCT.ID,P>
        Y.CTA.ACTUAL.2 = R.CUS.PRD<PRD.PRODUCT.ID,P>
        Y.TMP.TOTAL.GANADO = 0
        Y.TMP.TOTAL.RETENIDO = 0
        T.MES.OD = 0
        T.MES.CD = 0
        T.PERIODO.ACT = ""

**------------------------------------------------------------------------------------------------------------------------------------
**EVALUO SI LA CUENTA ACTUAL YA FUE PROCESADA; DE SER AFIRMATIVO CONTINUO CON EL SIGUIENTE REGISTRO
**------------------------------------------------------------------------------------------------------------------------------------
        FINDSTR Y.CTA.ACTUAL IN Y.ALL.ACCOUNTS SETTING Ap, Vp THEN
            T.CUENTAS.PROCE = " CAMPO ":Ap:", VALOR ":Vp
            CONTINUE
        END ELSE
            T.CUENTAS.PROCE = "A PROCESAR CTA."
        END
        SEL.CMD2 = "SELECT " : FN.STMT : " WITH @ID LIKE " : Y.CTA.ACTUAL : "... AND PERIOD.LAST.DATE GE " : F.FECHA.INI.PERIOD : " AND PERIOD.LAST.DATE LE " : F.FECHA.FIN.PERIOD
        CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.RECS2,SEL.ERR2)
**-------------------------------------------------------------------------------------------------------------------------------------
**BUSCO ESTA CUENTA EN ACCOUNT O ACCOUNT$HIS PARA VERFICIAR SI EL CAMPO L.AC.REINVESTED = YES
**-------------------------------------------------------------------------------------------------------------------------------------

        CALL F.READ(FN.ACC,Y.CTA.ACTUAL,R.ACC, FV.ACC, ACC.ERR)
        T.AC.INTEREST.LIQU.ACCT = ""
        T.L.AC.REINVESTED = ""
        T.AC.CATEGORY = ""
        T.ID = ""
        T.ID = R.ACC<AC.CUSTOMER>

**------------------------------------------------------------------------------------------------------------------------------------
**| PRIMERO BUSCO ESTA CUENTA EN LA TABLA EN-VIVO DE ACCOUNT PARA VALIDAR SI EL CAMPO L.AC.REINVESTED = YES
**| EN CASO AFIRMATIVO ASIGNO SU VALOR A LA VARIABLE T.AC.INTEREST.LIQU.ACCT
**|
**------------------------------------------------------------------------------------------------------------------------------------
        IF T.ID NE "" THEN
            T.AC.CATEGORY = R.ACC<AC.CATEGORY>

            IF T.AC.CATEGORY GE 6012 AND T.AC.CATEGORY LE 6020 THEN
                CONTINUE
            END
            CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
            T.L.AC.REINVESTED = R.ACC<AC.LOCAL.REF,ACC.POS>
            IF T.L.AC.REINVESTED EQ "YES" THEN
                T.AC.INTEREST.LIQU.ACCT = R.ACC<AC.INTEREST.LIQU.ACCT>
            END
        END
**----------------------------------------------------------------------------------------------------------------------------
**| SI LA VARIABLE T.ID ES IGUAL A "" ES PORQUE EL REGISTRO NO SE ENCONTRO EN LA TABLA EN-VIVO DE ACCOUNT;
**| ASI QUE SE PROCEDE A INTENTAR BUSCAR ESTA CUENTA EN ACCOUNT$HIS
**|
**----------------------------------------------------------------------------------------------------------------------------
        IF T.ID EQ "" THEN
            FN.ACC = "F.ACCOUNT$HIS"
            FV.ACC = ""
            R.ACC = ""
            ACC.ERR = ""
            CALL F.READ(FN.ACC,Y.CTA.ACTUAL : ";1",R.ACC, FV.ACC, ACC.ERR)
            T.AC.INTEREST.LIQU.ACCT = ""
            T.L.AC.REINVESTED = ""
            T.ID = ""
            T.ID = R.ACC<AC.CUSTOMER>
            IF T.ID NE "" THEN
                T.AC.CATEGORY = R.ACC<AC.CATEGORY>
                CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
                T.L.AC.REINVESTED = R.ACC<AC.LOCAL.REF,ACC.POS>
                IF T.L.AC.REINVESTED EQ "YES" THEN
                    T.AC.INTEREST.LIQU.ACCT = R.ACC<AC.INTEREST.LIQU.ACCT>
                END
            END
        END

***
**CALL F.READ(FN.ACC.C,NO.CUENTA,R.ACC.C, FV.ACC.C, ACC.ERR.C)
**TMP.CLOSED.DATE = R.ACC.C<1>

        HIS.REC = ''
        YERROR = ''
        FN.AC.HIS = 'F.ACCOUNT$HIS' ; F.AC.HIS = ''
        CALL OPF(FN.AC.HIS,F.AC.HIS)
        CALL EB.READ.HISTORY.REC(F.AC.HIS,Y.CTA.ACTUAL.2,HIST.REC,YERROR)
        T.CUSTOMER.ACTUAL = HIST.REC<1>
        TMP.DATE = HIST.REC<AC.OPENING.DATE>
        T.MES.OD = TMP.DATE[5,2]
        TMP.CLOSED.DATE = HIST.REC<AC.CLOSURE.DATE>
        T.MES.CD = TMP.CLOSED.DATE[5,2]
**VALIDACION: CUENTA PERTENECIENTE O RELACIONADA AL CLIENTE:

        APLICA_SALTO = "TRUE"
        IF HIST.REC NE '' THEN
            IF (T.CUSTOMER.ACTUAL EQ F.ID) THEN

                APLICA_SALTO = "FALSE"
            END
            FOR JH = 1 TO T.CANT.VM.REL.CO STEP 1
                JH.JOINT.HOLDER.ACTUAL = HIST.REC<105, JH>
                JH.RELATION.CODE.ACTUAL = HIST.REC<106, JH>
                RC = R.ACC<AC.RELATION.CODE,JH> ;* R22 Manual Conversion RC variabl initialised
                IF (JH.JOINT.HOLDER.ACTUAL EQ F.ID) AND (RC EQ 501 OR RC EQ 501) THEN
                    APLICA_SALTO = "FALSE"

                END
            NEXT JH
        END
        IF HIST.REC EQ '' THEN
            IF (T.ID EQ F.ID) THEN

                APLICA_SALTO = "FALSE"
            END
            FOR JH = 1 TO T.CANT.VM.REL.CO STEP 1
                JH.JOINT.HOLDER.ACTUAL = R.ACC<105, JH>
                JH.RELATION.CODE.ACTUAL = R.ACC<106, JH>
                RC = R.ACC<AC.RELATION.CODE,JH> ;* R22 Manual Conversion RC variabl initialised
                IF (JH.JOINT.HOLDER.ACTUAL EQ F.ID) AND (RC EQ 501 OR RC EQ 501) THEN
                    APLICA_SALTO = "FALSE"

                END
            NEXT JH
        END

        IF APLICA_SALTO EQ "TRUE" THEN
            CONTINUE
        END
**FIN-VALIDACION: CUENTA PERTENECIENTE O RELACIONADA AL CLIENTE
**GOSUB ACTUAL_PERIOD


        LOOP REMOVE Y.STMT.ACC.ID FROM SEL.LIST2 SETTING STMT.POS

        WHILE Y.STMT.ACC.ID DO

            Y.TMP.GANADO = 0
            Y.TMP.RETENIDO = 0
            Y.TMP.CR.VAL.BALANCE = 0
            Y.TMP.CR.INT.RATE = 0
            CALL F.READ(FN.STMT.ACC,Y.STMT.ACC.ID,R.STMT, FV.STMT, STMT.ERR)
            Y.PERIOD.FIRST.DATE = R.STMT<IC.STMCR.PERIOD.FIRST.DATE>
            Y.PERIOD.LAST.DATE = R.STMT<IC.STMCR.PERIOD.LAST.DATE>
            Y.CR.VAL.BALANCE = R.STMT<IC.STMCR.CR.VAL.BALANCE>
            Y.CAN.CR.VAL.BALANCE = DCOUNT(Y.CR.VAL.BALANCE,@VM)
            T.LST.TRX.DATE = R.STMT<IC.STMCR.INT.POST.DATE>
            FOR A = 1 TO Y.CAN.CR.VAL.BALANCE STEP 1
                Y.TMP.CR.VAL.BALANCE = Y.TMP.CR.VAL.BALANCE + R.STMT<IC.STMCR.CR.VAL.BALANCE, A>
            NEXT A
            Y.CR.INT.RATE = R.STMT<IC.STMCR.CR.INT.RATE>
            Y.CAN.CR.INT.RATE = DCOUNT(Y.CR.INT.RATE,@VM)
            FOR B.VAR = 1 TO Y.CAN.CR.INT.RATE STEP 1
                Y.TMP.CR.INT.RATE = Y.TMP.CR.INT.RATE + R.STMT<IC.STMCR.CR.INT.RATE, B.VAR>
            NEXT B.VAR
**MONTO GANADO:
            Y.CR.INT.AMT = R.STMT<IC.STMCR.CR.INT.AMT>
            Y.CAN.AMT = DCOUNT(Y.CR.INT.AMT,@VM)
            FOR I.VAR = 1 TO Y.CAN.AMT STEP 1
                Y.TMP.GANADO = Y.TMP.GANADO + R.STMT<IC.STMCR.CR.INT.AMT, I.VAR>
            NEXT I.VAR
            Y.TMP.TOTAL.GANADO += Y.TMP.GANADO

**MONTO RETENCION:
            Y.INT.TAX.AMT = R.STMT<IC.STMCR.CR.INT.TAX.AMT>
            Y.CAN.TAX.AMT = DCOUNT(Y.INT.TAX.AMT,@VM)
            FOR J.VAR = 1 TO Y.CAN.AMT STEP 1
                Y.TMP.RETENIDO = Y.TMP.RETENIDO + R.STMT<IC.STMCR.CR.INT.TAX.AMT, J.VAR>
            NEXT J.VAR
            Y.TMP.TOTAL.RETENIDO += Y.TMP.RETENIDO

            Y.LIQUIDITY.ACCOUNT = R.STMT<IC.STMCR.LIQUIDITY.ACCOUNT>
**-------------------------------------------------------------------------------------------------
**VALIDACION CONTROL DE TOTAL DE REGISTROS A MOSTRAR MAXIMO ACTUAL 33 REGISTROS
**-------------------------------------------------------------------------------------------------
            IF Y.CONTADOR GT 33 THEN
                ENQ.ERROR = "EL CLIENTE SOLICITADO POSEE MAS REGISTROS DE LOS ADMITIDOS PARA LA SALIDA DEL REPORTE EN EL RANGO ESPECIFICADO, ESPECIFIQUE UN RANGO MENOR."
                ENQ.ERROR<1,2> = 2
                RETURN
            END
        REPEAT

        GOSUB ACTUAL_PERIOD

**-------------------------------------------------------------------------------------------------
**SI INTEREST.LIQU.ACCT POSEE VALOR PROCEDO A BUSCAR REGISTROS PARA ESA CUENTA
**-------------------------------------------------------------------------------------------------
        IF T.AC.INTEREST.LIQU.ACCT NE "" THEN
            GOSUB PROC_LIQ_ACCT

        END

        Y.TOTAL.GANADO += Y.TMP.TOTAL.GANADO
        Y.TOTAL.RETENIDO += Y.TMP.TOTAL.RETENIDO


        IF Y.TMP.TOTAL.GANADO NE 0 AND Y.TMP.TOTAL.RETENIDO NE 0 THEN
            IF T.AC.CATEGORY[1,2] NE "66" THEN
                Y.ARR.STMT.ACC = Y.ARR.STMT.ACC : Y.CTA.ACTUAL : " |" : T.PERIODO.ACT : " |" : Y.TMP.TOTAL.GANADO : " |" : Y.TMP.TOTAL.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
            IF T.AC.CATEGORY[1,2] EQ "66" THEN
                Y.ARR.STMT.AZ.ACC = Y.ARR.STMT.AZ.ACC : Y.CTA.ACTUAL : " |" : T.PERIODO.ACT : " |" : Y.TMP.TOTAL.GANADO : " |" : Y.TMP.TOTAL.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
        END
**---------------------------------------
**AUMENTO CONTADOR DE CONTROL DE FILAS. |
**---------------------------------------
        Y.CONTADOR += 1
**---------------------------
**TODAS LAS CUENTAS PARTE 1
**---------------------------
        IF Y.ALL.ACCOUNTS EQ "" THEN
            Y.ALL.ACCOUNTS = Y.CTA.ACTUAL
        END
        IF Y.ALL.ACCOUNTS NE "" THEN
            Y.ALL.ACCOUNTS = Y.ALL.ACCOUNTS : @VM : Y.CTA.ACTUAL
        END

        GOSUB ASIENTOS_AJUSTES_AZ

    NEXT P
**-------------------------------------------------------------------------------------------------
**BUSCO LOS ASIENTOS DE AJUSTES PARA ESTE CLIENTE Y PERIODO.
**-------------------------------------------------------------------------------------------------
    GOSUB ASIENTOS_AJUSTES


**-------------------------------------------------------------------------------------------------
**FORMATEO Y CONCATENACION FINAL
**-------------------------------------------------------------------------------------------------
    IF Y.ARR.STMT.ACC EQ "" THEN
        Y.ARR.STMT.ACC = Y.ARR.STMT.ACC : "^"
    END
    IF Y.ARR.STMT.AZ.ACC EQ "" THEN
        Y.ARR.STMT.AZ.ACC = Y.ARR.STMT.AZ.ACC : "^"
    END

    Y.FINAL<-1> = F.ID : "*" : Y.CUS.NAME.1 : "*" : Y.IDENTIFICACION : "*" : Y.TOTAL.GANADO : "*" : Y.TOTAL.RETENIDO : "*" : Y.ARR.STMT.ACC : "*" : Y.ARR.STMT.AZ.ACC : "*" : Y.PERIOD : "*" : Y.CONTADOR
RETURN

**------------------------------------------------------------------------------------------------------------------------------------
*| Si una cuenta es reinvested, no se muestra en la lista de productos, mas sus montos ganados y retenidos.
*| se les suman a la cuentra madre
*|
*|
**------------------------------------------------------------------------------------------------------------------------------------
PROC_LIQ_ACCT:

    Y.CTA.ACTUAL2 = T.AC.INTEREST.LIQU.ACCT
    Y.TMP.TOTAL.GANADO.LQD = 0
    Y.TMP.TOTAL.RETENIDO.LQD = 0
    SEL.CMD2 = "SELECT " : FN.STMT : " WITH @ID LIKE " : Y.CTA.ACTUAL2 : "... AND PERIOD.LAST.DATE GE " : F.FECHA.INI.PERIOD : " AND PERIOD.LAST.DATE LE " : F.FECHA.FIN.PERIOD
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.RECS2,SEL.ERR2)
    LOOP REMOVE Y.STMT.ACC.ID FROM SEL.LIST2 SETTING STMT.POS

    WHILE Y.STMT.ACC.ID DO

        Y.TMP.GANADO.LQD = 0
        Y.TMP.RETENIDO.LQD = 0
        Y.TMP.CR.VAL.BALANCE.LQD = 0
        Y.TMP.CR.INT.RATE.LQD = 0
        CALL F.READ(FN.STMT.ACC,Y.STMT.ACC.ID,R.STMT, FV.STMT, STMT.ERR)

**MONTO GANADO:
        Y.CR.INT.AMT = R.STMT<IC.STMCR.CR.INT.AMT>
        Y.CAN.AMT = DCOUNT(Y.CR.INT.AMT,@VM)
        FOR I.VAR = 1 TO Y.CAN.AMT STEP 1
            Y.TMP.GANADO.LQD = Y.TMP.GANADO.LQD + R.STMT<IC.STMCR.CR.INT.AMT, I.VAR>
        NEXT I.VAR
        Y.TMP.TOTAL.GANADO.LQD += Y.TMP.GANADO.LQD


**MONTO RETENCION:
        Y.INT.TAX.AMT = R.STMT<IC.STMCR.CR.INT.TAX.AMT>
        Y.CAN.TAX.AMT = DCOUNT(Y.INT.TAX.AMT,@VM)
        FOR J.VAR = 1 TO Y.CAN.AMT STEP 1
            Y.TMP.RETENIDO.LQD = Y.TMP.RETENIDO.LQD + R.STMT<IC.STMCR.CR.INT.TAX.AMT, J.VAR>
        NEXT J.VAR
        Y.TMP.TOTAL.RETENIDO.LQD += Y.TMP.RETENIDO.LQD

    REPEAT

    Y.TMP.TOTAL.GANADO += Y.TMP.TOTAL.GANADO.LQD
    Y.TMP.TOTAL.RETENIDO += Y.TMP.TOTAL.RETENIDO.LQD

**TODAS LAS CUENTAS PARTE 2
**---------------------------
    IF Y.ALL.ACCOUNTS EQ "" THEN
        Y.ALL.ACCOUNTS = Y.CTA.ACTUAL2
    END
    IF Y.ALL.ACCOUNTS NE "" THEN
        Y.ALL.ACCOUNTS = Y.ALL.ACCOUNTS : @VM : Y.CTA.ACTUAL2
    END

RETURN
**--------------------------------------------------------------------------------------------------
** PERIODO(FECHA) PARA LA CUENTA ACTUAL
**--------------------------------------------------------------------------------------------------
ACTUAL_PERIOD:

**DEBUG

    T.PERIODO.ACT = ""
    T.MES.INI = 0
    T.MES.FIN = 0
    IF TMP.DATE GE F.FECHA.INI.PERIOD THEN
        T.MES.INI = T.MES.OD
    END ELSE
        T.MES.INI = F.FECHA.INI.PERIOD[5,2]
    END
    T.MES.FIN = F.FECHA.FIN.PERIOD[5,2]
    IF TMP.CLOSED.DATE NE '' THEN
        IF TMP.CLOSED.DATE LT F.FECHA.FIN.PERIOD THEN
            T.MES.FIN = T.MES.CD
        END ELSE
            T.MES.FIN = F.FECHA.FIN.PERIOD[5,2]
        END
    END
**SI fecha ult trx menor a fecha fin periodo, setear mes fin a la fecha de la ultima trx
    IF T.LST.TRX.DATE NE '' THEN
        IF T.LST.TRX.DATE LT F.FECHA.FIN.PERIOD THEN
            T.MES.FIN = T.LST.TRX.DATE[5,2]
        END ELSE
            T.MES.FIN = F.FECHA.FIN.PERIOD[5,2]
        END
    END

    BEGIN CASE
        CASE T.MES.INI EQ 1
            T.MES.INI.LIT = "Ene-"
        CASE T.MES.INI EQ 2
            T.MES.INI.LIT = "Feb-"
        CASE T.MES.INI EQ 3
            T.MES.INI.LIT = "Mar-"
        CASE T.MES.INI EQ 4
            T.MES.INI.LIT = "Abr-"
        CASE T.MES.INI EQ 5
            T.MES.INI.LIT = "May-"
        CASE T.MES.INI EQ 6
            T.MES.INI.LIT = "Jun-"
        CASE T.MES.INI EQ 7
            T.MES.INI.LIT = "Jul-"
        CASE T.MES.INI EQ 8
            T.MES.INI.LIT = "Ago-"
        CASE T.MES.INI EQ 9
            T.MES.INI.LIT = "Sept-"
        CASE T.MES.INI EQ 10
            T.MES.INI.LIT = "Oct-"
        CASE T.MES.INI EQ 11
            T.MES.INI.LIT = "Nov-"
        CASE T.MES.INI EQ 12
            T.MES.INI.LIT = "Dic-"
    END CASE

    BEGIN CASE
        CASE T.MES.FIN EQ 1
            T.MES.FIN.LIT = T.MES.INI.LIT:"Ene. ":T.ANO.FIN
        CASE T.MES.FIN EQ 2
            T.MES.FIN.LIT = T.MES.INI.LIT:"Feb. ":T.ANO.FIN
        CASE T.MES.FIN EQ 3
            T.MES.FIN.LIT = T.MES.INI.LIT:"Mar. ":T.ANO.FIN
        CASE T.MES.FIN EQ 4
            T.MES.FIN.LIT = T.MES.INI.LIT:"Abr. ":T.ANO.FIN
        CASE T.MES.FIN EQ 5
            T.MES.FIN.LIT = T.MES.INI.LIT:"May. ":T.ANO.FIN
        CASE T.MES.FIN EQ 6
            T.MES.FIN.LIT = T.MES.INI.LIT:"Jun. ":T.ANO.FIN
        CASE T.MES.FIN EQ 7
            T.MES.FIN.LIT = T.MES.INI.LIT:"Jul. ":T.ANO.FIN
        CASE T.MES.FIN EQ 8
            T.MES.FIN.LIT = T.MES.INI.LIT:"Ago. ":T.ANO.FIN
        CASE T.MES.FIN EQ 9
            T.MES.FIN.LIT = T.MES.INI.LIT:"Sept. ":T.ANO.FIN
        CASE T.MES.FIN EQ 10
            T.MES.FIN.LIT = T.MES.INI.LIT:"Oct. ":T.ANO.FIN
        CASE T.MES.FIN EQ 11
            T.MES.FIN.LIT = T.MES.INI.LIT:"Nov. ":T.ANO.FIN
        CASE T.MES.FIN EQ 12
            T.MES.FIN.LIT = T.MES.INI.LIT:"Dic. ":T.ANO.FIN
    END CASE
    T.PERIODO.ACT = T.MES.FIN.LIT
    T.LST.TRX.DATE = ""
RETURN

ASIENTOS_AJUSTES_AZ:
    T.MES.OD = 0
    T.MES.CD = 0
    T.PERIODO.ACT = ""
    SEL.LIST3 = ""
    SEL.ERR3 = ""
    SEL.CMD3 = "SELECT " : FN.STMT.EN : " WITH ACCOUNT.NUMBER EQ " : Y.CTA.ACTUAL : " AND BOOKING.DATE GE " : F.FECHA.INI.PERIOD : " AND BOOKING.DATE LE " : F.FECHA.FIN.PERIOD : " AND TRANS.REFERENCE LIKE FT... AND AMOUNT.LCY LT 0 AND TRANSACTION.CODE EQ 492"

    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',NO.OF.RECS3,SEL.ERR3)
    LOOP REMOVE Y.STMT.EN.ID FROM SEL.LIST3 SETTING STMT.EN.POS
    WHILE Y.STMT.EN.ID DO
        CALL F.READ(FN.STMT.EN,Y.STMT.EN.ID,R.STMT.EN, FV.STMT.EN, STMT.EN.ERR)

        T.TRANS.REFERENCE = R.STMT.EN<AC.STE.TRANS.REFERENCE>
        T.BOOKING.DATE = R.STMT.EN<AC.STE.BOOKING.DATE>
**BUSCAMOS EN FUNDS.TRANSFER$HIS
        HIS.FT.ID = T.TRANS.REFERENCE
        FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS' ; F.FT.HIS = ''
        CALL OPF(FN.FT.HIS,F.FT.HIS)
        HIS.REC = ''
        YERROR = ''
        CALL EB.READ.HISTORY.REC(F.FT.HIS,HIS.FT.ID,HIST.REC,YERROR)

        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.AZ.ACC.REF",FTH.POS)
**FT.LOCAL.REF => 67
        T.L.FT.AZ.ACC.REF = HIST.REC<67,FTH.POS>

**BUSCO LA CUENTA/DEPOSITO EN ACCOUNT
        HIS.REC = ''
        YERROR = ''
        FN.AC.HIS = 'F.ACCOUNT$HIS' ; F.AC.HIS = ''
        CALL OPF(FN.AC.HIS,F.AC.HIS)
        CALL EB.READ.HISTORY.REC(F.AC.HIS,Y.CTA.ACTUAL,HIST.REC,YERROR)
        TMP.DATE = HIST.REC<AC.OPENING.DATE>
        T.MES.OD = TMP.DATE[5,2]
        TMP.CLOSED.DATE = HIST.REC<AC.CLOSURE.DATE>
        T.MES.CD = TMP.CLOSED.DATE[5,2]
        T.CUSTOMER.ID = HIST.REC<AC.CUSTOMER>
**T.LST.TRX.DATE = R.STMT.EN<AC.STE.BOOKING.DATE>
        GOSUB ACTUAL_PERIOD

**SI EL CLIENTE DE LA CUENTA X ES EL CLIENTE SOLICITADO EVALUO EVALUO SI LA CUENTA APLICA PARA MOSTRARSE
        IF T.CUSTOMER.ID EQ F.ID THEN
            T.MULTIPLICADOR = 10
            T.MNT.RET = SMUL(R.STMT.EN<AC.STE.AMOUNT.LCY>, -1)
            T.MNT.ORI = SMUL(T.MNT.RET, T.MULTIPLICADOR)
            Y.TOTAL.GANADO += T.MNT.ORI
            Y.TOTAL.RETENIDO += T.MNT.RET
            IF Y.TMP.TOTAL.GANADO NE 0 AND Y.TMP.TOTAL.RETENIDO NE 0 THEN
                IF T.AC.CATEGORY[1,2] NE "66" THEN
                    Y.ARR.STMT.ACC = Y.ARR.STMT.ACC : Y.CTA.ACTUAL[1,10] : "|" : T.PERIODO.ACT : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
                END
                IF T.AC.CATEGORY[1,2] EQ "66" THEN
                    Y.ARR.STMT.AZ.ACC = Y.ARR.STMT.AZ.ACC : Y.CTA.ACTUAL[1,10] : "|" : T.PERIODO.ACT : " |" : T.MNT.ORI : " |" : T.MNT.RET: " |" : "N/A" : "^"
                END
            END


        END



    REPEAT

RETURN

ASIENTOS_AJUSTES:
    T.MES.OD = 0
    T.MES.CD = 0
    T.PERIODO.ACT = ""
    SEL.LIST3 = ""
    SEL.ERR3 = ""
    SEL.CMD3 = "SELECT " : FN.STMT.EN : " WITH ACCOUNT.NUMBER EQ DOP1761500100017 AND BOOKING.DATE GE " : F.FECHA.INI.PERIOD : " AND BOOKING.DATE LE " : F.FECHA.FIN.PERIOD : " AND TRANS.REFERENCE LIKE FT... AND AMOUNT.LCY LT 0"
**DEBUG
    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',NO.OF.RECS3,SEL.ERR3)
    LOOP REMOVE Y.STMT.EN.ID FROM SEL.LIST3 SETTING STMT.EN.POS
    WHILE Y.STMT.EN.ID DO
        CALL F.READ(FN.STMT.EN,Y.STMT.EN.ID,R.STMT.EN, FV.STMT.EN, STMT.EN.ERR)

        T.TRANS.REFERENCE = R.STMT.EN<AC.STE.TRANS.REFERENCE>
        T.BOOKING.DATE = R.STMT.EN<AC.STE.BOOKING.DATE>
**BUSCAMOS EN FUNDS.TRANSFER$HIS
        HIS.FT.ID = T.TRANS.REFERENCE
        FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS' ; F.FT.HIS = ''
        CALL OPF(FN.FT.HIS,F.FT.HIS)
        HIS.REC = ''
        YERROR = ''
        CALL EB.READ.HISTORY.REC(F.FT.HIS,HIS.FT.ID,HIST.REC,YERROR)

        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.AZ.ACC.REF",FTH.POS)
**FT.LOCAL.REF => 67
        T.L.FT.AZ.ACC.REF = HIST.REC<67,FTH.POS>

**BUSCO LA CUENTA/DEPOSITO EN ACCOUNT
        HIS.REC = ''
        YERROR = ''
        FN.AC.HIS = 'F.ACCOUNT$HIS' ; F.AC.HIS = ''
        CALL OPF(FN.AC.HIS,F.AC.HIS)
        CALL EB.READ.HISTORY.REC(F.AC.HIS,T.L.FT.AZ.ACC.REF,HIST.REC,YERROR)
        TMP.DATE = HIST.REC<AC.OPENING.DATE>
        T.MES.OD = TMP.DATE[5,2]
        TMP.CLOSED.DATE = HIST.REC<AC.CLOSURE.DATE>
        T.MES.CD = TMP.CLOSED.DATE[5,2]
        T.CUSTOMER.ID = HIST.REC<AC.CUSTOMER>
**T.LST.TRX.DATE = R.STMT.EN<AC.STE.BOOKING.DATE>
        GOSUB ACTUAL_PERIOD

**SI EL CLIENTE DE LA CUENTA X ES EL CLIENTE SOLICITADO EVALUO EVALUO SI LA CUENTA APLICA PARA MOSTRARSE
        IF T.CUSTOMER.ID EQ F.ID THEN
**IF (T.L.FT.AZ.ACC.REF EQ "1014431069") OR (Y.CTA.ACTUAL EQ "1014431069") THEN
**DEBUG
**END
            T.MULTIPLICADOR = 10
            T.MNT.RET = SMUL(R.STMT.EN<AC.STE.AMOUNT.LCY>, -1)
            T.MNT.ORI = SMUL(T.MNT.RET, T.MULTIPLICADOR)
            Y.TOTAL.GANADO += T.MNT.ORI
            Y.TOTAL.RETENIDO += T.MNT.RET
            IF Y.TMP.TOTAL.GANADO NE 0 AND Y.TMP.TOTAL.RETENIDO NE 0 THEN
                IF T.AC.CATEGORY[1,2] NE "66" THEN
                    Y.ARR.STMT.ACC = Y.ARR.STMT.ACC : T.L.FT.AZ.ACC.REF[1,10] : "|" : T.PERIODO.ACT : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
                END
                IF T.AC.CATEGORY[1,2] EQ "66" THEN
                    Y.ARR.STMT.AZ.ACC = Y.ARR.STMT.AZ.ACC : T.L.FT.AZ.ACC.REF[1,10] : "|" : T.PERIODO.ACT : " |" : T.MNT.ORI : " |" : T.MNT.RET: " |" : "N/A" : "^"
                END
            END


        END



    REPEAT

RETURN



END
