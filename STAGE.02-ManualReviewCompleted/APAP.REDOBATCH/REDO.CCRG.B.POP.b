* @ValidationCode : MjotMjIxNjIzNzk4OkNwMTI1MjoxNjgxNzM5NTQxNjI1OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 19:22:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.POP(P.IN.CUS.ID)
*
*--------------------------------------------------------------------------------------------
* Company Name : APAP
* Developed By : Temenos Application Management
*--------------------------------------------------------------------------------------------
* Description   : Multithread routine associated to the service REDO.CCRG.POP to take data from
*                 REDO.CCRG.CONTRACT.BAL to populate REDO.CCRG.RL.BAL.MAIN, REDO.CCRG.RL.BAL.DET
*                 and REDO.CCRG.RL.BAL.CUS.DET to generate reports.
*
* Linked With   : TSA.SERVICE - ID: REDO.CCRG.POP
* In Parameter  : P.IN.CUS.ID - Customer code of the customer consulted
* Out Parameter :
*--------------------------------------------------------------------------------------------
* Modification Details:
*--------------------------------------------------------------------------------------------
*
* 07/04/2011 - ODR-2011-03-0154  Development for populate files to generate reports
* 12-09-2011 - Fix               Adjusment in the code. hpasquel@temenos.com
*REM Just for compile
*--------------------------------------------------------------------------------------------
* Modification History
* Company Name: APAP
* Developed By: Temenos Application Management
* Program Name: REDO.CCRG
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM 
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -ADDING PACKAGE TO CALL ROUTINE
*-------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.CCRG.B.POP.COMMON
*
    $INSERT I_F.REDO.CCRG.CONTRACT.BAL
    $INSERT I_F.REDO.CCRG.RL.BAL.CUS.DET
    $INSERT I_F.REDO.CCRG.RL.BAL.DET
    $INSERT I_F.REDO.CCRG.RL.BAL.MAIN
*--------------------------------------------------------------------------------------------

    GOSUB INITIALISE
    GOSUB PROCESS
*
RETURN
*
*--------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------

    Y.PRGRAPH.NAME = 'PROCESS'

* Delete files of the enquieries
    CALL REDO.CCRG.B.POP.DEL(P.IN.CUS.ID)
    Y.MAIN.ID = P.IN.CUS.ID

* Get all Risk Limits that apply TO Customer consulted
    GOSUB GET.RISK.LIMIT

* Update data en REDO.CCRG.RL.EFFECTIVE (monitor application)
    IF PROCESS.GOAHEAD THEN
        CALL S.REDO.CCRG.EFFECTIVE.REGISTER(P.IN.CUS.ID,R.MSG.ERR)
        IF R.MSG.ERR THEN
            GOSUB RAISE.ERROR
        END
    END

* Delete P.IN.CUS.ID from FN.REDO.CCRG.POP.QUEUE
    CALL F.DELETE(FN.REDO.CCRG.POP.QUEUE,P.IN.CUS.ID)

RETURN


*--------------------------------------------------------------------------------------------
GET.RISK.LIMIT:
*--------------------------------------------------------------------------------------------
*
* Get every Risk Limit to the Customer Consulted
*
    Y.PRGRAPH.NAME = 'GET.RISK.LIMIT'

* Get all Risk Limits that apply to Customer consulted
    Y.CUS.ID = P.IN.CUS.ID
    R.REDO.CCRG.RL.CUSTOMER = ''
    YERR    = ''
    CALL F.READ(FN.REDO.CCRG.RL.CUSTOMER,Y.CUS.ID,R.REDO.CCRG.RL.CUSTOMER,F.REDO.CCRG.RL.CUSTOMER,YERR)

    IF NOT(R.REDO.CCRG.RL.CUSTOMER) THEN
        R.MSG.ERR = 'ST-REDO.CCRG.NOT.EXIST.RL.LIST.TO.PROCESS.POP' : @FM : Y.CUS.ID : @VM : FN.REDO.CCRG.RL.CUSTOMER
        GOSUB RAISE.ERROR
    END

* Get array of the Risk Limit and Risk Group
    R.RISK.LIMIT = R.REDO.CCRG.RL.CUSTOMER<1>       ;*Risk Limit
    R.RISK.GROUP = R.REDO.CCRG.RL.CUSTOMER<2>       ;*Risk Group

