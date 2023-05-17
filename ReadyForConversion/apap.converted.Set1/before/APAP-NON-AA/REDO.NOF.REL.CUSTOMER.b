*-----------------------------------------------------------------------------
* <Rating>-186</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOF.REL.CUSTOMER(Y.ENQ.OUT)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.NOF.REL.CUSTOMER
*--------------------------------------------------------------------------------------------------------
*Description       : This is a nofile routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.E.REL.CUSTOMER
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    08 Mar 2011            Janani             ODR-2010-03-0150         Initial Creation
*    06 Jul 2011          SUDHARSANAN S         PACS00080514             Modify as per the issue
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.CUSTOMER
$INSERT I_F.DE.ADDRESS
$INSERT I_F.DE.PRODUCT
$INSERT I_F.REDO.REL.CUSTOMER
$INSERT I_F.COUNTRY
  GOSUB INIT
  GOSUB PROCESS

  RETURN
*********
INIT:
*********
  FN.COUNTRY = 'F.COUNTRY'
  F.COUNTRY = ''
  R.COUNTRY = ''
  CALL OPF(FN.COUNTRY,F.COUNTRY)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  R.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.REDO.REL.CUSTOMER = 'F.REDO.REL.CUSTOMER'
  F.REDO.REL.CUSTOMER = ''
  R.REDO.REL.CUSTOMER = ''
  CALL OPF(FN.REDO.REL.CUSTOMER,F.REDO.REL.CUSTOMER)

  FN.DE.ADDRESS = 'F.DE.ADDRESS'
  F.DE.ADDRESS = ''
  R.DE.ADDRESS = ''
  CALL OPF(FN.DE.ADDRESS,F.DE.ADDRESS)

  FN.DE.PRODUCT = 'F.DE.PRODUCT'
  F.DE.PRODUCT = ''
  CALL OPF(FN.DE.PRODUCT,F.DE.PRODUCT)

  FN.CUS.ACC = 'F.CUSTOMER.ACCOUNT'
  F.CUS.ACC = ''
  CALL OPF(FN.CUS.ACC,F.CUS.ACC)

  LOC.REF.APPLICATION='DE.ADDRESS':FM:'CUSTOMER'
  LOC.REF.FIELDS = 'L.CU.RES.SECTOR':VM:'L.CU.URB.ENS.RE':VM:'L.DA.PAIS':VM:'L.DA.NO.DIR':VM:'L.DA.APT.POSTAL':FM:'L.CU.TIPO.CL':VM:'L.CU.TEL.P.CONT':VM:'L.CU.TEL.TYPE'
  LOC.REF.FIELDS := VM:'L.CU.TEL.AREA':VM:'L.CU.TEL.NO':VM:'L.CU.TEL.EXT'
  LOC.REF.POS = ''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.CU.RES.SECTOR = LOC.REF.POS<1,1>
  POS.L.CU.URB.ENS.RE = LOC.REF.POS<1,2>
  POS.L.DA.PAIS = LOC.REF.POS<1,3>
  POS.L.DA.NO.DIR = LOC.REF.POS<1,4>
  POS.L.DA.APT.POSTAL = LOC.REF.POS<1,5>
  POS.L.CU.TIPO.CL = LOC.REF.POS<2,1>
  POS.L.CU.TEL.P.CONT = LOC.REF.POS<2,2>
  POS.L.CU.TEL.TYPE = LOC.REF.POS<2,3>
  POS.L.CU.TEL.AREA = LOC.REF.POS<2,4>
  POS.L.CU.TEL.NO = LOC.REF.POS<2,5>
  POS.L.CU.TEL.EXT = LOC.REF.POS<2,6>

  RETURN

