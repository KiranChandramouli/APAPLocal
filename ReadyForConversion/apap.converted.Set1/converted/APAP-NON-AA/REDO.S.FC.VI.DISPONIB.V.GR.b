SUBROUTINE REDO.S.FC.VI.DISPONIB.V.GR(AA.ID,VI.ARR)

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.FC.ENQPARMS
* Attached as     : ROUTINE
* Primary Purpose : Get the limit value minus of the value taken by group linked and risk group
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres- TAM Latin America
* Date            : 10/10/2001
*
*MG 2013 03 20
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.CUSTOMER
    $INSERT I_System

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB VERIFY.PROCESS
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
VERIFY.PROCESS:
*======
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    Y.ERROR = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,Y.ERROR)
    IF R.CUSTOMER THEN
        IF R.CUSTOMER<EB.CUS.CUSTOMER.TYPE> EQ 'PROSPECT' THEN
            VI.ARR = ''
            RETURN
        END
    END

    IF ID.CUST THEN
        IF ID.CUST.LIM THEN
            IF ID.CUST EQ Y.CUS.ID THEN
                GOSUB PROCESS
            END ELSE
                GOSUB OFS.PROCESS
            END
        END
    END ELSE
        GOSUB OFS.PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------
OFS.PROCESS:
*======

    Y.MESSAGE.ACC  = "REDO.CCRG.CUSTOMER,MAN/////,,,CUSTOMER.ID::=" : Y.CUS.ID

    AC.EXPECTED.RECS = "TAM.OFS.SRC"

    CALL OFS.GLOBUS.MANAGER("AC.EXPECTED.RECS",Y.MESSAGE.ACC)

    Y.F.RES = FIELD(Y.MESSAGE.ACC,",",1)
    Y.RESCTA = FIELD(Y.F.RES,"/",3)

    IF Y.RESCTA LT 0 THEN
* error
    END ELSE
        CALL REDO.FC.E.MAIN(Y.CUS.ID,DATA.ENQ)
        IF DATA.ENQ THEN
            GOSUB Y.DATA.ENQ
        END

    END
*-----------------------------------------------------------------------------------
Y.DATA.ENQ:
*======
    DATA.ENQ = CHANGE(DATA.ENQ,@FM,@VM)
    Y.COUNT.DATA = DCOUNT(DATA.ENQ,@VM)
    FOR Y.I = 1 TO Y.COUNT.DATA
        DATA.ENQ.AUX = DATA.ENQ
        DATA.ENQ.AUX = FIELD(DATA.ENQ.AUX<1,Y.I>,"*",1)
        Y.DATA.ENQ.AUX<-1>=DATA.ENQ.AUX
    NEXT Y.I
    Y.DATA.ENQ.AUX = CHANGE(Y.DATA.ENQ.AUX,@FM,@VM)
    GOSUB DISPONIB
RETURN

*-----------------------------------------------------------------------------------
DISPONIB:
*======

    CALL REDO.S.FC.LIMITE.TOPE.VINC(Y.CUS.ID, CUST.OUT)
    Y.TOPE.VINC= CUST.OUT
    CALL REDO.S.FC.LIMITE.TOPE.GR(Y.CUS.ID, CUST.OUT)
    Y.TOPE.GR =CUST.OUT
    Y.TOPE.TOT  = Y.TOPE.VINC+Y.TOPE.GR

    LOCATE  "RISK.INDIV.TOTAL" IN Y.DATA.ENQ.AUX<1,1> SETTING Y.RISK.IN.T THEN
        DEL DATA.ENQ<1,Y.RISK.IN.T>
        DEL Y.DATA.ENQ.AUX<1,Y.RISK.IN.T>
    END
    LOCATE  "RISK.GROUP.TOTAL" IN Y.DATA.ENQ.AUX<1,1> SETTING Y.RISK.GR.T THEN
        DEL DATA.ENQ<1,Y.RISK.GR.T>
        DEL Y.DATA.ENQ.AUX<1,Y.RISK.GR.T>
    END

    GOSUB PROCESS

RETURN

*------------------------
PROCESS:
*=========
    YPOS.TOPE="3"
    Y.COUNT.DATA = DCOUNT(DATA.ENQ,@VM)
    FOR Y.I = 1 TO Y.COUNT.DATA
        Y.LIMIT.KIND=FIELD(DATA.ENQ,@VM,Y.I)
        Y.TOT.TOM = FIELD(Y.LIMIT.KIND,"*",YPOS.TOPE)
        Y.TOT.TOM = TRIM(Y.TOT.TOM, "", "D")
        Y.TOT.TOM = TRIM(Y.TOT.TOM, ",", "A")

        Y.TOT.TOMADO += Y.TOT.TOM

    NEXT Y.I

    VI.ARR = Y.TOPE.TOT-Y.TOT.TOMADO

RETURN
*------------------------
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    VI.ARR = ''
    Y.CUS.ID = AA.ID
    VI.ARR = ''
    ID.CUST.LIM = System.getVariable("ID.CUST.LIM")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        ID.CUST.LIM = ""
    END
    ID.CUST = System.getVariable("ID.CUST")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        ID.CUST = ""
    END

RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