* Sort by Risk Limit
    R.RISK.LIMIT.SORT = ''
    R.RISK.GROUP.SORT = ''
    R.LINK.1.SORT     = ''
    Y.TYPE.RL         = ''
    GOSUB SORT.RISK.LIMIT
* Sort by Risk Group
    Y.TYPE.RL         = 'RG'
    GOSUB SORT.RISK.GROUP
* Set sort RL
    R.RISK.LIMIT      = ''
    R.RISK.LIMIT      = R.RISK.LIMIT.SORT

* By every Risk Limit ID
    Y.RL.ID           = ''
    Y.RL.MARK         = ''
    Y.RL.SEQ          = 0
    R.RISK.LIMIT      = R.RISK.LIMIT.SORT

    LOOP
        REMOVE Y.RL.ID FROM R.RISK.LIMIT SETTING Y.RL.MARK
    WHILE Y.RL.ID : Y.RL.MARK

        Y.RL.SEQ += 1
        IF Y.RL.ID THEN
* Get Risk Group
            Y.RG.ID = ''
            Y.RG.ID = R.RISK.GROUP.SORT<Y.RL.SEQ>
*Populate R.REDO.CCRG.RL.BAL.MAIN
            Y.MAIN.ID = ''
            Y.MAIN.ID = P.IN.CUS.ID
*Populate R.REDO.CCRG.RL.BAL.DET and R.REDO.CCRG.RL.BAL.CUS.DET
            GOSUB SET.DATA.BY.ENQUIRY.FILE
        END
    REPEAT

*Save data by Risk Limit
*    GOSUB SAVE.DATA.RL.BAL.MAIN
*WRITE R.REDO.CCRG.RL.BAL.MAIN  TO F.REDO.CCRG.RL.BAL.MAIN,Y.MAIN.ID ;* PP *Tus Start
    CALL F.WRITE(FN.REDO.CCRG.RL.BAL.MAIN,Y.MAIN.ID,R.REDO.CCRG.RL.BAL.MAIN) ;*Tus End


RETURN

*--------------------------------------------------------------------------------------------
SORT.RISK.LIMIT:
*--------------------------------------------------------------------------------------------
*
* Sort data to save in every file for the enquiry
*
*Initialise
    Y.PRGRAPH.NAME = 'SORT.RISK.LIMIT'
    Y.RL.ID        = ''
    Y.RL.MARK      = ''
    R.RISK.LIMIT   = R.RISK.LIMIT
    LOOP
        REMOVE Y.RL.ID FROM R.RISK.LIMIT SETTING Y.RL.MARK
    WHILE Y.RL.ID : Y.RL.MARK
        Y.LOC.RL.POS = ''
*Get RL without RG
        IF NOT(Y.TYPE.RL) AND Y.RL.ID MATCHES R.RL.WITHOUT.RG THEN
            GOSUB LOCATE.POSITION.RL
            R.RISK.LIMIT.SORT<Y.LOC.RL.POS> = R.RISK.LIMIT.POS<Y.LOC.RL.POS>
            Y.SRT.RL.POS = Y.LOC.RL.POS
        END
*Get RL with RG
        IF Y.TYPE.RL AND Y.RL.ID MATCHES R.RL.WITH.RG THEN
*Get position in Rl
            GOSUB LOCATE.POSITION.RL
*Verify if the sequence has to increse
            Y.FIND.POS   = '1'
            Y.SRT.RL.POS = Y.LOC.RL.POS
            LOOP
            WHILE Y.FIND.POS
                IF R.RISK.LIMIT.SORT<Y.SRT.RL.POS> THEN
                    Y.SRT.RL.POS += 3
                END ELSE
                    Y.FIND.POS = '0'
                END
            REPEAT
*Set RL
            R.RISK.LIMIT.SORT<Y.SRT.RL.POS> = R.RISK.LIMIT.POS.RG<Y.LOC.RL.POS>
*Set RG
            R.RISK.GROUP.SORT<Y.SRT.RL.POS> = Y.RG.ID
        END

