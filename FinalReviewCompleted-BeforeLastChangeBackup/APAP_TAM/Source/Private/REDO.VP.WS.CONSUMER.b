* @ValidationCode : MjotMTQ4NjcyNjY4NTpDcDEyNTI6MTcwMDQ4MDY2Mjg3NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Nov 2023 17:14:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
*-----------------------------------------------------------------------------
* Developer    :TAM Latin America
*
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 04.23.2013
* Description  : Consumer for Vision Plus WS - Online information
* Type         : Interface Routine
* Attached to  : -
* Dependencies : NA
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.23.2013     lpazmino       -                 Initial Version
* 13/06/2023      Santosh      R22 MANUAL CODE CONVERSION       Changed FUNCTION CALL into SUBROUTINE CALL
*20-11-2023       Santosh      Intrface Change comment added    Vision Plus-Interface Changes done by Santiago
*-----------------------------------------------------------------------------
* Input:
* ACTIVATION
* OnlineTransactionsService > 'VP_ONLINE_TXN_SERVICE'
* WsT24VplusService         > 'WS_T24_VPLUS'
* VPlusMasterDataBean  > 'VP_MASTER_DATA'
*
* WS.DATA
*
* OnlineTransactionsService Data Definition
* =========================================
*** <region name= WSInfo>
*** <desc>WSInfo </desc>

