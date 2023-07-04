* @ValidationCode : MjotNDY0NzIwNDQ0OkNwMTI1MjoxNjg4MzY0OTgwNDI0OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 03 Jul 2023 11:46:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>29</Rating>
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION

*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion      FMto@FM, VMto@VMT24.BP IS REMOVED,Commented this Insert file I_F.T24.FUND.SERVICES
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.GET.NOMBRE.CUS.CAJA.RT

    $INSERT  I_COMMON ;*R22 manual code cnversion
    $INSERT  I_EQUATE
    $INSERT  I_GTS.COMMON ;*R22 manual code cnversion
    $INSERT  I_System
    $INSERT JBC.h
    $INSERT  I_F.CUSTOMER
    $INSERT  I_F.TELLER
    $INSERT  I_F.VERSION
*$INSERT  I_F.T24.FUND.SERVICES ;*R22 manual code cnversion
    $USING APAP.TAM

    GOSUB METHOD_INIT
    GOSUB METHOD_PRELIMINAR_COND


    IF Y.PROCESS.GO.AHEAD NE '' THEN
        RETURN
    END ELSE
        GOSUB METHOD_PROCESS
    END

RETURN

****************
METHOD_INIT:
****************

    Y.NOMBRE.COMPLETO = ''
    Y.EXISTE = ''
    Y.PROCESS.GO.AHEAD = ''
    Y.IDENT.NUMBER = COMI
    ETEXT = ''
    E = ''

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CUS.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'; F.CUS.CIDENT = ''
    CALL OPF(FN.CUS.CIDENT,F.CUS.CIDENT)

    FN.CUS.RNC = 'F.CUSTOMER.L.CU.RNC'; F.CUS.RNC = ''
    CALL OPF(FN.CUS.RNC,F.CUS.RNC)

    FN.CUS.LEGAL.ID = 'F.REDO.CUSTOMER.LEGAL.ID'; F.CUS.LEGAL.ID  = ''
    CALL OPF(FN.CUS.LEGAL.ID,F.CUS.LEGAL.ID)

    LREF.POS   = ''
    LREF.FIELD = 'L.IDENT.TYPE':@VM:'L.TT.CLIENT.NME'

    CALL MULTI.GET.LOC.REF(APPLICATION,LREF.FIELD,LREF.POS)

    POS.L.IDENT.TYPE = LREF.POS<1,1>
    POS.L.TT.CLIENT.NME = LREF.POS<1,2>

    IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
        Y.TIPO.ID = R.NEW(TFS.LOCAL.REF)<1,POS.L.IDENT.TYPE>
    END ELSE
        Y.TIPO.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.IDENT.TYPE>
    END

*Y.L.TT.CLIENT.NME = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.CLIENT.NME>

RETURN

*******************
METHOD_PRELIMINAR_COND:
*******************
    IF Y.TIPO.ID EQ '' THEN
        COMI = ''
        Y.PROCESS.GO.AHEAD = 0
        ETEXT = "COMPLETE EL TIPO DE IDENTIFICACION"
        CALL STORE.END.ERROR
    END

RETURN

*******************
METHOD_PROCESS:
*******************

    BEGIN CASE
        CASE Y.TIPO.ID EQ "CED"
            Cedule = "padrone$":Y.IDENT.NUMBER
            GOSUB METHOD_GET_CEDULA
        CASE Y.TIPO.ID EQ "PAS"
            GOSUB METHOD_GET_PASAPORTE
        CASE Y.TIPO.ID EQ "RNC"
            Cedule = "rnc$":Y.IDENT.NUMBER
            GOSUB METHOD_GET_RNC
    END CASE

    IF Y.NOMBRE.COMPLETO NE '' THEN

        IF APPLICATION EQ 'T24.FUND.SERVICES' THEN
            R.NEW(TFS.LOCAL.REF)<1,POS.L.TT.CLIENT.NME> = Y.NOMBRE.COMPLETO
        END ELSE
            R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.CLIENT.NME> = Y.NOMBRE.COMPLETO

        END

        T.LOCREF<POS.L.TT.CLIENT.NME,7> = 'NOINPUT'
    END ELSE
        IF Y.PROCESS.GO.AHEAD EQ '' THEN
            T.LOCREF<POS.L.TT.CLIENT.NME,7> = ''
        END
    END

RETURN