*Set Links
        IF Y.LOC.RL.POS THEN
            R.LINK.1.SORT<Y.SRT.RL.POS> = R.RISK.LIMIT.LINK.1<Y.LOC.RL.POS>
            R.LINK.2.SORT<Y.SRT.RL.POS> = R.RISK.LIMIT.LINK.2<Y.LOC.RL.POS>
        END
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------
SORT.RISK.GROUP:
*--------------------------------------------------------------------------------------------
*
* Sort data to save in every file for the enquiry
* by Risk Group and Risk Limit
*
    Y.PRGRAPH.NAME = 'SORT.RISK.GROUP'
    Y.TYPE.RL      = 'RG'
    Y.RG.ID        = ''
    Y.GROUP.MARK   = ''
    R.RISK.GROUP   = R.RISK.GROUP
    LOOP
        REMOVE Y.RG.ID FROM R.RISK.GROUP  SETTING Y.GROUP.MARK
    WHILE Y.RG.ID : Y.GROUP.MARK
        GOSUB SORT.RISK.LIMIT
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------
LOCATE.POSITION.RL:
*--------------------------------------------------------------------------------------------
*
*  Locate the prosition for the Risk Limit ID in R.RISK.LIMIT.POS array
*
    Y.PRGRAPH.NAME = 'LOCATE.POSITION.RL'

    IF NOT(Y.TYPE.RL) THEN
        LOCATE Y.RL.ID IN R.RISK.LIMIT.POS<1> SETTING Y.LOC.RL.POS THEN
        END
    END ELSE
        LOCATE Y.RL.ID IN R.RISK.LIMIT.POS.RG<1> SETTING Y.LOC.RL.POS THEN
        END
    END
RETURN

*--------------------------------------------------------------------------------------------
SET.DATA.BY.ENQUIRY.FILE:
*--------------------------------------------------------------------------------------------
*
* Set common data for every enquiry file
*

    Y.PRGRAPH.NAME = 'SET.DATA.BY.ENQUIRY.FILE'

*Set common data for every enquiry file
*-------------------------------------------
*Populate R.REDO.CCRG.RL.BAL.MAIN
    Y.RL.POS += 1
    R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.RISK.LIMIT.ID,Y.RL.POS> := Y.RL.ID

* Locate position for RL to set of links
*Y.LOC.RL.POS = Y.RL.SEQ
    R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.LINK.DET.1,Y.RL.POS> = R.LINK.1.SORT<Y.RL.SEQ>
    R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.LINK.DET.2,Y.RL.POS> = R.LINK.2.SORT<Y.RL.SEQ>

*Populate R.REDO.CCRG.RL.BAL.DET
    Y.ENQ.RL.BAL.DET.ID    = ''
    Y.ENQ.RL.BAL.DET.ID    = P.IN.CUS.ID : '-' : Y.RL.ID
    R.CONTRACT.TOTAL       = ''
    R.REDO.CCRG.RL.BAL.DET = ''
    R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.CUSTOMER.ID>   = P.IN.CUS.ID
    R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.RISK.LIMIT.ID> = Y.RL.ID

*Set data by Risk Group
*-------------------------------------------
    IF Y.RG.ID THEN
*Populate R.REDO.CCRG.RL.BAL.MAIN
        R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.RISK.GROUP.ID,Y.RL.POS> = Y.RG.ID
*Populate R.REDO.CCRG.RL.BAL.DET
        Y.ENQ.RL.BAL.DET.ID := '-' : Y.RG.ID
        R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.RISK.GROUP.ID> = Y.RG.ID
    END

*Populate R.REDO.CCRG.RL.BAL.CUS.DET
    GOSUB GET.RELATED.CUSTOMER

*Save data by Category Product
    IF PROCESS.GOAHEAD THEN
*        GOSUB SAVE.DATA.RL.BAL.DET

* WRITE R.REDO.CCRG.RL.BAL.DET TO F.REDO.CCRG.RL.BAL.DET,Y.ENQ.RL.BAL.DET.ID ;*Tus Start
        CALL F.WRITE(FN.REDO.CCRG.RL.BAL.DET,Y.ENQ.RL.BAL.DET.ID,R.REDO.CCRG.RL.BAL.DET);*Tus End
    END

RETURN

*--------------------------------------------------------------------------------------------
GET.RELATED.CUSTOMER:
*--------------------------------------------------------------------------------------------
*
* Get all Related Customer by Risk Limit
*

    Y.PRGRAPH.NAME = 'GET.RELATED.CUSTOMER'

    Y.RL.REL.CUS.ID = P.IN.CUS.ID : '-' : Y.RL.ID
    IF Y.RG.ID THEN
        Y.RL.REL.CUS.ID :=  '-' : Y.RG.ID
    END
