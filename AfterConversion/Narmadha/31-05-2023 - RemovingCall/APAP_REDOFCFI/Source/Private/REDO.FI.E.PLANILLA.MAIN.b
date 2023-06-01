* @ValidationCode : MjotMTQyMDAxODQ2NDpDcDEyNTI6MTY4MTEzNTE2NDMyMzpJVFNTOi0xOi0xOjIzOToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 239
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.E.PLANILLA.MAIN(DATA.OUT)
******************************************************************************

* Subroutine Type : ENQUIRY ROUTINE
* Attached to     : REDO.FI.E.PLANILLAS
* Attached as     : NOFILE ROUTINE
* Primary Purpose : Extract information from REDO.INTERFACE.PARAM
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* DATA.OUT - data returned to the enquiry


*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos ODR-2010-03-0025
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Nov. 11, 2010
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.REDO.INTERFACE.PARAM
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*


    GOSUB B100.GET.DIRECTORIES.LIST
    DATA.EACH.PLAN<11>   = PARAM.ID
    DATA.EACH.PLAN<12>   = FI.METODO.PAGO
    DATA.EACH.PLAN<13>   = FI.COMPANIA.AFILIADA
    DATA.EACH.PLAN<14>   = FI.SUCURSAL
    DATA.EACH.PLAN<15>   = FI.ESTADO
    DATA.EACH.PLAN<16>   = FI.VALIDAR.TRANS.IN
    CHANGE @FM TO "*" IN DATA.EACH.PLAN
    DATA.OUT<-1> = DATA.EACH.PLAN

*
RETURN
*
* ========================
B100.GET.DIRECTORIES.LIST:
* ========================
*
    FI.ESTADO = ''
    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID, R1.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        PROCESS.GOAHEAD = 0
        WERROR.MSG = "FI.PARAMETER.MISSING-&":@FM:PARAM.ID
        CALL TXT(WERROR.MSG)
    END
    RIP.PARAM1 = R1.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.VALUE1 = R1.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

* Locate METODO.PAGO
    WPARAM.POS = 1
    LOCATE METODO.PAGO IN RIP.PARAM1<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.METODO.PAGO = RIP.VALUE1<1,PARAM.POS>
    END
* Locate COMPANIA.AFILIADA
    WPARAM.POS = 1
    LOCATE COMPANIA.AFILIADA IN RIP.PARAM1<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.COMPANIA.AFILIADA  = RIP.VALUE1<1,PARAM.POS>
    END
* Locate SUCURSAL
    WPARAM.POS = 1
    LOCATE SUCURSAL IN RIP.PARAM1<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.SUCURSAL  = RIP.VALUE1<1,PARAM.POS>
    END
* Locate ESTADO

    FI.ESTADO  = R1.REDO.INTERFACE.PARAM<REDO.INT.PARAM.SERVICE.CONTROL>

* Locate VALIDAR.TRANS.IN
    WPARAM.POS = 1
    LOCATE VALIDAR.TRANS.IN IN RIP.PARAM1<1,WPARAM.POS> SETTING PARAM.POS THEN
        FI.VALIDAR.TRANS.IN  = RIP.VALUE1<1,PARAM.POS>
    END
*
RETURN
*
* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD           = 1
    NEVER.END.FLAG            = 1
    LOOP.CNT                  = 1
    MAX.LOOPS                 = 3
    DIRP.COUNT                = 1
    DIRP.LOOPS                = 7
    WPARAM.POS                = 1
    NUM.DIR                   = 0
*
*   CONSTANTS
*
    PARAM.ID                  = "PLANILLA"
    W.PARAM.DATA              = "PLANILLA record in REDO.INTERFACE.PARAM"
    PLANILLA.ID               = "PLANILLA.ID"
    METODO.PAGO               = "METODO.PAGO"
    COMPANIA.AFILIADA         = "COMPANIA.AFILIADA"
    SUCURSAL                  = "SUCURSAL"
    ESTADO                    = "ESTADO"
    VALIDAR.TRANS.IN          = "VALIDAR.TRANS.IN"
*
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM = ""
*
RETURN
*
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================

*

    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, PARAM.ID, R.REDO.INTERFACE.PARAM, Y.ERR)
    IF Y.ERR THEN
        PROCESS.GOAHEAD = 0
        WERROR.MSG = "PARAMETER.MISSING.&":@FM:PARAM.ID
    END
*Locate PLANILLA.ID list
    RIP.PARAM = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
    RIP.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
    PARAM.ID.LIST = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.AFF.COMPANY>
    CHANGE @VM TO @FM IN PARAM.ID.LIST

    IF PARAM.ID.LIST EQ "" THEN
        WERROR.MSG   = "MISSING.PARAMETER.ID.IN.PLANILLA.RECORD"
        CALL TXT(WERROR.MSG)
        PROCESS.GOAHEAD = 0
    END
RETURN

END
