*-----------------------------------------------------------------------------
* <Rating>-86</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.GET.CCARD.DETAILS.VP(DETAIL.RECORD)

*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for obtaining Credit Card Information
* Type         : NOFILE Routine
* Attached to  : ENQUIRY > AI.REDO.CCARD.DETAILS.CHANGE
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
*-----------------------------------------------------------------------------

* <region name="INSERTS">

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.CUSTOMER

$INSERT I_System
$INSERT I_ENQUIRY.COMMON

* </region>

  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
  Y.CHANNEL = ''
  Y.MON.CHANNEL = ''

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  R.CUSTOMER = ''
  Y.ERR = ''

  VP.CUST.LIST = ''
  VP.CUST.LIST.NAME = ''
  VP.CUST.SELECTED = ''
  SYSTEM.RETURN.CODE = ''

  CREDIT.CARD.ID = System.getVariable('CURRENT.CARD.ID')
 

  IF NUM(CREDIT.CARD.ID) ELSE
    SLEEP 2
    CREDIT.CARD.ID = System.getVariable('CURRENT.CARD.ID')
  END

  CREDIT.CARD.ID = FMT(CREDIT.CARD.ID, 'R%19')

  RETURN

***********************
* Open Files
OPEN.FILES:
***********************

  RETURN

***********************
* Main Process
PROCESS:
***********************
  IF CREDIT.CARD.ID MATCHES "...CURRENT.CARD.ID..." NE 1 THEN
    GOSUB INVOKE.VP.WS.CB
  END

  RETURN

**************************************************
* Invoke VP Web Service 'CONSULTA_BALANCE'
INVOKE.VP.WS.CB:
**************************************************
  ACTIVATION = 'WS_T24_VPLUS'

  WS.DATA = ''
  WS.DATA<1> = 'CONSULTA_SALDOS'
  WS.DATA<2> = CREDIT.CARD.ID
  WS.DATA<3> = 'ITB'

* Invoke VisionPlus Web Service
  CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)

* Credit Card exits - Info obtained OK
  IF WS.DATA<1> EQ 'OK' THEN
    GOSUB GET.CUSTOMER.DATA
  END ELSE
* 'ERROR/OFFLINE'
    ENQ.ERROR<1> = WS.DATA<2>
  END

  RETURN

*----------------*
GET.CUSTOMER.DATA:
*----------------*

  IF NOT (ENQ.ERROR<1>) THEN
    CCARD.DATA = ''

* Credit Card Account
    CCARD.DATA<1> = TRIM(CREDIT.CARD.ID,'0','L')

* Card Type
    CCARD.DATA<2> = WS.DATA<29>

* Card Holder
    CCARD.DATA<3> = WS.DATA<30>

* Credit Limit USD
    CCARD.DATA<4> = WS.DATA<15>

* Credit Limit
    CCARD.DATA<5> = WS.DATA<14>

* Fecha Vencimiento (TODO Confirmar!!)
    CCARD.DATA<6> = WS.DATA<3>

* Card Status
    CCARD.DATA<7> = WS.DATA<26>

* TODO Add. Card

    CCARD.DATA<8> = WS.DATA<31>

* Agency Code

    CCARD.DATA<9> = WS.DATA<32>

    CCARD.DATA<10> = System.getVariable('EXT.CUSTOMER')
    
* Prev Bal USD
    CCARD.DATA<11> = WS.DATA<23>

* Prev Bal DOP
    CCARD.DATA<12> = WS.DATA<22>

* Fecha Ult Corte (Ult Estado Cta)
    CCARD.DATA<13> = WS.DATA<4>

* Fecha Limite Pago
    CCARD.DATA<14> = WS.DATA<3>

* Min. Payment USD
    CCARD.DATA<15> = WS.DATA<19>

* Min. Payment DOP
    CCARD.DATA<16> = WS.DATA<18>

* Last Payment USD
    CCARD.DATA<17> = WS.DATA<17>

* Last Payment DOP
    CCARD.DATA<18> = WS.DATA<16>

* Last Payment Date USD
    CCARD.DATA<19> = WS.DATA<6>

* Last Payment Date DOP
    CCARD.DATA<20> = WS.DATA<5>

* Cuotas Vencidas USD
    CCARD.DATA<21> = WS.DATA<10>

* Cuotas Vencidas DOP
    CCARD.DATA<22> = WS.DATA<9>

* Due Amt (Importe) USD
    CCARD.DATA<23> = WS.DATA<13>

* Due Amt (Importe) DOP
    CCARD.DATA<24> = WS.DATA<12>

* Current Bal USD
    CCARD.DATA<25> = WS.DATA<21>

* Current Bal DOP
    CCARD.DATA<26> = WS.DATA<20>

* Available Bal USD
    CCARD.DATA<27> = WS.DATA<8>

* Avaiable Bal DOP
    CCARD.DATA<28> = WS.DATA<7>

* Overdraft USD
    CCARD.DATA<29> = WS.DATA<25>

* Overdraft DOP
    CCARD.DATA<30> = WS.DATA<24>

    CHANGE FM TO "*" IN CCARD.DATA
    DETAIL.RECORD<-1> = CCARD.DATA
  END

  RETURN
