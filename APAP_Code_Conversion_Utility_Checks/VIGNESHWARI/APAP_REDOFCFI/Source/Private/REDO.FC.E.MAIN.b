* @ValidationCode : Mjo3MDc1ODYzNTA6Q3AxMjUyOjE3MDI1NTYxNjY2MTI6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Dec 2023 17:46:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.E.MAIN(Y.CUS.ID,DATA.ENQ)
*
******************************************************************************
*
* Subroutine Type : NOFILE ROUTINE
* Attached to     : ENQ E.REDO.CCRG.RL.BAL.MAIN
* Attached as     : NOFILE ROUTINE
* Primary Purpose : Extract information from REDO.CCRG.RL.BAL.MAIN
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* DATA.ENQ - data returned to the enquiry
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP  ODR-2011-03-0154  B.5
* Development by  : Adriana Velasco - TAM Latin America
* Date            : Apr.13, 2011
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 VM TO @VM ,FM TO @FM SM TO @SM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*14-12-2023             VIGNESHWARI                 MANUAL R22 CODE CONVERSION              Change "read" to "CACHE.READ"
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.CUSTOMER
    $INSERT I_F.RELATION
    $INSERT I_F.EB.LOOKUP
*
    $INSERT I_F.REDO.CCRG.RL.BAL.MAIN
    $INSERT I_F.REDO.RISK.GROUP
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM

*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
* Get Detail of the enquiry

    GOSUB GET.DATA.DETAIL
    IF PROCESS.GOAHEAD THEN
* Get Headerof the enquiry

* Populate output variable
        CHANGE @VM TO "*" IN R.DETAIL

        DATA.ENQ<-1> = R.DETAIL

    END
*
RETURN
*

* =============
GET.DATA.DETAIL:
* =============
*
*  Get info from REDO.CCRG.RL.BAL.MAIN

* Read data for the Y.CUSTOMER.ID from REDO.CCRG.RL.BAL.MAIN
    R.REDO.CCRG.RL.BAL.MAIN = ''
    CALL F.READ(FN.REDO.CCRG.RL.BAL.MAIN,Y.CUSTOMER.ID,R.REDO.CCRG.RL.BAL.MAIN,F.REDO.CCRG.RL.BAL.MAIN,Y.ERR)
    IF NOT(R.REDO.CCRG.RL.BAL.MAIN) THEN
        Y.TEXT = "ST-REDO.CCRG.BAL.NO.EXIST.BY.CUSTOMER"

        PROCESS.GOAHEAD = 0
    END
*
    IF PROCESS.GOAHEAD THEN
* Display data acording the Risk Limit Param
        GOSUB PROCESS.RISK.LIMIT.GROUP
    END
*
RETURN
*

* =======================
PROCESS.RISK.LIMIT.GROUP:
* =======================
*
* For each Risk.Limt & Risk.Group

* Set data about Risk Limit definition
    Y.RISK.LIMIT = R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.RISK.LIMIT.ID>
    Y.RISK.GROUP = R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.RISK.GROUP.ID>
    Y.USE.AMNT   = R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.USED.AMOUNT>

* Get total Risk Limit that apply to the Customer to consult
    Y.NO.FIELDS = DCOUNT(Y.RISK.LIMIT,@VM)
    IF Y.NO.FIELDS EQ 0 THEN
        Y.TEXT = "ST-REDO.LIMITS.NOT.EXIST"

        PROCESS.GOAHEAD = 0
    END

* Set detail by every Risk Limit to the Customer
    IF PROCESS.GOAHEAD THEN
        FOR Y.LIM.POS = 1 TO Y.NO.FIELDS
* Read param for the Risk Limit
            Y.LIMIT.ID = Y.RISK.LIMIT<1,Y.LIM.POS>

*            CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.LIMIT.ID,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARM,Y.ERR)
CALL CACHE.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.LIMIT.ID,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARM,Y.ERR);*MANUAL R22 CODE CONVERSION -Change "read" to "CACHE.READ"
            IF NOT(R.REDO.CCRG.RISK.LIMIT.PARAM) THEN
                Y.TEXT = "ST-REDO.CCRG.RISK.LIMIT.NOT.FOUND"

                PROCESS.GOAHEAD = 0
            END
* Get flag to show Available Amount
            Y.SHOW.AVAI.MNT = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.FSHOW.TDIS>
* Get Description
            GOSUB GET.RISK.LIMIT.DESC
* Get Amounts
            GOSUB GET.RISK.LIMIT.AMT
        NEXT Y.LIM.POS
    END
*
RETURN
*

* ===================
GET.RISK.LIMIT.DESC:
* ===================
*
*  Get data by every Risk Limit
*
* Set description by every Risk Limit
    IF PROCESS.GOAHEAD THEN