*Get List Related Customer for the Risk Limit in process
    R.REDO.CCRG.RL.REL.CUS = ''
    YERR = ''
    CALL F.READ(FN.REDO.CCRG.RL.REL.CUS,Y.RL.REL.CUS.ID,R.REDO.CCRG.RL.REL.CUS,F.REDO.CCRG.RL.REL.CUS,YERR)
    IF NOT(R.REDO.CCRG.RL.REL.CUS) THEN
        R.MSG.ERR = 'ST-REDO.CCRG.NOT.EXIST.RELCUS.LIST.TO.PROCESS.POP' : @FM : Y.RL.REL.CUS.ID : @VM : FN.REDO.CCRG.RL.REL.CUS
        GOSUB RAISE.ERROR
    END

    Y.REL.CUS.ID   = ''
    Y.REL.CUS.MARK = ''
    R.REDO.CCRG.RL.REL.CUS = R.REDO.CCRG.RL.REL.CUS
    LOOP
        REMOVE Y.REL.CUS.ID FROM R.REDO.CCRG.RL.REL.CUS SETTING Y.REL.CUS.MARK
    WHILE Y.REL.CUS.ID : Y.REL.CUS.MARK
* Populate R.REDO.CCRG.RL.BAL.CUS.DET
        Y.ENQ.RL.REL.CUS.ID = ''
        Y.ENQ.RL.REL.CUS.ID = P.IN.CUS.ID : '-' : Y.REL.CUS.ID : '-' : Y.RL.ID
        R.REDO.CCRG.RL.BAL.CUS.DET  = ''
        R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.CUSTOMER.ID>   = P.IN.CUS.ID
        R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.REL.CUS.ID>    = Y.REL.CUS.ID
        R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.RISK.LIMIT.ID> = Y.RL.ID

* If Risk Group no apply set data without this value
        IF Y.RG.ID THEN
            Y.ENQ.RL.REL.CUS.ID := '-' : Y.RG.ID
            R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.RISK.GROUP.ID> = Y.RG.ID
        END

* Get Balance by Customer
        GOSUB GET.CONTRACT.BALANCE

*Save enquiry by Category Code
*        GOSUB SAVE.DATA.RL.BAL.CUS.DET

* WRITE R.REDO.CCRG.RL.BAL.CUS.DET  TO F.REDO.CCRG.RL.BAL.CUS.DET,Y.ENQ.RL.REL.CUS.ID ;*Tus Start
        CALL F.WRITE(FN.REDO.CCRG.RL.BAL.CUS.DET,Y.ENQ.RL.REL.CUS.ID,R.REDO.CCRG.RL.BAL.CUS.DET);*Tus End
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------
GET.CONTRACT.BALANCE:
*--------------------------------------------------------------------------------------------
*
* Get balance data by customer
*
    Y.PRGRAPH.NAME = 'GET.CONTRACT.BALANCE'

*Primary Owner
    Y.SEL.CMD = ''
    Y.SEL.CMD = 'SELECT ':FN.REDO.CCRG.CONTRACT.BAL:' WITH PRIMARY.OWNER  EQ '  : Y.REL.CUS.ID
    GOSUB GET.BALANCE.BY.RL

* Other Party
    Y.SEL.CMD = ''
    Y.SEL.CMD = 'SELECT ':FN.REDO.CCRG.CONTRACT.BAL:' WITH OTHER.PARTY  EQ '  : Y.REL.CUS.ID
    GOSUB GET.BALANCE.BY.RL

RETURN


*--------------------------------------------------------------------------------------------
GET.BALANCE.BY.RL:
*--------------------------------------------------------------------------------------------
*
* Get Data Balance by Risk Limit
*

    Y.PRGRAPH.NAME    = 'GET.BALANCE.BY.RL'

* Get contract list by role
    CONTRACT.BAL.LIST = ''
    LIST.NAME         = ''
    SELECTED          = ''
    SYS.RTN.CODE      = ''
    CALL EB.READLIST(Y.SEL.CMD,CONTRACT.BAL.LIST,LIST.NAME,SELECTED,SYS.RTN.CODE )

* Primary
    Y.CONTRACT.ID     = ''
    Y.CONTRACT.MARK   = ''
    CONTRACT.BAL.LIST = CONTRACT.BAL.LIST
    LOOP
        REMOVE Y.CONTRACT.ID FROM CONTRACT.BAL.LIST SETTING Y.CONTRACT.MARK
    WHILE Y.CONTRACT.ID : Y.CONTRACT.MARK
*Get balance by contract
        GOSUB READ.BALANCE.BY.RL
