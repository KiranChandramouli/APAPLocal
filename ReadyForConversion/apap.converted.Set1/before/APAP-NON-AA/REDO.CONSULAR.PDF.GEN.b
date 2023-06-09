*-----------------------------------------------------------------------------
* <Rating>-63</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONSULAR.PDF.GEN(Y.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.CONSULAR.PDF.GEN
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in NOFILE ENQUIRY
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: Y.ARRAY
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION
*17.06.2011  RIYAS          PACS00072839   MODIFY-CHECK THE LEGAL ID
*24.08.2011  Sudharsanan   PACS00120764   Get the id value of REDO.ISSUE.LETTER and get the customer and product values
*----------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CATEGORY
$INSERT I_F.REDO.OFFICERS.LIST
$INSERT I_F.REDO.LETTER.ISSUE
$INSERT I_F.CUSTOMER
$INSERT I_F.TELLER
$INSERT I_F.AZ.ACCOUNT
$INSERT I_System
*Tus Start
$INSERT I_F.EB.CONTRACT.BALANCES
*Tus End
  GOSUB INIT
  GOSUB OPENFILES
  GOSUB LOCAL.REF
  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  FN.CATEGORY='F.CATEGORY'
  F.CATEGORY=''
  FN.CUSTOMER='F.CUSTOMER'
  F.CUSTOMER=''
  FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
  F.AZ.ACCOUNT=''
  FN.REDO.OFFICERS.LIST='F.REDO.OFFICERS.LIST'
  F.REDO.OFFICERS.LIST=''
  FN.REDO.LETTER.ISSUE='F.REDO.LETTER.ISSUE'
  F.REDO.LETTER.ISSUE=''
  Y.TOTAL.AMT=0
  RETURN

*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  CALL OPF(FN.CATEGORY,F.CATEGORY)
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)
  CALL OPF(FN.REDO.OFFICERS.LIST,F.REDO.OFFICERS.LIST)
  CALL OPF(FN.REDO.LETTER.ISSUE,F.REDO.LETTER.ISSUE)
  RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
  LOC.REF.APPLICATION="TELLER":FM:"CUSTOMER"
  LOC.REF.FIELDS='L.LETTER.ID':FM:'L.CU.CIDENT':VM:'L.CU.TIPO.CL':VM:'L.CU.RNC'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.LETTER.ID=LOC.REF.POS<1,1>
  POS.L.CU.CIDENT=LOC.REF.POS<2,1>
  POS.L.CU.TIPO.CL = LOC.REF.POS<2,2>
  POS.L.CU.RNC = LOC.REF.POS<2,3>
  RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
* Get the details of Customer and Product Details
*PACS00120764 - S
  IF APPLICATION EQ 'TELLER' THEN
    Y.LETTER.CONS.ISSUE.ID=R.NEW(TT.TE.LOCAL.REF)<1,POS.L.LETTER.ID>
    CALL F.READ(FN.REDO.LETTER.ISSUE,Y.LETTER.CONS.ISSUE.ID,R.LETTER.CONS.ISSUE,F.REDO.LETTER.ISSUE,LETTER.ERR)
  END ELSE
    Y.LETTER.CONS.ISSUE.ID = System.getVariable("CURRENT.CONS")
    CALL F.READ(FN.REDO.LETTER.ISSUE,Y.LETTER.CONS.ISSUE.ID,R.LETTER.CONS.ISSUE,F.REDO.LETTER.ISSUE,ERR.IS)
  END
  Y.RECIPIENT.NAME=R.LETTER.CONS.ISSUE<REDO.LET.ISS.RECIPIENT>
  Y.RECIPIENT.CITY=R.LETTER.CONS.ISSUE<REDO.LET.ISS.RECIPIENT.CITY>
  Y.CUSTOMER.ID=R.LETTER.CONS.ISSUE<REDO.LET.ISS.CUSTOMER.ID>
  CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
  Y.CU.NAME=R.LETTER.CONS.ISSUE<REDO.LET.ISS.CU.NAME>
  Y.NAME.CUS=R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TIPO.CL>
  IF Y.NAME.CUS EQ 'PERSONA FISICA' THEN
    Y.COMPANY.PREFIX="la Cedula de Identidad Personal No."
    Y.CUDELA = R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>
*PACS00072839-S
    IF NOT(Y.CUDELA) THEN
      Y.COMPANY.PREFIX = "Pasaporte No."
      Y.PASSPORT = R.CUSTOMER<EB.CUS.LEGAL.ID>
      Y.CUDELA = Y.PASSPORT
    END
  END ELSE
    IF Y.NAME.CUS EQ 'PERSONA JURIDICA' THEN
      Y.CUDELA= R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
    END
  END
