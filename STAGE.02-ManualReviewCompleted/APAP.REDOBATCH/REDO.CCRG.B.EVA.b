* @ValidationCode : MjotMTQ0NDcwODU4NTpDcDEyNTI6MTY4MTc5NDcwNjA3MTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:41:46
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
* Version 1 13/04/00  GLOBUS Release No. G14.0.00 03/07/03

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CCRG.B.EVA(P.IN.PRO.ID)
*-----------------------------------------------------------------------------
* Mutli-threaded Close of Business routine
* Description: Main Service Routine, allows to
*              1. Evaluate customer to determinate the Risk Limits to applied
*              2. Get the list of customer vinculated by Limits
*-----------------------------------------------------------------------------
* PARAMETERS:
* INPUT:
*       P.IN.PRO.ID -> Customer Id. to process, related with REDO.CCRG.RL.CUSTOMER
*
*-----------------------------------------------------------------------------
* Modification History:
*                      2011-04-07 : avelasco@temenos.com
*                                   First version
*REM Just for compile
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND I TO I.VAR
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -P.RETURN TO Y.RETURN AND ADDING PACKAGE TO CALL ROUTINE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_F.CUSTOMER
*
    $INSERT I_REDO.CCRG.B.EVA.COMMON
    $INSERT I_F.REDO.CCRG.RISK.LIMIT.PARAM
    $INSERT I_F.REDO.CCRG.CUSTOMER
*
*-----------------------------------------------------------------------------
* Perform the transaction/contract processing in this routine. All files & standard

* variables should be setup in REDO.B.CCRG.EVA.LOAD and passed using the named common I_REDO.B.CCRG.EVA.COMMON



    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

* ========
PROCESS:
* ========
*
*  Principal process to:
*
    Y.PRGRAPH.NAME = 'PROCESS'

*Get the customer to process
    GOSUB GET.RL.CUSTOMER

*Delete applications
    GOSUB DELETE.FILE.PROCESS

*Evaluate Customer and get data
    GOSUB EVALUATE.CUSTOMER

*Write Output Queue for Extract process
    GOSUB SAVE.EXTRACT.QUEUE
*Delete EVA.QUEUE
    GOSUB DELETE.EVA.QUEUE
*

*
RETURN
*
* =================
GET.RL.CUSTOMER:
* =================
*
*  Paragraph to get data from REDO.CCRG.CUSTOMER for P.IN.PRO.ID

*
    Y.PRGRAPH.NAME = 'GET.RL.CUSTOMER'
*Read data in Application REDO.CCRG.CUSTOMER

    CALL F.READ(FN.REDO.CCRG.CUSTOMER,P.IN.PRO.ID,R.REDO.CCRG.CUSTOMER,F.REDO.CCRG.CUSTOMER,Y.ERR)

    IF NOT(R.REDO.CCRG.CUSTOMER) THEN
        Y.MSG.ERR = 'ST-REDO.CCRG.RL.CUSTOMER.NO.FOUND'
        GOSUB  RAISE.ERROR
    END ELSE

        Y.CUSTOMER.ID   = R.REDO.CCRG.CUSTOMER<REDO.CCRG.CUS.CUSTOMER.ID>
        R.EXT.QUEUE<-1> = Y.CUSTOMER.ID

*Get data for customer from Customer Application

        CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR)

        IF NOT(R.CUSTOMER) THEN
            Y.MSG.ERR = 'ST-REDO.CCRG.CUSTOMER.ID.MISSING'
            GOSUB RAISE.ERROR
        END

*Set Risk Group
        R.RISK.GRP = R.CUSTOMER<EB.CUS.LOCAL.REF,GRP.RISK.POS>
        R.RISK.GRP = CHANGE(R.RISK.GRP, @SM, @VM)
    END

*
RETURN
*
* ==========================
DELETE.FILE.PROCESS:
* ==========================
*
*  Paragraph to delete the customer data in REDO.CCRG.RL.CUSTOMER & REDO.CCRG.RL.REL.CUS
*
    Y.PRGRAPH.NAME = 'DELETE.FILE.PROCESS'

