* @ValidationCode : MjotNTIyMjUzMDA0OkNwMTI1MjoxNjgxODg4Mjk5MTM5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 12:41:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE S.REDO.CCRG.GET.DETAIL(P.IN.TYPE.ENQ,P.IN.TYPE.DETAIL,R.IN.RL.BAL.DET,Y.TOTAL.APPROVED,Y.AVAILABLE.AMT,R.OUT.DATA.DET)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is an Nofile routine as a part of detail enquiries E.REDO.CCRG.RL.BAL.DET
* and E.REDO.CCRG.RL.BAL.CUS.DET for B.5 CONTROL OF LINKED CUSTOMERS AND RISK GROUPS.
*
*
* Input/Output:
*--------------
* P.IN.TYPE.ENQ:    Enquiry Type, values:
*                      (1) - Detail by Product Type and Category Code E.REDO.CCRG.RL.BAL.DET
*                      (2) - Detail by Customer REDO.CCRG.RL.BAL.CUS.DET
* P.IN.TYPE.DETAIL: Detail Type by Risk Limit
*                   Values to Enquiry (1)
*                      (1) - GLOBAL.LINKED, GLOBAL.EMPLOYEES, INDIVIDUAL.EMPLOYEES, RISK.INDIV.SECURED, RISK.INDIV.UNSECURED, RISK.INDIV.TOTAL
*                      (2) - RISK.GROUP.SECURED, RISK.GROUP.UNSECURED, RISK.GROUP.TOTAL
*                   Values to Enquiry (2)
*                      (1) - GLOBAL.LINKED, GLOBAL.EMPLOYEES
*                      (2) - RISK.GROUP.SECURED, RISK.GROUP.UNSECURED, RISK.GROUP.TOTAL
*                      (3) - HOUSING.PLAN.APAP
* R.IN.RL.BAL.DET: Select command, this select is diferent its depend of the P.IN.TYPE.ENQ
* Y.TOTAL.APPROVED: Total Approved Amount to the Risk Limit consulted
* Y.AVAILABLE.AMT:  Total Available Amount to the Risk Limit consulted
*
* Output:
*--------------
* R.OUT.DATA.DET: Output data to send the detail of the enquiry
*
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 4-MAY-2011     RMONDRAGON            ODR-2011-03-0154          FIRST VERSION
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*19/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION     FM TO @FM, VM TO @VM, ++ TO +=, I TO I.WAR, J TO J.WAR, K TO K.WAR, F.READ TO CACHE.READ
*19/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CATEGORY
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.CCRG.RL.BAL.DET
    $INSERT I_F.REDO.CCRG.RL.BAL.CUS.DET
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
* </region>
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPEN.FILE
    GOSUB GET.DETAIL

RETURN

*-----------------------------
INIT:
*-----------------------------
*
*  Inicilize Variables
*
    Y.DIR.BAL        = ''
    Y.INT.REC        = ''
    Y.CONTINGEN      = ''
    Y.TOT.USED       = ''
    Y.DESCRIPTION    = ''
    Y.DESTYPEBAL     = ''
    Y.TOT.APP        = ''
    Y.TOT.AVA        = ''
    Y.CNT            = 1
    Y.CNT2           = 1
    Y.REC            = ''
    Y.CUS            = ''
    Y.CUS.SHORT.NAME = ''
    Y.CAT            = ''
    Y.TOT.DIR.BAL    = 0
    Y.TOT.INT.REC    = 0
    Y.TOT.CONTINGEN  = 0
    Y.TOT.TOTAL      = 0
    Y.DATA.DET       = ''
    Y.REC.ID         = 0
    Y.REC.ID.RG      = 0
    Y.CUS.ID         = ''
    Y.TOT.SECURED    = 0
    Y.TOT.UNSECURED  = 0
    Y.TOTAL          = 0
    Y.CUS.CODE.CTRL  = ''
    Y.CUS.CODE.HP    = '0'
    R.SORT.BAL.TYPE  = 'SECURED':@FM:'UNSECURED':@FM:'TOTAL'

    APPL = 'CUSTOMER'
    FLD = 'L.CU.CIDENT':@VM:'L.CU.RNC'
    POS = ''
    CALL MULTI.GET.LOC.REF(APPL,FLD,POS)
    CIDENT.POS = POS<1,1>
    RNC.POS = POS<1,2>