* Get description Risk Limit
        GOSUB GET.DESC.LIMIT
* Set type format enquiry accoording of the type Risk Limit
        IF NOT(Y.LIMIT.ID MATCHES 'RISK.INDIV.SECURED' : @VM : 'RISK.INDIV.UNSECURED' : @VM : 'RISK.INDIV.TOTAL') THEN
            Y.RELATED.CUS = '1'
        END
* Get description of the Risk Group
        Y.RISK.GROUP.ID = Y.RISK.GROUP<1,Y.LIM.POS>
        IF Y.RISK.GROUP.ID THEN
            Y.RISK.DESC = ''
            CALL F.READ(FN.REDO.RISK.GROUP,Y.RISK.GROUP.ID,R.REDO.RISK.GROUP,F.REDO.RISK.GROUP,Y.ERR)
            Y.RISK.DESC = R.REDO.RISK.GROUP<RG.GRP.SHORT.DESC>
            IF Y.LIMIT.DESC THEN
                Y.LIMIT.DESC := '-':Y.RISK.DESC
            END ELSE
                Y.LIMIT.DESC = Y.RISK.DESC
            END
            CHANGE " " TO "." IN Y.LIMIT.DESC
        END
* Title to next enquiries
        Y.RL.GNRAL.DESC = Y.LIMIT.DESC
        CHANGE ' ' TO '.' IN Y.RL.GNRAL.DESC
        IF Y.LIMIT.ID MATCHES 'RISK.GROUP.TOTAL':@VM:'RISK.GROUP.SECURED':@VM:'RISK.GROUP.UNSECURED' THEN
            Y.RL.GNRAL.DESC = "LIMITE.DE.CREDITO.GRUPO.DE.RIESGO"
        END
    END
*
RETURN
*

* =============
GET.DESC.LIMIT:
* =============
*
* Get Description
*

* Get Risk Limit Description from EB.LOOKUP
    Y.EB.LOOK.ID = 'REDO.CCRG.LIMIT*':Y.LIMIT.ID
    CALL F.READ(FN.EB.LOOKUP,Y.EB.LOOK.ID,R.EB.LOOKUP,F.EB.LOOKUP,Y.ERR)
    Y.DESCRIPTION = R.EB.LOOKUP<EB.LU.DESCRIPTION>
    IF Y.DESCRIPTION<1,LNGG> NE '' THEN
        Y.LIMIT.DESC = Y.DESCRIPTION<1,LNGG>
    END ELSE
        Y.LIMIT.DESC = Y.DESCRIPTION<1,1>
    END
*
RETURN
*

* =================
GET.RISK.LIMIT.AMT:
* =================
*
*  Get amounts by every Risk Limit
*

*  Used Amount
    Y.USED.AMOUNT  =  Y.USE.AMNT<1,Y.LIM.POS>
    IF NOT(Y.USED.AMOUNT) THEN
        Y.USED.AMOUNT = 0
    END

*  Aproved Amount
    GOSUB GET.APROVED.AMOUNT.TO.RISK.TOTAL

*  Available Amount
* Consider in REDO.CCRG.RISK.LIMIT.PARAM the flag to show Available Amount
    IF Y.SHOW.AVAI.MNT NE 'NO' THEN
        IF Y.LIMIT.ID EQ 'HOUSING.PLAN.APAP' THEN
*This information does not to show for the HOUSING.PLAN.APAP Risk Limit
            Y.AVAILABLE.AMT = ''
        END ELSE
            Y.AVAILABLE.AMT = Y.MAX.AMOUNT - Y.USED.AMOUNT
* Set format amount
            Y.AVAILABLE.AMT = FMT(Y.AVAILABLE.AMT,"R2,#30")
        END
    END ELSE
        Y.AVAILABLE.AMT = ''
    END
*
*  Set format amount
    Y.USED.AMOUNT   = FMT(Y.USED.AMOUNT,"R2,#30")
*
    TITLE = 'TITLE'
*
    R.DETAIL<-1> = Y.LIMIT.ID: @VM :Y.LIMIT.DESC : @VM : Y.USED.AMOUNT : @VM : Y.AVAILABLE.AMT
*
RETURN
*

* ===============================
GET.APROVED.AMOUNT.TO.RISK.TOTAL:
* ===============================
*
* Get Aproved Amount to Risk Group Total and Risk Indiv Total
*
    Y.MAX.AMOUNT = 0
