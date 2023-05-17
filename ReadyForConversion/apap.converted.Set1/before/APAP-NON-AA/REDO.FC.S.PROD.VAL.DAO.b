*-----------------------------------------------------------------------------
* <Rating>-61</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.PROD.VAL.DAO

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : Get Paymnent Schedule definition in order to populate the fields
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 22 Jun 2011
*
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date               Name                      Description
* -------          ----               ----                      ------------
* PACS00253689     19/3/2012          Prakash.G.K.S             Value in CUSTOMER's local field
*                                                               L.CU.TIPO.CL should not be 'CLIENTE MENOR'
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.PRODUCT.DESIGNER
$INSERT I_F.AA.PAYMENT.SCHEDULE
$INSERT I_F.AA.INTEREST
$INSERT I_F.AA.PRODUCT
$INSERT I_F.AA.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.REDO.CREATE.ARRANGEMENT
$INSERT I_F.REDO.FC.PROD.COLL.POLICY
$INSERT I_GTS.COMMON

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CLIENTE.MENOR.CHECK   ;*PACS00253689
* ------------------------------------------------------------------------------------------
* PA20071025 Se debe ejecutar solo cuando es invocado desde el campo HOT.FIELD de la version
  CAMPO.ACTUAL = OFS$HOT.FIELD
  NOMBRE.CAMPO = "...CUSTOMER..."
  IF CAMPO.ACTUAL MATCH NOMBRE.CAMPO ELSE
    RETURN
  END
* Fin PA20071025
*-------------------


*    GOSUB INITIALISE
*    GOSUB OPEN.FILES

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS.MAIN
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*============
  CALL REDO.FC.S.CUSTOMER.EVAL

  GOSUB SET.DAO

  RETURN

SET.DAO:
*===============
*    ID.CUST = COMI
*    CALL F.READ(FN.CUSTOMER,ID.CUST,R.CUSTOMER,F.CUSTOMER,YERR)
  R.NEW(REDO.FC.PRIM.OFFICER) =  R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>

  RETURN

*-------------------
CLIENTE.MENOR.CHECK:
*-------------------
*PACS00253689 - Start
  ID.CUST = COMI
  CALL F.READ(FN.CUSTOMER,ID.CUST,R.CUSTOMER,F.CUSTOMER,YERR)
  CU.TIPO.CL.VALUE = R.CUSTOMER<EB.CUS.LOCAL.REF,CU.TIPO.CL>
  IF CU.TIPO.CL.VALUE EQ 'CLIENTE MENOR' THEN
    AF = REDO.FC.CUSTOMER
    ETEXT = 'EB-CUS.TYPE.CLIENTE.MENOR'
    CALL STORE.END.ERROR
  END
*PACS00253689 - End

  RETURN

*------------------------
INITIALISE:
*=========


  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  R.CUSTOMER = ''
*PACS00253689 - Start
  APPLICATION.ARRAY = "CUSTOMER"
  FLD.NAME = 'L.CU.TIPO.CL'
  Y.POS = ''

  CALL MULTI.GET.LOC.REF(APPLICATION.ARRAY,FLD.NAME,Y.POS)
  CU.TIPO.CL = Y.POS<1,1>
*PACS00253689 - End

  Y.DEB.DIR = 'Debito Directo'

  YERR = ''
  PROCESS.GOAHEAD = 1
  RETURN


*------------------------

OPEN.FILES:
*=========
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  RETURN
*------------
END