RETURN

*-----------------------------
OPEN.FILE:
*-----------------------------
*
*  Open Files
*

* Open REDO.CCRG.RL.BAL.DET
    FN.REDO.CCRG.RL.BAL.DET = 'F.REDO.CCRG.RL.BAL.DET'
    F.REDO.CCRG.RL.BAL.DET  = ''
    CALL OPF(FN.REDO.CCRG.RL.BAL.DET,F.REDO.CCRG.RL.BAL.DET)

* Open REDO.CCRG.RL.BAL.CUS.DET
    FN.REDO.CCRG.RL.BAL.CUS.DET = 'F.REDO.CCRG.RL.BAL.CUS.DET'
    F.REDO.CCRG.RL.BAL.CUS.DET  = ''
    CALL OPF(FN.REDO.CCRG.RL.BAL.CUS.DET,F.REDO.CCRG.RL.BAL.CUS.DET)

* Open CUSTOMER
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

* Open CATEGORY
    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

* Open EB.LOOKUP
    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

* Open REDO.CCRG.RISK.LIMIT.PARAM
    FN.REDO.CCRG.RISK.LIMIT.PARAM = 'F.REDO.CCRG.RISK.LIMIT.PARAM'
    F.REDO.CCRG.RISK.LIMIT.PARAM = ''
    CALL OPF(FN.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM)

RETURN



*-----------------------------
GET.DETAIL:
*-----------------------------
*
* Obtiene Detalle de cada enquiry
*

* Set Variable to Work
    GOSUB SET.VARIABLES

* ---------------------------
* PROCESS DETAIL
* ---------------------------
    CALL EB.READLIST(R.IN.RL.BAL.DET,R.IN.RL.BAL.DET.LIST,'',R.IN.RL.BAL.DET.LIST.NO,R.IN.RL.BAL.DET.ERR)

* Sort Detail by Balance Type
    GOSUB SORT.DET.BAL.TYPE

* Process every record
    LOOP
        REMOVE Y.REC FROM R.IN.RL.BAL.DET.LIST SETTING Y.POS.D
    WHILE Y.REC:Y.POS.D
* Get Id record to process
        Y.CNT = Y.POS.D

*-----------------*
* BY TYPE ENQUIRY *
*-----------------*
* Read record
        CALL F.READ(FN.REDO.CCRG.DETAIL,Y.REC,R.RL.BAL.DET,F.REDO.CCRG.DETAIL,REDO.CCRG.RL.BAL.DET.ERR)
* Get Data Customer only to type Enquiery 2 - Detail by CUSTOMER
        IF P.IN.TYPE.ENQ EQ '2' THEN
*Customer Related
            Y.CUS.CODE = R.RL.BAL.DET<Y.POS.CUS.REL>
            GOSUB GET.CUS.DATA
            IF NOT(Y.CUS.CODE.CTRL) THEN
                Y.FIRST = 1
                Y.CUS.CODE.CTRL = Y.CUS.CODE
            END
        END

*-------------------*
* DETAIL BY ENQUIRY *
*-------------------*
* Get data by TYPE DETAIL
* RISK LIMITS without RISK GROUP
        IF P.IN.TYPE.DETAIL EQ '1' THEN
            GOSUB SET.RISK.LIMIT.WITHOUT.RG
        END


* RISK LIMITS with RISK GROUP
        IF P.IN.TYPE.DETAIL EQ '2' THEN
            GOSUB GET.DETAIL.BY.ENQUIRY
            GOSUB SUM.TO.TOTALS
        END


* Detail by CUSTOMER - RISK LIMIT HOUSING.PLAN.APAP
        IF P.IN.TYPE.ENQ EQ '2' AND P.IN.TYPE.DETAIL EQ '3' THEN
            GOSUB SET.HOUSING.PLAN.APAP
        END

        Y.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT


* Detail by CUSTOMER - RISK LIMITS with RISK GROUP - Because every detail line is by related customer,
* and exists the posibility that only exist one related customer.
    IF P.IN.TYPE.DETAIL EQ '2' AND P.IN.TYPE.ENQ EQ '2' THEN
        Y.TOTAL =  Y.TOT.SECURED + Y.TOT.UNSECURED
        Y.DATA.DET<Y.REC.ID.RG>  := FMT(Y.TOT.UNSECURED,"R2,#15") :'*': FMT(Y.TOT.SECURED,"R2,#15") :'*': FMT(Y.TOTAL,"R2,#15")
        Y.RG.TOT.SECURED   += Y.TOT.SECURED
        Y.RG.TOT.UNSECURED += Y.TOT.UNSECURED
        Y.RG.TOTAL         += Y.TOTAL
        Y.TOT.UNSECURED    = 0
        Y.TOT.SECURED      = 0
        Y.TOTAL            = 0
    END


