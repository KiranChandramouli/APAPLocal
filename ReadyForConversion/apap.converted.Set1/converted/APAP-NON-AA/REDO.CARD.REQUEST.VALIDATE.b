SUBROUTINE REDO.CARD.REQUEST.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REQUEST.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine to default value in CARD.START.NO based on the value in
*               CARD.SERIES.NO and to validate account entered in ACCOUNT field
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27 Jul 2010    Mohammed Anies K       ODR-2010-03-0400        Initial Creation
* 8-Apr-2011     Kavitha                PACS00036007            Bug Fix
* 16 MAY 2011     KAVITHA              ODR-2010-03-0400      PACS00061910 FIX
* 19 MAY 2011     JEEVA T               ODR-2010-03-0400      Removing Start Number Validation
* 16 JUN 2011     KAVITHA               PACS00072694          ADDED PROSPECT DETAILS
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.REG.STOCK
    $INSERT I_F.REDO.CARD.DAMAGE
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.CUSTOMER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

    AF.LIST = REDO.CARD.REQ.CARD.TYPE
    CALL DUP.FLD.SET(AF.LIST)


RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.L.CU.CIDENT = ''
    CALL OPF(FN.L.CU.CIDENT,F.L.CU.CIDENT)

    FN.L.CU.NOUNICO = 'F.CUSTOMER.L.CU.NOUNICO'
    F.L.CU.NOUNICO = ''
    CALL OPF(FN.L.CU.NOUNICO,F.L.CU.NOUNICO)

    FN.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.L.CU.RNC = ''
    CALL OPF(FN.L.CU.RNC,F.L.CU.RNC)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.CARD.REG.STOCK = 'F.REDO.CARD.REG.STOCK'
    F.REDO.CARD.REG.STOCK = ''
    CALL OPF(FN.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.LRF.APPL = "CARD.TYPE"
    Y.LRF.FIELDS = 'L.CT.BIN'
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)
    Y.CT.BIN.POS = FIELD.POS<1,1>

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    F.REDO.APAP.H.PARAMETER=''
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)


RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section

    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    Y.PARAM.CARD.TYPE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
    FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)
    VIRGIN.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.VIRGIN.DEPT.CODE>



    Y.TOT.CARD.TYPES = DCOUNT(R.NEW(REDO.CARD.REQ.CARD.TYPE),@VM)
    Y.INIT.COUNT = 1
    LOOP
    WHILE Y.INIT.COUNT LE Y.TOT.CARD.TYPES
        CARD.TYPE.FETCH = R.NEW(REDO.CARD.REQ.CARD.TYPE)<1,Y.INIT.COUNT>
        CALL F.READ(FN.CARD.TYPE,CARD.TYPE.FETCH,R.CARD.TYPE,F.CARD.TYPE,CARD.ERR)
        CARD.BIN.NO = R.CARD.TYPE<CARD.TYPE.LOCAL.REF,Y.CT.BIN.POS>
        R.NEW(REDO.CARD.REQ.BIN)<1,Y.INIT.COUNT> = CARD.BIN.NO
****************
        LOCATE CARD.TYPE.FETCH IN Y.PARAM.CARD.TYPE<1,1> SETTING Y.CARD.POS THEN

            PAR.CARD.SERIES = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES,Y.CARD.POS>
            COMPANY.CNTR = LEN(ID.COMPANY)
*PACS00036007 -S
* IF R.NEW(REDO.CARD.REQ.CARD.SERIES.ID)<1,Y.INIT.COUNT> EQ '' THEN
            R.NEW(REDO.CARD.REQ.CARD.SERIES.ID)<1,Y.INIT.COUNT> = PAR.CARD.SERIES
*PACS00036007  -E
*  END

        END ELSE
            AF = REDO.CARD.REQ.CARD.SERIES.ID
*AV = 1
            AV = Y.INIT.COUNT
            ETEXT = "EB-SERIES.PARAM"
            CALL STORE.END.ERROR
        END
****************
        GOSUB GET.CARD.START.NO
        GOSUB MAKE.MANDATORY
        GOSUB VALIDATE.ACCOUNT

*GOSUB VALIDATE.QUANTITY
        Y.INIT.COUNT +=1
    REPEAT

RETURN
*------------------------
*****************
GET.CARD.START.NO:
*****************

    Y.CARD.SERIES.ID = R.NEW(REDO.CARD.REQ.CARD.SERIES.ID)<1,Y.INIT.COUNT>

    IF Y.CARD.SERIES.ID NE '' THEN
        Y.CARD.SERIES.COUNT = DCOUNT(Y.CARD.SERIES.ID,@VM)
        Y.RECEIVE.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>
        IF Y.RECEIVE.DEPT.CODE EQ '' THEN