*************
PROCESS:
*************

  Y.CRITERIA = ''

  SEL.CMD = ''
  SEL.LIST = ''
  Y.FLAG = 0

  LOCATE "@ID" IN D.FIELDS<1> SETTING ID.POS THEN
    CALL F.READ(FN.REDO.REL.CUSTOMER,D.RANGE.AND.VALUE<ID.POS>,R.REDO.REL.CUSTOMER,F.REDO.REL.CUSTOMER,READ.ERR)
    IF R.REDO.REL.CUSTOMER THEN
      SEL.CMD = "SELECT ":FN.CUSTOMER:" WITH @ID EQ ":D.RANGE.AND.VALUE<ID.POS>
      Y.FLAG = 1
    END ELSE
      RETURN
    END
    Y.CRITERIA := 'Codigo(s) Cliente(s)- ':D.RANGE.AND.VALUE<ID.POS>
  END ELSE
    SEL.CMD2 = "SELECT ":FN.REDO.REL.CUSTOMER
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NOR1,ERR)
    IF SEL.LIST2 THEN
      CHANGE FM TO " " IN SEL.LIST2
      SEL.CMD = "SELECT ":FN.CUSTOMER:" WITH @ID EQ ":SEL.LIST2
    END ELSE
      RETURN
    END
  END

  LOCATE "ACCOUNT.OFFICER" IN D.FIELDS<1> SETTING AC.POS THEN

    Y.FLAG = 1
    SEL.CMD := " AND ACCOUNT.OFFICER EQ ":D.RANGE.AND.VALUE<AC.POS>
    IF Y.CRITERIA EQ '' THEN
      Y.CRITERIA = 'Oficial de cuenta - ':D.RANGE.AND.VALUE<AC.POS>
    END ELSE
      Y.CRITERIA := ',':'Oficial de cuenta - ':D.RANGE.AND.VALUE<AC.POS>
    END
  END
  LOCATE "OTHER.OFFICER" IN D.FIELDS<1> SETTING OC.POS THEN
    Y.FLAG = 1
    SEL.CMD := " AND OTHER.OFFICER EQ ":D.RANGE.AND.VALUE<OC.POS>
    IF Y.CRITERIA THEN
      Y.CRITERIA := ',Agencia - ':D.RANGE.AND.VALUE<OC.POS>
    END ELSE
      Y.CRITERIA = 'Agencia - ':D.RANGE.AND.VALUE<OC.POS>
    END
  END

  IF Y.FLAG THEN
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,SEL.ERR)
    IF SEL.LIST THEN
      CHANGE FM TO " " IN SEL.LIST
      SEL.CMD1 = "SELECT ":FN.REDO.REL.CUSTOMER:" WITH @ID EQ ":SEL.LIST
      CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NOR1,SEL.ERR)
    END ELSE
      RETURN
    END
  END ELSE
    SEL.LIST1 = SEL.LIST2
    CHANGE " " TO FM IN SEL.LIST1
  END
  IF Y.CRITERIA THEN
    Y.STR = Y.CRITERIA
  END ELSE
    Y.STR  = "ALL"
  END
  LOOP
    REMOVE I.SEL.LIST FROM SEL.LIST1 SETTING SEL.POS
  WHILE I.SEL.LIST:SEL.POS
    R.CUSTOMER = '' ; Y.CUS.TYPE = '' ;  Y.CO.CODE = '' ; Y.TYPE = '' ; Y.CARR.ADD.NO = '' ; Y.DE.ADD.ID = ''
    CALL F.READ(FN.CUSTOMER,I.SEL.LIST,R.CUSTOMER,F.CUSTOMER,READ.ERR)
    Y.STR := '*':R.CUSTOMER<EB.CUS.OTHER.OFFICER>
    Y.STR := "*":R.CUSTOMER<EB.CUS.ACCOUNT.OFFICER>
    Y.STR := "*":I.SEL.LIST:"*"
    Y.CUS.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF><1,POS.L.CU.TIPO.CL>
    Y.CO.CODE = R.CUSTOMER<EB.CUS.CO.CODE>
    IF Y.CUS.TYPE EQ 'PERSONA JURIDICA' THEN
      Y.STR := R.CUSTOMER<EB.CUS.NAME.1>:" ":R.CUSTOMER<EB.CUS.NAME.2>
    END
    IF Y.CUS.TYPE EQ 'PERSONA FISICA' THEN
      Y.STR := R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END
    Y.STR := '*':R.CUSTOMER<EB.CUS.CUSTOMER.SINCE>
    Y.STR := '*':R.CUSTOMER<EB.CUS.LOCAL.REF><1,POS.L.CU.TEL.P.CONT>
    Y.CNT = 0
    Y.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF><1,POS.L.CU.TEL.TYPE>
    Y.STR := '*'
    GOSUB TELE
    GOSUB CHECK.ADDRESS
    CALL F.READ(FN.REDO.REL.CUSTOMER,I.SEL.LIST,R.REDO.REL.CUSTOMER,F.REDO.REL.CUSTOMER,READ.ERR)
    CHANGE FM TO VM IN R.REDO.REL.CUSTOMER
    Y.STR := '*':R.REDO.REL.CUSTOMER:'*'
    GOSUB EMP.NAME
    Y.STR := FM:""
  REPEAT
  Y.ENQ.OUT = Y.STR
  RETURN