*PACS00072839-E
  Y.PRODUCT=R.LETTER.CONS.ISSUE<REDO.LET.ISS.PRODUCTS>
  Y.PRODUCT.CNT=DCOUNT(Y.PRODUCT,VM)
  VAR1=1
  LOOP
  WHILE VAR1 LE Y.PRODUCT.CNT
    Y.PRODUCT.ID=Y.PRODUCT<1,VAR1>
    CALL F.READ(FN.ACCOUNT,Y.PRODUCT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    R.ECB='' ; ECB.ERR='' ;*Tus Start
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES",Y.PRODUCT.ID,R.ECB,ECB.ERR) ;*Tus End
    Y.CATEGORY=R.ACCOUNT<AC.CATEGORY>
    CALL F.READ(FN.CATEGORY,Y.CATEGORY,R.CATEGORY,F.CATEGORY,CAT.ERR)
    Y.CATEGORY.DES=R.CATEGORY<EB.CAT.DESCRIPTION>
    Y.CATEGORY.DES=FMT(Y.CATEGORY.DES,"L2#35")
    CALL F.READ(FN.AZ.ACCOUNT,Y.PRODUCT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
    IF R.AZ.ACCOUNT NE '' THEN
      Y.BALANCE=R.AZ.ACCOUNT<AZ.PRINCIPAL>
    END ELSE
    * Y.BALANCE=R.ACCOUNT<AC.WORKING.BALANCE> ;*Tus Start
      Y.BALANCE=R.ECB<ECB.WORKING.BALANCE> ;*Tus End
    END
    Y.TOTAL.AMT=Y.BALANCE+Y.TOTAL.AMT
    IF Y.BALANCE EQ '' THEN
      Y.BALANCE= 0
    END
    Y.BALANCE=FMT(Y.BALANCE,"L2,RD$#15")
    Y.OPENING.DATE=R.ACCOUNT<AC.OPENING.DATE>
    IF Y.OPENING.DATE NE '' THEN
      Y.OPENING.DATE=Y.OPENING.DATE[7,2]:'/':Y.OPENING.DATE[5,2]:'/':Y.OPENING.DATE[1,4]
    END
    Y.PROD.LEN=LEN(Y.PRODUCT.ID)
    Y.PROD.NO='********':Y.PRODUCT.ID[Y.PROD.LEN-3,Y.PROD.LEN]
    Y.ARRAY1:=Y.CATEGORY.DES:":":Y.PROD.NO:":":Y.BALANCE:":":Y.OPENING.DATE:"@":VM
    VAR1++
  REPEAT
  Y.TOTAL.AMT=FMT(Y.TOTAL.AMT,"L2,RD$#15")
  Y.OFFICER.CODE=R.LETTER.CONS.ISSUE<REDO.LET.ISS.ISS.OFFICER>
  CALL F.READ(FN.REDO.OFFICERS.LIST,Y.OFFICER.CODE,R.REDO.OFFICERS.LIST,F.REDO.OFFICERS.LIST,OFF.ERR)
  Y.OFFICER.NAME=R.REDO.OFFICERS.LIST<REDO.OFF.LIS.OFFICER.NAME>
  Y.OFFICER.POSITION=R.REDO.OFFICERS.LIST<REDO.OFF.LIS.DESIGNATION>
  Y.OFFICER.DEPT=R.REDO.OFFICERS.LIST<REDO.OFF.LIS.DEPT.BRANCH>
  Y.DEBIT.ACC=R.LETTER.CONS.ISSUE<REDO.LET.ISS.CHARGE.LIQ.ACT>
  Y.CHARGE.AMT=R.LETTER.CONS.ISSUE<REDO.LET.ISS.CHARGE.AMT>
  Y.CHARGE.AMT=FMT(Y.CHARGE.AMT,"L2,RD$#25")
  Y.CHARGE.CCY=R.LETTER.CONS.ISSUE<REDO.LET.ISS.CHARGE.CCY>

  Y.ARRAY=TODAY[7,2]:'/':TODAY[5,2]:'/':TODAY[1,4]:"#":Y.RECIPIENT.NAME:"#":Y.RECIPIENT.CITY:"#":Y.CU.NAME:"#":Y.CUDELA:"#":Y.ARRAY1:"#":Y.TOTAL.AMT:"#":Y.OFFICER.NAME:"#":Y.OFFICER.POSITION:"#":Y.OFFICER.DEPT:"#":Y.DEBIT.ACC:"#":Y.CHARGE.AMT:"#":Y.CHARGE.CCY:"#":Y.COMPANY.PREFIX

  RETURN
*PACS00120764 - E

END
