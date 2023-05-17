*-----------------------------------------------------------------------------
* <Rating>-77</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AC.CANC.PODER(Y.ENQ.OUT)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AC.CANC.PODER
*--------------------------------------------------------------------------------------------------------
*Description       :
*
*Linked With       : NOFILE ENQUIRY
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : ACCOUNT
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date                 Who                  Reference                 Description
*  ------               -----               -------------              -------------
* 20.12.2010           Manju G          ODR-2010-12-0495          Initial Creation
**********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_ENQUIRY.COMMON

  GOSUB INIT
  GOSUB PROCESS
  RETURN

INIT:
********
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  APPL = ''; FIELD.NAMES = '';FIELD.POS = ''
  APPL = 'CUSTOMER'
  FIELD.NAMES = 'L.CU.TIPO.CL':VM:'L.CU.RNC':VM:'L.CU.CIDENT'
  CALL MULTI.GET.LOC.REF(APPL,FIELD.NAMES,FIELD.POS)
  L.CU.TIPO.POS = FIELD.POS<1,1>
  L.CU.RNC.POS = FIELD.POS<1,2>
  L.CU.CIDENT.POS = FIELD.POS<1,3>

  RETURN
*--------------------------------------------------------------------------------------------------
PROCESS:
*********

  SEL.ACCOUNT = "SELECT ":FN.ACCOUNT:" WITH RELATION.CODE GE '530' AND RELATION.CODE LE '549'"
  LOCATE "ACCOUNT>@ID" IN D.FIELDS<1> SETTING ACCT.POS THEN
    Y.ID = D.RANGE.AND.VALUE<ACCT.POS>
    SEL.ACCOUNT:= "AND @ID EQ ":Y.ID
  END

  CALL EB.READLIST(SEL.ACCOUNT,SEL.LIST.ACCT,'',NOR.ACCT,ERR.ACCT)
*1 TH FIELD DATE
  Y.DATE = TODAY[7,2]
*20091218
  Y.MONTH.POS = TODAY[5,2]

  Y.MONTH = "ENERO":FM:"FEBRERO":FM:"MARZO":FM:"ABRIL":FM:"MAYO":FM:"JUNIO":FM:"JULIO":FM:"AGOSTO":FM:"SEPTIEMBRE":FM:"OCTUBRE":FM:"NOVIEMBRE":FM:"DICIEMBRE"
  Y.MONTH.ES = Y.MONTH<Y.MONTH.POS>

  IN.YEAR='20'
  OUT.YEAR=''
  LANGUAGE='ES'
  LINE.LENGTH=100
  NO.OF.LINES=1
  ERR.MSG=''
  CALL DE.O.PRINT.WORDS(IN.YEAR,OUT.YEAR,LANGUAGE,LINE.LENGTH,NO.OF.LINES,ERR.MSG)
*    DOS*MIL*Y*NUEVE
  OUT.YEAR1 = FIELD(OUT.YEAR,'*',1)

*CONVERT '*' TO ' ' IN OUT.YEAR

  IN.YEAR=TODAY[3,2]
  IN.YEAR = TRIM(IN.YEAR,"0","L")
  OUT.YEAR=''
  LANGUAGE='ES'
  LINE.LENGTH=100
  NO.OF.LINES=1
  ERR.MSG=''
  CALL DE.O.PRINT.WORDS(IN.YEAR,OUT.YEAR,LANGUAGE,LINE.LENGTH,NO.OF.LINES,ERR.MSG)
  OUT.YEAR2 =   FIELD(OUT.YEAR,'*',1)

  OUT.YEAR = OUT.YEAR1:' ':OUT.YEAR2

  Y.DATE.ES = Y.DATE:' ':Y.MONTH.ES:' ':OUT.YEAR

  Y.SEL.AC = 1
  LOOP
  WHILE Y.SEL.AC LE NOR.ACCT
    Y.DISP.CU.NAME = ''
    Y.DOC.NUM = ''
