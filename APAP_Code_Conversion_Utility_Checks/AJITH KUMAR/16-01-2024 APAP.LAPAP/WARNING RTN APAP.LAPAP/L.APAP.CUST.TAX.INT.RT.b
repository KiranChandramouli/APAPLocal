* @ValidationCode : MjotNTExNjExNzUzOkNwMTI1MjoxNjgyMzMxMzIxMDI4OklUU1M6LTE6LTE6MjU4OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 2589
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.CUST.TAX.INT.RT(Y.FINAL)
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion      ++ to +=, I to I.VAR, J to J.VAR, b to B.VAR, F.READ to CACHE.READ, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.REDO.CUST.PRD.LIST ;*R22 Auto conversion - END
   $USING EB.LocalReferences

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
**ABRIR LA TABLA FBNK.ACCOUNT
**---------------------------------------
    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""
    CALL OPF(FN.ACC,FV.ACC)
**---------------------------------------
**ABRIR LA TABLA FBNK.CATEGORY
**---------------------------------------
    FN.CAT = "F.CATEGORY"
    FV.CAT = ""
    R.CAT = ""
    CAT.ERR = ""
    CALL OPF(FN.CAT,FV.CAT)
**---------------------------------------------------------------------------------------------
**SENTENCIA LOCATE
**---------------------------------------------------------------------------------------------
    LOCATE "CUSTOMER.NUMBER" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.ID = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "PERIOD.DATES" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.FECHA.INI.PERIOD = D.RANGE.AND.VALUE<CUS.POS>
    END

    LOCATE "PERIOD.DATES.END" IN D.FIELDS<1> SETTING CUS.POS THEN
        F.FECHA.FIN.PERIOD = D.RANGE.AND.VALUE<CUS.POS>
    END


**---------------------------------------------------------------------------------------------
**Periodos.
**---------------------------------------------------------------------------------------------
    T.FECHA.DESDE = F.FECHA.INI.PERIOD
    T.FECHA.HASTA = F.FECHA.FIN.PERIOD

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

**------------------------------------------------------------------------------------------------------------------------------------------------
**PRIMERO LEO DESDE LA TABLA CUSTOMER
**------------------------------------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.CUS,F.ID,R.CUS, FV.CUS, CUS.ERR)
    Y.CUS.NAME.1 = R.CUS<EB.CUS.NAME.1>
    Y.CUS.NAME.2 = R.CUS<EB.CUS.NAME.2>

*    CALL GET.LOC.REF("CUSTOMER", "L.CU.CIDENT",CUS.POS)
EB.LocalReferences.GetLocRef("CUSTOMER", "L.CU.CIDENT",CUS.POS);* R22 UTILITY AUTO CONVERSION
    Y.CUS.CIDENT = R.CUS<EB.CUS.LOCAL.REF,CUS.POS>
*    CALL GET.LOC.REF("CUSTOMER", "L.CU.RNC",CUS.POS.1)
EB.LocalReferences.GetLocRef("CUSTOMER", "L.CU.RNC",CUS.POS.1);* R22 UTILITY AUTO CONVERSION
    Y.CUS.RNC = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.1>
*    CALL GET.LOC.REF("CUSTOMER", "L.CU.PASS.NAT",CUS.POS.2)
EB.LocalReferences.GetLocRef("CUSTOMER", "L.CU.PASS.NAT",CUS.POS.2);* R22 UTILITY AUTO CONVERSION
    Y.CUS.PASS.NAT = R.CUS<EB.CUS.LOCAL.REF,CUS.POS.2>
    Y.IDENTIFICACION = ""
**-------------------------------------------------------------------------------------------------------------------------------------------------
**VALIDACION 1, SI LA CEDULA ESTA VACIO NO ES CLIENTE FISICO, POR LO TANTO MUESTRO ERROR.
**-------------------------------------------------------------------------------------------------------------------------------------------------
    IF Y.CUS.RNC NE "" THEN
        Y.IDENTIFICACION = Y.CUS.RNC
    END
    IF Y.CUS.PASS.NAT NE "" THEN
        Y.IDENTIFICACION = Y.CUS.PASS.NAT
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
        Y.TMP.TOTAL.GANADO = 0
        Y.TMP.TOTAL.RETENIDO = 0
        Y.TOTAL.GANADO = 0
        Y.TOTAL.RETENIDO = 0