*Acum balance by type
        IF PROCESS.GOAHEAD THEN
            GOSUB ACUM.BALANCE
        END
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------
READ.BALANCE.BY.RL:
*--------------------------------------------------------------------------------------------
*
* Read REDO.CCRG.CONTRACT.BAL
*
*Initialize
    Y.PRGRAPH.NAME   = 'READ.BALANCE.BY.RL'
    Y.DIR.BALANCE    = 0
    Y.INT.RECEIVABLE = 0
    Y.CON.BALANCE    = 0
    Y.TOTAL          = 0

    Y.BAL.TYPE.CORRESPOND = @FALSE        ;* PP Contract balance does not correspond with RiskLimit Balance type


*Read Record contrat
    R.REDO.CCRG.CONTRACT.BAL= ''
    YERR = ''
    CALL F.READ(FN.REDO.CCRG.CONTRACT.BAL,Y.CONTRACT.ID,R.REDO.CCRG.CONTRACT.BAL,F.REDO.CCRG.CONTRACT.BAL,YERR)

* Data of the Contract Balance
* Category Contract
    Y.CATEGORY = ''
    Y.CATEGORY = R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.CATEGORY>
    Y.SUNNEL   = ''
*AV->
    Y.APP      = ''
    Y.APP      = R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.SYSTEM.ID>
*Y.SUNNEL  = R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.SYSTEM.ID,I>
    IF Y.APP EQ 'SU' THEN
        Y.SUNNEL = 'SU'
    END
*<-AV

* Balance Type for the Risk Limit
    Y.BALANCE.TYPE = ''
    Y.BAL.POS      = 1
    Y.BALANCE      = ''
    BEGIN CASE
        CASE Y.RL.ID EQ 'HOUSING.PLAN.APAP'
            Y.BALANCE = 'APAP.MORTGAGE'
        CASE Y.RL.ID MATCHES 'RISK.GROUP.SECURED':@VM:'RISK.INDIV.SECURED'
            Y.BALANCE = 'SECURED'
        CASE Y.RL.ID MATCHES 'RISK.GROUP.UNSECURED':@VM:'RISK.INDIV.UNSECURED'
            Y.BALANCE = 'UNSECURED'
        CASE Y.RL.ID MATCHES 'RISK.GROUP.TOTAL':@VM:'RISK.INDIV.TOTAL' : @VM : 'GLOBAL.LINKED' : @VM : 'GLOBAL.EMPLOYEES' : @VM : 'INDIVIDUAL.EMPLOYEES'
            Y.BALANCE = 'TOTAL'
* <<PP
        CASE 1
            CALL OCOMO('Limit Risk -' : Y.RL.ID : '- no definido')
            R.MSG.ERR = 'ST-REDO.CCRG.WRONG.RISK.LIMIT.ID' : @FM : Y.RL.ID     ;* 'RISK.LIMIT -' : Y.RL.ID : '- NO DEFINIDO'
            GOSUB RAISE.ERROR
            RETURN
* >>
    END CASE

* Validate that the data in REDO.CCRG.CONTRACT.BAL for the customer is related to de CATEGORY and BALANCE.TYPE
* In the case of SUNNEL process, the category code not exists, then by SUNNEL only Balance Type has to be validate
    Y.BALANCE.TYPE = Y.BALANCE
    IF NOT(Y.SUNNEL) AND NOT(Y.CATEGORY) AND NOT(Y.BALANCE.TYPE) THEN
        R.MSG.ERR = 'ST-REDO.CCRG.CONTRACT.BAL.NOT.PROPERLY.DEFINED' : @FM : Y.SUNNEL:'-':Y.REL.CUS.ID:'-':Y.RL.ID:'-':Y.CATEGORY:'-':Y.BALANCE.TYPE :'-':Y.CONTRACT.ID : @VM : FN.REDO.CCRG.CONTRACT.BAL
        GOSUB RAISE.ERROR
    END


    Y.DIR.BALANCE    = 0        ;*PP
    Y.INT.RECEIVABLE = 0        ;*PP
    Y.CON.BALANCE    = 0        ;*PP
    Y.TOTAL          = 0        ;*PP
* << PP
    Y.BAL.POS = ''
    LOCATE Y.BALANCE IN R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.BALANCE.TYPE,1> SETTING Y.BAL.POS THEN
