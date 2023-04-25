* @ValidationCode : MjotMTU5NzcyNDEyMjpDcDEyNTI6MTY4MTg4MTg0MTExOTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 10:54:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.COL.EXTRACT.CREDIT(Y.CUSTOMER.ID, Y.CREDIT, Y.CREDIT.TXN)
*-----------------------------------------------------------------------------
* Name : REDO.COLLECTOR.EXTRACT.TO.CREDIT
*      : Allows to mapping the values from AA to INSERT for Collector Data Base
*
* -----------------------------------------------------------------------------------------
* This development uses and Static Mapping defined on RAD.CONDUIT.LINEAR with @id = REDO.COL.MAP.STATIC
*------------------------------------------------------------------------------
* @author hpasquel@temenos.com
* @stereotype subroutine
* @package REDO.COL
*
* @Parameters:
* ----------------------------------------------------------------------------
*             Y.CUSTOMER.ID   (in)  Customer to process
*             Y.CREDIT        (out) The insert instructions, separated by FM for TMPCREDITO
*             Y.CREDIT.TXN    (out) The insert instructions, separated by FM for TMPMOVIMIENTOS
* note.- For tracing the process we must keep the details data, this details will be returned in the second VM
* INPUT/OUTPUT
* ----------------------------------------------------------------------------
*             E               (out) The message error
*-----------------------------------------------------------------------------
*  HISTORY CHANGES:
*                  2011-11-30 - PACS00169639
*                               hpasquel@temenos.com        To improve SELECT statements
** Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COMPANY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.CUSTOMER
*
    $INSERT I_REDO.COL.CUSTOMER.COMMON
    $INSERT I_REDO.COL.EXTRACT.CREDIT.COMMON
*
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
*-----------------------------------------------------------------------------
    Y.START.TIME = TIME()
    E = ""
    GOSUB INITIALISE
    IF E THEN
        GOSUB TRACE.ERROR
        RETURN
    END
    GOSUB PROCESS
    Y.ELAPSED.TIME = TIME()- Y.START.TIME ;* How long the select took
    MSG = 'tracking execution time REDO.COL.EXTRACT.CREDIT( ' : Y.CUSTOMER.ID : ') time=' :  Y.ELAPSED.TIME : 'secs'
    CALL OCOMO("")  ;     CALL OCOMO(MSG)     ;    CALL OCOMO("")
RETURN

*-----------------------------------------------------------------------------
* Just Porcess the list of AA for the current Customer
PROCESS:
*-----------------------------------------------------------------------------
* << PACS00169639
    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER.ID,R.CUS.ARR,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)
    AA.LIST = R.CUS.ARR<CUS.ARR.OWNER>
* >> PACS00169639

    E = ""
    LOOP
        REMOVE AA.ID FROM AA.LIST SETTING AA.MARK
    WHILE AA.ID : AA.MARK AND PROCESS.GOAHEAD
        GOSUB INITIALISE.VARS
        E = ""
        GOSUB READ.MAIN.FILES
        IF NOT(E) AND Y.CONTINUE.AA THEN
            GOSUB PROCESS.AA
        END
        IF E NE "" THEN
            GOSUB TRACE.ERROR
        END
    REPEAT

RETURN

*-----------------------------------------------------------------------------
* Read Main records from AA files
READ.MAIN.FILES:
*-----------------------------------------------------------------------------
* Read Main Files
    CALL APAP.REDORETAIL.REDO.COL.EXTRACT.CREDIT.READ(AA.ID,R.AA,R.ACT.HIST,R.PRINCIPALINT,R.PENALTYINT,R.AA.ACCOUNT.DETAILS) ;* MANUAL R22 CODE CONVERSION
    IF E NE "" THEN
        RETURN
    END
* << PACS00169639
    Y.CONTINUE.AA = @FALSE
    GOSUB CHECK.SELECTION.CRITERIA.AA
    IF Y.CONTINUE.AA EQ @FALSE THEN
        RETURN
    END
* >> PACS00169639

    IF R.AA<AA.ARR.START.DATE> GT Y.PROCESS.DATE THEN
        Y.CONTINUE.AA = @FALSE
        RETURN
    END

* Product Code, this code is used to report TRACE info
    Y.TMPCREDITOCODIGOPRODUCTO = R.AA<AA.ARR.PRODUCT.GROUP>
    Y.PRODUCT.GROUP = Y.TMPCREDITOCODIGOPRODUCTO
    CALL APAP.TAM.REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, R.STATIC.MAPPING, "PRODUCT.GROUP", Y.TMPCREDITOCODIGOPRODUCTO) ;* R22 Manual conversion - CALL method format changed
    IF E NE "" THEN
        RETURN
    END
    Y.START.DATE = R.AA<AA.ARR.START.DATE>

RETURN
*-----------------------------------------------------------------------------
* Process each AA contract
PROCESS.AA:
*-----------------------------------------------------------------------------
* Start Mapping
* Agency Code
    Y.CO.CODE = R.AA<AA.ARR.CO.CODE>
    R.COMP = ''
    CALL CACHE.READ('F.COMPANY',Y.CO.CODE, R.COMP ,YERR)
    IF YERR NE '' THEN
        E = yRecordNotFound : @FM : Y.CO.CODE : @VM : 'F.COMPANY'
        RETURN
    END
    Y.TMPCREDITOCODIGOAGENCIA = R.COMP<EB.COM.SUB.DIVISION.CODE> + 0    ;* Change from format 000X to Number
    Y.AGENCY.CODE = Y.TMPCREDITOCODIGOAGENCIA
    IF Y.TMPCREDITOCODIGOAGENCIA EQ '' THEN
        E = yValueMantatory : @FM : "COMPANY>SUB.DIVISION.CODE" : @VM : Y.CO.CODE
        RETURN
    END