*-----------------------------*
* TOTAL BY ENQUIRY AND DETAIL *
*-----------------------------*
    GOSUB GET.TOTAL.BY.ENQUIRY.AND.DETAIL


* Send out data
    R.OUT.DATA.DET = Y.DATA.DET

RETURN


*-----------------------------
SET.VARIABLES:
*-----------------------------
*
* Obtiene Detalle de cada enquiry
*
*Detail by Category
    Y.POS.CATEGORY            = REDO.CCRG.RBD.CATEGORY
    Y.POS.BALANCE.TYPE        = REDO.CCRG.RBD.BALANCE.TYPE
    Y.POS.BAL.DIR             = REDO.CCRG.RBD.DIR.BALANCE
    Y.POS.INTEREST.RECEIVABLE = REDO.CCRG.RBD.INT.RECEIVABLE
    Y.POS.CONTINGENT.BALANCE  = REDO.CCRG.RBD.CON.BALANCE
    Y.POS.TOTAL               = REDO.CCRG.RBD.TOTAL
* To read table
    FN.REDO.CCRG.DETAIL       = FN.REDO.CCRG.RL.BAL.DET
    F.REDO.CCRG.DETAIL        = F.REDO.CCRG.RL.BAL.DET

    IF P.IN.TYPE.ENQ EQ '2' THEN
*Detail by Customer
        Y.POS.CUS.REL             = REDO.CCRG.RBCD.REL.CUS.ID
        Y.POS.CATEGORY            = REDO.CCRG.RBCD.CATEGORY
        Y.POS.BALANCE.TYPE        = REDO.CCRG.RBCD.BALANCE.TYPE
        Y.POS.BAL.DIR             = REDO.CCRG.RBCD.DIR.BALANCE
        Y.POS.INTEREST.RECEIVABLE = REDO.CCRG.RBCD.INT.RECEIVABLE
        Y.POS.CONTINGENT.BALANCE  = REDO.CCRG.RBCD.CON.BALANCE
        Y.POS.TOTAL               = REDO.CCRG.RBCD.TOTAL
*
        FN.REDO.CCRG.DETAIL      = FN.REDO.CCRG.RL.BAL.CUS.DET
        F.REDO.CCRG.DETAIL       = F.REDO.CCRG.RL.BAL.CUS.DET
    END
RETURN

*-------------------------------
SET.RISK.LIMIT.WITHOUT.RG:
*-------------------------------
*
*  Get Detail only Risk Limit without Risk Group
*
* Get number of Balances(always has values in Balance Field, in Category can have "" in Sunel case)
*    Y.CAT    = R.RL.BAL.DET<Y.POS.CATEGORY>

* Y.CAT.NO = 0
* Y.CAT.NO = DCOUNT(Y.CAT,VM)
* IF Y.CAT AND Y.CAT.NO LT 1 THEN
*     Y.CAT.NO = 1
* END
*For Sunnel, Sunnel does not have category code but it has balance type
    Y.SU.BAL  = ''
*    Y.SU.BAL  = R.RL.BAL.DET<Y.POS.BALANCE.TYPE>
    Y.SU.BAL = R.RL.BAL.DET<Y.POS.BAL.DIR>
    Y.CAT.NO = 0
    Y.CAT.NO = DCOUNT(Y.SU.BAL,@VM)

* Detail by CATEGORY CODE
    FOR K.VAR = 1 TO Y.CAT.NO ;*AUTO R22 CODE CONVERSION
