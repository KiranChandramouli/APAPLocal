* @ValidationCode : MjoxOTA5MjE3NjEwOkNwMTI1MjoxNjkxMzk5ODExMjg4OklUU1M6LTE6LTE6NDY3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 07 Aug 2023 14:46:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 467
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       No changes
* 13-07-2023     Harishvikram C   Manual R22 conversion       BP Removed
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.ACTUALIZAR.REFERIDO
*-------------------------------------------------------------------
* Subroutine to fetch customer's emails
* @out employment_status, occupation, employers_name, employers_addr
* Author : Omar Perez / Estanlin Hurtado
* Date   : 17/08/2022
*-------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ST.L.APAP.AC.REFERRER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT

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