*--------------------------------------------------------------------------------------------------------
TELE:
*----------------
  LOOP
    REMOVE I.Y.TYPE FROM Y.TYPE SETTING Y.POS
  WHILE I.Y.TYPE:Y.POS
    Y.CNT +=1
    Y.STR := R.CUSTOMER<EB.CUS.LOCAL.REF><1,POS.L.CU.TEL.TYPE,Y.CNT>:" ":R.CUSTOMER<EB.CUS.LOCAL.REF><1,POS.L.CU.TEL.AREA,Y.CNT>:" "
    Y.STR := R.CUSTOMER<EB.CUS.LOCAL.REF><1,POS.L.CU.TEL.NO,Y.CNT>:" ":R.CUSTOMER<EB.CUS.LOCAL.REF><1,POS.L.CU.TEL.EXT,Y.CNT>
    Y.STR = TRIM(Y.STR," ",'T')
    Y.STR := SM
  REPEAT
  RETURN
*------------------------------------------------------------------------------------------------------------------------
CHECK.ADDRESS:
*------------------------------------------------------------------------------------------------------------------------
*PACS00080514 - S
  CALL F.READ(FN.CUS.ACC,I.SEL.LIST,R.CUS.ACC,F.CUS.ACC,ERR)
  CNT.CUS.ACC = DCOUNT(R.CUS.ACC,FM)
  IF R.CUS.ACC THEN
    VAR1=1
    LOOP
    WHILE VAR1 LE CNT.CUS.ACC
      Y.ACCT.NO = R.CUS.ACC<VAR1>
      Y.DE.ID=Y.CO.CODE:'.A-':Y.ACCT.NO:'.ALL.ALL'
      CALL F.READ(FN.DE.PRODUCT,Y.DE.ID,R.DE.PROD,F.DE.PROD,DE.ERR)
      IF R.DE.PROD THEN
        Y.CARR.ADD.NO = R.DE.PROD<DE.PRD.CARR.ADD.NO,1>
        VAR1 = CNT.CUS.ACC
      END
      VAR1++
    REPEAT
  END
  IF Y.CARR.ADD.NO THEN
    Y.DE.ADD.ID=Y.CO.CODE:'.C-':I.SEL.LIST:'.':Y.CARR.ADD.NO
  END ELSE
    Y.DE.ADD.ID=Y.CO.CODE:'.C-':I.SEL.LIST:'.PRINT.1'
  END
  CALL F.READ(FN.DE.ADDRESS,Y.DE.ADD.ID,R.DE.ADDRESS,F.DE.ADDRESS,ERR)
  Y.STR := "*"
  IF R.DE.ADDRESS THEN
    Y.L.DA.NO.DIR = R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,POS.L.DA.NO.DIR>
    Y.L.CU.URB.ENS.RE = R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,POS.L.CU.URB.ENS.RE>
    Y.L.CU.RES.SECTOR = R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,POS.L.CU.RES.SECTOR>
    Y.L.DA.PAIS = R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,POS.L.DA.PAIS>
    Y.L.DA.APT.POSTAL = R.DE.ADDRESS<DE.ADD.LOCAL.REF><1,POS.L.DA.APT.POSTAL>
    Y.STR := R.DE.ADDRESS<DE.ADD.STREET.ADDRESS>:" ":Y.L.DA.NO.DIR:" "
    Y.STR := Y.L.CU.URB.ENS.RE:" ":Y.L.CU.RES.SECTOR:" "
    Y.STR := R.DE.ADDRESS<DE.ADD.COUNTRY>:" ":R.DE.ADDRESS<DE.ADD.TOWN.COUNTY>:" "
    CALL F.READ(FN.COUNTRY,Y.L.DA.PAIS,R.COUNTRY,F.COUNTRY,READ.ERR)
    Y.L.DA.PAIS = R.COUNTRY<EB.COU.SHORT.NAME,1>
    Y.STR := Y.L.DA.PAIS:" "
    Y.STR := Y.L.DA.APT.POSTAL
  END
  RETURN
*PACS00080514 - E
*--------------
EMP.NAME:
*-------------
  LOOP
    REMOVE I.RC FROM R.REDO.REL.CUSTOMER SETTING REL.POS
  WHILE I.RC:REL.POS
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,I.RC,R.CUSTOMER,F.CUSTOMER,READ.ERR)
    Y.REL.CUS.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF><1,POS.L.CU.TIPO.CL>
    IF Y.REL.CUS.TYPE EQ 'PERSONA JURIDICA' THEN
      Y.STR := R.CUSTOMER<EB.CUS.NAME.1>:" ":R.CUSTOMER<EB.CUS.NAME.2>
    END
    IF Y.REL.CUS.TYPE EQ 'PERSONA FISICA' OR Y.REL.CUS.TYPE EQ 'CLIENTE MENOR' THEN
      Y.STR := R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END
    Y.STR := VM
  REPEAT
  RETURN
*-----------------
END       ;* End of program
