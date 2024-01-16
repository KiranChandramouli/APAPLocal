$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.RET.1.PRC.RT(Y.FINAL)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 21-APRIL-2023      Conversion Tool       R22 Auto Conversion - B to B.VAR , I to I.VAR and J to J.VAR , ++ to +=1 and T24.BP is removed from Insert
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CUST.PRD.LIST
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
**CALL OPF(FN.CUS.PRD,FV.CUS.PRD)
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
**ABRIR LA TABLA FBNK.REDO.CUST.PRD.LIST
**---------------------------------------
    FN.ACC = "F.ACCOUNT"
    FV.ACC = ""
    R.ACC = ""
    ACC.ERR = ""
**---------------------------------------
**ABRIR LA TABLA STMT.ENTRY
**---------------------------------------
    FN.STMT.EN = "F.STMT.ENTRY"
    FV.STMT.EN = ""
    R.STMT.EN = ""
    STMT.EN.ERR = ""
    CALL OPF(FN.STMT.EN,FV.STMT.EN)
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
**Periodo amigable.
**---------------------------------------------------------------------------------------------
    T.ANO.INI = F.FECHA.INI.PERIOD[1,4]
    T.MES.INI = F.FECHA.INI.PERIOD[5,2]
    T.MES.INI.LIT = ""
    BEGIN CASE
        CASE T.MES.INI EQ 1
            T.MES.INI.LIT = "Ene-":T.ANO.INI
        CASE T.MES.INI EQ 2
            T.MES.INI.LIT = "Feb-":T.ANO.INI
        CASE T.MES.INI EQ 3
            T.MES.INI.LIT = "Mar-":T.ANO.INI
        CASE T.MES.INI EQ 4
            T.MES.INI.LIT = "Abr-":T.ANO.INI
        CASE T.MES.INI EQ 5
            T.MES.INI.LIT = "May-":T.ANO.INI
        CASE T.MES.INI EQ 6
            T.MES.INI.LIT = "Jun-":T.ANO.INI
        CASE T.MES.INI EQ 7
            T.MES.INI.LIT = "Jul-":T.ANO.INI
        CASE T.MES.INI EQ 8
            T.MES.INI.LIT = "Ago-":T.ANO.INI
        CASE T.MES.INI EQ 9
            T.MES.INI.LIT = "Sep-":T.ANO.INI
        CASE T.MES.INI EQ 10
            T.MES.INI.LIT = "Oct-":T.ANO.INI
        CASE T.MES.INI EQ 11
            T.MES.INI.LIT = "Nov-":T.ANO.INI
        CASE T.MES.INI EQ 12
            T.MES.INI.LIT = "Dec-":T.ANO.INI
    END CASE
    T.ANO.FIN = F.FECHA.FIN.PERIOD[1,4]
    T.MES.FIN = F.FECHA.FIN.PERIOD[5,2]
    T.MES.FIN.LIT = ""
    BEGIN CASE
        CASE T.MES.FIN EQ 1
            T.MES.FIN.LIT = "Ene-":T.ANO.FIN
        CASE T.MES.FIN EQ 2
            T.MES.FIN.LIT = "Feb-":T.ANO.FIN
        CASE T.MES.FIN EQ 3
            T.MES.FIN.LIT = "Mar-":T.ANO.FIN
        CASE T.MES.FIN EQ 4
            T.MES.FIN.LIT = "Abr-":T.ANO.FIN
        CASE T.MES.FIN EQ 5
            T.MES.FIN.LIT = "May-":T.ANO.FIN
        CASE T.MES.FIN EQ 6
            T.MES.FIN.LIT = "Jun-":T.ANO.FIN
        CASE T.MES.FIN EQ 7
            T.MES.FIN.LIT = "Jul-":T.ANO.FIN
        CASE T.MES.FIN EQ 8
            T.MES.FIN.LIT = "Ago-":T.ANO.FIN
        CASE T.MES.FIN EQ 9
            T.MES.FIN.LIT = "Sep-":T.ANO.FIN
        CASE T.MES.FIN EQ 10
            T.MES.FIN.LIT = "Oct-":T.ANO.FIN
        CASE T.MES.FIN EQ 11
            T.MES.FIN.LIT = "Nov-":T.ANO.FIN
        CASE T.MES.FIN EQ 12
            T.MES.FIN.LIT = "Dec-":T.ANO.FIN
    END CASE

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
    Y.ARR.STMT = ""
    Y.ARR.STMT2 = ""
    Y.ARR.STMT3 = ""
    Y.ARR.STMT4 = ""
    Y.ARR.STMT5 = ""
    Y.ARR.STMT6 = ""
    Y.ARR.STMT7 = ""
    Y.ARR.STMT8 = ""
    Y.TOTAL.GANADO = 0
    Y.TOTAL.RETENIDO = 0
    Y.TMP.GANADO = 0
    Y.TMP.RETENIDO = 0
    Y.CONTADOR = 0
    Y.ALL.ACCOUNTS = ""

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
    Y.IDENTIFICACION = ""