* Contract Number
    Y.ACCOUNT.ID = ""
    LOCATE "ACCOUNT" IN R.AA<AA.ARR.LINKED.APPL,1> SETTING Y.POS THEN
        Y.ACCOUNT.ID =  R.AA<AA.ARR.LINKED.APPL.ID,Y.POS>
        Y.TMPCREDITONUMEROCONTRATO = Y.ACCOUNT.ID
    END ELSE
        E = "ST-REDO.COL.NON.ACCOUNT.REF" : @VM : "VALUE ACCOUNT NOT FOUND LINKED.APPL FIELD ON AA.ARRANGEMENT & ID" : @FM : AA.ID
        RETURN
    END
*
    CALL F.READ(FN.ACCOUNT, Y.ACCOUNT.ID ,R.ACCT, F.ACCOUNT, YERR)
    IF YERR NE '' THEN
        E = yRecordNotFound : @FM : Y.ACCOUNT.ID : @VM : 'F.ACCOUNT'
        RETURN
    END
    CALL F.READ(FN.EB.CONTRACT.BALANCES, Y.ACCOUNT.ID ,R.EB.CONTRACT.BALANCES, F.EB.CONTRACT.BALANCES, YERR)
    IF YERR NE '' THEN
        E = yRecordNotFound : @FM : Y.ACCOUNT.ID : @VM : 'F.EB.CONTRACT.BALANCES'
        RETURN
    END
* Customer Code
    Y.TMPCREDITOCODIGOCLIENTE   = Y.CUSTOMER.ID
* Ccy Code
    Y.TMPCREDITOCODIGOMONEDA = R.AA<AA.ARR.CURRENCY>
    CALL APAP.TAM.REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, R.STATIC.MAPPING, "CURRENCY", Y.TMPCREDITOCODIGOMONEDA);* R22 Manual conversion - CALL method format changed
    IF E NE "" THEN
        RETURN
    END

    Y.TMPCREDITONUMEROCONTRATOORIGEN = R.ACCT<AC.ALT.ACCT.ID,1>         ;* Original Contract Number
    Y.TMPCREDITOFECHAINICIO = redoOracleDate(R.AA<AA.ARR.START.DATE>,'yyyyMMdd')  ;* Start Date
* Due Days & Number of due payments
    CALL APAP.REDOSRTN.REDO.S.COL.GET.BILL.DETAILS(R.AA.ACCOUNT.DETAILS,  Y.PROCESS.DATE,  Y.MORA.CTA.VEN, Y.TMPCREDITODIASATRASO, Y.TMPCREDITOCUOTASVENCIDAS, Y.TMPCREDITOCUOTASPAGADAS, Y.TMPCREDITOMONTOMOROSO ) ;* R22 Manual conversion - CALL method format changed
* Total
    GOSUB GET.TOTAL.AMOUNT
* Number of Payments (call projector routine)
    GOSUB PAYMENT.SCHEDULE.DETAILS
    Y.TMPCREDITOFECHAPROXIMOPAGO = redoOracleDate(Y.TMPCREDITOFECHAPROXIMOPAGO,'yyyyMMdd')
* Payment Frequency (M,W,etc)
    CALL APAP.REDOSRTN.REDO.S.COL.GET.PAY.FREQ(AA.ID,  R.STATIC.MAPPING, Y.PROCESS.DATE, Y.TMPCREDITOTIPOCUOTA);* R22 Manual conversion - CALL method format changed
    IF E THEN
        RETURN
    END
* Contract Status
    CALL APAP.TAM.REDO.S.COL.GET.AA.STATUS(AA.ID, Y.PROCESS.DATE, Y.TMPCREDITOESTADOCONTRATO, Y.TMPCREDITOCOBROJUDICIAL) ;* R22 Manual conversion - CALL method format changed
    IF E THEN
        RETURN
    END
    Y.TMPCREDITOFECHAVCTO = redoOracleDate(R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>,'yyyyMMdd')      ;* Maturity Date
    Y.TMPCREDITOCODIGOEJECUTIVO = R.ACCT<AC.ACCOUNT.OFFICER>[1,10]      ;* Account Officer

    GOSUB GET.PERIOD.BALANCES

    Y.TMPCREDITOMONTOINTMORADIARIO = 0 ;    Y.TYPE.SYSDATE = "ACCPENALTYINT"
    GOSUB GET.PENALTIES
    Y.TMPCREDITOMONTOINTMORADIARIO = ABS(Y.PENALTY.AMOUNT)

    Y.TMPCREDITOMONTOINTCORRDIARIO = 0 ;    Y.TYPE.SYSDATE = "ACCPRINCIPALINT"
    GOSUB GET.PENALTIES
    Y.TMPCREDITOMONTOINTCORRDIARIO = ABS(Y.PENALTY.AMOUNT)

    Y.TMPCREDITOTASAINTERES = redoOracleNull(R.PRINCIPALINT<AA.INT.ACC.RATE,1,1>) ;* Principal Interest Rate
    Y.TMPCREDITOTASAMORAINTERES = redoOracleNull(R.PENALTYINT<AA.INT.ACC.RATE,1,1>)         ;* Penalty Interest Rate

    CALL APAP.REDOSRTN.REDO.S.COL.GET.PAY.TYPE(AA.ID, R.STATIC.MAPPING, Y.PROCESS.DATE, Y.TMPCREDITOFORMAPAGO) ;* R22 Manual conversion - CALL method format changed
    IF E THEN
        RETURN
    END
    GOSUB GET.HISTORY.PAYMENT
    IF E THEN
        RETURN
    END

    Y.TMPCREDITOFECHAULTIMOPAGO = redoOracleDate(Y.TMPCREDITOFECHAULTIMOPAGO,'yyyyMMdd')

    Y.TMPCREDITOMORAMES01 = Y.TMPCREDITOCUOTASVENCIDAS
    Y.TMPCREDITOMORAMES02 = Y.MORA.CTA.VEN<1>
    Y.TMPCREDITOMORAMES03 = Y.MORA.CTA.VEN<2>
    Y.TMPCREDITOMORAMES04 = Y.MORA.CTA.VEN<3>
    Y.TMPCREDITOMORAMES05 = Y.MORA.CTA.VEN<4>
    Y.TMPCREDITOMORAMES06 = Y.MORA.CTA.VEN<5>
    Y.TMPCREDITOMORAMES07 = Y.MORA.CTA.VEN<6>
    Y.TMPCREDITOMORAMES08 = Y.MORA.CTA.VEN<7>
    Y.TMPCREDITOMORAMES09 = Y.MORA.CTA.VEN<8>
    Y.TMPCREDITOMORAMES10 = Y.MORA.CTA.VEN<9>
    Y.TMPCREDITOMORAMES11 = Y.MORA.CTA.VEN<10>
    Y.TMPCREDITOMORAMES12 = Y.MORA.CTA.VEN<11>

    Y.TMPCREDITOFACTORMONEDACONVERSI = ""
    CALL APAP.TAM.REDO.R.GET.MID.RATE.CM(R.AA<AA.ARR.CURRENCY>, 1, Y.TMPCREDITOFACTORMONEDACONVERSI);* R22 Manual conversion - CALL method format changed