* Service > "OnlineInformation"
* Request
* -------
* WS.DATA<1> = 'ONLINE_INFO'
* WS.DATA<2> = CardNumber
* WS.DATA<3> = OrgId
* WS.DATA<4> = MerchantNumber
*
* Response
* --------
* WS.DATA<1> = "OK/ERROR"
* WS.DATA<2> = AvailableCredit
* WS.DATA<3> = AmountMemoCredit
* WS.DATA<4> = AccountCurrentBalance
* WS.DATA<5> = AmountMemoDebit
*
* Service > "OnlinePayment" LISTO******
* Request
* -------
* WS.DATA<1>  = 'ONLINE_PAYMENT'
* WS.DATA<2>  = POSUserData
* WS.DATA<3>  = RequestType
* WS.DATA<4>  = CardNumber
* WS.DATA<5>  = OrgId
* WS.DATA<6>  = MerchantNumber
* WS.DATA<7>  = CardExpirationDate
* WS.DATA<8>  = TotalSalesAmount
* WS.DATA<9>  = Track2length
* WS.DATA<10> = Track2Data
* WS.DATA<11> = CardValidationValue
*
* Response
* --------
*200^Success^Pago|A|0|APPROVED|P|C04731
* WS.DATA<1> = "OK/ERROR"
* WS.DATA<2>  = POSUserData             <POSUserData>Pago</POSUserData>
* WS.DATA<3>  = SystemAction            <SystemAction>A</SystemAction>
* WS.DATA<4>  = CardValidationResult    <CardValidationResult>P</CardValidationResult>
* WS.DATA<5>  = AuthorizationCode       <AuthorizationCode>C04730</AuthorizationCode>
*
* WsT24VplusService Data Definition
* =========================================
*
* Service > CONSOLIDADO_X_CLIENTE
* Request
* -------
* WS.DATA<1> = 'CONSOLIDADO_X_CLIENTE'
* WS.DATA<2> = numeroCliente
*
* Response
* --------
* WS.DATA<1>  = 'OK/ERROR'
* WS.DATA<2>  = Tipo_producto/Error Desciption
* WS.DATA<3>  = NUMERO_CUENTA
* WS.DATA<4>  = Numero_Plastico
* WS.DATA<5>  = FECHA_APERTURA
* WS.DATA<6>  = FECHA_ULT_PAGO
* WS.DATA<7>  = Balance_total_RD
* WS.DATA<8>  = Balance_Total_US
* WS.DATA<9>  = Balance_DisponibleRD
* WS.DATA<10> = Balance_DisponibleUS
*
* Service > CONSULTA_ESTADO_X_RANGO
* Request
* -------
* WS.DATA<1> = 'CONSULTA_ESTADO_X_RANGO'
* WS.DATA<2> = NumeroTarjeta
* WS.DATA<3> = moneda
* WS.DATA<4> = Mes_est_cta
* WS.DATA<5> = Ano_est_cta
*
* Response
* --------
*
*
* Service > CONSULTA_TC_X_CLIENTE
* Request
* -------
* WS.DATA<1> = 'CONSULTA_TC_X_CLIENTE'
* WS.DATA<2> = numeroCliente
*
* Response
* --------
*
* Service > CONSULTA_BALANCE
* Request
* -------
* WS.DATA<1> = 'CONSULTA_BALANCE'
* WS.DATA<2> = numeroTarjeta
*
* Response
* --------
* WS.DATA<1> = 'OK/ERROR'
* WS.DATA<2> = Pv_NumeroTarjeta
* WS.DATA<3> = Pv_NumeroCuenta
* WS.DATA<4> = Pn_balanceCorteRD
* WS.DATA<5> = Pn_balanceCorteUS
* WS.DATA<6> = Pn_pago_minimoRD
* WS.DATA<7> = Pn_pago_minimoUS
* WS.DATA<8> = Pd_Fecha_de_pago
* WS.DATA<9> = Estado_tarjeta
* WS.DATA<10> = Estado_cuenta
* WS.DATA<11> = Pv_Titular
* WS.DATA<12> = Pi_Codigo_Cliente
* WS.DATA<13> = Pv_NumeroDocumento
* WS.DATA<14> = Pv_DescripcionDocumento
* WS.DATA<15> = Pv_Tipo_Tarjeta
* WS.DATA<16> = Pn_limite_de_creditoRD
* WS.DATA<17> = Pn_limite_de_creditoUS
* WS.DATA<18> = Pn_Saldo_AnteriorRD
* WS.DATA<19> = Pn_Saldo_AnteriorUS
* WS.DATA<20> = Pn_monto_ultimo_pagoRD
* WS.DATA<21> = Pn_monto_ultimo_pagoUS
* WS.DATA<22> = Pd_Fecha_ultimo_pagoRD
* WS.DATA<23> = Pd_Fecha_ultimo_pagoUS
* WS.DATA<24> = Pn_Cuotas_VencidasRD
* WS.DATA<25> = Pn_Cuotas_VencidasUS
* WS.DATA<26> = Pn_Importe_VencidoRD
* WS.DATA<27> = Pn_Importe_VencidoUS
* WS.DATA<28> = Pn_Saldo_ActualRD
* WS.DATA<29> = Pn_Saldo_ActualUS
* WS.DATA<30> = Pn_credito_disponibleRD
* WS.DATA<31> = Pn_credito_disponibleUS
* WS.DATA<32> = Pn_SobregiroRD
* WS.DATA<33> = Pn_SobregiroUS
* WS.DATA<34> = Pd_fecha_ult_estcta
* WS.DATA<35> = ID_Comportamiento
*
* Service > CONSULTA_MOVIMIENTOS_X_RANGO
* Request
* -------
* WS.DATA<1> = 'CONSULTA_MOVIMIENTOS_X_RANGO'
* WS.DATA<2> = Pv_NumeroTarjeta
* WS.DATA<3> = Pd_fecha_desde (YYYYMMDD)
* WS.DATA<4> = Pd_fecha_hasta (YYYYMMDD)
* WS.DATA<5> = Pv_Filtro
* WS.DATA<6> = Pv_Moneda
*
* Response
* --------
*
* Service > CONSULTA_SALDOS
* Request
* -------
* WS.DATA<1> = 'CONSULTA_SALDOS'
* WS.DATA<2> = numeroTc
*
* Response
* --------
*
* Service > CONSULTA_TRANSITO
* Request
* -------
* WS.DATA<1> = 'CONSULTA_TRANSITO'
* WS.DATA<2> = numeroTc
*
* Response
* --------
*
* Service > LIMITE_CREDITO
* Request
* -------
* WS.DATA<1> = 'LIMITE_CREDITO'
* WS.DATA<2> = customer
*
* Service > RIESGO_INTERESES
* Request
* -------
* WS.DATA<1> = 'RIESGO_INTERESES'
* WS.DATA<2> = customer
*
* Response
* --------
*
* Service > STATUS_TARJETA_CLIENTE
* Request
* -------
* WS.DATA<1> = 'STATUS_TARJETA_CLIENTE'
* WS.DATA<2> = pT24CustomerID
*
*
* VPlusMasterDataBean Data Definition
* =========================================
*
* Service > "nMonetaryDataHandler"
* Request
* -------
* WS.DATA<1> = 'VP_MASTER_DATA'
*-----------------------------------------------------------------------------

*** </region>

*   $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT JBC.h
    $USING APAP.REDOSRTN
    $USING EB.SystemTables ;*Interface Changes done by Santiago