**-------------------------------------------------------------------------------------------------------------------------------------------------
**VALIDACION 1, SI EL RNC ESTA VACIO NO ES CLIENTE JURIDICO, POR LO TANTO MUESTRO ERROR.
**-------------------------------------------------------------------------------------------------------------------------------------------------
    IF Y.CUS.RNC EQ "" THEN
        ENQ.ERROR = "EL CLIENTE SOLICITADO NO ES JURIDICO, REVISE EL CODIGO DE CLIENTE."
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
**------------------------------------------------------------------------------------------------------------------------------------
**EVALUO SI LA CUENTA ACTUAL YA FUE PROCESADA; DE SER AFIRMATIVO CONTINUO CON EL SIGUIENTE REGISTRO.
**------------------------------------------------------------------------------------------------------------------------------------
        FINDSTR Y.CTA.ACTUAL IN Y.ALL.ACCOUNTS SETTING Ap, Vp THEN
            T.CUENTAS.PROCE = " is within Field ":Ap:", value ":Vp
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
        T.ID = ""
        T.ID = R.ACC<AC.CUSTOMER>
**------------------------------------------------------------------------------------------------------------------------------------
**| PRIMERO BUSCO ESTA CUENTA EN LA TABLA EN-VIVO DE ACCOUNT PARA VALIDAR SI EL CAMPO L.AC.REINVESTED = YES
**| EN CASO AFIRMATIVO ASIGNO SU VALOR A LA VARIABLE T.AC.INTEREST.LIQU.ACCT
**|
**------------------------------------------------------------------------------------------------------------------------------------
        IF T.ID NE "" THEN
*            CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.REINVESTED",ACC.POS);* R22 UTILITY AUTO CONVERSION
            T.L.AC.REINVESTED = R.ACC<AC.LOCAL.REF,ACC.POS>
            IF T.L.AC.REINVESTED EQ "YES" THEN
                T.AC.INTEREST.LIQU.ACCT = R.ACC<T.AC.INTEREST.LIQU.ACCT>
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
*                CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
EB.LocalReferences.GetLocRef("ACCOUNT", "L.AC.REINVESTED",ACC.POS);* R22 UTILITY AUTO CONVERSION
                T.L.AC.REINVESTED = R.ACC<AC.LOCAL.REF,ACC.POS>
                IF T.L.AC.REINVESTED EQ "YES" THEN
                    T.AC.INTEREST.LIQU.ACCT = R.ACC<T.AC.INTEREST.LIQU.ACCT>
                END
            END
        END

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

            Y.TOTAL.GANADO += Y.TMP.GANADO
            Y.LIQUIDITY.ACCOUNT = R.STMT<IC.STMCR.LIQUIDITY.ACCOUNT>