*
    CALL F.READ(FN.CUSTOMER, Y.CUSTOMER.ID, R.CUS.TEMP, F.CUSTOMER, YERR)
    Y.TMPCREDITOTIPOCALIFICACION = R.CUS.TEMP<EB.CUS.CUSTOMER.RATING>[1,1]
*
    Y.TMPCREDITOMONTOACTUAL = Y.TMPCREDITOMONTOCAPITALVIGENTE
*
    CALL APAP.REDORETAIL.REDO.COL.EXTRACT.CREDIT.2("GET.AA.CUSTOMER", Y.ACCOUNT.ID, AA.ID, "", P.GET.AA.CUSTOMER, "") ;* MANUAL R22 CODE CONVERSION
    IF E THEN
        RETURN
    END
    Y.TMPCREDITOCAMPO59 = P.GET.AA.CUSTOMER<1>
    Y.TMPCREDITOCAMPO60 = P.GET.AA.CUSTOMER<2>
*
    CALL APAP.REDORETAIL.REDO.COL.EXTRACT.CREDIT.2("GET.CREDIT.GRANTED", Y.ACCOUNT.ID, AA.ID, P.GET.CREDIT.GRANTED, "", "") ;* MANUAL R22 CODE CONVERSION
    IF E THEN
        RETURN
    END
    Y.TMPCREDITOMONTOAPERTURA = P.GET.CREDIT.GRANTED<1>
    Y.TMPCREDITOGARANTIA           = P.GET.CREDIT.GRANTED<2>
    Y.TMPCREDITOGARANTIA           = P.GET.CREDIT.GRANTED<3>
    Y.TMPCREDITOUBICACIONGARANTIA  = P.GET.CREDIT.GRANTED<4>
    Y.TMPCREDITOVALORGARANTIA      = P.GET.CREDIT.GRANTED<5>

    GOSUB PROCESS.ITEMS.DETAIL
    GOSUB INSERT.STMT
    CALL APAP.REDORETAIL.REDO.COL.EXTRACT.TXN(Y.PROCESS.DATE, AA.ID, R.STATIC.MAPPING, Y.ACCOUNT.ID, Y.PRODUCT.GROUP, Y.AGENCY.CODE, Y.CREDIT.TXN) ;* MANUAL R22 CODE CONVERSION

RETURN

*-----------------------------------------------------------------------------
* Initialise Process variables
INITIALISE:
*-----------------------------------------------------------------------------
    P.TABLE = "TMPCREDITO"
    PROCESS.GOAHEAD = 1
    Y.PROCESS.DATE = C.REPORT.PROCESS.DATE          ;* R.DATES(EB.DAT.LAST.WORKING.DAY) ;* TODAY

    R.AA   = ""       ;* AA.ARRANGEMENT
    R.ACCOUNT.DETAILS = ""      ;* AA.ACCOUNT.DETAILS
    R.ACCT = ""       ;* ACCOUNT

    R.STATIC.MAPPING    =  C.STATIC.MAPPING         ;* Static Mapping
    CALL APAP.REDORETAIL.REDO.R.COL.GET.MAPPING(C.ID.STATIC.MAPPING, R.STATIC.MAPPING, 1, R.STATIC.MAPPING.OUT, "", "")  ;* MANUAL R22 CODE CONVERSION
    IF E THEN
        RETURN
    END
    R.STATIC.MAPPING = R.STATIC.MAPPING.OUT
    Y.INS.STMT = C.INS.CREDIT.STMT

RETURN

* ---------------------------------------------------------------------------------------------
* Initialise variables for INSERT statement
INITIALISE.VARS:
* ---------------------------------------------------------------------------------------------