* AF = REDO.CARD.REQ.CARD.SERIES.ID
*AV = 1
*ETEXT = "EB-SERIES.PARAM.DEPT"
*CALL STORE.END.ERROR

        END

*>>>>>>>>>>>below validation's are commented -- Jeeva >>>>>>>>>>>>>>>>>


*     Y.CARD.REG.STOCK.ID = 'CARD.':ID.COMPANY:'-':Y.RECEIVE.DEPT.CODE

*Y.CARD.REG.STOCK.ID = 'CARD.':ID.COMPANY

*        Y.CARD.REG.STOCK.ID = 'CARD.':FINAL.COMP:'-':VIRGIN.DEPT.CODE

*  GOSUB READ.CARD.REG.STOCK

*       Y.CARD.SERIES.ID = "*":Y.CARD.SERIES.ID:"*"

*      LOCATE Y.CARD.SERIES.ID IN R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.ID,1> SETTING Y.SERIES.ID.POS THEN

*         Y.SERIES.NO = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SER.START.NO,Y.SERIES.ID.POS>
*        Y.FINAL.SERIES.NO = FIELD(Y.SERIES.NO,'-',2)
*       Y.FINAL.SERIES.NO +=1
*      IF R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> EQ '' THEN
*         R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> = Y.FINAL.SERIES.NO
*          END
*     END ELSE
*        IF R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> EQ '' THEN
*           R.NEW(REDO.CARD.REQ.CARD.START.NO)<1,Y.INIT.COUNT> = 1
*      END
*   END

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Ends>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    END


RETURN
*--------------------------------------------------------------------------------------------------------
*****************
MAKE.MANDATORY:
*****************

    IF R.NEW(REDO.CARD.REQ.PERS.CARD)<1,Y.INIT.COUNT>  EQ '' THEN
        RETURN
    END

    Y.ENT.CUSTOMER.LIST = ''
    Y.ENT.CUSTOMER.LIST = R.NEW(REDO.CARD.REQ.CUSTOMER.NO)<1,Y.INIT.COUNT>
    Y.TOT.CUS.LIST = DCOUNT(Y.ENT.CUSTOMER.LIST,@SM)
    IF Y.TOT.CUS.LIST EQ 0 THEN
        Y.TOT.CUS.LIST = 1
    END
    Y.INIT.CUS.CNT = 1
    LOOP
    WHILE Y.INIT.CUS.CNT LE Y.TOT.CUS.LIST
        IF R.NEW(REDO.CARD.REQ.CUSTOMER.NO)<1,Y.INIT.COUNT,Y.INIT.CUS.CNT> EQ '' THEN
            AF = REDO.CARD.REQ.CUSTOMER.NO
            AV = Y.INIT.COUNT
            AS = Y.INIT.CUS.CNT
            ETEXT = "EB-INSMNT.MANDATORY"
            CALL STORE.END.ERROR
        END

        IF R.NEW(REDO.CARD.REQ.CUSTOMER.NAME)<1,Y.INIT.COUNT,Y.INIT.CUS.CNT> EQ '' THEN
            AF = REDO.CARD.REQ.CUSTOMER.NAME
            AV = Y.INIT.COUNT
            AS = Y.INIT.CUS.CNT
            ETEXT = "EB-INSMNT.MANDATORY"
            CALL STORE.END.ERROR
        END
        Y.INIT.CUS.CNT +=1
    REPEAT

    Y.ACCOUNT.LIST = ''
    Y.ACCOUNT.LIST = R.NEW(REDO.CARD.REQ.ACCOUNT.NO)<1,Y.INIT.COUNT>
    Y.TOT.SV.COUNT = DCOUNT(Y.ACCOUNT.LIST,@SM)
    IF Y.TOT.SV.COUNT EQ 0 THEN
        Y.TOT.SV.COUNT = 1
    END
    Y.INIT.SV.CNT = 1
    LOOP
    WHILE Y.INIT.SV.CNT LE Y.TOT.SV.COUNT
        IF R.NEW(REDO.CARD.REQ.ACCOUNT.NO)<1,Y.INIT.COUNT,Y.INIT.SV.CNT> EQ  '' THEN
            AF = REDO.CARD.REQ.ACCOUNT.NO
            AV = Y.INIT.COUNT
            AS = Y.INIT.SV.CNT
            ETEXT = "EB-INSMNT.MANDATORY"
            CALL STORE.END.ERROR
        END
        Y.INIT.SV.CNT +=1
    REPEAT