**MONTO RETENCION:
            Y.INT.TAX.AMT = R.STMT<IC.STMCR.CR.INT.TAX.AMT>
            Y.CAN.TAX.AMT = DCOUNT(Y.INT.TAX.AMT,@VM)
            FOR J.VAR = 1 TO Y.CAN.AMT STEP 1
                Y.TMP.RETENIDO = Y.TMP.RETENIDO + R.STMT<IC.STMCR.CR.INT.TAX.AMT, J.VAR>
            NEXT J.VAR

            Y.TOTAL.RETENIDO += Y.TMP.RETENIDO

            IF Y.CONTADOR LE 31 THEN
                Y.ARR.STMT = Y.ARR.STMT : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
            IF Y.CONTADOR GT 31 AND Y.CONTADOR LE 67 THEN
                Y.ARR.STMT2 = Y.ARR.STMT2 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
            IF Y.CONTADOR GT 67 AND Y.CONTADOR LE 102 THEN
                Y.ARR.STMT3 = Y.ARR.STMT3 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
            IF Y.CONTADOR GT 102 AND Y.CONTADOR LE 137 THEN
                Y.ARR.STMT4 = Y.ARR.STMT4 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
            IF Y.CONTADOR GT 137 AND Y.CONTADOR LE 172 THEN
                Y.ARR.STMT5 = Y.ARR.STMT5 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
            IF Y.CONTADOR GT 172 AND Y.CONTADOR LE 207 THEN
                Y.ARR.STMT6 = Y.ARR.STMT6 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
            IF Y.CONTADOR GT 207 AND Y.CONTADOR LE 242 THEN
                Y.ARR.STMT7 = Y.ARR.STMT7 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
            IF Y.CONTADOR GT 242 AND Y.CONTADOR LE 272 THEN
                Y.ARR.STMT8 = Y.ARR.STMT8 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
            END
**---------------------------------------
**AUMENTO CONTADOR DE CONTROL DE FILAS. |
**---------------------------------------
            Y.CONTADOR += 1

**-------------------------------------------------------------------------------------------------
**VALIDACION CONTROL DE TOTAL DE REGISTROS A MOSTRAR MAXIMO ACTUAL 272 REGISTROS.
**-------------------------------------------------------------------------------------------------
            IF Y.CONTADOR GT 272 THEN
                ENQ.ERROR = "EL CLIENTE SOLICITADO POSEE MAS REGISTROS DE LOS ADMITIDOS PARA LA SALIDA DEL REPORTE EN EL RANGO ESPECIFICADO, ESPECIFIQUE UN RANGO MENOR."
                ENQ.ERROR<1,2> = 2
                RETURN
            END
        REPEAT
**---------------------------
**TODAS LAS CUENTAS PARTE 1
**---------------------------
        IF Y.ALL.ACCOUNTS EQ "" THEN
            Y.ALL.ACCOUNTS = Y.CTA.ACTUAL
        END
        IF Y.ALL.ACCOUNTS NE "" THEN
            Y.ALL.ACCOUNTS = Y.ALL.ACCOUNTS : @VM : Y.CTA.ACTUAL
        END

**-------------------------------------------------------------------------------------------------
**SI INTEREST.LIQU.ACCT POSEE VALOR PROCEDO A BUSCAR REGISTROS PARA ESA CUENTA
**-------------------------------------------------------------------------------------------------
        IF T.AC.INTEREST.LIQU.ACCT NE "" THEN
            GOSUB PROC_LIQ_ACCT
        END
    NEXT P
**-------------------------------------------------------------------------------------------------
**BUSCO LOS ASIENTOS DE AJUSTES PARA ESTE CLIENTE Y PERIODO...
**-------------------------------------------------------------------------------------------------
    GOSUB ASIENTOS_AJUSTES