*Data by category code
        Y.CNT2 = K.VAR ;*AUTO R22 CODE CONVERSION
        Y.CAT = R.RL.BAL.DET<Y.POS.CATEGORY><1,K.VAR>
        Y.DESCRIPTION = 'TARJETA DE CREDITO'          ;*If the category code is null, it is SUNNEL balances

        IF Y.CAT EQ 'SIN CONTRATOS' THEN
            Y.DESCRIPTION ='SIN CONTRATOS'
        END ELSE
            IF Y.CAT THEN
                CALL CACHE.READ(FN.CATEGORY, Y.CAT, R.CAT.DATA, CATEGORY.ERR) ;*AUTO R22 CODE CONVERSION
                Y.DESCRIPTION = R.CAT.DATA<EB.CAT.DESCRIPTION>
            END
        END
        Y.DIR.BAL     = R.RL.BAL.DET<Y.POS.BAL.DIR,K.VAR> ;*AUTO R22 CODE CONVERSION
        Y.INT.REC     = R.RL.BAL.DET<Y.POS.INTEREST.RECEIVABLE,K.VAR>
        Y.CONTINGEN   = R.RL.BAL.DET<Y.POS.CONTINGENT.BALANCE,K.VAR>
        Y.TOT.USED    = R.RL.BAL.DET<Y.POS.TOTAL,K.VAR>
        GOSUB GET.DETAIL.BY.ENQUIRY
        GOSUB SUM.TO.TOTALS
    NEXT K.VAR ;*AUTO R22 CODE CONVERSION

RETURN

*-------------------------------
SET.HOUSING.PLAN.APAP:
*-------------------------------
*
*  Get Detail only for HOUSING.PLAN.APAP
*

* Acum al values by CATEGORY CODE
    Y.TOT.USED = 0
* Get number of Category Code
*    Y.CAT    = R.RL.BAL.DET<Y.POS.CATEGORY>
    Y.CAT    = R.RL.BAL.DET<Y.POS.BAL.DIR>
    Y.CAT.NO = DCOUNT(Y.CAT,@VM)
    LOOP
    WHILE Y.CNT2 LE Y.CAT.NO
        Y.TOT.USED += R.RL.BAL.DET<Y.POS.TOTAL><1,Y.CNT2>
        Y.CNT2 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

* Set detail data
    GOSUB GET.DETAIL.BY.ENQUIRY
    Y.DATA.DET<Y.REC.ID> := FMT(Y.TOT.USED,"R2,#15")
    GOSUB SUM.TO.TOTALS

RETURN


*-------------------------------
GET.TOTAL.BY.ENQUIRY.AND.DETAIL:
*-------------------------------
*
*  Get Total by Enquiry and Detail
*

* RISK LIMITS without RISK GROUP
    IF P.IN.TYPE.DETAIL EQ '1' THEN
        Y.REC.ID += 1 ;*AUTO R22 CODE CONVERSION
*Columns to DETAIL by CATEGORY
        Y.ASTERISKS.1  = ''
        Y.ASTERISKS.2  = '***'
        IF P.IN.TYPE.ENQ EQ '2' THEN
*Columns to DETAIL by CUSTOMER
            Y.ASTERISKS.1  = '***'
            Y.ASTERISKS.2  = '******'
        END
        Y.DATA.DET<Y.REC.ID> = Y.ASTERISKS.1:'TOTAL TOMADO*': FMT(Y.TOT.DIR.BAL,"R2,#15") :'*': FMT(Y.TOT.INT.REC,"R2,#15") :'*': FMT(Y.TOT.CONTINGEN,"R2,#15") :'*': FMT(Y.TOT.TOTAL,"R2,#15")
        Y.TOT.AVA            = Y.AVAILABLE.AMT
        Y.REC.ID += 1 ;*AUTO R22 CODE CONVERSION
        Y.DATA.DET<Y.REC.ID> = Y.ASTERISKS.2:'TOTAL DISPONIBLE*': FMT(Y.TOT.AVA,"R2,#15")
    END

* RISK LIMITS with RISK GROUP
    IF P.IN.TYPE.ENQ EQ '2' AND P.IN.TYPE.DETAIL EQ '2' THEN
*----------------------
        Y.REC.ID.RG += 1 ;*AUTO R22 CODE CONVERSION
        Y.DATA.DET<Y.REC.ID.RG> = '****TOTAL TOMADO*': FMT(Y.RG.TOT.UNSECURED,"R2,#15") :'*': FMT(Y.RG.TOT.SECURED,"R2,#15") :'*': FMT(Y.RG.TOTAL,"R2,#15")
*----------------------
* Draw a line to separate Total Tomado from Total Aprobado and Total Disponible
        Y.REC.ID.RG += 1 ;*AUTO R22 CODE CONVERSION
        Y.DATA.DET<Y.REC.ID.RG> = '****____________*': '_________________' :'*': '_________________' :'*': '_________________'