*SJ start - Interface Changes done by Santiago
    $INSERT I_F.DFE.TRANSFORM
    $INSERT I_F.REDO.VISION.PLUS.WS
*SJ end - Interface Changes done by Santiago
    EQUATE WS_MASTER_DATA TO 'VP_MASTER_DATA'
    EQUATE WS_ONLINE_PAYMENT TO 'ONLINE_PAYMENT'
    EQUATE WS_ONLINE_INFO TO 'ONLINE_INFO'
    EQUATE WS_T24_VPLUS TO 'WS_T24_VPLUS'


*   DEFFUN REDO.S.GET.USR.ERR.MSG() ;*R22 Manual Code Conersion

* </region>
    
    GOSUB INIT
    IF Y.FLAG.WS EQ 0 THEN ;*Interface Changes done by Santiago
        GOSUB PROCESS
    END

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
* Set WS/WS method being called, for error checking purpose
    Y.FLAG.WS = 0
    FN.DFE.TRANSFORM = 'F.DFE.TRANSFORM'
    F.DFE.TRANSFORM = ''
    CALL OPF(FN.DFE.TRANSFORM,F.DFE.TRANSFORM)
    
    IF WS.DATA<1> EQ WS_ONLINE_PAYMENT THEN
        Y.WS = WS.DATA<1>       ;* Y.WS = 'ONLINE_PAYMENT'
    END ELSE
        Y.WS = ACTIVATION
    END
*Interface Changes done by Santiago- Start

    BEGIN CASE
        CASE WS.DATA<1> EQ 'CONSULTA_BALANCE'
            Y.ID.DFE.TRANSFORM = 'REDO.VP.CONSULTA.BALANCE'
            R.TARJETA<AP.VP.NUM.TARJETA> =  WS.DATA<2>
            R.TARJETA<AP.VP.CANAL> = WS.DATA<3>
            GOSUB GET.WS.DATA
            
        CASE WS.DATA<1> EQ 'CONSULTA_ESTADO_X_RANGO'
            Y.ID.DFE.TRANSFORM = 'REDO.VP.CONSULTA.ESTADO'  ;* there is not any routine that use this method
            R.TARJETA<AP.VP.NUM.TARJETA> =  WS.DATA<2>
            R.TARJETA<AP.VP.MONEDA> = WS.DATA<3>
            R.TARJETA<AP.VP.MES> = WS.DATA<4>
            R.TARJETA<AP.VP.ANO> = WS.DATA<5>
            GOSUB GET.WS.DATA
            
        CASE WS.DATA<1> EQ 'ONLINE_PAYMENT'
            Y.ID.DFE.TRANSFORM = 'ONLINE_PAYMENT'
            GOSUB GET.JAVA.DATA
    END CASE
    
RETURN

GET.WS.DATA:
    ID.NEW = EB.SystemTables.getIdNew() ;*R22 Manual Code Conersion - After Interface Change
    Y.ID.TEMP = ID.NEW
    ID.NEW = Y.ID.DFE.TRANSFORM
    
    CALL DFE.ONLINE.TRANSACTION(Y.ID.DFE.TRANSFORM, R.TARJETA, WS.DATA)
    ID.NEW = Y.ID.TEMP
    
    IF WS.DATA EQ 'ERROR' OR WS.DATA EQ '' THEN
        pErrCode = 'ST-VP-NO.WS.AVAIL'
        APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg)
        WS.DATA<2> = '(-99) - ' : pUsrMsg
        OPERATOR = EB.SystemTables.getOperator() ;*R22 Manual Code Conersion - After Interface Change
        APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA - ' : WS.DATA<2>, 'TIMEOUT EN TRANSACCION EN LINEA ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '')
 
        Y.FLAG.WS = 1
        WS.DATA<1> = 'ERROR'
        ERROR.CODE = Y.ID.DFE.TRANSFORM
*       ETEXT= "EB-JAVACOMP":@FM:ERROR.CODE ;*R22 Manual Code Conersion - After Interface Change
        ETEXT = EB.SystemTables.setEtext("EB-JAVACOMP":@FM:ERROR.CODE)
        CALL STORE.END.ERROR
    END
    
RETURN

