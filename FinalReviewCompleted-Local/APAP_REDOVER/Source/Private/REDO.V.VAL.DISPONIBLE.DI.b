* @ValidationCode : Mjo1NjUzMTAyMzA6Q3AxMjUyOjE2ODM2MjM2ODAxMDU6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 09 May 2023 14:44:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.DISPONIBLE.DI
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DIPONIBLE
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : DISPO VALUE FOR ARRANGEMENT
*
*-----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*17-04-2023              Samaran T                R22 Manual Code conversion                        CORRECTED SELECT STATEMENT
*---------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.FC.COLL.CODE.PARAMS
    $USING APAP.REDOSRTN
    $USING APAP.TAM

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        VAR.CRED   = COMI
        IF VAR.CRED EQ '' THEN    ;*if the user change a creditos an delete the credit number
            RETURN
        END
        IF LEN(VAR.CRED) EQ 0 THEN          ;*if the user change a creditos an delete the credit number
            RETURN
        END

        GOSUB PROCESS
        GOSUB PIGNORADO
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

*EXCECUTE ONLY IF PRES HOT FIELD
    VAR.HOT = OFS$HOT.FIELD
    IF LEN(VAR.HOT) EQ 0 THEN
        RETURN
    END

*GET THE INFORMATION FOR THE SALD FOR ARRANGEMENT
    IF VAR.CRED MATCHES "AA..." THEN
        GOSUB READ.AA.ARRANGEMENT
    END
    ELSE
        GOSUB READ.ACCOUNT
    END

*ERROR MESSAGE WHEN THE ARRANGEMETN DO NOT EXIST
    IF Y.ACCOUNT.ID EQ 0 THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        ETEXT = 'ST-ERROR.SEL.CRED'
        CALL STORE.END.ERROR
        RETURN
    END

* Get outstanding from AA
    GOSUB GET.AA.CURBAL         ;* PACS00307565 - S/E
    P.TOTAL.OUT = ABS(P.TOTAL.OUT)
    GOSUB MONTO.MAX
    GOSUB GET.RISK.PERCENT
    VAR.MAX  =  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX>

    Y.VAL.NOMINAL.COLL = (Y.RISK.PERC/100) * P.TOTAL.OUT
    Y.VAL.NOMINAL.COLL = DROUND(Y.VAL.NOMINAL.COLL,2)
    YAMTMAX = (R.NEW(COLL.LOCAL.REF)<1,WPOS.PER>/100) *  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.DI>
    YAMTMAX = DROUND(YAMTMAX,2)
* verify positive values
    IF (YAMTMAX - Y.VAL.NOMINAL.COLL) GE 0 THEN
        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISP> = 0        ;*VAR.MAX - P.TOTAL.OUT
        R.NEW(COLL.EXECUTION.VALUE) = Y.VAL.NOMINAL.COLL
        R.NEW(COLL.NOMINAL.VALUE) = Y.VAL.NOMINAL.COLL
        R.NEW(COLL.MAXIMUM.VALUE) = Y.VAL.NOMINAL.COLL
        R.NEW(COLL.GEN.LEDGER.VALUE) = Y.VAL.NOMINAL.COLL
    END
    ELSE
        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISP> = 0
        R.NEW(COLL.EXECUTION.VALUE) = YAMTMAX
        R.NEW(COLL.NOMINAL.VALUE) = YAMTMAX
        R.NEW(COLL.MAXIMUM.VALUE) = YAMTMAX
        R.NEW(COLL.GEN.LEDGER.VALUE) = YAMTMAX
    END

*Calc the REA VALUE
    CALL APAP.TAM.redoVValReaCollateral
*    CALL  REDO.V.VAL.REA.COLLATERAL

RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    FN.SALD  = 'F.EB.CONTRACT.BALANCES'
    F.SALD   = ''
    R.SALD   = ''

    FN.AA.ARRANGEMENT  = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    R.AA.ARRANGEMENT   = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''

    FN.COLL.CODE.PARAMS = 'F.REDO.FC.COLL.CODE.PARAMS'
    F.COLL.CODE.PARAMS  = ''
    R.COLL.CODE.PARAMS  = ''

*Read the local fields
    WCAMPO = "L.AC.LK.COL.ID"
    WCAMPO<2> = "L.COL.LN.MX.VAL"
    WCAMPO<3> = "L.COL.VAL.AVA"
    WCAMPO<4> = "L.COL.EXE.DATE"
    WCAMPO<5> = "L.COL.LN.MX.PER"
    WCAMPO<6> = "L.AVA.AMO.INS"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0
    WCAMPO<2>= "L.AA.RISK.PER"
*Get the position for all fields
    LOC.REF.APPLICATION = 'COLLATERAL' : @FM : 'AA.PRD.CAT.TERM.AMOUNT'
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,WCAMPO,YPOS)
    WPOS.CRED  = YPOS<1,1>
    WPOS.MAX   = YPOS<1,2>
    WPOS.DISP  = YPOS<1,3>
    WPOS.FECH  = YPOS<1,4>
    WPOS.PER = YPOS<1,5>
    WPOS.MAX.DI = YPOS<1,6>
    WPOS.RISK  = YPOS<2>