*Delete from R.REDO.CCRG.RL.CUSTOMER
    CALL F.DELETE(FN.REDO.CCRG.RL.CUSTOMER,Y.CUSTOMER.ID)

*Delete from REDO.CCRG.RL.REL.CUS
    Y.FILE.NAME = FN.REDO.CCRG.RL.REL.CUS
    Y.FILE.NAME<2> = '@ID LIKE ':Y.CUSTOMER.ID:'...'
    CALL EB.CLEAR.FILE(Y.FILE.NAME,F.REDO.CCRG.RL.REL.CUS)
*
RETURN
*
* ===================
EVALUATE.CUSTOMER:
* ===================
*
* Process to evaluate the customer vs. limits
    Y.PRGRAPH.NAME = 'EVALUATE.CUSTOMER'
*
    R.RL.CUSTOMER = ''
    R.RL.REL.CUS = ''

    GOSUB PROCESS.LIMIT
*
RETURN
*
* ===============
PROCESS.LIMIT:
* ===============
*
*Evaluate the limits for customer to determinate the risk limits
*
    Y.PRGRAPH.NAME = 'PROCESS.LIMIT'
*
    Y.CONT.LIMI.APP = 0

    IF NO.OF.RISK.LIM EQ 0 THEN
        Y.MSG.ERR = 'ST-REDO.CCRG.RISK.LIMIT.NOT.FOUND'
        GOSUB  RAISE.ERROR
    END

    LOOP
        REMOVE Y.RL.ID FROM R.RL.LIST SETTING POS
    WHILE Y.RL.ID:POS AND PROCESS.GOAHEAD

        CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RL.ID,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM,Y.ERR)
* Consider conditions for each Risk.limit
        GOSUB PROCESS.LIMITS.INI

    REPEAT

*Check the Risk Limits List for customer
*At least client has these limits
    IF NOT(Y.LIST.RISK.LIMITS) THEN
        Y.LIST.RISK.LIMITS = 'RISK.INDIV.SECURED' : @VM :'RISK.INDIV.UNSECURED' : @VM :'RISK.INDIV.TOTAL'
    END
*
    GOSUB CHECK.LIMITS.PROCESS
    GOSUB VALID.TYPE.LIMIT
*
RETURN
*
* ===================
PROCESS.LIMITS.INI:
* ===================
*
*Some limits dont have conditions
*
    Y.PRGRAPH.NAME = 'PROCESS.LIMITS.INI'
    P.APPLICATION  = 'CUSTOMER'
*
    R.COND.DEF<2>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.OPERATOR>
    R.COND.DEF<3>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MIN.VALUE>
    R.COND.DEF<4>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.VALUE>
    R.COND.DEF<5>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.BOOL.OPER>
    R.COND.DEF<1>   = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.FIELD.NO>
    P.VALUES<1>     = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.FIELD.NO>

    P.VALUES<2> = ''
    Y.FIELD.LIST = R.COND.DEF<1>
    LOOP
        P.ERR.MSG = ''
        P.FIELD.VALUE = ''
        REMOVE P.FIELD.NAME FROM Y.FIELD.LIST SETTING Y.XS1
    WHILE P.FIELD.NAME : Y.XS1
* Check if FIELD.NAME is not blank
        IF P.FIELD.NAME NE '' THEN
            CALL S.REDO.CCRG.GET.CUS.FIELD.VAL(R.CUSTOMER, P.FIELD.NAME, P.FIELD.VALUE, P.ERR.MSG)
            IF P.ERR.MSG THEN
                Y.MSG.ERR = P.ERR.MSG
                GOSUB RAISE.ERROR
            END
            P.FIELD.VALUE = CHANGE(P.FIELD.VALUE, @VM, @SM)
            P.VALUES<2,-1> = P.FIELD.VALUE
        END
    REPEAT
    CALL OCOMO("Evaluating ... " : R.COND.DEF )
    CALL OCOMO("Values ....... " : P.VALUES)
    CALL S.REDO.CONDITION.EVALUATOR(R.COND.DEF,P.VALUES,Y.RETURN)
    CALL OCOMO("Result ....... " : Y.RETURN) ;*R22 MANUAL CONVERSTION P.RETURN TO Y.RETURN

    IF Y.RETURN EQ '1' THEN
        Y.LIST.RISK.LIMITS<1,-1> = Y.RL.ID
    END