**------------------------------------------------------------------------------------------------------------------------------------
**EVALUO SI LA CUENTA ACTUAL YA FUE PROCESADA; DE SER AFIRMATIVO CONTINUO CON EL SIGUIENTE REGISTRO.
**------------------------------------------------------------------------------------------------------------------------------------
        FINDSTR Y.CTA.ACTUAL IN Y.ALL.ACCOUNTS SETTING Ap, Vp THEN
            T.CUENTAS.PROCE = " CAMPO ":Ap:", VALOR ":Vp
            CONTINUE
        END ELSE
            T.CUENTAS.PROCE = "A PROCESAR CTA."
        END
        SEL.CMD2 = "SELECT " : FN.STMT : " WITH @ID LIKE " : Y.CTA.ACTUAL : "... AND PERIOD.LAST.DATE GE " : T.FECHA.DESDE : " AND PERIOD.LAST.DATE LE " : T.FECHA.HASTA

**IF Y.CTA.ACTUAL EQ "1011156962" THEN
**DEBUG
**END
        CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.RECS2,SEL.ERR2)
**IF Y.CTA.ACTUAL EQ "1011156962" THEN
**DEBUG
**END
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
**
*            CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.REINVESTED",ACC.POS);* R22 UTILITY AUTO CONVERSION
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
**SI LA CATEGORIA PERTENECE AL TIPO DE INTERESES REINV. CONTINUO CON  EL SIG. PRODUCTO.
                IF (T.AC.CATEGORY GE 6013) AND (T.AC.CATEGORY LE 6020) THEN
                    CONTINUE
                END
**FIN-SI LA CATEGORIA PERTENECE AL TIPO DE INTERESES REINV. CONTINUO CON  EL SIG. PRODUCTO.
*                CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.REINVESTED",ACC.POS);* R22 UTILITY AUTO CONVERSION
                T.L.AC.REINVESTED = R.ACC<AC.LOCAL.REF,ACC.POS>
                IF T.L.AC.REINVESTED EQ "YES" THEN
                    T.AC.INTEREST.LIQU.ACCT = R.ACC<AC.INTEREST.LIQU.ACCT>
                END
            END

        END
        CALL CACHE.READ(FN.CAT, T.AC.CATEGORY, R.CAT, CAT.ERR) ;*R22 Auto conversion
        T.TIPO.PRODUCTO = R.CAT<EB.CAT.DESCRIPTION>
        T.AC.CURRENCY = R.ACC<AC.CURRENCY>

        T.STMT.ACCT.ID = ""
        Y.TMP.GANADO = 0
        Y.TMP.RETENIDO = 0
        Y.TMP.CR.VAL.BALANCE = 0
        Y.TMP.CR.INT.RATE = 0
        LOOP REMOVE Y.STMT.ACC.ID FROM SEL.LIST2 SETTING STMT.POS
        WHILE Y.STMT.ACC.ID DO

            Y.TMP.GANADO = 0
            Y.TMP.RETENIDO = 0
            T.STMT.ACCT.ID = Y.STMT.ACC.ID
            CALL F.READ(FN.STMT.ACC,Y.STMT.ACC.ID,R.STMT, FV.STMT, STMT.ERR)
**IF Y.CTA.ACTUAL EQ "1011156962" THEN
**DEBUG
**END
            Y.PERIOD.FIRST.DATE = R.STMT<IC.STMCR.PERIOD.FIRST.DATE>
            Y.PERIOD.LAST.DATE = R.STMT<IC.STMCR.PERIOD.LAST.DATE>
            Y.CR.VAL.BALANCE = R.STMT<IC.STMCR.CR.VAL.BALANCE>
            Y.CAN.CR.VAL.BALANCE = DCOUNT(Y.CR.VAL.BALANCE,@VM)
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
**IF Y.CTA.ACTUAL EQ "1014578264" THEN
**DEBUG
**END
        REPEAT

