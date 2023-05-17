*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.CUS.DATA
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This is a conversion routine used to fetch the ACCOUNT.OFFICER,
*               AGENCY and CUSTOMER CODE details from the application REDO.RESTRICTIVE.LIST
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.CONV.CUS.DATA
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 17-Aug-2010     Jeyachandran S      ODR-2010-08-0470                  Initial creation
*---------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER
$INSERT I_F.DEPT.ACCT.OFFICER
$INSERT I_F.REDO.RESTRICTIVE.LIST
*

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****
  FN.CUSTOMER = "F.CUSTOMER"
  F.CUSTOMER = ""
  R.CUSTOMER = ""
  E.CUSTOMER = ""
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
  FN.CUSTOMER.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
  F.CUSTOMER.L.CU.CIDENT = ''
  R.L.CU.REC = ''
  E.L.CU = ''
  CALL OPF(FN.CUSTOMER.L.CU.CIDENT,F.CUSTOMER.L.CU.CIDENT)
*
  FN.DEPT.ACCT.OFFICER = "F.DEPT.ACCT.OFFICER"
  F.DEPT.ACCT.OFFICER = ""
  R.DEPT.ACCT.OFFICER = ""
  E.DEPT.ACCT.OFFICER = ""
  CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
*
  Y.ACCT.OFFICER = ''
  Y.AGENCY = ''
  Y.CUS.CODE = ''
  RETURN
  Y.NUMERO.DOCUMENTO=''
********
PROCESS:
********
  Y.NUMERO.DOCUMENTO=R.RECORD<RESTR.LIST.NUMERO.DOCUMENTO>
  Y.OVERRIDE = R.RECORD<RESTR.LIST.OVERRIDE>

*    Y.STRING = "Es cliente de APAP"   ;* Removed for PACS00311526
*    LOCATE Y.STRING IN Y.OVERRIDE<1,1> SETTING OVER.POS THEN

  CALL F.READ(FN.CUSTOMER.L.CU.CIDENT,Y.NUMERO.DOCUMENTO,R.L.CU.REC,F.CUSTOMER.L.CU.CIDENT,E.L.CU)
  Y.REC = R.L.CU.REC
  Y.CUS.ID = FIELD(Y.REC,"*",2)

  CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,E.CUSTOMER)
  IF R.CUSTOMER NE "" THEN
    Y.DEPT.ACC.OFF = R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    CALL F.READ(FN.DEPT.ACCT.OFFICER,Y.DEPT.ACC.OFF,R.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER,E.DEPT.ACCT.OFFICER)
    Y.ACCT.OFFICER = R.DEPT.ACCT.OFFICER<EB.DAO.NAME>
    Y.AGENCY       = R.CUSTOMER<EB.CUS.CO.CODE>
    Y.CUS.CODE     = Y.CUS.ID
  END

*    END ;* Removed for PACS00311526

  O.DATA = Y.ACCT.OFFICER:"*":Y.AGENCY:"*":Y.CUS.CODE
  RETURN

END