RETURN
*
* ==================
CHECK.LIMITS.PROCESS:
* ==================
*
    LOOP
        REMOVE Y.RL.ID.TEMP FROM Y.LIST.RISK.LIMITS SETTING Y.SX1
    WHILE Y.RL.ID.TEMP : Y.SX1
*If risk limits are:
        IF Y.RL.ID.TEMP MATCHES "RISK.GROUP.SECURED" : @VM :"RISK.GROUP.UNSECURED"  THEN
* Always has to set
            Y.LIST.RISK.LIMITS<1,-1> = 'RISK.GROUP.TOTAL'
            RETURN
        END
    REPEAT

RETURN
*
* ==================
VALID.TYPE.LIMIT:
* ==================
* according with the validatiosn rebuild the list of limits for customer
*
    Y.PRGRAPH.NAME = 'VALID.TYPE.LIMIT'

    IF NOT(Y.LIST.RISK.LIMITS) THEN
        Y.MSG.ERR = 'ST-REDO.CCRG.NO.RISK.LIMIT.FOUND.FOR.CUSTOMER'
        GOSUB  RAISE.ERROR
    END

* Assign R.RL.CUSTOMER data to REDO.CCRG.RL.CUSTOMER
*
    R.RL.CUSTOMER    = ''
    R.RL.CUSTOMER<1> = Y.LIST.RISK.LIMITS
    R.RL.CUSTOMER<2> = R.RISK.GRP
*

    CALL F.WRITE(FN.REDO.CCRG.RL.CUSTOMER,Y.CUSTOMER.ID, R.RL.CUSTOMER)

    Y.KNUM = 0
* For each limit in the list, process it

    Y.NO.LIMITS.CUS = DCOUNT(Y.LIST.RISK.LIMITS,@VM)

    FOR Y.KNUM =  1 TO Y.NO.LIMITS.CUS
        Y.RL.ID = Y.LIST.RISK.LIMITS<1,Y.KNUM>
        GOSUB GET.CUS.BY.LIMIT
    NEXT Y.KNUM
*
RETURN
*
* ==================
GET.CUS.BY.LIMIT:
* ==================
*
* Assign R.RL.REL.CUS to REDO.CCRG.RL.REL.CUS
*
    Y.PRGRAPH.NAME = 'GET.CUS.BY.LIMIT'


    Y.NO.RISK.GRP = DCOUNT(R.RISK.GRP,@VM)
    CALL F.READ(FN.REDO.CCRG.RISK.LIMIT.PARAM,Y.RL.ID,R.REDO.CCRG.RISK.LIMIT.PARAM,F.REDO.CCRG.RISK.LIMIT.PARAM,Y.ERR)

* For  RISK.INDIV.SECURED RISK.INDIV.UNSECURED RISK.INDIV.TOTAL just report the principal customer
    IF Y.RL.ID MATCHES 'RISK.INDIV.SECURED' : @VM :'RISK.INDIV.UNSECURED' : @VM :'RISK.INDIV.TOTAL' THEN
        Y.RL.REL.CUS.ID = Y.CUSTOMER.ID:'-':Y.RL.ID
        R.RL.REL.CUS = Y.CUSTOMER.ID
        CALL F.WRITE(FN.REDO.CCRG.RL.REL.CUS,Y.RL.REL.CUS.ID,R.RL.REL.CUS)
        R.EXT.QUEUE = Y.CUSTOMER.ID
    END ELSE
*Process for other Risk.Limts
        GOSUB VAL.RISK.TYPE.GROUP
    END
*
RETURN
*
* ==================
VAL.RISK.TYPE.GROUP:
* ==================

    Y.PRGRAPH.NAME = "VAL.RISK.TYPE.GROUP"

* Set parameter for R.REDO.CCRG.SELECT.COMMAND routine
    Y.APPLICATION = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.APPLICATION>
    Y.COND.DEF<1> = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.FIELD.NO>
    Y.COND.DEF<2> = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.OPERATOR>
    Y.COND.DEF<3> = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MIN.VALUE>
    Y.COND.DEF<4> = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.MAX.VALUE>
    Y.SEL.CMD     = ''
    Y.ERR.MSG     = ''