*GET THE IFORMATION FOR PRODUCT
    FN.DETCRED  = 'F.AA.PRD.CAT.TERM.AMOUNT'
    F.DETCRED   = ''
    R.DETCRED   = ''

    VAR.PRODUCTO = ''
    VAR.MONEDA   = ''
    DETCRE.LIST  = ''

    Y.COLL.TYPE = R.NEW(COLL.COLLATERAL.TYPE)

RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.SALD,F.SALD)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    CALL OPF(FN.COLL.CODE.PARAMS,F.COLL.CODE.PARAMS)
    CALL OPF(FN.DETCRED,F.DETCRED)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*------------

PIGNORADO:
*=========
* GET THE % INTERNAL DEPOSITOS

    VAR.DETCRED = VAR.PRODUCTO:'-COMMITMENT-':VAR.MONEDA
    SELECT.STATEMENT = 'SELECT ':FN.DETCRED:' WITH @ID LIKE ':VAR.DETCRED:'...'  ;*R22 MANAUAL CODE CONVERSION
    DETCRE.LIST = ''
    LISTA.NOMBRE = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,DETCRE.LIST,LISTA.NOMBRE,SELECTED,SYSTEM.RETURN.CODDE)

*GET ALL VALUES FROM THE LIST AND ADD THE LOCK VALUE
    LOOP
        REMOVE Y.ID.AA.PRD FROM DETCRE.LIST SETTING POS
    WHILE Y.ID.AA.PRD:POS

        CALL CACHE.READ(FN.DETCRED, Y.ID.AA.PRD, R.DDDW, Y.ERR)

        VAR.PORCENT    =  R.DDDW<AA.AMT.LOCAL.REF,WPOS.RISK>

*SET THE PIGNORATION VALUE
        IF LEN(VAR.PORCENT) GT 0 THEN
            VAR.PIG = (P.TOTAL.OUT * VAR.PORCENT)/100
            VAR.PIG = DROUND(VAR.PIG,2)
            R.NEW(COLL.NOMINAL.VALUE) = VAR.PIG
        END
        ELSE
            AF = COLL.LOCAL.REF
            AV = YPOS<1,1>
            ETEXT = 'ST-PORCET.NOT.EXIST'
            CALL STORE.END.ERROR
            RETURN
        END


    REPEAT

RETURN
*------------
*=============
GET.AA.CURBAL:
*=============
*
* Get outstanding from AA
    P.TOTAL.OUT = ''
    CALL APAP.REDOSRTN.redoSGetOutBalance(VAR.CRED,TOTAL.AMT)
*    CALL REDO.S.GET.OUT.BALANCE(VAR.CRED,TOTAL.AMT)
    P.TOTAL.OUT    += TOTAL.AMT
*
RETURN
*
*=============================
READ.AA.ARRANGEMENT:
*=============================
    CALL F.READ(FN.AA.ARRANGEMENT, VAR.CRED, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, Y.ERR)
    Y.ACCOUNT.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    VAR.CUS.CRED = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    VAR.PRODUCTO =  R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    VAR.MONEDA   =  R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
RETURN
*=============================
READ.ACCOUNT:
*=============================
    CALL F.READ(FN.ACCOUNT,VAR.CRED,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    Y.ACCOUNT.ID = VAR.CRED
    VAR.CRED = R.ACCOUNT<AC.ARRANGEMENT.ID>
    GOSUB READ.AA.ARRANGEMENT
RETURN

*==================================
GET.RISK.PERCENT:
*==================================
    IF R.NEW(COLL.COLLATERAL.CODE) NE 150 THEN
        RETURN
    END
    Y.PRODUCT.ID.CUR = VAR.PRODUCTO
    CALL APAP.TAM.redoColGetRiskDi(Y.PRODUCT.ID.CUR,Y.RISK.PERC)
*    CALL REDO.COL.GET.RISK.DI (Y.PRODUCT.ID.CUR,Y.RISK.PERC)  ;*Rutina para calcular el % de riesgo
    IF NOT(Y.RISK.PERC)THEN
        Y.RISK.PERC = 100
    END

RETURN


*------------------------------------------------------------------------------------------------------------------
MONTO.MAX:
*------------------------------------------------------------------------------------------------------------------

    Y.ERR=""
    CALL F.READ(FN.COLL.CODE.PARAMS, Y.COLL.TYPE, R.COLL.CODE.PARAMS, F.COLL.CODE.PARAMS, Y.ERR)
    R.NEW(COLL.LOCAL.REF)<1,WPOS.PER> = R.COLL.CODE.PARAMS<FC.PR.PER.MAX.PRESTAR>

    YAMTMAX = (R.NEW(COLL.LOCAL.REF)<1,WPOS.PER>/100) *  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX.DI>

    CALL SC.FORMAT.CCY.AMT(LCCY,YAMTMAX)

    R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX> = YAMTMAX
RETURN
*------------------------------------------------------------------------------------------------------------------

END