*----------------------
        GOSUB GET.RISK.PARAM

        Y.REC.ID.RG += 1 ;*AUTO R22 CODE CONVERSION
        Y.DATA.DET<Y.REC.ID.RG> = '****TOTAL APROBADO*': FMT(Y.TOT.APP.UNSECURED,"R2,#15") :'*': FMT(Y.TOT.APP.SECURED,"R2,#15") :'*': FMT(Y.TOT.APP.TOTAL,"R2,#15")
*----------------------
        Y.TOT.AVA.UNSECURED = Y.TOT.APP.UNSECURED - Y.RG.TOT.UNSECURED
        Y.TOT.AVA.SECURED   = Y.TOT.APP.SECURED   - Y.RG.TOT.SECURED
        Y.TOT.AVA.TOTAL     = Y.TOT.APP.TOTAL     - Y.RG.TOT.UNSECURED - Y.RG.TOT.SECURED
        Y.REC.ID.RG += 1 ;*AUTO R22 CODE CONVERSION
        Y.DATA.DET<Y.REC.ID.RG> = '****TOTAL DISPONIBLE*': FMT(Y.TOT.AVA.UNSECURED,"R2,#15") :'*': FMT(Y.TOT.AVA.SECURED,"R2,#15") :'*': FMT(Y.TOT.AVA.TOTAL,"R2,#15")
    END


* RISK LIMIT HOUSING.PLAN.APAP
    IF P.IN.TYPE.ENQ EQ '2' AND P.IN.TYPE.DETAIL EQ '3' THEN
        Y.REC.ID += 1 ;*AUTO R22 CODE CONVERSION
        Y.DATA.DET<Y.REC.ID> = '**TOTAL*': FMT(Y.TOT.TOTAL,"R2,#15")
    END

RETURN

*-----------------------------
GET.DETAIL.BY.ENQUIRY:
*-----------------------------
*
*  Generate every Detail by Type Enquiry
*

    Y.REC.ID += 1 ;*AUTO R22 CODE CONVERSION

* DETAIL BY CUSTOMER
    IF P.IN.TYPE.ENQ EQ '2' AND P.IN.TYPE.DETAIL NE '2' THEN
*Only for enrquiry to detail by related customer
        Y.DATA.DET<Y.REC.ID> = Y.CUS.CODE:'*':Y.CUS.ID:'*':Y.CUS.NAME:'*'
    END

* GENERAL DETAIL
* Detail for Risk Limits without Risk Group
    IF P.IN.TYPE.DETAIL EQ '1' THEN
        Y.DATA.DET<Y.REC.ID> := Y.DESCRIPTION:'*': FMT(Y.DIR.BAL,"R2,#15") :'*': FMT(Y.INT.REC,"R2,#15") :'*': FMT(Y.CONTINGEN,"R2,#15") :'*': FMT(Y.TOT.USED,"R2,#15")
    END

* Detail for Risk Limits with Risk Group
    IF P.IN.TYPE.DETAIL EQ '2' THEN
        Y.CNT2=1
*Get description by languaje default for to BALANCE TYPE
        Y.BAL.TYPE = R.RL.BAL.DET<Y.POS.BALANCE.TYPE>
        Y.BAL.TYPE = "REDO.CCRG.BAL.TYPE*":Y.BAL.TYPE
        CALL F.READ(FN.EB.LOOKUP,Y.BAL.TYPE,R.LOOK.DATA,F.EB.LOOKUP,EB.LOOKUP.ERR)
        Y.DESCRIPTION = R.LOOK.DATA<EB.LU.DESCRIPTION><1,LNGG>

