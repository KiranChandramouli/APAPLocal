SUBROUTINE E.REDO.CCRG.NOF.RL.BAL.DET(DATA.ENQ)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is an Nofile routine as a part of enquiry E.REDO.CCRG.RL.BAL.DET for
* B.5 CONTROL OF LINKED CUSTOMERS AND RISK GROUPS.
*
*
* Input/Output:
*--------------
* IN : CUSTOMER.ID, RISK.LIMIT, RISK.GROUP, TITLE, CUSTOMER.NAME,
*      RISK.GROUP.DESC, TOTAL.APPROVED, AVAILABLE.AMT
* OUT : DATA.ENQ (ALL DATA)
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 3-MAY-2011     RMONDRAGON            ODR-2011-03-0154          FIRST VERSION
*
*-----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CCRG.RL.BAL.DET
* </region>
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPEN.FILE
    GOSUB GET.SEL.DATA
    GOSUB GET.HEAD.DATA
    GOSUB GET.TYPE.DETAIL
    GOSUB GET.DATA.DETAIL
    IF PROCESS.GOAHEAD EQ 1 THEN
        GOSUB GET.ENQUIRY
    END

RETURN

*****
INIT:
*****
    PROCESS.GOAHEAD = 1
    Y.TYPE.DETAIL   = ''
    R.RL.BAL.DET    = ''
    Y.HEAD.DETAIL   = 'TIPO DE PRODUCTO*BALANCE DIRECTO*BALANCE RENDIMIENTOS P/COBRAR*BALANCE CONTINGENCIAS'
    Y.HEAD.DETAIL.1 = '*TOTAL'
    Y.HEAD.DETAIL.2 = '*TOTAL APROBADO*TOTAL TOMADO*TOTAL DISPONIBLE'

RETURN

**********
OPEN.FILE:
**********

    FN.REDO.CCRG.RL.BAL.DET = 'F.REDO.CCRG.RL.BAL.DET'
    F.REDO.CCRG.RL.BAL.DET  = ''
    CALL OPF(FN.REDO.CCRG.RL.BAL.DET,F.REDO.CCRG.RL.BAL.DET)

RETURN

*************
GET.SEL.DATA:
*************

    LOCATE 'CUSTOMER.ID' IN D.FIELDS<1> SETTING CUSTOMER.ID.POS THEN
        Y.CUSTOMER.ID = D.RANGE.AND.VALUE<CUSTOMER.ID.POS>
    END

    LOCATE 'RISK.LIMIT' IN D.FIELDS<1> SETTING RISK.LIMIT.POS THEN
        Y.RISK.LIMIT = D.RANGE.AND.VALUE<RISK.LIMIT.POS>
    END

    LOCATE 'RISK.GROUP' IN D.FIELDS<1> SETTING RISK.GROUP.POS THEN
        Y.RISK.GROUP = D.RANGE.AND.VALUE<RISK.GROUP.POS>
    END

    LOCATE 'TITLE' IN D.FIELDS<1> SETTING TITLE.POS THEN
        Y.TITLE = D.RANGE.AND.VALUE<TITLE.POS>
    END

    LOCATE 'CUSTOMER.NAME' IN D.FIELDS<1> SETTING CUSTOMER.NAME.POS THEN
        Y.CUSTOMER.NAME = D.RANGE.AND.VALUE<CUSTOMER.NAME.POS>
    END

    LOCATE 'RISK.GROUP.DESC' IN D.FIELDS<1> SETTING RISK.GROUP.DESC.POS THEN
        Y.RISK.GROUP.DESC = D.RANGE.AND.VALUE<RISK.GROUP.DESC.POS>
    END

    LOCATE 'TOTAL.APPROVED' IN D.FIELDS<1> SETTING TOTAL.APPROVED.POS THEN
        Y.TOTAL.APPROVED = D.RANGE.AND.VALUE<TOTAL.APPROVED.POS>
    END

    LOCATE 'AVAILABLE.AMT' IN D.FIELDS<1> SETTING AVAILABLE.AMT.POS THEN
        Y.AVAILABLE.AMT = D.RANGE.AND.VALUE<AVAILABLE.AMT.POS>
    END


