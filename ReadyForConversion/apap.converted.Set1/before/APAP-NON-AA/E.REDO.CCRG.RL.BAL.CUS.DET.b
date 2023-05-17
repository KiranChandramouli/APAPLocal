*-----------------------------------------------------------------------------
* <Rating>-64</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE E.REDO.CCRG.RL.BAL.CUS.DET(DATA.ENQ)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : SANTIAGO JIJON R. - RTAM
*--------------------------------------------------------------------------------------------
* Description: This routine is a NOFILE routine for an enquiry
*
* Linked With:
*             ENQUIRY E.REDO.CCRG.RL.BAL.DET
*
* In Parameter:
*               NONE
*
* Out Parameter:
*               DATA.ENQ
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 10/05/2011 - ODR-2011-03-0154
*              Description of the development associated
*              ejijon@temenos.com
*
*--------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD EQ 1 THEN
    GOSUB PROCESS
  END

*
  RETURN
*
*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------
  PROCESS.GOAHEAD = 1
  LOOP.CNT=1
  MAX.LOOPS = 7
  Y.POS.ID = 0
  Y.TYPE.DETAIL = 0
  Y.CUSTOMER.ID = ""
  Y.RISK.LIMIT = ""
  Y.RISK.GROUP = ""
  Y.TITLE = ""
  Y.RISK.GROUP.DESC = ""
  Y.TOTAL.APPROVED = 0
  Y.AVAILABLE.AMT = 0
  R.DATA.DETAIL = ""

  Y.HEADER.DETAIL='CODIGO CLIENTE*ID CLIENTE*NOMBRE CLIENTE'
  Y.HEADER.DETAIL.1 = Y.HEADER.DETAIL: '*TIPO DE PRODUCTO*BALANCE DIRECTO*BALANCE RENDIMIENTOS P/COBRAR*BALANCE CONTINGENCIAS*TOTAL'
  Y.HEADER.DETAIL.2 = Y.HEADER.DETAIL: '***TOTAL TOMADO SIN GARANTIA*TOTAL TOMADO CON GARANTIA*TOTAL TOMADO'
  Y.HEADER.DETAIL.3 = Y.HEADER.DETAIL: '*TOTAL PRESTAMO'

  RETURN

*--------------------------------------------------------------------------------------------
OPEN.FILES:
*--------------------------------------------------------------------------------------------
  FN.REDO.CCRG.RL.BAL.CUS.DET="F.REDO.CCRG.RL.BAL.CUS.DET"
  F.REDO.CCRG.RL.BAL.CUS.DET=""
  CALL OPF(FN.REDO.CCRG.RL.BAL.CUS.DET,F.REDO.CCRG.RL.BAL.CUS.DET)

  RETURN


*--------------------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*--------------------------------------------------------------------------------------------

  AZPOS="CUSTOMER.ID#RISK.LIMIT#RISK.GROUP#TITLE#RISK.GROUP.DESC#TOTAL.APPROVED#AVAILABLE.AMT"
  AZVAR="Y.CUSTOMER.ID": FM :"Y.RISK.LIMIT": FM :"Y.RISK.GROUP": FM :"Y.TITLE": FM :"Y.RISK.GROUP.DESC": FM :"Y.TOTAL.APPROVED": FM :"Y.AVAILABLE.AMT"
  AZERR="ST-REDO.CCRG.PARAM.MISS.CUS": FM :"ST-REDO.CCRG.PARAM.MISS.RL": FM :"ST-REDO.CCRG.PARAM.MISS.RG": FM :"ST-REDO.CCRG.PARAM.MISS.TIT": FM :"ST-REDO.CCRG.PARAM.MISS.RGD": FM :"ST-REDO.CCRG.PARAM.MISS.TOTAPP": FM :"ST-REDO.CCRG.PARAM.MISS.TOTAV"
  FOR LOOP.CNT=1 TO MAX.LOOPS
    Y.MEN.POS = FIELD(AZPOS,"#",LOOP.CNT)
    IF LOOP.CNT EQ 3 OR LOOP.CNT EQ 5  THEN
      IF AZVAR<2,2> EQ "RISK.GROUP.SECURED" OR AZVAR<2,2> EQ "RISK.GROUP.UNSECURED" OR AZVAR<2,2> EQ "RISK.GROUP.TOTAL"  THEN
        LOCATE Y.MEN.POS IN D.FIELDS<1> SETTING Y.POS.ID THEN
          AZVAR<LOOP.CNT,-1>=D.RANGE.AND.VALUE <Y.POS.ID>
        END ELSE
          PROCESS.GOAHEAD = 0
*ENQ.ERROR<-1>= "ST-REDO.CCRG.PARAMETER.MISSING"
          ENQ.ERROR<-1>= AZERR<LOOP.CNT>
        END
      END
    END ELSE
      LOCATE Y.MEN.POS IN D.FIELDS<1> SETTING Y.POS.ID THEN
        AZVAR<LOOP.CNT,-1>=D.RANGE.AND.VALUE <Y.POS.ID>
      END ELSE
        PROCESS.GOAHEAD = 0