GET.JAVA.DATA:
    
    POSUserData = WS.DATA<2>
    MCCType = WS.DATA<3>
    RequestType = WS.DATA<4>
    CardNumber = WS.DATA<5>
    OrgId = WS.DATA<6>
    MerchantNumber = WS.DATA<7>
    CardExpirationDate = WS.DATA<8>
    TotalSalesAmount = WS.DATA<9>
    Track2Length = WS.DATA<10>
    Track2Data = WS.DATA<11>
    CardValidationValue = WS.DATA<12>
      
    param = POSUserData : '^' :MCCType:'^': RequestType:'^': CardNumber:'^': OrgId:'^': MerchantNumber:'^': CardExpirationDate :'^':TotalSalesAmount :'^':Track2Length :'^':Track2Data:'^': CardValidationValue
 
    EB.SystemTables.CallJavaApi('REDO.VISION.PLUS.ONLINE', param, CalljResponse, CalljError)

*CalljResponse:
*    error     = 0^null^null|null|null|null|null|null
*    success   = 200^Success^Pago |A|0|APPROVED  |P|C04731
*    wrongCard = 200^Success^Pago |D|900|DECLINED  |P|303970
*    revers    = 200^Success^Pago |A|0|APPROVED  |P|
    
    IF CalljError NE '' THEN
        WS.DATA<1> = 'ERROR'
        ERROR.CODE = CalljError
    END ELSE
        Y.RESP = FIELD(CalljResponse,'^',3)
        WS.DATA<1> = 'OK'
        WS.DATA<2> = TRIM(FIELD(Y.RESP,'|',1))  ;* POSUserData
        WS.DATA<3> = TRIM(FIELD(Y.RESP,'|',2))  ;* SystemAction
        WS.DATA<4> = TRIM(FIELD(Y.RESP,'|',5))  ;* CardValidationResult
        WS.DATA<5> = TRIM(FIELD(Y.RESP,'|',6))  ;* AuthorizationCode
    END
RETURN
*Interface Changes done by Santiago- End

**************
* Main Process
PROCESS:
**************
    
* ERROR.CODE = 0 > Action Completed Successfully

*   ERROR.CODE = CALLJEE(ACTIVATION,WS.DATA)    ;* SJ - Interface Changes done by Santiago

    IF ERROR.CODE OR (Y.WS EQ WS_ONLINE_PAYMENT AND WS.DATA<1> NE 'OK') THEN    ;* ONLINE_PAYMENT retorna 0 aunque hubo 'ERROR'
        ERR.ID = '(' : ERROR.CODE : ') - '

* Error handling for VP_ONLINE_TXN_SERVICE>ONLINE_PAYMENT
* [0] ERROR.CODE
* [1] [OK] [ERROR] [OFFLINE]
* [2] REASON.ACTION.CODE : ' - ' : DESCRIPTION
        IF Y.WS EQ WS_ONLINE_PAYMENT THEN
            GOSUB ONLINE.PAY.ERR.CHECK
        END

* Error handling for VP_ONLINE_TXN_SERVICE>ONLINE_INFO
* [0] ERROR.CODE
* [1] [OK] [ERROR]
* [2] REASON.ACTION.CODE : ' - ' : DESCRIPTION
        IF Y.WS EQ WS_ONLINE_INFO THEN
            GOSUB ONLINE.INFO.ERR.CHECK
        END

* Error handling for VP_MASTER_DATA
* [0] ERROR.CODE
* [1] RESULT
        IF Y.WS EQ WS_MASTER_DATA  THEN
            GOSUB MASTER.DATA.ERR.CHECK
        END

* Error handling for WS_T24_VPLUS and VP_ONLINE_TXN_SERVICE>ONLINE_INFO
* [0] ERROR.CODE
* [1] [OK] [ERROR]
* [2] RESULT
        IF Y.WS EQ WS_T24_VPLUS THEN
            GOSUB GENERAL.ERR.CHECK
        END
    END
*Interface Changes done by Santiago - Start
RETURN

ONLINE.PAY.ERR.CHECK:
    BEGIN CASE
        CASE ERROR.CODE EQ -1
            WS.DATA<1> = 'ERROR'
            pErrCode = 'EB-CARD.NO.EXIST'
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg)
            WS.DATA<2> = ERR.ID : pUsrMsg
            
        CASE ERROR.CODE MATCHES -2 : @VM : -3
            WS.DATA<1> = 'ERROR'
            pErrCode = 'ST-VP-MSG.' : ERROR.CODE
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg)
            WS.DATA<2> = ERR.ID : pUsrMsg
            
        CASE 1
            WS.DATA<1> = 'OFFLINE'
            pErrCode = 'ST-VP-MSG.-99'
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg)
            WS.DATA<2> = '(-99) - ' : pUsrMsg