* Get balance by type
        Y.DIR.BALANCE    = R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.DIR.BALANCE,Y.BAL.POS>
        Y.INT.RECEIVABLE = R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.INT.RECEIVABLE,Y.BAL.POS>
        Y.CON.BALANCE    = R.REDO.CCRG.CONTRACT.BAL<REDO.CCRG.CB.CON.BALANCE,Y.BAL.POS>
        Y.TOTAL          = Y.DIR.BALANCE + Y.INT.RECEIVABLE + Y.CON.BALANCE
        Y.BAL.TYPE.CORRESPOND = @TRUE
    END
* >> PP
RETURN

*--------------------------------------------------------------------------------------------
ACUM.BALANCE:
*--------------------------------------------------------------------------------------------
*
* Get Data Balance by every Enquiry Detail
*
*Balance by Customer
    Y.PRGRAPH.NAME = 'ACUM.BALANCE'

* Only if the Balance of the Contract is equal to Type Balance of the Risk Limit
* PP    IF (Y.BALANCE.TYPE EQ Y.BALANCE) AND (Y.CATEGORY OR Y.SUNNEL) THEN
    IF Y.BAL.TYPE.CORRESPOND THEN         ;* PP
        GOSUB ACUM.BALANCE.BY.CUS.CAT

*Balance by Category and Risk Limit
        IF Y.RL.ID MATCHES 'RISK.GROUP.SECURED' : @VM : 'RISK.GROUP.UNSECURED' : @VM : 'RISK.GROUP.TOTAL' THEN
* Total does not sum duplicate values for these Risk Limits
            Y.CONTRACT.POS   = ''
            R.CONTRACT.TOTAL = R.CONTRACT.TOTAL
            LOCATE Y.CONTRACT.ID  IN R.CONTRACT.TOTAL SETTING Y.CONTRACT.POS THEN
            END
            Y.COUNT.CNT = DCOUNT(R.CONTRACT.TOTAL,@FM)
            IF Y.CONTRACT.POS GT Y.COUNT.CNT THEN
                R.CONTRACT.TOTAL<-1> = Y.CONTRACT.ID
*Balance by Category
                GOSUB ACUM.BALANCE.BY.CAT
*Balance by Risk Limit
*                GOSUB ACUM.BALANCE.BY.RL
                R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.USED.AMOUNT,Y.RL.POS>  += Y.TOTAL
            END
        END ELSE
* Total does NOT duplicate values FOR the GLOBAL.LINKED Risk Limit
* and by the other Risk Limits only sum, data of the Customer Consulted
*Balance by Category
            GOSUB ACUM.BALANCE.BY.CAT
*Balance by Risk Limit
*            GOSUB ACUM.BALANCE.BY.RL
            R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.USED.AMOUNT,Y.RL.POS>  += Y.TOTAL
        END
    END
RETURN

*--------------------------------------------------------------------------------------------
ACUM.BALANCE.BY.CUS.CAT:
*--------------------------------------------------------------------------------------------
*
* Get Data Balance by Category or Type Balance by Customer
*

    Y.PRGRAPH.NAME        = 'ACUM.BALANCE.BY.CUS.CAT'
    R.CATEGORY.CODE       = ''
    R.BALANCE.TO.POPULATE = ''
    Y.POS = 1         ;* PP
    Y.VAR = Y.RL.ID MATCHES R.RL.WITH.RG

*Populate R.REDO.CCRG.RL.BAL.CUS.DET
*Populate Risk Limit that are not RISK.GROUP
    IF NOT(Y.VAR) AND (Y.CATEGORY OR Y.SUNNEL ) THEN
        IF R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.CATEGORY> THEN
            LOCATE Y.CATEGORY IN R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.CATEGORY, 1> SETTING Y.POS THEN
            END
        END
        R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.CATEGORY,Y.POS> = Y.CATEGORY
    END

*Populate only Risk Limit that are RISK.GROUP
    IF Y.VAR AND ( Y.BALANCE.TYPE OR Y.SUNNEL ) THEN
        IF R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.BALANCE.TYPE> THEN
            LOCATE Y.BALANCE.TYPE IN R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.BALANCE.TYPE,1> SETTING Y.POS THEN
            END
        END
        R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.BALANCE.TYPE,Y.POS> = Y.BALANCE.TYPE
    END

* Sunnel records only has Balance Type no Category Code
    IF Y.SUNNEL THEN
        R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.BALANCE.TYPE,Y.POS> = Y.BALANCE.TYPE
    END