*Process for RISK.GROUP SECURED & UNSECURED
    IF Y.RL.ID MATCHES "RISK.GROUP.SECURED" : @VM :"RISK.GROUP.UNSECURED" : @VM : "RISK.GROUP.TOTAL" THEN

* In case of RISK.GROUP limits, we have to search related customers, according Risk Group
        Y.COND.DEF<1> = R.REDO.CCRG.RISK.LIMIT.PARAM<REDO.CCRG.RLP.FIELD.NO>
        Y.COND.DEF<2> = 'EQ'
        Y.COND.DEF<3> = ''
        Y.COND.DEF<4> = ''

        FOR I.VAR = 1 TO Y.NO.RISK.GRP
*Get each Group Risk
            Y.RL.REL.CUS.ID = Y.CUSTOMER.ID:'-':Y.RL.ID:'-':R.RISK.GRP<1,I.VAR>
            Y.COND.DEF<3> =  R.RISK.GRP<1,I.VAR>
            IF Y.RL.ID NE "RISK.GROUP.TOTAL" THEN
                GOSUB GET.REL.CUSTOMER
            END ELSE
*Special process for RISK.GROUP.TOTAL
                GOSUB PROC.RISK.GROUP.TOTAL
            END
        NEXT I.VAR
    END ELSE
*For other types of RISK.LIMITS
        Y.RL.REL.CUS.ID = Y.CUSTOMER.ID:'-':Y.RL.ID
        GOSUB GET.REL.CUSTOMER
    END

*
RETURN
*
* ==================
PROC.RISK.GROUP.TOTAL:
* ==================
*
* The risk limtit is RISK.GROUP.TOTAL+R.RISK.GRP and we need the information of RISK.GROUP.SECURED+R.RISK.GRP and RISK.GROUP.UNSECURED+R.RISK.GRP
    Y.PRGRAPH.NAME = "PROC.RISK.GROUP.TOTAL"

    Y.REL.CUS.TOTAL.SECUNSEC = ''
    Y.GROUPS.SEC = Y.CUSTOMER.ID:"-RISK.GROUP.SECURED-":R.RISK.GRP<1,I.VAR>
    LOCATE Y.GROUPS.SEC IN Y.ARR.GRP.RISK<1> SETTING Y.POS.REL.CUS THEN
        Y.REL.CUS.SEC = Y.ARR.REL.CUS.GRP.RISK<Y.POS.REL.CUS>
    END ELSE
* RISK.GROUP.SECURED was not found
* no se ha encontrado el RISK.GROUP.SECURED para este cliente.
        CALL OCOMO("RiskLimit " : Y.GROUPS.SEC : ' No definido, por tanto RISK.GROUP.TOTAL no puede ser creado')
        RETURN
    END

    Y.REL.CUS.TOTAL.SECUNSEC =  Y.REL.CUS.SEC

* Write Total
    R.RL.REL.CUS = Y.REL.CUS.TOTAL.SECUNSEC
    CALL F.WRITE(FN.REDO.CCRG.RL.REL.CUS,Y.RL.REL.CUS.ID,R.RL.REL.CUS)

RETURN
*

* ==================
GET.REL.CUSTOMER:
* ==================
*Get list of relationed customers
*
    Y.PRGRAPH.NAME = 'GET.REL.CUSTOMER'
*
    R.RL.REL.CUS     = ''
    R.RL.REL.CUS<-1> = Y.CUSTOMER.ID

*build the select comand
    Y.SEL.COMAND = ''
    CALL S.REDO.BUILD.SELECT.COMM(Y.APPLICATION,Y.COND.DEF,Y.SEL.COMAND,Y.ERR.MSG)
    IF Y.ERR.MSG NE '' THEN
        Y.MSG.ERR = Y.ERR.MSG
        GOSUB  RAISE.ERROR
    END