* Variables to use building the INSERT statement
    Y.TMPCREDITOCODIGOAGENCIA = ""           ;     Y.TMPCREDITOCODIGOPRODUCTO = ""
    Y.TMPCREDITONUMEROCONTRATO = ""          ;     Y.TMPCREDITOCODIGOCLIENTE = ""
    Y.TMPCREDITOCODIGOMONEDA = ""            ;     Y.TMPCREDITONUMEROCONTRATOORIGEN = ""
    Y.TMPCREDITODIASATRASO = ""              ;     Y.TMPCREDITOCANTIDADCUOTASTOTAL = ""
    Y.TMPCREDITOCUOTASCREADAS = ""           ;     Y.TMPCREDITOCUOTASVENCIDAS = ""
    Y.TMPCREDITOCUOTASPAGADAS = ""           ;     Y.TMPCREDITOTIPOCUOTA = ""
    Y.TMPCREDITOESTADOCONTRATO = ""          ;     Y.TMPCREDITOFECHAINICIO = ""
    Y.TMPCREDITOFECHAVCTO = ""               ;     Y.TMPCREDITOMONTOMENSUALIDAD = ""
    Y.TMPCREDITOMONTOAPERTURA = ""           ;     Y.TMPCREDITOMONTOCAPITALVIGENTE = ""
    Y.TMPCREDITOMONTOCAPITALMOROSO = ""      ;     Y.TMPCREDITOMONTOCAPITALVENCIDO = ""
    Y.TMPCREDITOMONTOINTERESMOROSO = ""      ;     Y.TMPCREDITOMONTOINTERESVIGENTE = ""
    Y.TMPCREDITOMONTOINTERESVENCIDO = ""     ;     Y.TMPCREDITOMONTOSEGUROVIDAVENCI = 0
    Y.TMPCREDITOMONTOSEGUROFISICOVEN = 0     ;     Y.TMPCREDITOMONTOSEGUROVIDAVIGEN = 0
    Y.TMPCREDITOMONTOSEGUROFISICOVIG = 0     ;     Y.TMPCREDITOMONTOVIGENTEOTROS = 0
    Y.TMPCREDITOMONTOMOROSOOTROS = 0         ;     Y.TMPCREDITOMONTODEUDATOTAL = ""
    Y.TMPCREDITOMONTOMOROSO = ""             ;     Y.TMPCREDITOMONTOINTMORADIARIO = ""
    Y.TMPCREDITOMONTOINTCORRDIARIO = ""      ;     Y.TMPCREDITOTASAINTERES = ""
    Y.TMPCREDITOTASAMORAINTERES = ""         ;     Y.TMPCREDITOCODIGOEJECUTIVO = ""
    Y.TMPCREDITOFORMAPAGO = ""               ;     Y.TMPCREDITOFECHAULTIMOPAGO = ""
    Y.TMPCREDITOMONTOULTIMOPAGO = ""         ;     Y.TMPCREDITOFECHAPROXIMOPAGO = ""
    Y.TMPCREDITOTIPOCALIFICACION = ""        ;     Y.TMPCREDITOFECHAENTRADACOBRO = ""
    Y.TMPCREDITOCOBROJUDICIAL = ""           ;     Y.TMPCREDITOCODIGOVISTACREDITO = ""
    Y.TMPCREDITOMORAMES01 = ""               ;     Y.TMPCREDITOMORAMES02 = ""
    Y.TMPCREDITOMORAMES03 = ""               ;     Y.TMPCREDITOMORAMES04 = ""
    Y.TMPCREDITOMORAMES05 = ""               ;     Y.TMPCREDITOMORAMES06 = ""
    Y.TMPCREDITOMORAMES07 = ""               ;     Y.TMPCREDITOMORAMES08 = ""
    Y.TMPCREDITOMORAMES09 = ""               ;     Y.TMPCREDITOMORAMES10 = ""
    Y.TMPCREDITOMORAMES11 = ""               ;     Y.TMPCREDITOMORAMES12 = ""
    Y.TMPCREDITOFACTORMONEDACONVERSI = ""    ;     Y.TMPCREDITOCAMPO59 = ""
    Y.TMPCREDITOCAMPO60 = ""                 ;     Y.TMPCREDITOGARANTIA = ""
    Y.TMPCREDITOUBICACIONGARANTIA = ""       ;     Y.TMPCREDITOVALORGARANTIA = ""
    Y.TMPCREDITOMONTOACTUAL = ""

RETURN

