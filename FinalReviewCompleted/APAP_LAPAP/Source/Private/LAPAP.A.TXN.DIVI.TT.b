* @ValidationCode : Mjo0NDYwOTI0ODI6Q3AxMjUyOjE2OTI5NDY2NDQ5MTg6SVRTUzotMTotMToxNzA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Aug 2023 12:27:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 170
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.A.TXN.DIVI.TT
***********************************************************
*----------------------------------------------------------
*
* COMPANY NAME    : APAP
* DEVELOPED BY    : ROQUEZADA
*
*----------------------------------------------------------
*
* DESCRIPTION     : AUTHORISATION routine to be used in TT versions
*                   to save USD/EUR transfer in historic table
*------------------------------------------------------------
*
* Modification History :
*-----------------------
*  DATE             WHO             REFERENCE        DESCRIPTION
*2022-09-12       ROQUEZADA                           CREATE

* 09-08-2023      Harishvikram C   Manual R22 conversion      BP Removed
*-----------------------------------------------------------------------------------------------
*----------------------------------------------------------------------
*
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_GTS.COMMON
    $INSERT  I_System
    $INSERT  I_F.TELLER
    $INSERT  I_F.ST.LAPAP.TRANS.DIVISA.SDT
    $INSERT  I_F.CUSTOMER


    GOSUB INIT
    GOSUB READ.CUSTOMER
    GOSUB TT.PROCESS

RETURN


* ===
INIT:
* ===

    APPL.NAME.ARR = "TELLER" : @FM : "CUSTOMER"
    FLD.NAME.ARR = "L.TT.MSG.DESC" : @VM : "L.TT.CLIENT.COD" : @FM : "L.ACTUAL.VERSIO" : @VM : "L.CU.CIDENT" : @VM: "L.CU.RNC" : @VM : "L.CU.PASS.NAT"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    Y.L.TT.MSG.DESC.POS = FLD.POS.ARR<1,1>
    Y.L.TT.CLIENT.COD.POS = FLD.POS.ARR<1,2>
    Y.L.ACTUAL.VERSIO.POS = FLD.POS.ARR<1,3>
    Y.L.CU.CIDENT.POS = FLD.POS.ARR<2,1>

    Y.FECHA.EFECTIVA = R.NEW(TT.TE.VALUE.DATE.1)
    Y.FECHA.VALOR = R.NEW(TT.TE.VALUE.DATE.1)
    Y.ID.LOCALIDAD = R.NEW(TT.TE.CO.CODE)
    Y.ID.TIPO.TRANSACCION = R.NEW(TT.TE.TRANSACTION.CODE)
    Y.MONTO.ORIGEN = R.NEW(TT.TE.AMOUNT.FCY.1)
    Y.MONTO.DESTINO = R.NEW(TT.TE.AMOUNT.FCY.2)
    Y.ID.TIPO.CAMBIO = ''
    Y.TASA.CAMBIO = R.NEW(TT.TE.RATE.1)
    Y.ID.MONEDA.ORIGEN = R.NEW(TT.TE.CURRENCY.1)
    Y.ID.MONEDA.DESTINO = R.NEW(TT.TE.CURRENCY.2)
    Y.COMENTARIOS = R.NEW(TT.TE.NARRATIVE.1) : R.NEW(TT.TE.NARRATIVE.2)
    Y.ID.CLIENTE = R.NEW(TT.TE.LOCAL.REF)<1,Y.L.TT.CLIENT.COD.POS>
    Y.DOCUMENTO.CLIENTE = ''
    Y.NOMBRE.CLIENTE = ''
    Y.APELLIDO.CLIENTE = ''
    Y.ID.APAP = ID.NEW
    Y.USUARIO.REGISTRO.APAP = FIELD(R.NEW(TT.TE.INPUTTER),'_',2);
    Y.VERSION = 'TELLER':PGM.VERSION
    
    IF NOT(Y.MONTO.ORIGEN) THEN
        Y.MONTO.ORIGEN = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    END

    IF NOT(Y.MONTO.DESTINO) THEN
        Y.MONTO.DESTINO = R.NEW(TT.TE.AMOUNT.LOCAL.2)
    END

    FN.CUSTOMER = 'F.CUSTOMER';
    F.CUSTOMER = ''
    ERR.CUSTOMER = '';
    R.CUSTOMER = '';
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

*MSG<-1> = 'PASA POR INIT: ': Y.VERSION
*CALL LAPAP.LOGGER('TESTLOG',ID.NEW,MSG)