*4 TH FIELD ACCT NUMBER
    Y.DISP.ACCOUNT = SEL.LIST.ACCT<Y.SEL.AC>
    CALL F.READ(FN.ACCOUNT,Y.DISP.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>

    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
*2 ST FIELD ACCT HOLDER NAME
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.POS> EQ "PERSONA FISICA" THEN
      Y.DISP.CU.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
      IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.POS> EQ "PERSONA JURIDICA" THEN
        Y.DISP.CU.NAME  = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
      END
    END
*3 ND FIELD CUS DOC NUMBER
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE '' THEN
      Y.DOC.NUM = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    END
    IF R.CUSTOMER<EB.CUS.LEGAL.ID,1> NE '' THEN
      IF Y.DOC.NUM EQ '' THEN
        Y.DOC.NUM =  R.CUSTOMER<EB.CUS.LEGAL.ID,1>
      END
    END

    IF  R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS> NE '' THEN
      IF Y.DOC.NUM EQ '' THEN
        Y.DOC.NUM = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
      END
    END
    GOSUB ACCT.JOINT

    Y.SEL.AC += 1

    Y.ENQ.OUT<-1> = Y.DATE.ES:'*':Y.DISP.CU.NAME:'*':Y.DOC.NUM:'*':Y.DISP.ACCOUNT:'*':Y.DISP.JOINT.NAME.FIN:'*':Y.JOINT.DOC.NUM.FIN
  REPEAT
  RETURN
*-----------------------------------------------------------------------------------------------------------
ACCT.JOINT:
****************
  Y.DISP.JOINT.NAME.FIN = ''
  Y.DISP.JOINT.NAME = ''
  Y.JOINT.DOC.NUM.FIN = ''
  Y.JOINT.DOC.NUM = ''

  Y.JOINT.HOLDERS = R.ACCOUNT<AC.JOINT.HOLDER>
  Y.RELATION.CODES =  R.ACCOUNT<AC.RELATION.CODE>
  Y.REL.CT = DCOUNT(Y.RELATION.CODES,VM)
  Y.CT.RELATION = 1

  LOOP
  WHILE Y.CT.RELATION LE Y.REL.CT
    Y.REL.CODE = Y.RELATION.CODES<1,Y.CT.RELATION>
    IF Y.REL.CODE GE 530 AND Y.REL.CODE LE 549 THEN
      Y.JOINT.AC = Y.JOINT.HOLDERS<1,Y.CT.RELATION>
      GOSUB JOINT.NAMES
    END
    Y.CT.RELATION += 1
  REPEAT
  Y.DISP.JOINT.NAME.FIN = Y.DISP.JOINT.NAME
  Y.JOINT.DOC.NUM.FIN = Y.JOINT.DOC.NUM
  RETURN
*--------------------------------------------------------------------------------------------------------------
JOINT.NAMES:
***************
*5 RD FLD REP NAME
  CALL F.READ(FN.CUSTOMER,Y.JOINT.AC,R.CUST.JOINT,F.CUSTOMER,CUSTOMER.ERR)
  Y.JOINT<-1> = Y.JOINT.AC
  IF R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.TIPO.POS> EQ "PERSONA FISICA" THEN
    Y.DISP.JOINT.NAME<1,-1> = R.CUST.JOINT<EB.CUS.GIVEN.NAMES>:" ":R.CUST.JOINT<EB.CUS.FAMILY.NAME>
  END ELSE
    IF R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.TIPO.POS> EQ "PERSONA JURIDICA" THEN
      Y.DISP.JOINT.NAME<1,-1>  = R.CUST.JOINT<EB.CUS.NAME.1,1>:" ":R.CUST.JOINT<EB.CUS.NAME.2,1>
    END
  END
*6 TH FLD REP DOC NAME
  BEGIN CASE
  CASE R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE ''
    Y.JOINT.DOC.NUM<1,-1> = R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>


  CASE R.CUST.JOINT<EB.CUS.LEGAL.ID,1> NE ''
    Y.JOINT.DOC.NUM<1,-1> =  R.CUST.JOINT<EB.CUS.LEGAL.ID,1>

  CASE  R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.RNC.POS> NE ''

    Y.JOINT.DOC.NUM<1,-1> = R.CUST.JOINT<EB.CUS.LOCAL.REF,L.CU.RNC.POS>

  END CASE
  RETURN
*---------------------------------------------------------------------------------------------------------------
END