RETURN
*--------------------------------------------------------------------------------------------------------
*****************
VALIDATE.ACCOUNT:
*****************
*In this para, validations for the entered account is done

    Y.TOT.ACCOUNTS = DCOUNT(R.NEW(REDO.CARD.REQ.ACCOUNT.NO)<1,Y.INIT.COUNT>,@SM)
    Y.INIT.AC.COUNT = 1
    LOOP
    WHILE Y.INIT.AC.COUNT LE Y.TOT.ACCOUNTS
        Y.ENT.CUSTOMER = R.NEW(REDO.CARD.REQ.CUSTOMER.NO)<1,Y.INIT.COUNT,Y.INIT.AC.COUNT>
        IF Y.ENT.CUSTOMER EQ '' THEN
            RETURN
        END

        Y.ACCOUNT.ID =  R.NEW(REDO.CARD.REQ.ACCOUNT.NO)<1,Y.INIT.COUNT,Y.INIT.AC.COUNT>
        IF Y.ACCOUNT.ID NE '' THEN
            GOSUB READ.ACCOUNT
*PACS00061910 -S


            IF R.CARD.TYPE<CARD.TYPE.CATEGORY,1> NE '' THEN

                LOCATE R.ACCOUNT<AC.CATEGORY> IN R.CARD.TYPE<CARD.TYPE.CATEGORY,1> SETTING V.POS ELSE

                    AF = REDO.CARD.REQ.ACCOUNT.NO
                    AV = Y.INIT.COUNT
                    AS = Y.INIT.AC.COUNT
                    ETEXT = 'EB-CATEGORY.INVALID'
                    CALL STORE.END.ERROR

                END


                ALLOW.FCY.ACCT = R.CARD.TYPE<CARD.TYPE.ALLOW.FCY.ACCT>
                IF R.ACCOUNT<AC.CURRENCY> NE LCCY AND ALLOW.FCY.ACCT[1,1] NE 'Y' THEN

                    AF = REDO.CARD.REQ.ACCOUNT.NO
                    AV = Y.INIT.COUNT
                    AS = Y.INIT.AC.COUNT
                    ETEXT = 'EB-CURRENCY.INVALID'
                    CALL STORE.END.ERROR

                END
            END

* PACS00061910 -E

            GOSUB BEGIN.CASE.CHECK

        END
        Y.INIT.AC.COUNT +=1
    REPEAT

RETURN
*-------------
BEGIN.CASE.CHECK:

    BEGIN CASE

        CASE R.ACCOUNT<AC.CUSTOMER> NE Y.ENT.CUSTOMER
            AF = REDO.CARD.REQ.ACCOUNT.NO
            AV = Y.INIT.COUNT
            AS = Y.INIT.AC.COUNT
            ETEXT = 'EB-AC.NOT.CUST'
            CALL STORE.END.ERROR

        CASE R.ACCOUNT<AC.RELATION.CODE> NE ''
            CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,'SYSTEM',R.REDO.APAP.H.PARAMETER,ERR)
            REST.REL.CODE=R.REDO.APAP.H.PARAMETER<PARAM.REST.REL.CRD>
            LOCATE REST.REL.CODE IN R.ACCOUNT<AC.RELATION.CODE,1> SETTING POS.REL THEN
                AF = REDO.CARD.REQ.ACCOUNT.NO
                AV = Y.INIT.COUNT
                AS = Y.INIT.AC.COUNT
                ETEXT = 'EB-NOT.ALLOWED.FOR.JH'
                CALL STORE.END.ERROR
            END
    END CASE


RETURN
*--------------------------------------------------------------------------------------------------------
*****************
VALIDATE.QUANTITY:
*****************

    IF R.NEW(REDO.CARD.REQ.REGOFF.ACCEPTQTY) GT R.NEW(REDO.CARD.REQ.BRANCH.ORDERQTY) THEN
        AF = REDO.CARD.REQ.REGOFF.ACCEPTQTY
        ETEXT = "EB-REGOFF.GT.BRANCH"
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.CARD.REG.STOCK:
*****************
*LOCAL TEMPLATE record is read for the given stock entry id
    R.REDO.CARD.REG.STOCK   =''
    REDO.CARD.REG.STOCK.ERR = ''
    CALL F.READ(FN.REDO.CARD.REG.STOCK,Y.CARD.REG.STOCK.ID,R.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK,REDO.CARD.REG.STOCK.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.ACCOUNT:
*****************
*ACCOUNT record is read for the given stock entry id
    R.ACCOUNT   = ''
    ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------

END