*-----------------------------------------------------------------------------
* Create INSERT statement
INSERT.STMT:
*-----------------------------------------------------------------------------
    Y.TMPCREDITOCODIGOAGENCIA = redoOracleNull("'" : Y.TMPCREDITOCODIGOAGENCIA : "'")
    Y.TMPCREDITOCODIGOPRODUCTO = redoOracleNull("'" : Y.TMPCREDITOCODIGOPRODUCTO : "'")
    Y.TMPCREDITONUMEROCONTRATO = redoOracleNull("'" : Y.TMPCREDITONUMEROCONTRATO : "'")
    Y.TMPCREDITOCODIGOCLIENTE = redoOracleNull("'" : Y.TMPCREDITOCODIGOCLIENTE : "'")
    Y.TMPCREDITOCODIGOMONEDA = redoOracleNull("'" : Y.TMPCREDITOCODIGOMONEDA : "'")
    Y.TMPCREDITONUMEROCONTRATOORIGEN = redoOracleNull("'" : Y.TMPCREDITONUMEROCONTRATOORIGEN : "'")
    Y.TMPCREDITOCUOTASCREADAS = redoOracleNull("'" : Y.TMPCREDITOCUOTASCREADAS : "'")
    Y.TMPCREDITOCUOTASVENCIDAS = redoOracleNull("'" : Y.TMPCREDITOCUOTASVENCIDAS : "'")
    Y.TMPCREDITOTIPOCUOTA = redoOracleNull("'" : Y.TMPCREDITOTIPOCUOTA : "'")
    Y.TMPCREDITOESTADOCONTRATO = redoOracleNull("'" : Y.TMPCREDITOESTADOCONTRATO : "'")
    Y.TMPCREDITOMONTOMENSUALIDAD = redoOracleNull(Y.TMPCREDITOMONTOMENSUALIDAD)
    Y.TMPCREDITOMONTOAPERTURA = redoOracleNull(Y.TMPCREDITOMONTOAPERTURA)
    Y.TMPCREDITOCODIGOEJECUTIVO = redoOracleNull("'" : Y.TMPCREDITOCODIGOEJECUTIVO : "'")
    Y.TMPCREDITOFORMAPAGO = redoOracleNull("'" : Y.TMPCREDITOFORMAPAGO : "'")
    Y.TMPCREDITOMONTOULTIMOPAGO = redoOracleNull("'" : Y.TMPCREDITOMONTOULTIMOPAGO : "'")
    Y.TMPCREDITOTIPOCALIFICACION = redoOracleNull("'" : Y.TMPCREDITOTIPOCALIFICACION : "'")
    Y.TMPCREDITOFECHAENTRADACOBRO = redoOracleNull("'" : Y.TMPCREDITOFECHAENTRADACOBRO : "'")
    Y.TMPCREDITOCOBROJUDICIAL = redoOracleNull("'" : Y.TMPCREDITOCOBROJUDICIAL : "'")
    Y.TMPCREDITOCODIGOVISTACREDITO = redoOracleNull("'" : Y.TMPCREDITOCODIGOVISTACREDITO : "'")
    Y.TMPCREDITOMORAMES01 = redoOracleNull(Y.TMPCREDITOMORAMES01)
    Y.TMPCREDITOMORAMES02 = redoOracleNull(Y.TMPCREDITOMORAMES02)
    Y.TMPCREDITOMORAMES03 = redoOracleNull(Y.TMPCREDITOMORAMES03)
    Y.TMPCREDITOMORAMES04 = redoOracleNull(Y.TMPCREDITOMORAMES04)
    Y.TMPCREDITOMORAMES05 = redoOracleNull(Y.TMPCREDITOMORAMES05)
    Y.TMPCREDITOMORAMES06 = redoOracleNull(Y.TMPCREDITOMORAMES06)
    Y.TMPCREDITOMORAMES07 = redoOracleNull(Y.TMPCREDITOMORAMES07)
    Y.TMPCREDITOMORAMES08 = redoOracleNull(Y.TMPCREDITOMORAMES08)
    Y.TMPCREDITOMORAMES09 = redoOracleNull(Y.TMPCREDITOMORAMES09)
    Y.TMPCREDITOMORAMES10 = redoOracleNull(Y.TMPCREDITOMORAMES10)
    Y.TMPCREDITOMORAMES11 = redoOracleNull(Y.TMPCREDITOMORAMES11)
    Y.TMPCREDITOMORAMES12 = redoOracleNull(Y.TMPCREDITOMORAMES12)
    Y.TMPCREDITOFACTORMONEDACONVERSI = redoOracleNull(Y.TMPCREDITOFACTORMONEDACONVERSI)
    Y.TMPCREDITOCAMPO59 = redoOracleNull("'" : Y.TMPCREDITOCAMPO59 : "'")
    Y.TMPCREDITOCAMPO60 = redoOracleNull("'" : Y.TMPCREDITOCAMPO60 : "'")
    Y.TMPCREDITOGARANTIA = redoOracleNull("'" : Y.TMPCREDITOGARANTIA : "'")
    Y.TMPCREDITOUBICACIONGARANTIA = redoOracleNull("'" : Y.TMPCREDITOUBICACIONGARANTIA : "'")
    Y.TMPCREDITOVALORGARANTIA = redoOracleNull("'" : Y.TMPCREDITOVALORGARANTIA : "'")
    Y.TMPCREDITOMONTOACTUAL = redoOracleNull(Y.TMPCREDITOMONTOACTUAL)


    Y.INS.VALUES = ""
    Y.INS.VALUES := "1,'BPR',1,0,"
    Y.INS.VALUES := Y.TMPCREDITOCODIGOAGENCIA : "," : Y.TMPCREDITOCODIGOPRODUCTO : ","
    Y.INS.VALUES := Y.TMPCREDITONUMEROCONTRATO : "," : Y.TMPCREDITOCODIGOCLIENTE : "," : Y.TMPCREDITOCODIGOMONEDA : ","
    Y.INS.VALUES := Y.TMPCREDITONUMEROCONTRATOORIGEN : "," : "NULL" : "," : "1" : ","
    Y.INS.VALUES := Y.TMPCREDITODIASATRASO : "," : Y.TMPCREDITOCANTIDADCUOTASTOTAL : "," : Y.TMPCREDITOCUOTASCREADAS : ","
    Y.INS.VALUES := Y.TMPCREDITOCUOTASVENCIDAS : "," : Y.TMPCREDITOCUOTASPAGADAS : "," : Y.TMPCREDITOTIPOCUOTA : ","
    Y.INS.VALUES := Y.TMPCREDITOESTADOCONTRATO : "," : Y.TMPCREDITOFECHAINICIO : "," : Y.TMPCREDITOFECHAVCTO : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTOMENSUALIDAD : "," : Y.TMPCREDITOMONTOAPERTURA : "," : Y.TMPCREDITOMONTOCAPITALVIGENTE : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTOCAPITALMOROSO : "," : Y.TMPCREDITOMONTOCAPITALVENCIDO : "," : Y.TMPCREDITOMONTOINTERESMOROSO : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTOINTERESVIGENTE : "," : Y.TMPCREDITOMONTOINTERESVENCIDO : "," : Y.TMPCREDITOMONTOSEGUROVIDAVENCI : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTOSEGUROFISICOVEN : "," : Y.TMPCREDITOMONTOSEGUROVIDAVIGEN : "," : Y.TMPCREDITOMONTOSEGUROFISICOVIG : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTOVIGENTEOTROS : "," : Y.TMPCREDITOMONTOMOROSOOTROS : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTODEUDATOTAL : "," : Y.TMPCREDITOMONTOMOROSO : "," : Y.TMPCREDITOMONTOINTMORADIARIO : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTOINTCORRDIARIO : "," : Y.TMPCREDITOTASAINTERES : "," : Y.TMPCREDITOTASAMORAINTERES : ","
    Y.INS.VALUES := Y.TMPCREDITOCODIGOEJECUTIVO : "," : Y.TMPCREDITOFORMAPAGO : "," : Y.TMPCREDITOFECHAULTIMOPAGO : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTOULTIMOPAGO : "," : Y.TMPCREDITOFECHAPROXIMOPAGO : "," : Y.TMPCREDITOTIPOCALIFICACION : ","
    Y.INS.VALUES := Y.TMPCREDITOFECHAENTRADACOBRO : "," : Y.TMPCREDITOCOBROJUDICIAL : "," : Y.TMPCREDITOCODIGOVISTACREDITO : ","
    Y.INS.VALUES := Y.TMPCREDITOMORAMES01 : "," : Y.TMPCREDITOMORAMES02 : "," : Y.TMPCREDITOMORAMES03 : "," : Y.TMPCREDITOMORAMES04 : ","
    Y.INS.VALUES := Y.TMPCREDITOMORAMES05 : "," : Y.TMPCREDITOMORAMES06 : "," : Y.TMPCREDITOMORAMES07 : "," : Y.TMPCREDITOMORAMES08 : ","
    Y.INS.VALUES := Y.TMPCREDITOMORAMES09 : "," : Y.TMPCREDITOMORAMES10 : "," : Y.TMPCREDITOMORAMES11 : "," : Y.TMPCREDITOMORAMES12 : ","
    Y.INS.VALUES := Y.TMPCREDITOFACTORMONEDACONVERSI : "," : Y.TMPCREDITOCAMPO59 : "," : Y.TMPCREDITOCAMPO60 : ","
    Y.INS.VALUES := Y.TMPCREDITOGARANTIA : "," : Y.TMPCREDITOUBICACIONGARANTIA : "," : Y.TMPCREDITOVALORGARANTIA : ","
    Y.INS.VALUES := Y.TMPCREDITOMONTOACTUAL : "," : "1" : "," : redoOracleNull("'" : Y.CU.SCO.COB : "'")
    Y.INS.VALUES := ")"

    R.REDO.COL.QUEUE = Y.INS.STMT  : " " : Y.INS.VALUES
    Y.CREDIT<-1> = R.REDO.COL.QUEUE : @VM : Y.PRODUCT.GROUP