RETURN


***********
TT.PROCESS:
***********
    VALORDCOUNT = DCOUNT(PGM.VERSION,'.')
    Y.VERSION.VALID = FIELD(PGM.VERSION,'.',VALORDCOUNT)

    IF Y.VERSION.VALID EQ 'FIM' THEN
        
        RETURN
    END
    IF (Y.ID.MONEDA.ORIGEN EQ 'USD' OR Y.ID.MONEDA.ORIGEN EQ 'EUR') OR (Y.ID.MONEDA.DESTINO EQ 'USD' OR Y.ID.MONEDA.DESTINO EQ 'EUR') THEN

        GOSUB SAVE.TRANS.DIVISA

    END

RETURN

****************************************************************************************
READ.CUSTOMER:
****************************************************************************************

    CALL GET.LOC.REF('CUSTOMER','L.CU.TIPO.CL',TIPO.CL.POS)
    CALL GET.LOC.REF('CUSTOMER','L.CU.CIDENT',Y.L.CU.CIDENT.POS)
    CALL GET.LOC.REF('CUSTOMER','L.CU.RNC',Y.L.CU.RNC.POS)
    CALL GET.LOC.REF('CUSTOMER','L.CU.PASS.NAT',Y.L.CU.PASS.NAT.POS)
    CALL F.READ(FN.CUSTOMER,Y.ID.CLIENTE,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    L.CU.TIPO.CL.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS>

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,TIPO.CL.POS> EQ 'PERSONA JURIDICA' THEN
        Y.NOMBRE.CLIENTE = R.CUSTOMER<EB.CUS.NAME.1>:' ':R.CUSTOMER<EB.CUS.NAME.2>
        Y.DOCUMENTO.CLIENTE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.RNC.POS>
    END
    ELSE
        Y.NOMBRE.CLIENTE = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
        Y.APELLIDO.CLIENTE = R.CUSTOMER<EB.CUS.FAMILY.NAME>
        Y.DOCUMENTO.CLIENTE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>
        IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.CIDENT.POS>) THEN

            Y.DOCUMENTO.CLIENTE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.PASS.NAT.POS>
        END
    END

RETURN

***************************
SAVE.TRANS.DIVISA:
****************************

    Y.TRANS.ID = Y.ID.APAP
    Y.APP.NAME = "ST.LAPAP.TRANS.DIVISA.SDT"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""

    R.ACR = ""
    R.ACR<ST.LAP72.FECHA.EFECTIVA> = Y.FECHA.EFECTIVA
    R.ACR<ST.LAP72.FECHA.VALOR> = Y.FECHA.VALOR
    R.ACR<ST.LAP72.ID.LOCALIDAD> = Y.ID.LOCALIDAD
    R.ACR<ST.LAP72.ID.TIPO.TRANS> = Y.ID.TIPO.TRANSACCION
    R.ACR<ST.LAP72.MONTO> = Y.MONTO.ORIGEN
    R.ACR<ST.LAP72.MONTO.DESTINO> = Y.MONTO.DESTINO
    R.ACR<ST.LAP72.ID.TIPO.CAMBIO> = Y.ID.TIPO.CAMBIO
    R.ACR<ST.LAP72.TASA.CAMBIO> = Y.TASA.CAMBIO
    R.ACR<ST.LAP72.ID.MONEDA.ORIGEN> = Y.ID.MONEDA.ORIGEN
    R.ACR<ST.LAP72.ID.MONEDA.DESTINO> = Y.ID.MONEDA.DESTINO
    R.ACR<ST.LAP72.COMENTARIOS> = Y.COMENTARIOS
    R.ACR<ST.LAP72.ID.CLIENTE> = Y.ID.CLIENTE
    R.ACR<ST.LAP72.DOCUMENTO> = Y.DOCUMENTO.CLIENTE
    R.ACR<ST.LAP72.NOMBRE> = Y.NOMBRE.CLIENTE
    R.ACR<ST.LAP72.APELLIDO> = Y.APELLIDO.CLIENTE
    R.ACR<ST.LAP72.ID.APAP> = Y.ID.APAP
    R.ACR<ST.LAP72.USR.REG.APAP> = Y.USUARIO.REGISTRO.APAP
    R.ACR<ST.LAP72.VERSION> = Y.VERSION

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.ACR,FINAL.OFS)

    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"TXN.DIVI.SDT",'')


RETURN
