*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.FETCH.TELEPHONE(RES)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.FETCH.CUST.IDEN
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to check the customer record Field and get
*                   identification field and display in the deal slip
*[IDENTITY ID  >> "EEEE" = LEGAL.ID or L.CU.CIDENT or L.CU.NOUNICO or L.CU.ACTANAC
*    Just one of these values will be populated on CUSTOMER (so pick up the one being populated from above))
*LINKED WITH       :

* Revision History
*-------------------------
*    Date             Who               Reference       Description
* 01-JUL-2011        KAVITHA            PACS00062260    Issue fix

* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_F.LATAM.CARD.ORDER


  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN
*-----*
INIT:
*-----*

*PACS00062260 -S

*    Y.CUST.ID=RES
  Y.CUST.ID = R.NEW(CARD.IS.CUSTOMER.NO)<1,1>

*PACS00062260 -E

  RES=''
  LOC.REF.APPLICATION="CUSTOMER"
  LOC.REF.FIELDS="L.CU.TEL.AREA":VM:"L.CU.TEL.NO"
  LOC.REF.POS=''
  RETURN
*---------*
OPEN.FILES:
*----------*
  FN.CUST='F.CUSTOMER'
  F.CUST=''
  CALL OPF(FN.CUST,F.CUST)

  RETURN
*-------*
PROCESS:
*-------*

  CALL F.READ(FN.CUST,Y.CUST.ID,R.CUSTOMER,F.CUST,CUS.ERROR)
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  Y.CU.TEL.AREA.POS =LOC.REF.POS<1,1>
  Y.CU.TEL.NO.POS   =LOC.REF.POS<1,2>
  Y.CU.TEL.AREA.VAL=R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.CU.TEL.AREA.POS,1>
  Y.CU.TEL.NO.VAL  =R.CUSTOMER<EB.CUS.LOCAL.REF><1,Y.CU.TEL.NO.POS,1>
  Y.TEL.NO=Y.CU.TEL.AREA.VAL:' ':Y.CU.TEL.NO.VAL
  RES=Y.TEL.NO

  RETURN
END