* if IF Y.RL.ID NE INDIVIDUAL.EMPLOYEES just report the principal customer
    IF Y.RL.ID EQ "INDIVIDUAL.EMPLOYEES" THEN
        LOCATE Y.CUSTOMER.ID IN R.EXT.QUEUE SETTING Y.QUEUE.POS ELSE
            R.EXT.QUEUE<-1> = Y.CUSTOMER.ID
        END
    END ELSE
        IF Y.SEL.COMAND NE '' THEN
            CALL EB.READLIST(Y.SEL.COMAND,R.CUS.REL,'',NO.OF.RECO,Y.ERR3)
            Y.CUS.ID  = ''
            Y.MARK    = ''
            LOOP
                REMOVE Y.CUS.ID FROM R.CUS.REL SETTING Y.MARK
            WHILE Y.CUS.ID:Y.MARK
                LOCATE Y.CUS.ID IN R.RL.REL.CUS SETTING Y.QUEUE.POS ELSE
                    R.RL.REL.CUS<-1> = Y.CUS.ID
                END
                LOCATE Y.CUS.ID IN R.EXT.QUEUE SETTING Y.QUEUE.POS ELSE
                    R.EXT.QUEUE<-1> = Y.CUS.ID
                END

            REPEAT
        END
    END
    R.RL.REL.CUS = CHANGE(R.RL.REL.CUS, @FM, @VM)

* Write the list of customers

    CALL F.WRITE(FN.REDO.CCRG.RL.REL.CUS,Y.RL.REL.CUS.ID,R.RL.REL.CUS)

*   Saved temporally the list of Related Customer by RiskLimit, It used when GROUP.TOTAL is recorded
    IF Y.RL.ID MATCHES "RISK.GROUP.SECURED" THEN
        Y.ARR.GRP.RISK<-1> = Y.RL.REL.CUS.ID
        Y.ARR.REL.CUS.GRP.RISK<-1> = R.RL.REL.CUS
    END


*
RETURN
*
* ====================
SAVE.EXTRACT.QUEUE:
* ====================
*
*  Put the customer evaluetd and customers vinculated in REDO.CCRG.EXT.QUEUE
*
    Y.PRGRAPH.NAME = 'SAVE.EXTRACT.QUEUE'
*

    Y.EXT.ID = Y.CUSTOMER.ID :'-': P.IN.PRO.ID
    R.REDO.CCRG.EXT.QUEUE = CHANGE(R.EXT.QUEUE, @FM, @VM)

    CALL F.WRITE(FN.REDO.CCRG.EXT.QUEUE,Y.EXT.ID,R.REDO.CCRG.EXT.QUEUE)
*
RETURN
*
* =================
DELETE.EVA.QUEUE:
* =================
* Delete the process record from EVA.QUEUE
*
*
    CALL F.DELETE(FN.REDO.CCRG.EVA.QUEUE,P.IN.PRO.ID)

*
RETURN
*
* =============
RAISE.ERROR:
* =============
*
*  Paragraph to control message error
*

    R.SOURCE.INFO    = ''
    R.SOURCE.INFO<1> = "REDO.B.CCRG.EVA"
    R.SOURCE.INFO<2> = Y.PRGRAPH.NAME
    R.SOURCE.INFO<4> = P.IN.PRO.ID
    CALL APAP.REDOBATCH.REDO.CCRG.B.TRACE.ERROR(R.SOURCE.INFO, Y.MSG.ERR, @FALSE, Y.CUSTOMER.ID, @TRUE) ;*R22 MANUAL CONVERSTION ADDING PACKAGE TO CALL ROUTINE

*
RETURN
*
* ===========
INITIALISE:
* ===========
*
*  Paragraph to initialise variables
    Y.PRGRAPH.NAME = 'INITIALISE'
*
    Y.LIST.RISK.LIMITS = ''
    PROCESS.GOAHEAD             = 1

    R.EXT.QUEUE                 = ''
    Y.CUSTOMER.ID               = ''
    Y.TEXT                      = ''

    GRP.RISK.POS = L.CU.GRP.RIESGO.POS
*
    Y.ARR.GRP.RISK = ''
    Y.ARR.REL.CUS.GRP.RISK = ''

RETURN
*----------------------------------------------------------------------------------------------
END
