*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FC.PATRIMONIOTEC(CUST.ID, CUST.OUT)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of PATRIMONIO TECNICO IN REDO.CCRG.TECHNICAL.RESERVES TABLE.
*
* Incoming:
* ---------
* CUST.ID - ID FROM CUSTOMER
*
* Outgoing:
* ---------
* CUST.OUT - value to display in ENQUIRY
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : mgudino - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CCRG.TECHNICAL.RESERVES

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
  R.REDO.CCRG.TECHNICAL.RESERVES = ''
  YERR = ''
  REDO.CCRG.TECHNICAL.RESERVES.ID = 'SYSTEM'
  CALL CACHE.READ (FN.REDO.CCRG.TECHNICAL.RESERVES, REDO.CCRG.TECHNICAL.RESERVES.ID, R.REDO.CCRG.TECHNICAL.RESERVES, YERR )
  IF YERR THEN
    CUST.OUT = YERR
    RETURN
  END ELSE
    CUST.OUT = R.REDO.CCRG.TECHNICAL.RESERVES<REDO.CCRG.TR.TECH.RES.AMOUNT>
  END

  RETURN
*------------------------
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1
  FN.REDO.CCRG.TECHNICAL.RESERVES = 'F.REDO.CCRG.TECHNICAL.RESERVES'
  F.REDO.CCRG.TECHNICAL.RESERVES = ''

  FN.REDO.CCRG.RISK.LIMIT.PARAM = 'F.REDO.CCRG.RISK.LIMIT.PARAM'
  F.REDO.CCRG.RISK.LIMIT.PARAM = ''

  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM)

  RETURN
*------------
END