RETURN

*-----------------------------------------------------------------------------
PAYMENT.SCHEDULE.DETAILS:
*-----------------------------------------------------------------------------
    DUE.DATES = ''    ;* Holds the list of Schedule due dates
    DUE.TYPES = ''    ;* Holds the list of Payment Types for the above dates
    DUE.TYPE.AMTS = ''          ;* Holds the Payment Type amounts
    DUE.PROPS = ''    ;* Holds the Properties due for the above type
    DUE.PROP.AMTS = ''          ;* Holds the Property Amounts for the Properties above
    DUE.OUTS = ''     ;* Oustanding Bal for the date
    DUE.METHODS = ""
    TOT.PAYMENT = ''
    DATE.REQD = ''
    CYCLE.DATE = ''
    SIM.REF = ''

    Y.TMPCREDITOCANTIDADCUOTASTOTAL = 0
    Y.TMPCREDITOCUOTASCREADAS = 0
    Y.TMPCREDITOMONTOMENSUALIDAD = ""
    Y.MEN.FLAG = @FALSE         ;*PACS00169639

    CALL AA.SCHEDULE.PROJECTOR(AA.ID, SIM.REF, "",CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)  ;* Routine to Project complete schedules
    Y.TMPCREDITOCANTIDADCUOTASTOTAL = DCOUNT(DUE.DATES,@FM)

    IF Y.TMPCREDITOCANTIDADCUOTASTOTAL GT 0 THEN
        I.VAR = 1
        LOOP WHILE I.VAR LE Y.TMPCREDITOCANTIDADCUOTASTOTAL
            IF DUE.DATES<I.VAR> LE Y.PROCESS.DATE THEN
                Y.TMPCREDITOCUOTASCREADAS += 1
            END
            IF Y.MEN.FLAG EQ @FALSE AND DUE.DATES<I.VAR> GT Y.PROCESS.DATE THEN
                Y.TMPCREDITOMONTOMENSUALIDAD  = 0         ;* Could be we are running the enquiry after its maturity date, then there is no next payment
                DCNT = I.VAR
                TOT.PAY.TYPE = DCOUNT(DUE.TYPES<DCNT>,@VM)
                GOSUB GET.ALL.PAYMENTS.DETAIL
                Y.TMPCREDITOMONTOMENSUALIDAD = TOT.DUE.PAYM
                Y.TMPCREDITOFECHAPROXIMOPAGO =  DUE.DATES<DCNT>
                Y.MEN.FLAG = @TRUE    ;*PACS00169639
            END
            I.VAR += 1
        REPEAT
    END

RETURN
*------------------------------------------------------
GET.ALL.PAYMENTS.DETAIL:
*------------------------------------------------------
    PAY.CNT = 1
    LOOP WHILE PAY.CNT LE TOT.PAY.TYPE
        GOSUB GET.PAYMENT.DETAIL
        PAY.CNT += 1
    REPEAT
RETURN
*------------------------------------------------------
GET.PAYMENT.DETAIL:
*------------------------------------------------------
    PROP.LIST = DUE.PROPS<DCNT,PAY.CNT>
    PROP.LIST = RAISE(PROP.LIST)
    CALL AA.GET.PROPERTY.CLASS(PROP.LIST,PROP.CLS.LIST)
    TOT.PROP = DCOUNT(PROP.LIST,@VM)
    PROP.CNT = 1
    LOOP WHILE PROP.CNT LE TOT.PROP
        PROP.AMT = DUE.PROP.AMTS<DCNT,PAY.CNT,PROP.CNT>
        IF DUE.METHODS<DCNT,PAY.CNT> EQ 'DUE' THEN
            TOT.DUE.PAYM += PROP.AMT
        END
        PROP.CNT += 1
    REPEAT
