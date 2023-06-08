* @ValidationCode : Mjo3MDUxMDUzODA6Q3AxMjUyOjE2ODYyMDQ4ODUxMzI6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Jun 2023 11:44:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>270</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.ENQ.REPRECIO(Y.FINAL)

*-------------------------------------------------------------------------------------------------
* Description           : Enquiry NOFILE retorna informacion para un microservicio
* Developed On          : 18/02/2021
* Developed By          : Oliver Fermin
* Development Reference : ---
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* --------               Oliver Fermin                    18/02/2021           Creation
*08-JUNE-2023     Santosh         R22 Manual Conversion - Changed VM,FM to @VM,@FM and Corrcted NEXT statement
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.RELATION
    $INSERT I_F.CATEGORY
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.AA.OVERDUE
*   $INSERT I_F.AZ.ACCOUNT

    GOSUB LOAD.TABLES
    GOSUB PROCESS

RETURN

LOAD.TABLES:
************

    FN.CUS.PRD   = "F.REDO.CUST.PRD.LIST";
    FV.CUS.PRD   = "";
    R.CUS.PRD    = "";
    CUS.PRD.ERR  = "";
    CALL OPF(FN.CUS.PRD,FV.CUS.PRD)

    FN.CUS   = "F.CUSTOMER";
    FV.CUS   = "";
    R.CUS    = "";
    CUS.ERR  = "";
    CALL OPF(FN.CUS,FV.CUS)

    FN.REL  = "F.RELATION";
    FV.REL  = "";
    R.REL   = "";
    REL.ERR = "";
    CALL OPF(FN.REL,FV.REL)

    FN.ACC  = "F.ACCOUNT";
    FV.ACC  = "";
    R.ACC   = "";
    ACC.ERR = "";
    CALL OPF(FN.ACC,FV.ACC)

    FN.ACC.C   = "F.ACCOUNT.CLOSED";
    FV.ACC.C   = "";
    R.ACC.C    = "";
    ACC.ERR.C  = "";
    CALL OPF(FN.ACC.C,FV.ACC.C)

    FN.CAT   = "F.CATEGORY";
    FV.CAT   = "";
    R.CAT    = "";
    CAT.ERR  = "";
    CALL OPF(FN.CAT,FV.CAT)

    FN.JOINT.CONTRACTS.XREF='F.JOINT.CONTRACTS.XREF';
    FV.JOINT.CONTRACTS.XREF=''
    R.JOINT.CONTRACTS.XREF = ""
    JOINT.CONTRACTS.XREF.ERR = ""
    CALL OPF(FN.JOINT.CONTRACTS.XREF,FV.JOINT.CONTRACTS.XREF)

    FN.AA.ARR  = "F.AA.ARRANGEMENT";
    FV.AA.ARR  = "";
    R.AA.ARR   = "";
    AA.ARR.ERR = "";
    CALL OPF(FN.AA.ARR, FV.AA.ARR)

    FN.AZ.ACC   = "F.AZ.ACCOUNT";
    FV.AZ.ACC   = "";
    R.AZ.ACC    = "";
    AZ.ACC.ERR  = "";
    CALL OPF(FN.AZ.ACC,FV.AZ.ACC)

    FN.AA.PROD   = "F.AA.PRODUCT"
    FV.AA.PROD   = "";
    R.AA.PROD    = "";
    AA.PROD.ERR  = "";
    CALL OPF(FN.AA.PROD,FV.AA.PROD)

    HIS.REC    = '';
    YERROR     = '';
    FN.AC.HIS  = 'F.ACCOUNT$HIS';
    F.AC.HIS   = '';
    CALL OPF(FN.AC.HIS,F.AC.HIS)


RETURN

GET.LOCAL.FIELD:
***************

    LOC.REF.APPLICATION="CUSTOMER"
    LOC.REF.FIELDS='L.CU.SEGMENTO'
    LOC.REF.POS='' ;

    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    L.CU.SEGMENTO.POS=LOC.REF.POS

    LOC.REF.APPLICATION="AA.ARR.TERM.AMOUNT"
    LOC.REF.FIELDS='L.AA.COL'
    LOC.REF.POS.2 = '';

    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS.2)
    L.AA.COL.POS = LOC.REF.POS.2