**-------------------------------------------------------------------------------------------------
**FORMATEO Y CONCATENACION FINAL
**-------------------------------------------------------------------------------------------------
    IF Y.ARR.STMT2 EQ "" THEN
        Y.ARR.STMT2 = Y.ARR.STMT2 : "^"
    END
    IF Y.ARR.STMT3 EQ "" THEN
        Y.ARR.STMT3 = Y.ARR.STMT3 : "^"
    END
    IF Y.ARR.STMT4 EQ "" THEN
        Y.ARR.STMT4 = Y.ARR.STMT4 : "^"
    END
    IF Y.ARR.STMT5 EQ "" THEN
        Y.ARR.STMT5 = Y.ARR.STMT5 : "^"
    END
    IF Y.ARR.STMT6 EQ "" THEN
        Y.ARR.STMT6 = Y.ARR.STMT6 : "^"
    END
    IF Y.ARR.STMT7 EQ "" THEN
        Y.ARR.STMT7 = Y.ARR.STMT7 : "^"
    END
    IF Y.ARR.STMT8 EQ "" THEN
        Y.ARR.STMT8 = Y.ARR.STMT8 : "^"
    END

    Y.FINAL<-1> = F.ID : "*" : Y.CUS.NAME.1 : "*" : Y.IDENTIFICACION : "*" : Y.TOTAL.GANADO : "*" : Y.TOTAL.RETENIDO : "*" : Y.ARR.STMT : "*" : T.MES.INI.LIT : "*" : T.MES.FIN.LIT : "*" : Y.ARR.STMT2 : "*" : Y.ARR.STMT3 : "*" : Y.ARR.STMT4 : "*" : Y.ARR.STMT5 : "*"  : Y.ARR.STMT6 : "*"  : Y.ARR.STMT7 : "*" : Y.ARR.STMT8 : "*" : Y.CONTADOR
RETURN


**------------------------------------------------------------------------------------------------------------------------------------
*|
*|
*|
*|
**------------------------------------------------------------------------------------------------------------------------------------
PROC_LIQ_ACCT:

    Y.CTA.ACTUAL = T.AC.INTEREST.LIQU.ACCT
    SEL.CMD2 = "SELECT " : FN.STMT : " WITH @ID LIKE " : Y.CTA.ACTUAL : "... AND PERIOD.LAST.DATE GE " : F.FECHA.INI.PERIOD : " AND PERIOD.LAST.DATE LE " : F.FECHA.FIN.PERIOD
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NO.OF.RECS2,SEL.ERR2)
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

        Y.TOTAL.GANADO += Y.TMP.GANADO
        Y.LIQUIDITY.ACCOUNT = R.STMT<IC.STMCR.LIQUIDITY.ACCOUNT>
**MONTO RETENCION:
        Y.INT.TAX.AMT = R.STMT<IC.STMCR.CR.INT.TAX.AMT>
        Y.CAN.TAX.AMT = DCOUNT(Y.INT.TAX.AMT,@VM)
        FOR J.VAR = 1 TO Y.CAN.AMT STEP 1
            Y.TMP.RETENIDO = Y.TMP.RETENIDO + R.STMT<IC.STMCR.CR.INT.TAX.AMT, J.VAR>
        NEXT J.VAR

        Y.TOTAL.RETENIDO += Y.TMP.RETENIDO

        IF Y.CONTADOR LE 31 THEN
            Y.ARR.STMT = Y.ARR.STMT : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
        END
        IF Y.CONTADOR GT 31 AND Y.CONTADOR LE 67 THEN
            Y.ARR.STMT2 = Y.ARR.STMT2 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
        END
        IF Y.CONTADOR GT 67 AND Y.CONTADOR LE 102 THEN
            Y.ARR.STMT3 = Y.ARR.STMT3 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
        END
        IF Y.CONTADOR GT 102 AND Y.CONTADOR LE 137 THEN
            Y.ARR.STMT4 = Y.ARR.STMT4 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
        END
        IF Y.CONTADOR GT 137 AND Y.CONTADOR LE 172 THEN
            Y.ARR.STMT5 = Y.ARR.STMT5 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
        END
        IF Y.CONTADOR GT 172 AND Y.CONTADOR LE 207 THEN
            Y.ARR.STMT6 = Y.ARR.STMT6 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
        END
        IF Y.CONTADOR GT 207 AND Y.CONTADOR LE 242 THEN
            Y.ARR.STMT7 = Y.ARR.STMT7 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
        END
        IF Y.CONTADOR GT 242 AND Y.CONTADOR LE 272 THEN
            Y.ARR.STMT8 = Y.ARR.STMT8 : Y.CTA.ACTUAL : " |" : Y.PERIOD.FIRST.DATE : " |" : Y.PERIOD.LAST.DATE : " |" : Y.TMP.CR.VAL.BALANCE : " |" : Y.TMP.CR.INT.RATE : " |" : Y.TMP.GANADO : " |" : Y.TMP.RETENIDO : " |" : Y.LIQUIDITY.ACCOUNT : "^"
        END