* DETAIL BY CUSTOMER in Risk Limit by Risk Group
        IF P.IN.TYPE.ENQ EQ '2' THEN
            IF Y.CUS.CODE.CTRL NE Y.CUS.CODE THEN
                Y.TOTAL =  Y.TOT.SECURED + Y.TOT.UNSECURED
                Y.DATA.DET<Y.REC.ID.RG>  := FMT(Y.TOT.UNSECURED,"R2,#15") :'*': FMT(Y.TOT.SECURED,"R2,#15") :'*': FMT(Y.TOTAL,"R2,#15")
                Y.CUS.CODE.CTRL = Y.CUS.CODE
                Y.RG.TOT.SECURED   += Y.TOT.SECURED
                Y.RG.TOT.UNSECURED += Y.TOT.UNSECURED
                Y.RG.TOTAL         += Y.TOTAL
                Y.FIRST             = 1
                Y.TOT.UNSECURED     = 0
                Y.TOT.SECURED       = 0
                Y.TOTAL             = 0
            END
            IF Y.CUS.CODE.CTRL EQ Y.CUS.CODE AND Y.FIRST EQ 1 THEN
                Y.REC.ID.RG += 1 ;*AUTO R22 CODE CONVERSION
                Y.DATA.DET<Y.REC.ID.RG> = Y.CUS.CODE:'*':Y.CUS.ID:'*':Y.CUS.NAME:'***'
                Y.FIRST = 0
            END
        END

* GENERAL DATA to detailt by CATEGORY and CUSTOMER
        Y.CNT2 = 1
        Y.DESTYPEBAL  = R.RL.BAL.DET<Y.POS.BALANCE.TYPE>
        Y.DIR.BAL     = R.RL.BAL.DET<Y.POS.BAL.DIR>
        Y.INT.REC     = R.RL.BAL.DET<Y.POS.INTEREST.RECEIVABLE>
        Y.CONTINGEN   = R.RL.BAL.DET<Y.POS.CONTINGENT.BALANCE>
        Y.TOT.APP     = Y.TOTAL.APPROVED
        Y.TOT.USED    = R.RL.BAL.DET<Y.POS.TOTAL>
        Y.TOT.AVA     = Y.TOT.APP - Y.TOT.USED

        Y.BAL.TYPE.AUX   = FIELD(Y.BAL.TYPE,'*',2,1)
        Y.BAL.TYPE.AUX.1 = FIELD(Y.BAL.TYPE.AUX,@VM,Y.CNT2)

        IF Y.BAL.TYPE.AUX.1 EQ 'SECURED' THEN
            Y.TOT.SECURED   = Y.DIR.BAL + Y.INT.REC + Y.CONTINGEN
        END
        IF Y.BAL.TYPE.AUX.1 EQ 'UNSECURED' THEN
            Y.TOT.UNSECURED = Y.DIR.BAL + Y.INT.REC + Y.CONTINGEN
        END

* DETAIL BY CATEGORY
        IF P.IN.TYPE.ENQ EQ '1' THEN
* Balance Type UNSECURED and SECURED
            Y.RISK.LIMIT.PARAM.ID = 'RISK.GROUP.':Y.BAL.TYPE.AUX.1
            GOSUB GET.RISK.LIMIT.PARAM
            Y.TOT.APP = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.AMOUNT>
            Y.TOT.AVA = Y.TOT.APP - Y.TOT.USED
* Balance Type TOTAL
            IF Y.DESTYPEBAL EQ 'TOTAL' THEN
                GOSUB GET.RISK.PARAM
                Y.TOT.APP = Y.TOT.APP.TOTAL
                Y.TOT.AVA = Y.TOT.APP - Y.TOT.USED
            END
* Set record detail
            Y.DATA.DET<Y.REC.ID> := Y.DESCRIPTION:'*': FMT(Y.DIR.BAL,"R2,#15") :'*': FMT(Y.INT.REC,"R2,#15"):'*': FMT(Y.CONTINGEN,"R2,#15") :'*': FMT(Y.TOT.APP,"R2,#15") :'*': FMT(Y.TOT.USED,"R2,#15") :'*': FMT(Y.TOT.AVA,"R2,#15")
        END
    END     ;*P.IN.TYPE.DETAIL EQ 2
RETURN

*-----------------------------
SUM.TO.TOTALS:
*-----------------------------
*
*  Generate Total for every enquiery
*
* This process no apply to Detall by CATEGORY and Type Detail 2 (Risk Group)
    IF P.IN.TYPE.ENQ EQ '1' AND P.IN.TYPE.DETAIL EQ '2' THEN
        RETURN
    END

* Get total to Detail by CATEGORY and CUSTOMER and Type Detail 1 (Without Risk Group)
    IF P.IN.TYPE.ENQ MATCHES '1':@VM:'2' AND P.IN.TYPE.DETAIL EQ '1' THEN
        Y.TOT.DIR.BAL    += Y.DIR.BAL
        Y.TOT.INT.REC    += Y.INT.REC
        Y.TOT.CONTINGEN  += Y.CONTINGEN
        Y.TOT.TOTAL      += Y.TOT.USED
    END

