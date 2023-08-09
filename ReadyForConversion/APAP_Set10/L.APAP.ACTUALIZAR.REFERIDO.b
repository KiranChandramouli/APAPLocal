*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.ACTUALIZAR.REFERIDO
*-------------------------------------------------------------------
* Subroutine to fetch customer's emails
* @out employment_status, occupation, employers_name, employers_addr
* Author : Omar Perez / Estanlin Hurtado
* Date   : 17/08/2022
*-------------------------------------------------------------------

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT BP  I_F.ST.L.APAP.AC.REFERRER
    $INSERT T24.BP I_F.CUSTOMER
    $INSERT T24.BP I_F.ACCOUNT

    GOSUB INIT

    IF(Y.ID.CATEGORIA.CUENTA = '6031') THEN
        GOSUB BUSCAR.DOCUMENTO
        GOSUB CONSULTAR.REFERIDO
    END


INIT:

    Y.ID.CLIENTE           = R.NEW(AC.CUSTOMER)
    Y.ID.CUENTA            = ID.NEW
    Y.ID.CATEGORIA.CUENTA  = R.NEW(AC.CATEGORY)
    Y.DOCUMENTO.IDENTIDAD  = ''

**---------------------------------------
**ABRIR LA TABLA CUSTOMER
**---------------------------------------
    FN.CUS = "F.CUSTOMER"
    FV.CUS = ""
    R.CUS = ""
    CUS.ERR = ""
    CALL OPF(FN.CUS,FV.CUS)

**---------------------------------------
**ABRIR LA TABLA REFERIDOS
**---------------------------------------

    FN.REF     = 'FBNK.ST.L.APAP.AC.REFERRER'
    FV.REF     = ''
    R.REF      = ''
    R.ERROR    = ''

    CALL OPF(FN.REF, FV.REF);


**------------------------------
** Locales
**------------------------------
    APPL.NAME.ARR<1> = 'CUSTOMER' ;
    FLD.NAME.ARR<1,1> = 'L.CU.CIDENT' ;
    FLD.NAME.ARR<1,2> = 'L.CU.PASS.NAT' ;

    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    L.CU.CIDENT.POS = FLD.POS.ARR<1,1>
    L.CU.PASS.NAT.POS = FLD.POS.ARR<1,2>

    RETURN

BUSCAR.DOCUMENTO:
**------------------------------------------------------------------------------------------------------------------------------------
**------------------------------------------------------------------------------------------------------------------------------------
**CONSULTAR DATOS DEL CLIENTE
**------------------------------------------------------------------------------------------------------------------------------------

    CALL F.READ(FN.CUS,Y.ID.CLIENTE, R.CUS, FV.CUS, CUS.ERR)

    Y.DOCUMENTO.IDENTIDAD = R.CUS<EB.CUS.LOCAL.REF, L.CU.CIDENT.POS>
    Y.CUS.PASPORTE = R.CUS<EB.CUS.LOCAL.REF, L.CU.PASS.NAT.POS>

    RETURN

CONSULTAR.REFERIDO:

    CALL F.READ(FN.REF, Y.DOCUMENTO.IDENTIDAD, R.REF, FV.REF, R.ERROR)
    Y.NO.DOCUMENTO = ''
    IF (R.REF) THEN
        Y.NO.DOCUMENTO = Y.DOCUMENTO.IDENTIDAD
        GOSUB ACTUALIZAR.CUENTA;

    END
    ELSE
        Y.CUS.PASPORTE = SUBSTRINGS(Y.CUS.PASPORTE, 1, LEN(Y.CUS.PASPORTE)-3)
        CALL F.READ(FN.REF , Y.CUS.PASPORTE, R.PASS.REF, FV.REF, R.PASS.ERROR)
        IF (R.PASS.REF) THEN
            Y.NO.DOCUMENTO = Y.CUS.PASPORTE
            GOSUB ACTUALIZAR.CUENTA;
        END
    END


    RETURN


ACTUALIZAR.CUENTA:

    Y.TRANS.ID =  Y.NO.DOCUMENTO
    Y.APP.NAME = "ST.L.APAP.AC.REFERRER"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    R.ACR = ""

    R.ACR<ST.L.A51.ACCOUNT.ID.REF> = Y.ID.CUENTA;

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"LAPAP.JSON",'')

    RETURN

END