**---------------------------------------
**AUMENTO CONTADOR DE CONTROL DE FILAS.
**---------------------------------------
        Y.CONTADOR += 1
**---------------------------------------
**TODAS LAS CUENTAS PARTE 2
**---------------------------------------

        IF Y.ALL.ACCOUNTS NE "" THEN
            Y.ALL.ACCOUNTS = Y.ALL.ACCOUNTS : @VM : Y.CTA.ACTUAL
        END
**-------------------------------------------------------------------------------------------------
**VALIDACION CONTROL DE TOTAL DE REGISTROS A MOSTRAR MAXIMO ACTUAL 272 REGISTROS.
**-------------------------------------------------------------------------------------------------
        IF Y.CONTADOR GT 272 THEN
            ENQ.ERROR = "EL CLIENTE SOLICITADO POSEE MAS REGISTROS DE LOS ADMITIDOS PARA LA SALIDA DEL REPORTE EN EL RANGO ESPECIFICADO, ESPECIFIQUE UN RANGO MENOR."
            ENQ.ERROR<1,2> = 2
            RETURN
        END
    REPEAT
RETURN

ASIENTOS_AJUSTES:
    SEL.LIST3 = ""
    SEL.ERR3 = ""
    SEL.CMD3 = "SELECT " : FN.STMT.EN : " WITH ACCOUNT.NUMBER EQ DOP1761500100017 AND BOOKING.DATE GE " : F.FECHA.INI.PERIOD : " AND BOOKING.DATE LE " : F.FECHA.FIN.PERIOD : " AND TRANS.REFERENCE LIKE FT... AND AMOUNT.LCY LT 0"
**DEBUG
    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',NO.OF.RECS3,SEL.ERR3)
    LOOP REMOVE Y.STMT.EN.ID FROM SEL.LIST3 SETTING STMT.EN.POS
    WHILE Y.STMT.EN.ID DO
        CALL F.READ(FN.STMT.EN,Y.STMT.EN.ID,R.STMT.EN, FV.STMT.EN, STMT.EN.ERR)
**DEBUG
        T.TRANS.REFERENCE = R.STMT.EN<AC.STE.TRANS.REFERENCE>
        T.BOOKING.DATE = R.STMT.EN<AC.STE.BOOKING.DATE>
**BUSCAMOS EN FUNDS.TRANSFER$HIS
        HIS.FT.ID = T.TRANS.REFERENCE
        FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS' ; F.FT.HIS = ''
        CALL OPF(FN.FT.HIS,F.FT.HIS)
        HIS.REC = ''
        YERROR = ''
        CALL EB.READ.HISTORY.REC(F.FT.HIS,HIS.FT.ID,HIST.REC,YERROR)
**DEBUG
*        CALL GET.LOC.REF("FUNDS.TRANSFER", "L.FT.AZ.ACC.REF",FTH.POS)
EB.LocalReferences.GetLocRef("FUNDS.TRANSFER", "L.FT.AZ.ACC.REF",FTH.POS);* R22 UTILITY AUTO CONVERSION
**FT.LOCAL.REF => 67
        T.L.FT.AZ.ACC.REF = HIST.REC<67,FTH.POS>