RETURN
*** </region>
*------------------------------------------------------
GET.PERIOD.BALANCES:
*------------------------------------------------------
    Y.TMPCREDITOMONTOCAPITALVIGENTE = 0
    Y.AA.BALANCE.LIST = C.AA.PERIOD.BALANCES.TYPE
    Y.OUT.AA.AMOUNT.LIST = ""
    CALL APAP.REDOSRTN.REDO.S.GET.PERIOD.AMTS(Y.ACCOUNT.ID,Y.PROCESS.DATE, Y.PROCESS.DATE, Y.AA.BALANCE.LIST, Y.OUT.AA.AMOUNT.LIST);* R22 Manual conversion - CALL method format changed
    Y.TMPCREDITOMONTOCAPITALVIGENTE = Y.OUT.AA.AMOUNT.LIST<1,1>         ;* Current Outstanding - VIGENTE
    Y.TMPCREDITOMONTOCAPITALMOROSO = Y.OUT.AA.AMOUNT.LIST<2,1>          ;* Age Outstanding - MOROSO
    Y.TMPCREDITOMONTOCAPITALVENCIDO = Y.OUT.AA.AMOUNT.LIST<3,1>         ;* Due Outstanding - VENCIDO
    Y.TMPCREDITOMONTOINTERESMOROSO = Y.OUT.AA.AMOUNT.LIST<4,1>          ;* Age Interest    - MOROSO
    Y.TMPCREDITOMONTOINTERESVIGENTE = Y.OUT.AA.AMOUNT.LIST<5,1>         ;* Acc Interest    - VIGENTE
    Y.TMPCREDITOMONTOINTERESVENCIDO = Y.OUT.AA.AMOUNT.LIST<6,1>         ;* Due Interest    - VENCIDO
RETURN

*-----------------------------------------------------------------------------
* In AA.ARRANGEMENT, search by arrangement ID:
* 1. For every arrangement, fetch value from LINKED.APPL.ID field, 2. Go to EB.CONTRACT.BALANCES, and search by ID, using the value fetched in step 1,  3. Fetch absolute value from OPEN.BALANCE field from the multivalue set that starts in TYPE.SYSDATE field and ends in CURR.ASSET.TYPE field, when TYPE.SYSDATE field is equal to CURACCOUNT,* 4. Fetch absolute value from CREDIT.MVMT field and from the multivalue set that starts in TYPE.SYSDATE field and ends in CURR.ASSET.TYPE field, when TYPE.SYSDATE field contains CURACCOUNT,* 5. Fetch value from DEBIT.MVMT field from the multivalue set that starts in TYPE.SYSDATE field and ends in CURR.ASSET.TYPE field, when TYPE.SYSDATE field contains CURACCOUNT, which es closest to TODAY's date,* 6. Add values from step 3 and 4, substract the value from step 5, and add the value from TMPCREDITOMONTOMOROSO field for that arrangement, and display the total amount here.
GET.TOTAL.AMOUNT:
*-----------------------------------------------------------------------------
    Y.TYPE.SYSDATE = "CURACCOUNT"
    Y.TMPCREDITOMONTODEUDATOTAL = 0
    LOCATE Y.TYPE.SYSDATE IN R.EB.CONTRACT.BALANCES<ECB.TYPE.SYSDATE,1> SETTING Y.POS.VM THEN
        Y.TMPCREDITOMONTODEUDATOTAL = ABS(SUM(R.EB.CONTRACT.BALANCES<ECB.OPEN.BALANCE,Y.POS.VM>))
    END
    GOSUB GET.PENALTIES
    Y.TMPCREDITOMONTODEUDATOTAL =  Y.TMPCREDITOMONTODEUDATOTAL + ABS(Y.ECB.CREDIT.MVT) - Y.ECB.DEBIT.MVT + Y.TMPCREDITOMONTOMOROSO
RETURN

**-----------------------------------------------------------------------------
GET.PENALTIES:
*-----------------------------------------------------------------------------
    Y.PENALTY.AMOUNT = 0
    Y.TYPE.SYSDATE.LIST = R.EB.CONTRACT.BALANCES<ECB.TYPE.SYSDATE>
    Y.TOTAL = DCOUNT(Y.TYPE.SYSDATE.LIST, @VM)
    Y.ECB.CREDIT.MVT = 0
    Y.ECB.DEBIT.MVT = 0
    I.VAR = 1
    LOOP WHILE I.VAR LE Y.TOTAL
        Y.TYPE.SYSDATE.CURR = Y.TYPE.SYSDATE.LIST<1,I.VAR>
        IF Y.TYPE.SYSDATE.CURR["-",1,1] EQ Y.TYPE.SYSDATE THEN
            Y.DATE = Y.TYPE.SYSDATE.CURR["-",2,1]
            IF Y.DATE NE "" AND Y.DATE LE Y.PROCESS.DATE THEN
                Y.ECB.CREDIT.MVT = R.EB.CONTRACT.BALANCES<ECB.CREDIT.MVMT,I.VAR,1>
                Y.ECB.DEBIT.MVT = R.EB.CONTRACT.BALANCES<ECB.DEBIT.MVMT,I.VAR,1>
                Y.PENALTY.AMOUNT = R.EB.CONTRACT.BALANCES<ECB.CREDIT.MVMT,I.VAR,1> + R.EB.CONTRACT.BALANCES<ECB.DEBIT.MVMT,I.VAR,1>
            END
        END
        I.VAR += 1
    REPEAT
RETURN