RETURN

PROCESS:
********

    CUSTOMER.ID = '';
    Y.NUMBER.PRODUCT = '';
    Y.FILTRO.AMBOS.CAMPOS = 'NO';

    FINDSTR 'NUMERO.CLIENTE' IN D.FIELDS SETTING V.FLD, V.VAL THEN
        CUSTOMER.ID = D.RANGE.AND.VALUE<V.FLD>
    END

    FINDSTR 'NUMERO.PRODUCTO' IN D.FIELDS SETTING V.FLD, V.VAL THEN
        Y.NUMBER.PRODUCT = D.RANGE.AND.VALUE<V.FLD>
    END

    IF Y.NUMBER.PRODUCT EQ '' AND CUSTOMER.ID EQ '' THEN
        Y.TIPO.BUSQUEDA = '';
    END ELSE

*Si numero producto posee DATA y customer id no, entonces Tipo de busqueda = PRODUCTO
        IF Y.NUMBER.PRODUCT NE '' AND CUSTOMER.ID EQ '' THEN
            Y.TIPO.BUSQUEDA = 'PRODUCTO';
        END

*Si CUSTOMER ID posee DATA y numero de producto no, entonces Tipo de busqueda = CLIENTE
        IF CUSTOMER.ID NE '' AND Y.NUMBER.PRODUCT EQ '' THEN
            Y.TIPO.BUSQUEDA = 'CLIENTE';
        END

*Si numero producto posee DATA y customer id tambiente, entonces Tipo de busqueda = PRODUCTO
        IF CUSTOMER.ID NE '' AND Y.NUMBER.PRODUCT NE '' THEN
            Y.FILTRO.AMBOS.CAMPOS = 'YES';
            Y.TIPO.BUSQUEDA       = 'PRODUCTO';
        END

    END

    Y.POSEE.GARANTIA = 'NO';

    IF Y.TIPO.BUSQUEDA EQ 'CLIENTE' THEN
        Y.CUSTOMER = CUSTOMER.ID;
        GOSUB GET.INFO.BY.CUSTOMER.ID
    END ELSE
        GOSUB GET.INFO.BY.NUMBER.PRODUCT
    END

RETURN

GET.INFO.BY.NUMBER.PRODUCT:
*************************
*DEBUG
    Y.CUSTOMER = '';

    CALL F.READ(FN.ACC,Y.NUMBER.PRODUCT,R.ACC, FV.ACC, ACC.ERR)

    CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
    Y.L.AC.REINVESTED  = R.ACC<AC.LOCAL.REF,ACC.POS>

    CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS1",ACC.STATUS.POS)
    L.AC.STATUS1  = R.ACC<AC.LOCAL.REF,ACC.STATUS.POS>

    Y.CATEGORY           = R.ACC<AC.CATEGORY>
    Y.ARRANGEMENT.ID     = R.ACC<AC.ARRANGEMENT.ID>
    Y.ACCOUNT.NUMBER     = Y.NUMBER.PRODUCT
    Y.CUSTOMER           = R.ACC<AC.CUSTOMER>
    Y.POSTING.RESTRIC    = R.ACC<AC.POSTING.RESTRICT>
    Y.RECORD.STATUS      = R.ACC<AC.RECORD.STATUS>

    IF Y.RECORD.STATUS EQ "CLOSED" OR L.AC.STATUS1 EQ 'CLOSED' OR Y.CUSTOMER EQ '' THEN
        T.CONTINUE.FLAG  = "YES";
    END ELSE


        Y.CONTINUAR.BUSQUEDA = 'YES';
        Y.TIPO.PRODUCTO = '';

        IF Y.FILTRO.AMBOS.CAMPOS EQ 'YES' AND Y.CUSTOMER NE CUSTOMER.ID THEN
            Y.CONTINUAR.BUSQUEDA = 'NO';
        END

        IF Y.FILTRO.AMBOS.CAMPOS EQ 'YES' AND Y.CUSTOMER EQ CUSTOMER.ID THEN
            Y.CONTINUAR.BUSQUEDA = 'YES';
        END

        IF Y.CONTINUAR.BUSQUEDA EQ 'YES' THEN