*           CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL003', 'ONLINE', '04', 'Email RESPUESTA DE WEBSERVICE [' : WS.DATA<1> : '] - ' : WS.DATA<2>, ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')
            OPERATOR = EB.SystemTables.getOperator() ;*R22 Manual Code Conersion - After Interface Change
            APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL003', 'ONLINE', '04', 'Email RESPUESTA DE WEBSERVICE [' : WS.DATA<1> : '] - ' : WS.DATA<2>, ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '') ;*R22 Manual Code Conersion
    END CASE
*Interface Changes done by Santiago- End
RETURN

ONLINE.INFO.ERR.CHECK:
    BEGIN CASE
        CASE ERROR.CODE EQ -1
            WS.DATA<1> = 'ERROR'
*           WS.DATA<2> = ERR.ID : REDO.S.GET.USR.ERR.MSG('EB-CARD.NO.EXIST')
            pErrCode = 'EB-CARD.NO.EXIST' ;*R22 Manual Code Conersion
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg) ;*R22 Manual Code Conersion
            WS.DATA<2> = ERR.ID : pUsrMsg ;*R22 Manual Code Conersion
        CASE ERROR.CODE MATCHES -2 : @VM : -3
            WS.DATA<1> = 'ERROR'
*           WS.DATA<2> = ERR.ID : REDO.S.GET.USR.ERR.MSG('ST-VP-MSG.' : ERROR.CODE)
            pErrCode = 'ST-VP-MSG.' : ERROR.CODE ;*R22 Manual Code Conersion
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg) ;*R22 Manual Code Conersion
            WS.DATA<2> = ERR.ID : pUsrMsg ;*R22 Manual Code Conersion
    END CASE

RETURN

MASTER.DATA.ERR.CHECK:
    WS.DATA<1> = 'ERROR'
*   WS.DATA<2> = ERR.ID : REDO.S.GET.USR.ERR.MSG('ST-VP-NO.INSERT.MD')
   
    pErrCode = 'ST-VP-NO.INSERT.MD' ;*R22 Manual Code Conersion
    APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg) ;*R22 Manual Code Conersion
    WS.DATA<2> = ERR.ID : pUsrMsg  ;*R22 Manual Code Conersion

RETURN

GENERAL.ERR.CHECK:
    BEGIN CASE
        CASE ERROR.CODE MATCHES 1 : @VM : 2 : @VM : 4 : @VM : 101 : @VM : 102
            WS.DATA<1> = 'ERROR'
*           WS.DATA<2> = ERR.ID : REDO.S.GET.USR.ERR.MSG('ST-VP-MSG.' : ERROR.CODE)
            
            pErrCode = 'ST-VP-MSG.' : ERROR.CODE ;*R22 Manual Code Conersion
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg) ;*R22 Manual Code Conersion
            WS.DATA<2> = ERR.ID : pUsrMsg ;*R22 Manual Code Conersion
* Log writing: abnormal error that must be notified
*           CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'ERROR EN TRANSACCION EN LINEA ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')
            OPERATOR = EB.SystemTables.getOperator() ;*R22 Manual Code Conersion - After Interface Change
            APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'ERROR EN TRANSACCION EN LINEA ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '') ;*R22 Manual Code Conersion
        CASE 1
            WS.DATA<1> = 'ERROR'  ;* y se devuelve el error
*           WS.DATA<2> = '(-99) - ' : REDO.S.GET.USR.ERR.MSG('ST-VP-MSG.-99')
            pErrCode = 'ST-VP-MSG.-99' ;*R22 Manual Code Conersion
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg) ;*R22 Manual Code Conersion
            WS.DATA<2> = '(-99) - ' : pUsrMsg ;*R22 Manual Code Conersion
* S - 4/03/2015 - RM - Adding logic to report to C.22 in case of error code unknown returned by WS.
*           CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'ERROR EN TRANSACCION EN LINEA ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')
            OPERATOR = EB.SystemTables.getOperator() ;*R22 Manual Code Conersion - After Interface Change
            APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'ERROR EN TRANSACCION EN LINEA ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '') ;*R22 Manual Code Conersion
* E - 4/03/2015 - RM
    END CASE

RETURN

* </region>

END