* Aproved Amount to Risk Total
    IF Y.LIMIT.ID MATCHES 'RISK.GROUP.TOTAL':@VM:'RISK.INDIV.TOTAL'  THEN
        Y.APP.AMT.RL.SEC   = 0
        Y.APP.AMT.RL.UNSEC = 0
        Y.RL.SEC   = 'RISK.GROUP.SECURED'
        Y.RL.UNSEC = 'RISK.GROUP.UNSECURED'
        IF Y.LIMIT.ID EQ 'RISK.INDIV.TOTAL' THEN
            Y.RL.SEC   = 'RISK.INDIV.SECURED'
            Y.RL.UNSEC = 'RISK.INDIV.UNSECURED'
        END
 *       CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RL.SEC,R.RL.SEC,F.REDO.CCRG.RISK.LIMIT.PARM,Y.ERR)
 CALL CACHE.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RL.SEC,R.RL.SEC,F.REDO.CCRG.RISK.LIMIT.PARM,Y.ERR) ;*MANUAL R22 CODE CONVERSION -Change "read" to "CACHE.READ"
 *       CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RL.UNSEC,R.RL.UNSEC,F.REDO.CCRG.RISK.LIMIT.PARM,Y.ERR)
  CALL CACHE.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RL.UNSEC,R.RL.UNSEC,F.REDO.CCRG.RISK.LIMIT.PARM,Y.ERR)    ;*MANUAL R22 CODE CONVERSION -Change "read" to "CACHE.READ"
        IF R.RL.SEC<REDO.CCRG.RLP.MAX.AMOUNT> THEN
            Y.APP.AMT.RL.SEC = R.RL.SEC<REDO.CCRG.RLP.MAX.AMOUNT>
        END
        IF R.RL.UNSEC<REDO.CCRG.RLP.MAX.AMOUNT> THEN
            Y.APP.AMT.RL.UNSEC = R.RL.UNSEC<REDO.CCRG.RLP.MAX.AMOUNT>
        END
        Y.MAX.AMOUNT = Y.APP.AMT.RL.SEC + Y.APP.AMT.RL.UNSEC
    END ELSE
* Aproved Amount to all Risk Limits
        IF R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.AMOUNT> THEN
            Y.MAX.AMOUNT = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.AMOUNT>
        END
    END
*
RETURN
*

* ============

* =========
INITIALISE:
* =========
*
    PROCESS.GOAHEAD  = 1
    DATA.EACH.PLAN   = ""
*    Y.SEP.LINE       = CHAR(13):CHAR(10)
    Y.SEP.LINE  = '-'
*
RETURN
*

* =========
OPEN.FILES:
* =========
*
    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
*
    FN.REDO.CCRG.RL.BAL.MAIN = 'F.REDO.CCRG.RL.BAL.MAIN'
    F.REDO.CCRG.RL.BAL.MAIN  = ""
    CALL OPF(FN.REDO.CCRG.RL.BAL.MAIN,F.REDO.CCRG.RL.BAL.MAIN)
*
    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)
*
    FN.REDO.RISK.GROUP = 'F.REDO.RISK.GROUP'
    F.REDO.RISK.GROUP  = ''
    CALL OPF(FN.REDO.RISK.GROUP,F.REDO.RISK.GROUP)
*
    FN.REDO.CCRG.RISK.LIMIT.PARAM = 'F.REDO.CCRG.RISK.LIMIT.PARAM'
    F.REDO.CCRG.RISK.LIMIT.PARM  = ''
    CALL OPF(FN.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARM)
*
    FN.EB.LOOKUP   = 'F.EB.LOOKUP'
    F.EB.LOOKUP    = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

*
RETURN
*

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
*
* Validate the customer code is input
    Y.SHORT.NAME.CUS = ''
    Y.CUSTOMER.ID = Y.CUS.ID

*LOCATE 'CUSTOMER.ID' IN D.FIELDS<1> SETTING Y.POS.ID THEN
*     Y.CUSTOMER.ID = D.RANGE.AND.VALUE <Y.POS.ID>
*END ELSE
*   Y.TEXT = "ST-REDO.CCRG.CUSTOMER.ID.MISSING"

*
*   PROCESS.GOAHEAD = 0
* END
* Validate Customer to consulta has information in CUSTOMER application
    IF PROCESS.GOAHEAD THEN
        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR)
        IF NOT(R.CUSTOMER) THEN
            Y.TEXT = "ST-REDO.CCRG.CUSTOMER.NOT.FOUND"

            PROCESS.GOAHEAD = 0
        END
    END
* Get Name Customer
    IF PROCESS.GOAHEAD THEN
        Y.SHORT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        IF Y.SHORT.NAME<1,LNGG> NE '' THEN
            Y.SHORT.NAME.CUS = Y.SHORT.NAME<1,LNGG>
        END ELSE
            Y.SHORT.NAME.CUS = Y.SHORT.NAME<1,1>
        END
    END
*
RETURN
*
END