*Prestamos
            IF (Y.CATEGORY GE 3000 AND Y.CATEGORY LE 3999) THEN
                Y.TIPO.PRODUCTO = 'PRESTAMO';
                T.CONTINUE.FLAG = 'NO';
                GOSUB GET.INFO.ARRANGEMENT
            END

*Certificados
            IF (Y.CATEGORY GT 6600 AND Y.CATEGORY LT 6699) THEN
                Y.TIPO.PRODUCTO = 'CERTIFICADO';
                T.CONTINUE.FLAG = 'NO';
                GOSUB GET.INFO.CERTIFICADO
            END

            GOSUB GET.INFO.SEGMENT.CUST
            GOSUB GET.DESCRIPCION.CATEGORY
            GOSUB SET.FINAL

        END

    END

RETURN

GET.INFO.SEGMENT.CUST:
*********************

    Y.SEGMENTO.CLIENTE = '';
    GOSUB GET.LOCAL.FIELD

    CALL F.READ(FN.CUS,Y.CUSTOMER,R.CUS, FV.CUS, CUS.ERR)

    IF R.CUS THEN
        Y.SEGMENTO.CLIENTE = R.CUS<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>
        Y.SEGMENTO.CLIENTE = UPCASE(Y.SEGMENTO.CLIENTE)
    END

RETURN

GET.INFO.BY.CUSTOMER.ID:
***********************

    GOSUB GET.INFO.SEGMENT.CUST

    CALL F.READ(FN.CUS.PRD,CUSTOMER.ID,R.CUS.PRD, FV.CUS.PRD, CUS.PRD.ERR)
    Y.CUS.PRD = R.CUS.PRD<PRD.PRODUCT.ID>
    Y.CUS.PRD.XREF = CHANGE(Y.CUS.PRD,@VM,@FM)

    CALL F.READ(FN.JOINT.CONTRACTS.XREF,CUSTOMER.ID,R.JOINT.CONTRACTS.XREF,FV.JOINT.CONTRACTS.XREF,EF.ERR)
    NO.OF.JOINT.ACCOUNT = DCOUNT(R.JOINT.CONTRACTS.XREF,@FM)

    FOR A = 1 TO NO.OF.JOINT.ACCOUNT STEP 1

        Y.ACC.NO = R.JOINT.CONTRACTS.XREF<A>

        LOCATE Y.ACC.NO IN Y.CUS.PRD.XREF SETTING POS.XREF ELSE
            Y.CUS.PRD = Y.CUS.PRD : @VM : Y.ACC.NO
        END

*    NEXT P
    NEXT A ;* R22 Manual Conversion
    Y.CAN.CUS.PRD = DCOUNT(Y.CUS.PRD,@VM)

    FOR P = 1 TO Y.CAN.CUS.PRD STEP 1

        T.CONTINUE.FLAG  = "NO";
        Y.NUMBER.PRODUCT     = Y.CUS.PRD<1,P>
        Y.NUMBER.PRODUCT.EST  = R.CUS.PRD<PRD.PRD.STATUS,P>

        CALL F.READ(FN.ACC,Y.NUMBER.PRODUCT,R.ACC, FV.ACC, ACC.ERR)

        CALL GET.LOC.REF("ACCOUNT", "L.AC.REINVESTED",ACC.POS)
        Y.L.AC.REINVESTED  = R.ACC<AC.LOCAL.REF,ACC.POS>

        CALL GET.LOC.REF("ACCOUNT", "L.AC.STATUS1",ACC.STATUS.POS)
        L.AC.STATUS1  = R.ACC<AC.LOCAL.REF,ACC.STATUS.POS>

        Y.CUSTOMER = '';
        Y.CATEGORY           = R.ACC<AC.CATEGORY>
        Y.ARRANGEMENT.ID     = R.ACC<AC.ARRANGEMENT.ID>
        Y.CUSTOMER           = R.ACC<AC.CUSTOMER>
        Y.POSTING.RESTRIC    = R.ACC<AC.POSTING.RESTRICT>
        Y.RECORD.STATUS      = R.ACC<AC.RECORD.STATUS>

        IF Y.RECORD.STATUS EQ "CLOSED" OR Y.NUMBER.PRODUCT.EST EQ "CLOSED" OR L.AC.STATUS1 EQ 'CLOSED' OR  Y.CUSTOMER EQ '' THEN
            T.CONTINUE.FLAG  = "YES"
            CONTINUE
        END

        Y.CONTINUAR.BUSQUEDA = 'YES';

        IF Y.FILTRO.AMBOS.CAMPOS EQ 'YES' AND Y.CUSTOMER NE CUSTOMER.ID THEN
            Y.CONTINUAR.BUSQUEDA = 'NO';
        END

        IF Y.FILTRO.AMBOS.CAMPOS EQ 'YES' AND Y.CUSTOMER EQ CUSTOMER.ID THEN
            Y.CONTINUAR.BUSQUEDA = 'YES';
        END

        IF Y.CONTINUAR.BUSQUEDA EQ 'YES' THEN

            Y.TIPO.PRODUCTO = '';