**********************
METHOD_GET_CEDULA:
**********************

    IF LEN(Y.IDENT.NUMBER) NE 11 THEN
        Y.PROCESS.GO.AHEAD = 0
        ETEXT = "EB-INCORRECT.CHECK.DIGIT"
        CALL STORE.END.ERROR
        RETURN
    END ELSE
        CIDENT.CHK.RESULT = Y.IDENT.NUMBER
        CALL REDO.S.CALC.CHECK.DIGIT(CIDENT.CHK.RESULT)

        IF CIDENT.CHK.RESULT NE "PASS" THEN
            Y.PROCESS.GO.AHEAD = 0
            ETEXT = "EB-INCORRECT.CIDENT.NUMBER"
            CALL STORE.END.ERROR
            RETURN
        END
    END

    CALL F.READ(FN.CUS.CIDENT,Y.IDENT.NUMBER,R.CUS.CIDENT,F.CUS.CIDENT,CIDENT.ERR)

    IF R.CUS.CIDENT THEN
        CUS.ID = FIELD(R.CUS.CIDENT,"*",2)

        CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
        IF R.CUSTOMER THEN
            Y.NOMBRE.COMPLETO = R.CUSTOMER<EB.CUS.NAME.1>
        END ELSE
            GOSUB METHOD_GET_NO_CLIENTE
        END

    END ELSE
        GOSUB METHOD_GET_NO_CLIENTE
    END

RETURN

*************************
METHOD_GET_PASAPORTE:
*************************

    CALL F.READ(FN.CUS.LEGAL.ID,Y.IDENT.NUMBER,R.CUS.LEGAL.ID,F.CUS.LEGAL.ID,CUS.LEGAL.ERR)
    IF R.CUS.LEGAL.ID THEN
        CUS.ID = FIELD(R.CUS.LEGAL.ID,"*",2)
        CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

        IF R.CUSTOMER THEN
            Y.NOMBRE.COMPLETO = R.CUSTOMER<EB.CUS.NAME.1>
        END
    END

RETURN

*******************
METHOD_GET_RNC:
*******************

    IF LEN(Y.IDENT.NUMBER) NE 9 THEN
        Y.PROCESS.GO.AHEAD = 0
        ETEXT = "EB-INCORRECT.CHECK.DIGIT"
        CALL STORE.END.ERROR
        RETURN
    END ELSE
        RNC.CHK.RESULT = Y.IDENT.NUMBER
*   CALL REDO.RNC.CHECK.DIGIT(RNC.CHK.RESULT)
        APAP.TAM.redoRncCheckDigit(RNC.CHK.RESULT)   ;*R22 MANUAL CONVERSION

        IF RNC.CHK.RESULT NE "PASS" THEN
            Y.PROCESS.GO.AHEAD = 0
            ETEXT = "EB-INCORRECT.RNC.NUMBER"
            CALL STORE.END.ERROR
            RETURN
        END
    END

    CALL F.READ(FN.CUS.RNC,Y.IDENT.NUMBER,R.CUS.RNC,F.CUS.RNC,CUS.RNC.ERR)

    IF R.CUS.RNC THEN
        CUS.ID = FIELD(R.CUS.RNC,"*",2)

        CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

        IF R.CUSTOMER THEN
            Y.NOMBRE.COMPLETO = R.CUSTOMER<EB.CUS.NAME.1>
        END ELSE
            GOSUB METHOD_GET_NO_CLIENTE
        END

    END ELSE
        GOSUB METHOD_GET_NO_CLIENTE
    END

RETURN

******************************
METHOD_GET_NO_CLIENTE:
******************************
    ACTIVATION  = "APAP_PADRONES_WEBSERVICES"
    INPUT_PARAM = Cedule

    ERROR.CODE  = CALLJEE(ACTIVATION,INPUT_PARAM)

    IF ERROR.CODE THEN
        Y.EXISTE = 'NO'
    END ELSE
        IF INPUT_PARAM NE "" THEN
            CIDENT.RESULT = INPUT_PARAM

            CHANGE '$' TO '' IN CIDENT.RESULT
            CHANGE '#' TO @FM IN CIDENT.RESULT
            CIDENT.RESULT.ERR = CIDENT.RESULT<1>
            CHANGE '::' TO @FM IN CIDENT.RESULT.ERR
            CHANGE '::' TO @FM IN CIDENT.RESULT

            IF CIDENT.RESULT.ERR<1> EQ "SUCCESS" THEN
                IF Y.TIPO.ID EQ 'CED' THEN
                    Y.APELLIDO = CIDENT.RESULT<2>
                    Y.NOMBRE =  CIDENT.RESULT<4>
                    Y.NOMBRE.COMPLETO = Y.NOMBRE : ' ': Y.APELLIDO
                END ELSE
*RNC
                    Y.NOMBRE.COMPLETO = CIDENT.RESULT<3>
                END
            END
        END
    END

RETURN

END