* Get total to Detail by CUSTOMER and Type Detail 3 (Housing Plan APAP)
    IF P.IN.TYPE.ENQ EQ '2' AND P.IN.TYPE.DETAIL EQ '3' THEN
        Y.TOT.TOTAL += Y.TOT.USED
    END

RETURN

*-----------------------------
GET.CUS.DATA:
*-----------------------------
*
*  Get data from CUSTOMER application for the Related Customer
*

* Read Record
    CALL F.READ(FN.CUSTOMER,Y.CUS.CODE,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

* Get Name Record
    Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>

*  Get identification by Related Customer

* (1) Identity Card
    Y.CUS.ID = R.CUSTOMER<EB.CUS.LOCAL.REF><1,CIDENT.POS>

* (2) Passport
    IF Y.CUS.ID EQ '' THEN
        Y.CUS.ID = R.CUSTOMER<EB.CUS.LEGAL.ID>
    END
* (3) RNC Number
    IF Y.CUS.ID EQ '' THEN
        Y.CUS.ID = R.CUSTOMER<EB.CUS.LOCAL.REF><1,RNC.POS>
    END

RETURN

*-----------------------------
SORT.DET.BAL.TYPE:
*-----------------------------
*
*  Sort every Risk Limit by Risk Group
*

* Enquiry by CATEGORY and type Detail by Risk Group
    IF P.IN.TYPE.ENQ EQ '1' AND P.IN.TYPE.DETAIL EQ '2' THEN
        Y.CNT.POS = 1
        LOOP
        WHILE Y.CNT.POS LE R.IN.RL.BAL.DET.LIST.NO
* Read every record to process
            Y.ID = R.IN.RL.BAL.DET.LIST<Y.CNT.POS>
            R.RL = ''
            CALL F.READ(FN.REDO.CCRG.DETAIL,Y.ID,R.RL,F.REDO.CCRG.DETAIL,Y.ERR)
* Get the Type Balance ID for the Risk Limit
            Y.BAL.ID  = R.RL<Y.POS.BALANCE.TYPE>
* Get the position in the sort by type balance
            Y.POS.BAL = ''
            LOCATE Y.BAL.ID IN R.SORT.BAL.TYPE<1> SETTING Y.POS.BAL THEN
                R.RL.SORT<Y.POS.BAL> = Y.ID
            END
            Y.CNT.POS += 1 ;*AUTO R22 CODE CONVERSION
        REPEAT
* If the records dont have all the RISK GROUP, its posible that exists some blank spaces
        FOR I.VAR = 1 TO 3 ;*AUTO R22 CODE CONVERSION
            IF R.RL.SORT<I.VAR> THEN
                J.VAR += 1
                R.RL.SORT.1<J.VAR> = R.RL.SORT<I.VAR>
            END
        NEXT
* Set the record to process
        Y.CNT = 0
        R.IN.RL.BAL.DET.LIST = R.RL.SORT.1
    END

RETURN

*-----------------------------
GET.RISK.PARAM:
*-----------------------------
*
*  Get Param Risk Group
*
* Param for RISK.GROUP.UNSECURED
    Y.RISK.LIMIT.PARAM.ID = 'RISK.GROUP.UNSECURED'
    GOSUB GET.RISK.LIMIT.PARAM
    Y.TOT.APP.UNSECURED    = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.AMOUNT>

* Param for RISK.GROUP.SECURED
    Y.RISK.LIMIT.PARAM.ID = 'RISK.GROUP.SECURED'
    GOSUB GET.RISK.LIMIT.PARAM
    Y.TOT.APP.SECURED     = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.AMOUNT>

* Max amount to RISK.GROUP.TOTAL
    Y.TOT.APP.TOTAL       = Y.TOT.APP.UNSECURED + Y.TOT.APP.SECURED

RETURN

*-----------------------------
GET.RISK.LIMIT.PARAM:
*-----------------------------
*
*  Get param Risk Limit Param
*
    R.REDO.CCRG.RISK.LIMIT.PARAM = ''
    YERR = ''
    CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RISK.LIMIT.PARAM.ID,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM,YERR)

RETURN

END