*Filtro general
            IF (Y.CATEGORY GE 3000 AND Y.CATEGORY LE 3999)  OR (Y.CATEGORY GT 6600 AND Y.CATEGORY LT 6699) OR (Y.CATEGORY GT 6000 AND Y.CATEGORY LT 6011) OR (Y.CATEGORY GT 6020 AND Y.CATEGORY LT 6599)  THEN

*Prestamos
                IF (Y.CATEGORY GE 3000 AND Y.CATEGORY LE 3999) THEN
                    Y.TIPO.PRODUCTO = 'PRESTAMO';
                    T.CONTINUE.FLAG = 'NO';
                    GOSUB GET.INFO.ARRANGEMENT
                END

*Certificados
                IF (Y.CATEGORY GT 6600 AND Y.CATEGORY LT 6699) THEN
                    Y.TIPO.PRODUCTO = 'CERTIFICADO';
                    T.CONTINUE.FLAG = 'NO';
                    GOSUB GET.INFO.CERTIFICADO
                END

                IF (Y.CATEGORY GT 6000 AND Y.CATEGORY LT 6011) OR (Y.CATEGORY GT 6020 AND Y.CATEGORY LT 6599) THEN
                    Y.TIPO.PRODUCTO = 'AHORRO';
                    T.CONTINUE.FLAG = 'NO';
                    GOSUB GET.INFO.AHORRO
                END

                GOSUB GET.DESCRIPCION.CATEGORY
                GOSUB SET.FINAL

            END ELSE
                T.CONTINUE.FLAG = 'YES';
                CONTINUE
            END

        END


    NEXT P

RETURN

GET.INFO.CERTIFICADO:
*********************

**Las categorias que identifican los certificados estan en los siguientes rangos: entre 6600 y 6618 y entre 6630 y 6699.

    Y.MONTO = "";
    Y.PLAZO = "";
    Y.TASA.ACTUAL = '';
    Y.TASA.POOL   = '';
    Y.MARGIN.RATE = '';
    Y.FECHA.ULT.REVISION = "";
    Y.MONTO.RENIVERTIDO = "";

    LREF.APPLNS = 'AZ.ACCOUNT';
    LREF.FIELDS = 'L.EB.TASA.POOL':@VM:'L.AZ.REIVSD.INT';
    CALL MULTI.GET.LOC.REF(LREF.APPLNS,LREF.FIELDS,LREF.POS)
    POS.EB.TASA.POOL = LREF.POS<1,1>
    POS.EB.MONTO.REINV = LREF.POS<1,2>

    CALL F.READ(FN.AZ.ACC, Y.NUMBER.PRODUCT, R.AZ.ACC, FV.AZ.ACC, AZ.ACC.ERR)

    IF R.AZ.ACC NE '' THEN

        Y.MONTO              = R.AZ.ACC<AZ.PRINCIPAL>
        Y.TASA.ACTUAL        = R.AZ.ACC<AZ.INTEREST.RATE>
        Y.TASA.ACTUAL        = DROUND(Y.TASA.ACTUAL, 2)
        Y.TASA.POOL          = R.AZ.ACC<AZ.LOCAL.REF, POS.EB.TASA.POOL>
        Y.FECHA.ULT.REVISION = R.AZ.ACC<AZ.VALUE.DATE>
        Y.VALUE.DATE         = R.AZ.ACC<AZ.VALUE.DATE>
        Y.MATURITY.DATE      = R.AZ.ACC<AZ.MATURITY.DATE>
        Y.MONTO.RENIVERTIDO = R.AZ.ACC<AZ.LOCAL.REF,POS.EB.MONTO.REINV>

        Y.MONTO = Y.MONTO + Y.MONTO.RENIVERTIDO

        Y.PRESTAMO = Y.NUMBER.PRODUCT
        GOSUB VERIFICAR.GARANTIA

        IF Y.MARGIN.RATE EQ '' THEN
            Y.MARGIN.RATE  = '0';
        END

        IF Y.TASA.POOL EQ '' THEN
            Y.TASA.POOL  = '0';
        END

        IF Y.TASA.ACTUAL EQ '' THEN
            Y.TASA.ACTUAL  = '0';
        END

        DAYS = "C";
        CALL CDD("",Y.VALUE.DATE,Y.MATURITY.DATE,DAYS)
        Y.PLAZO = EREPLACE(DAYS,"D","")


    END ELSE
        T.CONTINUE.FLAG = 'YES';
    END