*ENQ.ERROR<-1>= "ST-REDO.CCRG.PARAMETER.MISSING"
        ENQ.ERROR<-1>= AZERR<LOOP.CNT>
      END
    END

    IF PROCESS.GOAHEAD EQ 0 THEN
      EXIT
    END

  NEXT LOOP.CNT
  Y.CUSTOMER.ID=AZVAR<1,2>
  Y.RISK.LIMIT=AZVAR<2,2>
  Y.RISK.GROUP=AZVAR<3,2>
  Y.TITLE=AZVAR<4,2>
  Y.RISK.GROUP.DESC=AZVAR<5,2>
  Y.TOTAL.APPROVED=AZVAR<6,2>
  Y.AVAILABLE.AMT=AZVAR<7,2>

  RETURN

*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------
  GOSUB GET.TYPE.DETAIL
  GOSUB GET.HEAD.DATA
  GOSUB GET.DATA.DETAIL


  BEGIN CASE
  CASE Y.TYPE.DETAIL = 1
    DATA.ENQ = Y.HEAD.DATA:FM:Y.HEADER.DETAIL.1:FM:R.DATA.DETAIL
  CASE Y.TYPE.DETAIL = 2
    DATA.ENQ = Y.HEAD.DATA:FM:Y.HEADER.DETAIL.2:FM:R.DATA.DETAIL
  CASE Y.TYPE.DETAIL = 3
    DATA.ENQ = Y.HEAD.DATA:FM:Y.HEADER.DETAIL.3:FM:R.DATA.DETAIL
  CASE 1
    DATA.ENQ = "**No aplica Detalle por Cliente"
  END CASE



  RETURN


*--------------------------------------------------------------------------------------------
GET.TYPE.DETAIL:
*--------------------------------------------------------------------------------------------

  BEGIN CASE
  CASE Y.RISK.LIMIT MATCHES "GLOBAL.EMPLOYEES" : VM : "GLOBAL.LINKED"
    Y.TYPE.DETAIL = 1         ;*Vinculados

  CASE Y.RISK.LIMIT MATCHES "RISK.GROUP.SECURED" : VM : "RISK.GROUP.TOTAL" : VM : "RISK.GROUP.UNSECURED"
    Y.TYPE.DETAIL = 2         ;*Grupo de Riesgo

  CASE Y.RISK.LIMIT  EQ "HOUSING.PLAN.APAP"
    Y.TYPE.DETAIL = 3         ;*Vivienda APAP

  END CASE

  RETURN

*--------------------------------------------------------------------------------------------
GET.HEAD.DATA:
*--------------------------------------------------------------------------------------------

  Y.HEAD.DATA<1>= " "
  IF Y.RISK.GROUP THEN
    Y.HEAD.DATA<1> = "GRUPO DE RIESGO:"
    Y.HEAD.DATA<1> := "*" : Y.RISK.GROUP
    Y.HEAD.DATA<1> := "*" : Y.RISK.GROUP.DESC
  END

  RETURN

*--------------------------------------------------------------------------------------------
GET.DATA.DETAIL:
*--------------------------------------------------------------------------------------------


  SELECT.STATEMENT = "SELECT ":FN.REDO.CCRG.RL.BAL.CUS.DET:" WITH CUSTOMER.ID EQ ": Y.CUSTOMER.ID
  IF AZVAR<3,2> THEN
* Only for Risk Group
    SELECT.STATEMENT := " AND RISK.GROUP.ID EQ '": Y.RISK.GROUP : "'"
    SELECT.STATEMENT := ' AND RISK.LIMIT.ID EQ RISK.GROUP.SECURED RISK.GROUP.UNSECURED ORDER BY REL.CUS.ID'
  END ELSE
* Risk Limit without Risk Group
    SELECT.STATEMENT := " AND RISK.LIMIT.ID EQ '": Y.RISK.LIMIT : "'"
  END


  REDO.CCRG.RL.BAL.CUS.DET.LIST = ''
  LIST.NAME = ''
  SELECTED = ''
  SYSTEM.RETURN.CODE = ''
  CALL EB.READLIST(SELECT.STATEMENT,REDO.CCRG.RL.BAL.CUS.DET.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

  LOOP
    REMOVE Y.ID FROM REDO.CCRG.RL.BAL.CUS.DET.LIST SETTING POS
  WHILE Y.ID:POS
    R.IN.RL.BAL.DET=SELECT.STATEMENT
    Y.ERR=''
    CALL F.READ(FN.REDO.CCRG.RL.BAL.CUS.DET,Y.ID,R.RL.BAL.CUS.DET,F.REDO.CCRG.RL.BAL.CUS.DET,Y.ERR)
    CALL S.REDO.CCRG.GET.DETAIL(2, Y.TYPE.DETAIL, R.IN.RL.BAL.DET, Y.TOTAL.APPROVED,Y.AVAILABLE.AMT, R.DATA.DETAIL)

  REPEAT
  RETURN
END
