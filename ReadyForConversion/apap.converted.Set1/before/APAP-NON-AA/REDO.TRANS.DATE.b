*-----------------------------------------------------------------------------
* <Rating>-19</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TRANS.DATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.TRANS.DATE
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
* 20.12.2010           Manju G          ODR-2010-12-0495           Initial Creation
* 28.06.2011           Marimuthu S      PACS00080561
**********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_ENQUIRY.COMMON

  Y.ID=O.DATA
  Y.DATE = TODAY[7,2]
  Y.MONTH.POS = TODAY[5,2]

  Y.MONTH = "ENERO":FM:"FEBRERO":FM:"MARZO":FM:"ABRIL":FM:"MAYO":FM:"JUNIO":FM:"JULIO":FM:"AGOSTO":FM:"SEPTIEMBRE":FM:"OCTUBRE":FM:"NOVIEMBRE":FM:"DICIEMBRE"
  Y.MONTH.ES = Y.MONTH<Y.MONTH.POS>

**PACS00080561 - S
  IN.YEAR=TODAY[1,4]
  Y.CK.YR = IN.YEAR/100
  Y.CK.YR = FIELD(Y.CK.YR,'.',1)
  Y.CK.YR = Y.CK.YR*100
**PACS00080561 - E
  OUT.YEAR=''
  LANGUAGE='ES'
  LINE.LENGTH=100
  NO.OF.LINES=1
  ERR.MSG=''
  CALL DE.O.PRINT.WORDS(Y.CK.YR,OUT.YEAR,LANGUAGE,LINE.LENGTH,NO.OF.LINES,ERR.MSG)
*    DOS*MIL*Y*NUEVE

  OUT.YEAR1 = CHANGE(OUT.YEAR,'*',' ')

*   OUT.YEAR1 = FIELD(OUT.YEAR,'*',1)


**PACS00080561 - S
*    IN.YEAR=TODAY[3,2]
*    IN.YEAR = TRIM(IN.YEAR,"0","L")
  Y.CK1.YR = MOD(IN.YEAR,100)
  OUT.YEAR=''
  LANGUAGE='ES'
  LINE.LENGTH=100
  NO.OF.LINES=1
  ERR.MSG=''
  CALL DE.O.PRINT.WORDS(Y.CK1.YR,OUT.YEAR,LANGUAGE,LINE.LENGTH,NO.OF.LINES,ERR.MSG)
  OUT.YEAR2 = CHANGE(OUT.YEAR,'*',' ')
*  OUT.YEAR2 =   FIELD(OUT.YEAR,'*',1)
**PACS00080561 - E
  Y.FINAL.YR = TODAY[1,4]
  Y.OPEN = "("
  Y.CLOSE = ")"
**PACS00080561 - S
  Y.DISP.YEAR = OUT.YEAR1:' ':OUT.YEAR2
**PACS00080561 - E
  O.DATA = "FD7=" : Y.DATE : "^^FD8=" : Y.MONTH.ES : "^^FD9=" : Y.DISP.YEAR : "^^FD10=" : Y.FINAL.YR
  RETURN
END