RETURN

GET.INFO.ARRANGEMENT:
********************

    Y.TASA.POOL    = '';
    Y.ULT.REVISION = "";
    Y.MARGIN.RATE  = '';
    Y.TASA.ACTUAL  = '';
    Y.MONTO = "";
    Y.PLAZO = "";

    R.ARRANGEMENT = ''; ERR.ARRAGEMENT = ''; CLIENTE.ID = '';
    CALL AA.GET.ARRANGEMENT(Y.ARRANGEMENT.ID,R.ARRANGEMENT,ERR.ARRAGEMENT)
    Y.ARR.STATUS       = R.ARRANGEMENT<AA.ARR.ARR.STATUS>

    IF Y.ARR.STATUS EQ 'CLOSE' OR Y.ARR.STATUS EQ 'PENDING.CLOSURE' THEN
        T.CONTINUE.FLAG = 'YES';
    END ELSE
        T.CONTINUE.FLAG = 'NO';
    END

    CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(Y.ARRANGEMENT.ID,OUT.RECORD)
    R.AA.TERM.AMOUNT          = FIELD(OUT.RECORD,"*",1)
    R.AA.INTEREST             = FIELD(OUT.RECORD,"*",7)

    LOC.REF.APPLICATION="AA.PRD.DES.INTEREST";
    LOC.REF.FIELDS='L.AA.LST.REV.DT':@VM:'L.AA.POOL.RATE':@VM:'L.AA.RT.RV.FREQ':@VM:'L.AA.NXT.REV.DT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.LST.REV.DT = LOC.REF.POS<1,1>
    POS.L.AA.POOL.RATE  = LOC.REF.POS<1,2>
    POS.L.AA.RT.RV.FREQ = LOC.REF.POS<1,3>
    POS.L.AA.NXT.REV.DT = LOC.REF.POS<1,4>

    Y.TASA.ACTUAL         = R.AA.INTEREST<AA.INT.FIXED.RATE>
    Y.TASA.POOL           = R.AA.INTEREST<AA.INT.LOCAL.REF,POS.L.AA.POOL.RATE>
    Y.FECHA.ULT.REVISION  = R.AA.INTEREST<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT>
    Y.FECHA.PROX.REVISON  = R.AA.INTEREST<AA.INT.LOCAL.REF,POS.L.AA.NXT.REV.DT>
    Y.PLAZO.REV           = R.AA.INTEREST<AA.INT.LOCAL.REF,POS.L.AA.RT.RV.FREQ>
    Y.MARGIN.RATE         = R.AA.INTEREST<AA.INT.MARGIN.RATE>