RETURN

**************
GET.HEAD.DATA:
**************

    IF Y.RISK.LIMIT NE 'GLOBAL.LINKED' AND Y.RISK.LIMIT NE 'GLOBAL.EMPLOYEES' THEN
        Y.HEAD.DATA<-1> = "CODIGO CLIENTE: *":Y.CUSTOMER.ID:"*":Y.CUSTOMER.NAME
        IF Y.RISK.GROUP THEN
            Y.HEAD.DATA<-1> = "GRUPO RIESGO: *":Y.RISK.GROUP:"*":Y.RISK.GROUP.DESC
        END
    END

RETURN

****************
GET.TYPE.DETAIL:
****************

    IF Y.RISK.LIMIT MATCHES 'RISK.GROUP.SECURED' : @VM : 'RISK.GROUP.TOTAL' : @VM : 'RISK.GROUP.UNSECURED' THEN
        Y.TYPE.DETAIL = 2         ;*Risk Group
    END ELSE
        Y.TYPE.DETAIL = 1         ;*No Risk Limit HOUSING.PLAN.APAP
        IF Y.RISK.LIMIT EQ 'HOUSING.PLAN.APAP' THEN
            Y.TYPE.DETAIL = 0
        END
    END

RETURN

****************
GET.DATA.DETAIL:
****************

    IF Y.RISK.LIMIT EQ 'HOUSING.PLAN.APAP' THEN
        Y.DATA.DET = 'No aplica Detalle por Producto'
        RETURN
    END

    R.RL.BAL.DET  = 'SELECT ':FN.REDO.CCRG.RL.BAL.DET
    R.RL.BAL.DET := ' WITH CUSTOMER.ID EQ ':Y.CUSTOMER.ID

    IF Y.RISK.LIMIT MATCHES "RISK.GROUP.SECURED": @VM :"RISK.GROUP.UNSECURED": @VM :"RISK.GROUP.TOTAL"  THEN
        R.RL.BAL.DET := ' AND RISK.LIMIT.ID EQ RISK.GROUP.SECURED RISK.GROUP.UNSECURED RISK.GROUP.TOTAL'
        IF Y.RISK.GROUP NE '' THEN
            R.RL.BAL.DET := ' AND RISK.GROUP.ID EQ ':Y.RISK.GROUP
        END ELSE
            PROCESS.GOAHEAD = 0
            ENQ.ERROR<-1>= "ST-REDO.CCRG.PARAM.MISS.RG"
        END
    END ELSE
        R.RL.BAL.DET := ' AND RISK.LIMIT.ID EQ ':Y.RISK.LIMIT
    END
    CALL S.REDO.CCRG.GET.DETAIL('1',Y.TYPE.DETAIL,R.RL.BAL.DET,Y.TOTAL.APPROVED,Y.AVAILABLE.AMT,Y.DATA.DET)

RETURN

************
GET.ENQUIRY:
************

    IF Y.TYPE.DETAIL EQ 0 THEN
        DATA.ENQ = Y.DATA.DET
        RETURN
    END

    IF Y.TYPE.DETAIL EQ 1 THEN
        Y.HEAD.DATA2<-1> = Y.HEAD.DETAIL:Y.HEAD.DETAIL.1
    END

    IF Y.TYPE.DETAIL EQ 2 THEN
        Y.HEAD.DATA2<-1> = Y.HEAD.DETAIL:Y.HEAD.DETAIL.2
    END

    IF Y.RISK.LIMIT MATCHES 'GLOBAL.LINKED':@VM:'GLOBAL.EMPLOYEES' THEN
        DATA.ENQ = Y.HEAD.DATA2:@FM:Y.DATA.DET
    END ELSE
        DATA.ENQ = Y.HEAD.DATA:@FM:Y.HEAD.DATA2:@FM:Y.DATA.DET
    END

RETURN

END