**BUSCO LA CUENTA/DEPOSITO EN ACCOUNT
        FN.ACC = "F.ACCOUNT"
        CALL F.READ(FN.ACC,T.L.FT.AZ.ACC.REF,R.ACC, FV.ACC, ACC.ERR)

        T.CUSTOMER.ID = R.ACC<AC.CUSTOMER>

**SI EL CLIENTE DE LA CUENTA X ES EL CLIENTE SOLICITADO EVALUO EVALUO SI LA CUENTA APLICA PARA MOSTRARSE
        IF T.CUSTOMER.ID EQ F.ID THEN
            T.MULTIPLICADOR = 100
            T.MNT.RET = SMUL(R.STMT.EN<AC.STE.AMOUNT.LCY>, -1)
            T.MNT.ORI = SMUL(T.MNT.RET, T.MULTIPLICADOR)
            Y.TOTAL.GANADO += T.MNT.ORI
            Y.TOTAL.RETENIDO += T.MNT.RET

            IF Y.CONTADOR LE 31 THEN
                Y.ARR.STMT = Y.ARR.STMT : Y.CTA.ACTUAL : " |" : T.BOOKING.DATE : " |" : T.BOOKING.DATE : " |" : 0 : " |" : 0 : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
            END
            IF Y.CONTADOR GT 31 AND Y.CONTADOR LE 67 THEN
                Y.ARR.STMT2 = Y.ARR.STMT2 : Y.CTA.ACTUAL : " |" : T.BOOKING.DATE : " |" : T.BOOKING.DATE : " |" : 0 : " |" : 0 : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
            END
            IF Y.CONTADOR GT 67 AND Y.CONTADOR LE 102 THEN
                Y.ARR.STMT3 = Y.ARR.STMT3 : Y.CTA.ACTUAL : " |" : T.BOOKING.DATE : " |" : T.BOOKING.DATE : " |" : 0 : " |" : 0 : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
            END
            IF Y.CONTADOR GT 102 AND Y.CONTADOR LE 137 THEN
                Y.ARR.STMT4 = Y.ARR.STMT4 : Y.CTA.ACTUAL : " |" : T.BOOKING.DATE : " |" : T.BOOKING.DATE : " |" : 0 : " |" : 0 : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
            END
            IF Y.CONTADOR GT 137 AND Y.CONTADOR LE 172 THEN
                Y.ARR.STMT5 = Y.ARR.STMT5 : Y.CTA.ACTUAL : " |" : T.BOOKING.DATE : " |" : T.BOOKING.DATE : " |" : 0 : " |" : 0 : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
            END
            IF Y.CONTADOR GT 172 AND Y.CONTADOR LE 207 THEN
                Y.ARR.STMT6 = Y.ARR.STMT6 : Y.CTA.ACTUAL : " |" : T.BOOKING.DATE : " |" : T.BOOKING.DATE : " |" : 0 : " |" : 0 : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
            END
            IF Y.CONTADOR GT 207 AND Y.CONTADOR LE 242 THEN
                Y.ARR.STMT7 = Y.ARR.STMT7 : Y.CTA.ACTUAL : " |" : T.BOOKING.DATE : " |" : T.BOOKING.DATE : " |" : 0 : " |" : 0 : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
            END
            IF Y.CONTADOR GT 242 AND Y.CONTADOR LE 272 THEN
                Y.ARR.STMT8 = Y.ARR.STMT8 : Y.CTA.ACTUAL : " |" : T.BOOKING.DATE : " |" : T.BOOKING.DATE : " |" : 0 : " |" : 0 : " |" : T.MNT.ORI : " |" : T.MNT.RET : " |" : "N/A" : "^"
            END

        END



    REPEAT

RETURN
END