*IF Y.CTA.ACTUAL EQ "1012646467" THEN
*DEBUG
*END
**-------------------------------------------------------------------------------------------------
**SI INTEREST.LIQU.ACCT POSEE VALOR PROCEDO A BUSCAR REGISTROS PARA ESA CUENTA
**-------------------------------------------------------------------------------------------------
        IF T.L.AC.REINVESTED EQ "YES" THEN
            T.AC.INTEREST.LIQU.ACCT = Y.LIQUIDITY.ACCOUNT
*IF (T.AC.INTEREST.LIQU.ACCT EQ "") AND (Y.LIQUIDITY.ACCOUNT NE "") THEN
*T.AC.INTEREST.LIQU.ACCT = Y.LIQUIDITY.ACCOUNT
*END
            IF T.AC.INTEREST.LIQU.ACCT NE "" THEN
*IF Y.CTA.ACTUAL EQ "1012646467" THEN
*DEBUG
*END
                GOSUB PROC_LIQ_ACCT
            END
        END

        Y.TOTAL.GANADO += Y.TMP.TOTAL.GANADO
        Y.TOTAL.RETENIDO += Y.TMP.TOTAL.RETENIDO
**IF Y.CTA.ACTUAL EQ "1011156962" THEN
**DEBUG
**END
**Y.FINAL DE RESULTADO
        IF T.STMT.ACCT.ID NE '' THEN
            Y.FINAL<-1> = T.TIPO.PRODUCTO : "*" : Y.CTA.ACTUAL : "*" : F.ID : "*" : Y.IDENTIFICACION : "*" : Y.CUS.NAME.1 : "*" : T.AC.CURRENCY : "*" : T.STMT.ACCT.ID : "*" : Y.TMP.TOTAL.GANADO : "*" : Y.TMP.TOTAL.RETENIDO
        END

**---------------------------
**TODAS LAS CUENTAS PARTE 1
**---------------------------
        IF Y.ALL.ACCOUNTS EQ "" THEN
            Y.ALL.ACCOUNTS = Y.CTA.ACTUAL
        END
        IF Y.ALL.ACCOUNTS NE "" THEN
            Y.ALL.ACCOUNTS = Y.ALL.ACCOUNTS : @VM : Y.CTA.ACTUAL
        END
**
        Y.TOTAL.GANADO = 0
        Y.TOTAL.RETENIDO = 0
        Y.CTA.ACTUAL2 = ""
        Y.TMP.TOTAL.GANADO.LQD = 0
        Y.TMP.TOTAL.RETENIDO.LQD = 0
        Y.TMP.GANADO.LQD = 0
        Y.TMP.RETENIDO.LQD = 0
        T.AC.INTEREST.LIQU.ACCT = ""
        T.L.AC.REINVESTED = ""
    NEXT P
RETURN

**------------------------------------------------------------------------------------------------------------------------------------
*| Si una cuenta es reinvested, no se muestra en la lista de productos, mas sus montos ganados y retenidos...
*| se les suman a la cuentra madre.
*|
*|
**------------------------------------------------------------------------------------------------------------------------------------
PROC_LIQ_ACCT:

    Y.CTA.ACTUAL2 = T.AC.INTEREST.LIQU.ACCT
    Y.TMP.TOTAL.GANADO.LQD = 0
    Y.TMP.TOTAL.RETENIDO.LQD = 0
    SEL.CMD2 = "SELECT " : FN.STMT : " WITH @ID LIKE " : Y.CTA.ACTUAL2 : "... AND PERIOD.LAST.DATE GE " : T.FECHA.DESDE : " AND PERIOD.LAST.DATE LE " : T.FECHA.HASTA
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.RECS2,SEL.ERR2)
*IF Y.CTA.ACTUAL EQ "1012646467" THEN
*DEBUG
*END
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

END