* Set balance value
    R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.DIR.BALANCE,Y.POS>    += Y.DIR.BALANCE
    R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.INT.RECEIVABLE,Y.POS> += Y.INT.RECEIVABLE
    R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.CON.BALANCE,Y.POS>    += Y.CON.BALANCE
    R.REDO.CCRG.RL.BAL.CUS.DET<REDO.CCRG.RBCD.TOTAL,Y.POS>          += Y.TOTAL

RETURN



*--------------------------------------------------------------------------------------------
ACUM.BALANCE.BY.CAT:
*--------------------------------------------------------------------------------------------
*
* Get Data Balance by Category Product
*

    Y.PRGRAPH.NAME        = 'ACUM.BALANCE.BY.CAT'
    R.CATEGORY.CODE       = ''
    R.BALANCE.TO.POPULATE = ''
    Y.CAT.POS             = 1

* Populate R.REDO.CCRG.RL.BAL.DET
* Category
    IF NOT(Y.VAR) AND ( Y.CATEGORY OR Y.SUNNEL ) THEN
        IF R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.CATEGORY> THEN
            LOCATE Y.CATEGORY IN R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.CATEGORY,1> SETTING Y.CAT.POS THEN
            END
        END
        R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.CATEGORY,Y.CAT.POS> = Y.CATEGORY
    END

*Balance Type
    IF Y.VAR AND ( Y.BALANCE.TYPE OR Y.SUNNEL) THEN
        IF R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.BALANCE.TYPE>  THEN
            LOCATE Y.BALANCE.TYPE IN R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.BALANCE.TYPE,1> SETTING Y.CAT.POS THEN
            END
        END
        R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.BALANCE.TYPE,Y.CAT.POS> = Y.BALANCE.TYPE
    END

* Sunnel records only has Balance Type no Category Code
    IF Y.SUNNEL THEN
        R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.BALANCE.TYPE,Y.CAT.POS> = Y.BALANCE.TYPE
    END

*Balance Amount
    R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.DIR.BALANCE,Y.CAT.POS>    += Y.DIR.BALANCE
    R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.INT.RECEIVABLE,Y.CAT.POS> += Y.INT.RECEIVABLE
    R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.CON.BALANCE,Y.CAT.POS>    += Y.CON.BALANCE
    R.REDO.CCRG.RL.BAL.DET<REDO.CCRG.RBD.TOTAL,Y.CAT.POS>          += Y.TOTAL

RETURN


**--------------------------------------------------------------------------------------------
*ACUM.BALANCE.BY.RL:
**--------------------------------------------------------------------------------------------
**
** Get Data Balance by Risk Limit
**
*
*    Y.PRGRAPH.NAME = 'ACUM.BALANCE.BY.RL'
*
**Populate R.REDO.CCRG.RL.BAL.CUS.DET
*    R.REDO.CCRG.RL.BAL.MAIN<REDO.CCRG.RBM.USED.AMOUNT,Y.RL.POS>  += Y.TOTAL
*
*    RETURN

**--------------------------------------------------------------------------------------------
*SAVE.DATA.RL.BAL.MAIN:
**--------------------------------------------------------------------------------------------
**
** Set data by every Risk Limit
**
*    Y.PRGRAPH.NAME = 'SAVE.DATA.RL.BAL.MAIN'
*
**Save Record
*    WRITE R.REDO.CCRG.RL.BAL.MAIN  TO F.REDO.CCRG.RL.BAL.MAIN,Y.MAIN.ID ;* PP
*
*    RETURN
**--------------------------------------------------------------------------------------------
*SAVE.DATA.RL.BAL.DET:
**--------------------------------------------------------------------------------------------
**
** Set data by every Category Product
**
*    Y.PRGRAPH.NAME = 'SAVE.DATA.RL.BAL.DET'
*    WRITE R.REDO.CCRG.RL.BAL.DET      TO F.REDO.CCRG.RL.BAL.DET,Y.ENQ.RL.BAL.DET.ID
*
*    RETURN


**--------------------------------------------------------------------------------------------
*SAVE.DATA.RL.BAL.CUS.DET:
**--------------------------------------------------------------------------------------------
**
** Set data by every Customer - Category Product
**
*    Y.PRGRAPH.NAME = 'SAVE.DATA.RL.BAL.CUS.DET'
*    WRITE R.REDO.CCRG.RL.BAL.CUS.DET  TO F.REDO.CCRG.RL.BAL.CUS.DET,Y.ENQ.RL.REL.CUS.ID
*
*    RETURN

