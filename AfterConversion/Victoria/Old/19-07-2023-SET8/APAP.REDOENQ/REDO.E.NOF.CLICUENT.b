$PACKAGE APAP.REDOENQ
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   VARIABLE NAME MODIFIED
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.E.NOF.CLICUENT(CU.DET.ARR)
*
* Subroutine Type : ENQUIRY ROUTINE
* Attached to     : REDO.CLIENTE.CUENTA
* Attached as     : NOFILE ROUTINE
* Primary Purpose : To return data to the enquiry
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* CU.DET.ARR - data returned to the enquiry
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : Agosto 03, 2010
*
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.ACCOUNT ;*R22 MANUAL CONVERSION
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

*
* Y.ENQ.NAME = ENQ.SELECTION<1,1>

*  Recupera los valores de los parametros de entrada


    LOCATE 'CUSTOMER.CODE' IN D.FIELDS<1> SETTING Y.CUS.CODE.POS ELSE Y.CUS.CODE.POS = ''
    Y.CUS.CODE = D.RANGE.AND.VALUE<Y.CUS.CODE.POS>

    LOCATE 'ACCOUNT.NUMBER' IN D.FIELDS<1> SETTING Y.ACC.NRO.POS ELSE Y.ACC.NRO.POS = ''
    Y.ACC.NRO = D.RANGE.AND.VALUE<Y.ACC.NRO.POS>

    IF Y.CUS.CODE AND NOT(Y.ACC.NRO) THEN
        ENQ.ERROR<-1>="VERIFIQUE EL CRITERIO DE SELECION"
        RETURN
    END
    IF Y.CUS.CODE THEN
* Buscar la cuenta en CUSTOMER.ACCOUNT
        CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUS.CODE,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,"")
        IF NOT(R.CUSTOMER.ACCOUNT) THEN
            ENQ.ERROR<-1>="El cliente NO tiene cuentas"
            RETURN
        END
*    LOCATE Y.ACC.NRO IN R.CUSTOMER.ACCOUNT<1> SETTING Y.ACC.POS THEN
*    Tus Start
        LOCATE Y.ACC.NRO IN R.CUSTOMER.ACCOUNT<EB.CAC.ACCOUNT.NUMBER> SETTING Y.ACC.POS THEN
*    Tus End
            CU.DET.ARR <-1> = Y.CUS.CODE:"*":R.CUSTOMER.ACCOUNT<Y.ACC.POS>
        END

    END ELSE
* Buscar el cliente en ACCOUNT
        CALL F.READ(FN.ACCOUNT,Y.ACC.NRO,R.ACCOUNT,F.ACCOUNT,"")
        IF NOT(R.ACCOUNT) THEN
            ENQ.ERROR<-1>="El cliente NO tiene cuentas"
            RETURN
        END

        CU.DET.ARR <-1> = R.ACCOUNT<AC.CUSTOMER>:"*":Y.ACC.NRO

    END

RETURN  ;* from PROCESS
*-----------------------------------------------------------------------------------
* <New Subroutines>


* </New Subroutines>
*-----------------------------------------------------------------------------------*
INITIALISE:
*=========
* Variables


* Punteros

    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'

    F.ACCOUNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'

    PROCESS.GOAHEAD = 1

RETURN  ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN  ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*======================

RETURN  ;* From CHECK.PRELIM.CONDITIONS
*-----------------------------------------------------------------------------------
END
