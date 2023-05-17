*-----------------------------------------------------------------------------
* <Rating>-57</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.SEL.CLIE.CUEN
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.SEL.CLIE.CUEN
* Attached as     : ROUTINE
* Primary Purpose : CALCULATING THE VALUE OF THE AVAILABLE INSTRUMENT
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
*
*-----------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL
* PACS00307565 - S
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
* PACS00307565 - E
  GOSUB INITIALISE
  GOSUB OPEN.FILES
*
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

* Get the account number (fix deposit or deposits )
*VAR.CUENTA = R.NEW(COLL.APPLICATION.ID)
  VAR.CUENTA = COMI
  VAR.TIPO = R.NEW(COLL.COLLATERAL.TYPE)

*For accounts
  IF (VAR.TIPO = 151) OR (VAR.TIPO = 153) THEN
*Get the prymary key customer
    GOSUB GET.ACC.INFO        ;* PACS00307565 - S/E
*Get the name of customer
    CALL F.READ(FN.CUSTOMER,VAR.CUSTOMER,R.CUSTOMER,F.CUSTOMER,R.ERROR)
    VAR.CUSTOMER =  R.CUSTOMER<EB.CUS.NAME.1>
    R.NEW(COLL.LOCAL.REF)<1,WPOSNOMB> = VAR.CUSTOMER
  END


*Fix Deposits
  IF (VAR.TIPO = 152) THEN
*Get the prymary key customer
    CALL F.READ(FN.AZ,VAR.CUENTA,R.AZ,F.AZ,R.ERROR)
    IF R.AZ NE "" THEN
      VAR.CUSTOMER =  R.AZ<AZ.CUSTOMER>
*Date end of fix deposit
      VAR.DATE     =  R.AZ<AZ.MATURITY.DATE>
*Value of fix deposit
*       VAR.VALOR    =  R.AZ<AZ.PRINCIPAL>
    END
    ELSE
      GOSUB GET.ACC.INFO      ;* PACS00307565 - S/E
    END

*Get the name of customer
    CALL F.READ(FN.CUSTOMER,VAR.CUSTOMER,R.CUSTOMER,F.CUSTOMER,R.ERROR)
    VAR.CUSTOMER = R.CUSTOMER<EB.CUS.NAME.1>
    Y.CUS.NAME    = FIELD(VAR.CUSTOMER,VM,1)
    R.NEW(COLL.LOCAL.REF)<1,WPOSNOMB> = Y.CUS.NAME
    R.NEW(COLL.LOCAL.REF)<1,WPOSDATE> = VAR.DATE
*       R.NEW(COLL.NOMINAL.VALUE)         = VAR.VALOR

  END

  RETURN
*----------------------------------------------------------------------------
*
GET.ACC.INFO:
*======
*
  R.ACCOUNT = '' ; R.ERROR = ''
  CALL F.READ(FN.ACCOUNT,VAR.CUENTA,R.ACCOUNT,F.ACCOUNT,R.ERROR)
  VAR.CUSTOMER =  R.ACCOUNT<AC.CUSTOMER>
*
  RETURN
*
INITIALISE:
*=========
  PROCESS.GOAHEAD = 1

  FN.ACCOUNT   = 'F.ACCOUNT'
  F.ACCOUNT    = ''
  R.ACCOUNT    = ''

  FN.CUSTOMER   = 'F.CUSTOMER'
  F.CUSTOMER    = ''
  R.CUSTOMER    = ''
  R.ERROR       = ''

  FN.AZ         = 'F.AZ.ACCOUNT'
  F.AZ          = ''
  R.AZ          = ''

*Read the local fields
  WCAMPO     = "L.COL.SE.HLD.NA"
  WCAMPO<2>  = "L.COL.INVST.DT"
  WCAMPO = CHANGE(WCAMPO,FM,VM)
  YPOS=0

*Get the position for all fields
  CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
  WPOSNOMB  = YPOS<1,1>
  WPOSDATE  = YPOS<1,2>

  VAR.CUSTOMER = ''
  VAR.DATE     = ''
  Y.CUS.NAME   = ''

  RETURN

*------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  CALL OPF(FN.AZ,F.AZ)
  RETURN
*------------
END