*--------------------------------------------------------------------------------------------
INITIALISE:
*--------------------------------------------------------------------------------------------
    PROCESS.GOAHEAD            = 1

    Y.RNT.NAME                 = 'REDO.CCRG.B.POP'
    Y.PRGRAPH.NAME             = 'INITIALISE'
    R.MSG.ERR                  = ''

    Y.RL.POS                   = 0

    Y.RL.ID                    = ''
    Y.RG.ID                    = ''
    Y.REL.CUS.ID               = ''

    R.REDO.CCRG.RL.BAL.CUS.DET = ''
    R.REDO.CCRG.RL.BAL.DET     = ''
    R.REDO.CCRG.RL.BAL.MAIN    = ''

    R.CONTRACT.TOTAL           = ''

* ----------
* RISK LIMIT
* ----------
*Risk Limits
    R.RL.WITHOUT.RG            = 'GLOBAL.LINKED'        : @VM : 'GLOBAL.EMPLOYEES'     : @VM :
    R.RL.WITHOUT.RG           := 'INDIVIDUAL.EMPLOYEES' : @VM : 'HOUSING.PLAN.APAP'    : @VM :
    R.RL.WITHOUT.RG           := 'RISK.INDIV.SECURED'   : @VM : 'RISK.INDIV.UNSECURED' : @VM : 'RISK.INDIV.TOTAL'

*Risk Limits with Risk Group
    R.RL.WITH.RG               = 'RISK.GROUP.SECURED' : @VM : 'RISK.GROUP.UNSECURED' : @VM : 'RISK.GROUP.TOTAL'

*Risk Limits
    R.RISK.LIMIT.POS<1>        = 'GLOBAL.LINKED'
    R.RISK.LIMIT.POS<2>        = 'GLOBAL.EMPLOYEES'
    R.RISK.LIMIT.POS<3>        = 'INDIVIDUAL.EMPLOYEES'
    R.RISK.LIMIT.POS<4>        = 'HOUSING.PLAN.APAP'
*Risk Limits with Risk Group
    R.RISK.LIMIT.POS.RG<5>     = 'RISK.GROUP.SECURED'
    R.RISK.LIMIT.POS.RG<6>     = 'RISK.GROUP.UNSECURED'
    R.RISK.LIMIT.POS.RG<7>     = 'RISK.GROUP.TOTAL'
*Risk Limits Individual
    R.RISK.LIMIT.POS<8>        = 'RISK.INDIV.SECURED'
    R.RISK.LIMIT.POS<9>        = 'RISK.INDIV.UNSECURED'
    R.RISK.LIMIT.POS<10>       = 'RISK.INDIV.TOTAL'

* --------------
* LINK ENQUIRIES
* --------------

    Y.NAME.ENQ.DET.1           = 'ENQ E.REDO.CCRG.RL.BAL.DET'
    Y.NAME.ENQ.DET.2           = 'ENQ REDO.CCRG.RL.BAL.CUS.DET'
    Y.NAME.ENQ.DEFAULT         = ''

* Link Enquiry detail 1
*--------------------------------------------
    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1
    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1
    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1
    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DEFAULT

    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1
    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1
    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1

    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1
    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1
    R.RISK.LIMIT.LINK.1<-1>    = Y.NAME.ENQ.DET.1

* Link Enquiry detail 2
*--------------------------------------------
    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DET.2
    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DET.2
    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DEFAULT
    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DET.2

    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DET.2
    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DET.2
    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DET.2

    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DEFAULT
    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DEFAULT
    R.RISK.LIMIT.LINK.2<-1>    = Y.NAME.ENQ.DEFAULT
*
RETURN

*-----------------------------------------------------------------------------
RAISE.ERROR:
*-----------------------------------------------------------------------------
*
*  Process to catch the error message in the process
*
*  Register process status
    PROCESS.GOAHEAD  = 0
*
    CALL S.REDO.CCRG.EFFECTIVE.REGISTER(P.IN.CUS.ID,R.MSG.ERR)

*  Report the error and take an action with the process
    R.SOURCE.INFO    = ''
    R.SOURCE.INFO<1> = Y.RNT.NAME
    R.SOURCE.INFO<2> = Y.PRGRAPH.NAME
    CALL APAP.REDOBATCH.REDO.CCRG.B.TRACE.ERROR(R.SOURCE.INFO, R.MSG.ERR, @FALSE, P.IN.CUS.ID, @TRUE) ;*R22 MANUAL CONVERSTION ADD PACKAGE
*
RETURN
*-----------------------------------------------------------------------------

END
