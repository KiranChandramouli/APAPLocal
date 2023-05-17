*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.CUST.ADDRESS(Y.ADDR)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Akthar Rasool S
*Program   Name    :REDO.S.CUST.ADDRESS
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine is fetch customer address to DEAL.SLIP
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*2/12/2010      saktharrasool@temenos.com   ODR-2010-09-0251       Initial Version
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ACCOUNT
$INSERT I_F.COMPANY
$INSERT I_F.CUSTOMER
$INSERT I_F.DE.ADDRESS
$INSERT I_F.DE.PRODUCT
$INSERT I_F.COUNTRY
$INSERT I_F.FUNDS.TRANSFER

  GOSUB INITIALISE
  GOSUB OPENFILE
  GOSUB PROCESS
  RETURN

*--------------------------------------------------------------------------------------------------------
INITIALISE:
*-------------
* Initailaise all the necessary variables

  Y.POS.DIR = ""
  Y.POS.URD = ""
  Y.POS.SEC = ""
  Y.POS.PAIS = ""
  Y.POS.POST = ""
  FN.ACCOUNT = 'F.ACCOUNT' ; F.ACCOUNT = ''
  FN.DE.PRODUCT = 'F.DE.PRODUCT' ; F.DE.PRODUCT=''
  FN.DE.ADDRESS='F.DE.ADDRESS'; F.DE.ADDRESS=''
  FN.CUSTOMER='F.CUSTOMER'; F.CUSTOMER=''
  FN.COUNTRY = 'F.COUNTRY'
  F.COUNTRY = ''
  Y.CARR = ''
  RETURN

*--------------------------------------------------------------------------------------------------------
OPENFILE:
*------------
* Open all the necessary files

  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.DE.PRODUCT,F.DE.PRODUCT)
  CALL OPF(FN.DE.ADDRESS,F.DE.ADDRESS)
  CALL OPF(FN.COUNTRY,F.COUNTRY)
  RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS:
*------------
  Y.ACCT.NO = R.NEW(FT.DEBIT.ACCT.NO)

  CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT.REC,F.ACCOUNT,ACCOUNT.ERR)
  Y.DEPT.NO = R.ACCOUNT.REC<AC.CO.CODE>
  Y.CUS.NO  = R.ACCOUNT.REC<AC.CUSTOMER>
  Y.DE.ID   = Y.DEPT.NO:'.A-':Y.ACCT.NO:'.ALL.ALL'
  CALL F.READ(FN.DE.PRODUCT,Y.DE.ID,R.DE.PRODUCT.REC,F.DE.PRODUCT,DE.PRODUCT.ERR)
  Y.CARR = R.DE.PRODUCT.REC<DE.PRD.CARR.ADD.NO,1>
  IF R.DE.PRODUCT.REC NE '' THEN
    Y.DE.ADD.ID=R.ACCOUNT.REC<AC.CO.CODE>:'.C-':Y.CUS.NO:'.':Y.CARR
  END ELSE
    Y.DE.ADD.ID=R.ACCOUNT.REC<AC.CO.CODE>:'.C-':Y.CUS.NO:'.PRINT.1'
  END

  CALL F.READ(FN.DE.ADDRESS,Y.DE.ADD.ID,R.DE.ADDRESS.REC,F.DE.ADDRESS,DE.ADD.ERR)
  GOSUB GET.LT.DETS
  Y.DIR   = R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.DIR>
  Y.URD   = R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.URD>
  Y.SEC   = R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.SEC>
  Y.PAIS  = R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.PAIS>
  IF Y.PAIS NE '' THEN
    CALL F.READ(FN.COUNTRY,Y.PAIS,R.COUNTRY,F.COUNTRY,CTRY.ERR)
    Y.PAIS = R.COUNTRY<EB.COU.SHORT.NAME>
  END

  Y.POST  = R.DE.ADDRESS.REC<DE.ADD.LOCAL.REF,Y.POS.POST>
  Y.TOWN.COUNTRY = R.DE.ADDRESS.REC<DE.ADD.TOWN.COUNTY>
  Y.COUNTRY      = R.DE.ADDRESS.REC<DE.ADD.COUNTRY>
  Y.STR.ADR      = R.DE.ADDRESS.REC<DE.ADD.STREET.ADDRESS>

  Y.DATA = TRIM(Y.STR.ADR):' ':TRIM(Y.DIR):" ":TRIM(Y.URD):" ":TRIM(Y.SEC):VM:SPACE(17):TRIM(Y.COUNTRY):" ":TRIM(Y.TOWN.COUNTRY):" ":TRIM(Y.PAIS):" ":TRIM(Y.POST)


  Y.ADDR = Y.DATA


  RETURN

*--------------------------------------------------------------------------------------------------------
GET.LT.DETS:
*--------------
* Reads the core routine MULTI.GET.LOC.REF and gets the position of the required Local Fields

  APPL.NAME = 'DE.ADDRESS'
  FLD.NAME = 'L.DA.NO.DIR':VM:'L.CU.URB.ENS.RE':VM:'L.CU.RES.SECTOR':VM:'L.DA.PAIS':VM:'L.DA.APT.POSTAL'
  FLD.POS = ''
  CALL MULTI.GET.LOC.REF(APPL.NAME,FLD.NAME,FLD.POS)
  Y.POS.DIR = FLD.POS<1,1>
  Y.POS.URD = FLD.POS<1,2>
  Y.POS.SEC = FLD.POS<1,3>
  Y.POS.PAIS = FLD.POS<1,4>
  Y.POS.POST = FLD.POS<1,5>
  RETURN

END
