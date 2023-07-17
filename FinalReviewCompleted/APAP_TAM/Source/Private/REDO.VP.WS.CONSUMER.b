* @ValidationCode : Mjo1NjUxNTY1MjY6Q3AxMjUyOjE2ODY2NzcwOTc4NjI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:54:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
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
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
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
*
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
* Service > "OnlinePayment"
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
* WS.DATA<1> = "OK/ERROR"
* WS.DATA<2>  = POSUserData
* WS.DATA<3>  = SystemAction
* WS.DATA<4>  = CardValidationResult
* WS.DATA<5>  = AuthorizationCode
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

* <region name="INCLUDES">

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT JBC.h
    $USING APAP.REDOSRTN

    EQUATE WS_MASTER_DATA TO 'VP_MASTER_DATA'
    EQUATE WS_ONLINE_PAYMENT TO 'ONLINE_PAYMENT'
    EQUATE WS_ONLINE_INFO TO 'ONLINE_INFO'
    EQUATE WS_T24_VPLUS TO 'WS_T24_VPLUS'

*   DEFFUN REDO.S.GET.USR.ERR.MSG() ;*R22 Manual Code Conersion

* </region>
    GOSUB INIT
    GOSUB PROCESS

RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************

* Set WS/WS method being called, for error checking purpose
    IF WS.DATA<1> EQ WS_ONLINE_PAYMENT THEN
        Y.WS = WS.DATA<1>
    END ELSE
        Y.WS = ACTIVATION
    END

* Obtain session vars for CALJEE execution

* Default environment. Should be properly changed
    IF NOT(GETENV("JREMOTE_INBOUND_HOST",JREMOTE_INBOUND_HOST)) THEN
        CRT "JREMOTE_INBOUND_HOST NOT FOUND !!! USING DEFAULT VALUE 127.0.0.1 INSTEAD"
        HOST.SET = PUTENV("JREMOTE_INBOUND_HOST=127.0.0.1")
    END

    IF NOT(GETENV("JREMOTE_INBOUND_PORT",JREMOTE_INBOUND_PORT)) THEN
        CRT "JREMOTE_INBOUND_PORT NOT FOUND !!! USING DEFAULT VALUE 55006 INSTEAD"
        PORT.SET = PUTENV("JREMOTE_INBOUND_PORT=55006")
    END

*       IF GETENV("JEE_HOSTS",PROFILE.JEE.HOSTS) THEN
*            JEE.HOSTS = PROFILE.JEE.HOSTS
*        END

*        IF GETENV("JEE_PORTS",PROFILE.JEE.PORTS) THEN
*            JEE.PORTS = PROFILE.JEE.PORTS
*        END

*        HOST.FLAG = PUTENV('JEE_HOSTS=':JEE.HOSTS)
*        PORT.FLAG = PUTENV('JEE_PORTS=':JEE.PORTS)

    CRT "VISION PLUS JREMOTE_INBOUND_HOST : (" : JREMOTE_INBOUND_HOST : ') '
    CRT "VISION PLUS JREMOTE_INBOUND_PORT : (" : JREMOTE_INBOUND_PORT : ') '

RETURN

**************
* Main Process
PROCESS:
**************

* ERROR.CODE = 0 > Action Completed Successfully
*DEBUG
    ERROR.CODE = CALLJEE(ACTIVATION,WS.DATA)
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

    IF NOT(ERROR.CODE) AND NOT(WS.DATA<1>) THEN
        WS.DATA<1> = 'ERROR'
*        WS.DATA<2> = '(-99) - ' : REDO.S.GET.USR.ERR.MSG('ST-VP-NO.WS.AVAIL')   ;* Probablemente por TimeOut
        pErrCode = 'ST-VP-NO.WS.AVAIL' ;*R22 Manual Code Conersion
        APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg) ;*R22 Manual Code Conersion
        WS.DATA<2> = '(-99) - ' : pUsrMsg  ;*R22 Manual Code Conersion
* Log writing: abnormal error that must be notified
*       CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA - ' : WS.DATA<2>, 'TIMEOUT EN TRANSACCION EN LINEA ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '')
        APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA - ' : WS.DATA<2>, 'TIMEOUT EN TRANSACCION EN LINEA ' : TIMEDATE(), '', '', '', '', '', OPERATOR, '') ;*R22 Manual Code Conersion
    END

RETURN

ONLINE.PAY.ERR.CHECK:
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
            
        CASE 1
            WS.DATA<1> = 'OFFLINE'
*           WS.DATA<2> = '(-99) - ' : REDO.S.GET.USR.ERR.MSG('ST-VP-MSG.-99')
            pErrCode = 'ST-VP-MSG.-99' ;*R22 Manual Code Conersion
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg) ;*R22 Manual Code Conersion
            WS.DATA<2> = '(-99) - ' : pUsrMsg ;*R22 Manual Code Conersion
*           CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL003', 'ONLINE', '04', 'Email RESPUESTA DE WEBSERVICE [' : WS.DATA<1> : '] - ' : WS.DATA<2>, ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')
            APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL003', 'ONLINE', '04', 'Email RESPUESTA DE WEBSERVICE [' : WS.DATA<1> : '] - ' : WS.DATA<2>, ' ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '') ;*R22 Manual Code Conersion
    END CASE

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
            APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'ERROR EN TRANSACCION EN LINEA ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '') ;*R22 Manual Code Conersion
        CASE 1
            WS.DATA<1> = 'ERROR'  ;* y se devuelve el error
*           WS.DATA<2> = '(-99) - ' : REDO.S.GET.USR.ERR.MSG('ST-VP-MSG.-99')
            pErrCode = 'ST-VP-MSG.-99' ;*R22 Manual Code Conersion
            APAP.REDOSRTN.redoSGetUsrErrMsg(pErrCode, pUsrMsg) ;*R22 Manual Code Conersion
            WS.DATA<2> = '(-99) - ' : pUsrMsg ;*R22 Manual Code Conersion
* S - 4/03/2015 - RM - Adding logic to report to C.22 in case of error code unknown returned by WS.
*           CALL REDO.S.NOTIFY.INTERFACE.ACT('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'ERROR EN TRANSACCION EN LINEA ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '')
            APAP.REDOSRTN.redoSNotifyInterfaceAct('VPL008', 'ONLINE', '04', 'Email ERROR WS EN LINEA [' : WS.DATA<1> : '] - ' : WS.DATA<2>, 'ERROR EN TRANSACCION EN LINEA ' : TIMEDATE() : ' - LOG EN Jboss : server.log', '', '', '', '', '', OPERATOR, '') ;*R22 Manual Code Conersion
* E - 4/03/2015 - RM
    END CASE

RETURN

* </region>

END