* Y.MONTO               = R.AA.TERM.AMOUNT<AA.AMT.AMOUNT>
    Y.START.DATE          = R.ARRANGEMENT<AA.ARR.START.DATE>
    Y.MATURITY.DATE       = R.AA.TERM.AMOUNT<AA.AMT.MATURITY.DATE>

    CALL F.READ(FN.ACC, Y.NUMBER.PRODUCT, R.ACC, FV.ACC, ACC.ERR)

    Y.MONTO = R.ACC<AC.WORKING.BALANCE>


    COLLATERAL.ID        = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    Y.POSEE.GARANTIA = 'NO';
    IF COLLATERAL.ID NE '' THEN
        Y.POSEE.GARANTIA  = 'SI';
    END

    IF Y.MARGIN.RATE EQ '' THEN
        Y.MARGIN.RATE  = '0';
    END

    IF Y.TASA.POOL EQ '' THEN
        Y.TASA.POOL  = '0';
    END

    IF Y.TASA.ACTUAL EQ '' THEN
        Y.TASA.ACTUAL  = '0';
    END

    DAYS = "C";
    CALL CDD("",Y.START.DATE,Y.MATURITY.DATE,DAYS)
    Y.PLAZO = EREPLACE(DAYS,"D","")

RETURN


GET.INFO.AHORRO:

    Y.TASA = ''

    CALL F.READ(FN.ACC, Y.NUMBER.PRODUCT, R.ACC, FV.ACC, ACC.ERR)

    Y.MONTO = R.ACC<AC.WORKING.BALANCE>
    CALL GET.LOC.REF("ACCOUNT","L.EB.TASA.POOL",ACC.POS.POOL)
    CALL GET.LOC.REF("ACCOUNT","L.STAT.INT.RATE",ACC.POS.TASA)
    Y.TASA.POOL   = R.ACC<AC.LOCAL.REF,ACC.POS.POOL>
    Y.TASA.ACTUAL = R.ACC<AC.LOCAL.REF,ACC.POS.TASA>


GET.DESCRIPCION.CATEGORY:
************************

    Y.CATEGORY.DESC = "";

    IF Y.CATEGORY NE '' THEN

        CALL F.READ(FN.CAT,Y.CATEGORY,R.CAT, FV.CAT, CAT.ERR)
        Y.CATEGORY.DESC  = R.CAT<EB.CAT.DESCRIPTION>

        IF Y.ARRANGEMENT.ID NE '' THEN

            CALL F.READ(FN.AA.ARR, Y.ARRANGEMENT.ID, R.AA.ARR, FV.AA.ARR, AA.ARR.ERR)
            CALL F.READ(FN.AA.PROD, R.AA.ARR<AA.ARR.PRODUCT>, R.AA.PROD, FV.AA.PROD, AA.PROD.ERR)

            Y.TIPO.PRODUCTO = R.AA.ARR<AA.ARR.PRODUCT.GROUP>
            Y.CATEGORY.DESC  = R.AA.PROD<AA.PDT.DESCRIPTION,2>

            IF Y.CATEGORY.DESC EQ '' THEN
                Y.CATEGORY.DESC  = R.AA.PROD<AA.PDT.DESCRIPTION,1>
            END

        END

    END

RETURN

VERIFICAR.GARANTIA:
*******************

    PROP.CLASS = 'TERM.AMOUNT';    PROP.NAME  = ''; returnConditions = ''; RET.ERR = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.PRESTAMO,PROP.CLASS,PROP.NAME,'','',returnConditions,ERR.COND)
    R.AA.TERM.AMOUNT = RAISE(returnConditions)

    GOSUB GET.LOCAL.FIELD

    COLLATERAL.ID = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.POS>
    Y.POSEE.GARANTIA = 'NO';
    IF COLLATERAL.ID NE '' THEN
        Y.POSEE.GARANTIA  = 'SI';
    END

RETURN


SET.FINAL:
*********

    IF T.CONTINUE.FLAG EQ "NO" THEN
        Y.FINAL<-1> = Y.NUMBER.PRODUCT:"*":Y.CATEGORY:"*":Y.CATEGORY.DESC:"*":Y.MONTO:"*":Y.PLAZO:"*":Y.TASA.ACTUAL:"*":Y.TASA.POOL:"*":Y.MARGIN.RATE:"*":Y.FECHA.ULT.REVISION:"*":Y.TIPO.PRODUCTO:"*":Y.SEGMENTO.CLIENTE:"*":Y.POSEE.GARANTIA:"*":Y.FECHA.PROX.REVISON:"*":Y.PLAZO.REV
    END

RETURN