*-----------------------------------------------------------------------------
GET.HISTORY.PAYMENT:
*-----------------------------------------------------------------------------

    Y.TOTAL.ACT = DCOUNT(AA.AH.EFFECTIVE.DATE,@VM)
    I.VAR = 1
    LOOP WHILE I.VAR LE Y.TOTAL.ACT
        Y.AH.ACTIVITY.TOTAL = DCOUNT(R.ACT.HIST<AA.AH.ACTIVITY,I.VAR>,@SM)
        Y.VAR = 1
        LOOP WHILE Y.VAR LE Y.AH.ACTIVITY.TOTAL
            Y.IS.AUTH = R.ACT.HIST<AA.AH.ACT.STATUS,I.VAR,Y.VAR> EQ "AUTH"
            Y.IS.PAY  = R.ACT.HIST<AA.AH.ACTIVITY,I.VAR,Y.VAR>["-",1,2] EQ "LENDING-APPLYPAYMENT"
            Y.IS.PAY  = Y.IS.PAY OR R.ACT.HIST<AA.AH.ACTIVITY,I.VAR,Y.VAR>["-",1,3] EQ "LENDING-CREDIT-ARRANGEMENT"
            Y.IS.PAY  = Y.IS.PAY OR R.ACT.HIST<AA.AH.ACTIVITY,I.VAR,Y.VAR>["-",1,3] EQ "LENDING-SETTLE-PAYOFF"
            GOSUB CHECK.HISTORY.PAYMENT
            Y.VAR += 1
        REPEAT
        I.VAR += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
CHECK.HISTORY.PAYMENT:
*-----------------------------------------------------------------------------
    IF Y.IS.AUTH AND Y.IS.PAY THEN
        Y.SYSTEM.DATE = R.ACT.HIST<AA.AH.SYSTEM.DATE,I.VAR,Y.VAR>
        Y.AMT         = R.ACT.HIST<AA.AH.ACTIVITY.AMT,I.VAR,Y.VAR>
        IF Y.SYSTEM.DATE LE Y.PROCESS.DATE THEN
            Y.TMPCREDITOFECHAULTIMOPAGO = Y.SYSTEM.DATE
            Y.TMPCREDITOMONTOULTIMOPAGO = Y.AMT
        END
    END
RETURN
*-----------------------------------------------------------------------------
PROCESS.ITEMS.DETAIL:
*-----------------------------------------------------------------------------
    P.PROCESS.ITEMS.DETAILS = ''
    CALL APAP.REDORETAIL.REDO.COL.EXTRACT.CREDIT.2("PROCESS.ITEMS.DETAIL", Y.ACCOUNT.ID, AA.ID, "", "", P.PROCESS.ITEMS.DETAILS) ;* MANUAL R22 CODE CONVERSION
    Y.TMPCREDITOMONTOSEGUROVIDAVIGEN = P.PROCESS.ITEMS.DETAILS<1>
    Y.TMPCREDITOMONTOSEGUROVIDAVENCI = P.PROCESS.ITEMS.DETAILS<2>
    Y.TMPCREDITOMONTOSEGUROFISICOVIG = P.PROCESS.ITEMS.DETAILS<3>
    Y.TMPCREDITOMONTOSEGUROFISICOVEN = P.PROCESS.ITEMS.DETAILS<4>
    Y.TMPCREDITOMONTOVIGENTEOTROS    = P.PROCESS.ITEMS.DETAILS<5>
    Y.TMPCREDITOMONTOMOROSOOTROS     = P.PROCESS.ITEMS.DETAILS<6>

RETURN
*----------------------------------------------------------------------------
CHECK.SELECTION.CRITERIA.AA:
* Check if the current AA "commits" with filter C.AA.STA... & C.AA.PRD... are initiliazed in REDO.COL.EXTRACT.LOAD
*----------------------------------------------------------------------------
    Y.CONTINUE.AA = @FALSE
    IF R.AA<AA.ARR.ARR.STATUS> MATCHES C.AA.STA.SELECTION THEN
        Y.CONTINUE.AA = R.AA<AA.ARR.PRODUCT.GROUP> MATCHES C.AA.PRD.SELECTION
    END

RETURN
*>>PACS00169639
*-----------------------------------------------------------------------------
TRACE.ERROR:
*-----------------------------------------------------------------------------
    CALL OCOMO(E)
    C.DESC = E ;   CALL TXT(C.DESC)
    C.DESC = C.DESC : "-" : AA.ID
    CALL APAP.TAM.REDO.R.COL.PROCESS.TRACE("EXTRACT", "20", Y.CONTADOR, "TMPCREDITO", Y.PRODUCT.GROUP, C.DESC);* R22 Manual conversion - CALL method format changed
    CALL APAP.TAM.REDO.R.COL.EXTRACT.ERROR(C.DESC, "REDO.COL.EXTRACT.CREDIT",P.TABLE);* R22 Manual conversion - CALL method format changed
    Y.PROCESS.FLAG.TABLE<1,5> = ""
    GOSUB STORE.MSG.ON.QUEUE
    PROCESS.GOAHEAD = 0
RETURN
*------------------------------------------------------------------------------
STORE.MSG.ON.QUEUE:
*------------------------------------------------------------------------------
    Y.MSG.QUEUE.ID = ''
    CALL ALLOCATE.UNIQUE.TIME(Y.MSG.QUEUE.ID)
    Y.MSG.QUEUE.ID = ID.COMPANY:'.':TODAY:'.':Y.MSG.QUEUE.ID
    R.REDO.COL.MSG.QUEUE = C.DESC
    WRITE R.REDO.COL.MSG.QUEUE TO F.REDO.COL.MSG.QUEUE, Y.MSG.QUEUE.ID ON ERROR CALL OCOMO("NO REGISTRO EL SUCESO" : C.DESC)

RETURN
*-----------------------------------------------------------------------------
END
