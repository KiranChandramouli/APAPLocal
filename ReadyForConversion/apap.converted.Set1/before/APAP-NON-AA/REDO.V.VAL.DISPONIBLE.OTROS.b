*-----------------------------------------------------------------------------
* <Rating>-135</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.VAL.DISPONIBLE.OTROS
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DIPONIBLE.OTROS
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            :
*-----------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_GTS.COMMON

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
        GOSUB PIGNORADO
    END


    RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

*EXCECUTE ONLY IF PRES HOT FIELD
    VAR.HOT = OFS$HOT.FIELD
    IF LEN(VAR.HOT) EQ 0 THEN
        RETURN
    END

    VAR.CRED = R.NEW(COLL.LOCAL.REF)<1,WPOS.CRED>
*if the user change a creditos an delete the credit number
    IF VAR.CRED EQ '' THEN
*        R.NEW(COLL.LOCAL.REF)<1,WPOS.ESTAD> = "IN-FORCE"    ;*Set state in ACTIVA
        RETURN
    END
    IF LEN(VAR.CRED) EQ 0 THEN
        RETURN
    END

*GET THE INFORMATION FOR THE SALD FOR ARRANGEMENT
    GOSUB GET.AAID.SM         ;* PACS00307565 - S/E

*ERROR MESSAGE WHEN THE ARRANGEMETN DO NOT EXIST
    IF Y.ACCOUNT.ID EQ 0 THEN
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        AS = Y.VAR
        ETEXT = 'ST-ERROR.SEL.CRED'
        CALL STORE.END.ERROR
        RETURN
    END

    P.TOTAL.OUT = ABS(P.TOTAL.OUT)

    VAR.MAX  =  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX>

*** SET THE MAXIMUN VALUE ***
    P.TOTAL.OUT = P.TOTAL.OUT

    VAR.POR = R.NEW(COLL.LOCAL.REF)<1,WPOS.PORC>


    R.NEW(COLL.LOCAL.REF)<1,WPOS.ESTAD> = "IN-USE"          ;*Set state in USADA

* verify positive values
    IF (VAR.MAX - P.TOTAL.OUT) GE 0 THEN

*THIS ROWS WAS COMENTED 13/06/2011 ISSUE REPORTED
*        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISP> = 0 ;*VAR.MAX - P.TOTAL.OUT
*        R.NEW(COLL.EXECUTION.VALUE) = P.TOTAL.OUT
*        R.NEW(COLL.NOMINAL.VALUE) = P.TOTAL.OUT
*        R.NEW(COLL.MAXIMUM.VALUE) = P.TOTAL.OUT
*        R.NEW(COLL.GEN.LEDGER.VALUE) = P.TOTAL.OUT

*        R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX> = (P.TOTAL.OUT * VAR.POR)


    END
    ELSE
*        AF = COLL.LOCAL.REF
*        AV = YPOS<1,1>
*        ETEXT = 'ST-MAX.COLL.CRED'
*        CALL STORE.END.ERROR
*        RETURN

*THIS ROWS WAS COMENTED 13/06/2011 ISSUE REPORTED
*         R.NEW(COLL.LOCAL.REF)<1,WPOS.DISP> = 0
*         R.NEW(COLL.EXECUTION.VALUE) = P.TOTAL.OUT
*         R.NEW(COLL.NOMINAL.VALUE) = P.TOTAL.OUT
*         R.NEW(COLL.MAXIMUM.VALUE) = P.TOTAL.OUT
*         R.NEW(COLL.GEN.LEDGER.VALUE) = P.TOTAL.OUT

*         R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX> = (P.TOTAL.OUT * VAR.POR)
    END

*Calc the REA VALUE
    CALL  REDO.V.VAL.REA.COLLATERAL

    RETURN
*----------------------------------------------------------------------------
*
GET.AAID.SM:
*===========
*
    Y.AA.NUM = DCOUNT(VAR.CRED,SM)
    Y.VAR = 1
    LOOP
    WHILE Y.VAR LE Y.AA.NUM
        Y.AA.ID = FIELD(VAR.CRED,SM,Y.VAR)
        GOSUB READ.AA.ACCT
        IF Y.ERR NE "" THEN
            BREAK
        END
        GOSUB GET.AA.CURBAL   ;* PACS00307565 - S/E
        Y.VAR++
    REPEAT
*
    RETURN
*
READ.AA.ACCT:
*===========
*
    IF Y.AA.ID MATCHES "AA..." THEN     ;*GET THE INFORMATION FOR THE SALD FOR ARRANGEMENT
        GOSUB READ.AA.ARRANGEMENT
    END
    ELSE
        GOSUB READ.ACCOUNT
    END
*
    RETURN
*
INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    FN.SALD  = 'F.EB.CONTRACT.BALANCES'
    F.SALD   = ''
    R.SALD   = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT = ''

    FN.AA.ARRANGEMENT  = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    R.AA.ARRANGEMENT   = ''

    FN.AC.BALANCE.TYPE = 'F.AC.BALANCE.TYPE'
    F.AC.BALANCE.TYPE  = ''
    R.AC.BALANCE.TYPE  = ''

*Read the local fields
    WCAMPO = "L.AC.LK.COL.ID"
    WCAMPO<2> = "L.COL.LN.MX.VAL"
    WCAMPO<3> = "L.COL.VAL.AVA"
    WCAMPO<4> = "L.COL.EXE.DATE"
    WCAMPO<5> = "L.COL.LN.MX.PER"
    WCAMPO<6> = "L.COL.SEC.STA"

    WCAMPO = CHANGE(WCAMPO,FM,VM)
    YPOS=0
    WCAMPO<2>= "L.AA.RISK.PER"
*Get the position for all fields
    LOC.REF.APPLICATION = 'COLLATERAL' : FM : 'AA.PRD.CAT.TERM.AMOUNT'
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,WCAMPO,YPOS)
    WPOS.CRED  = YPOS<1,1>
    WPOS.MAX   = YPOS<1,2>
    WPOS.DISP  = YPOS<1,3>
    WPOS.FECH  = YPOS<1,4>
    WPOS.PORC  = YPOS<1,5>
    WPOS.ESTAD = YPOS<1,6>
    WPOS.RISK  = YPOS<2>

*GET THE IFORMATION FOR PRODUCT
    FN.DETCRED  = 'F.AA.PRD.CAT.TERM.AMOUNT'
    F.DETCRED   = ''
    R.DETCRED   = ''

    VAR.PRODUCTO = ''
    VAR.MONEDA   = ''
    DETCRE.LIST  = ''

    RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.SALD,F.SALD)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    CALL OPF(FN.AC.BALANCE.TYPE,F.AC.BALANCE.TYPE)
    CALL OPF(FN.DETCRED,F.DETCRED)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    RETURN
*------------

PIGNORADO:
*=========
*EXCECUTE ONLY IF PRES HOT FIELD
    VAR.HOT = OFS$HOT.FIELD
    IF LEN(VAR.HOT) EQ 0 THEN
        RETURN
    END
    VAR.CRED   = COMI

*if the user change a creditos an delete the credit number
    IF VAR.CRED EQ '' THEN
        RETURN
    END

*if the user change a creditos an delete the credit number
    IF LEN(VAR.CRED) EQ 0 THEN
        RETURN
    END


* GET THE % INTERNAL DEPOSITOS

    VAR.DETCRED = VAR.PRODUCTO:'-COMMITMENT-':VAR.MONEDA
    SELECT.STATEMENT = 'SELECT ':FN.DETCRED:' WITH @ID LIKE ':VAR.DETCRED ...
    DETCRE.LIST = ''
    LISTA.NOMBRE = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,DETCRE.LIST,LISTA.NOMBRE,SELECTED,SYSTEM.RETURN.CODDE)

*GET ALL VALUES FROM THE LIST AND ADD THE LOCK VALUE
    LOOP
        REMOVE Y.ID.AA.PRD FROM DETCRE.LIST SETTING POS
    WHILE Y.ID.AA.PRD:POS

        CALL CACHE.READ(FN.DETCRED, Y.ID.AA.PRD, R.DDDW, Y.ERR)

        VAR.PORCENT    =  R.DDDW<AA.AMT.LOCAL.REF,WPOS.RISK>

*SET THE PIGNORATION VALUE
        IF LEN(VAR.PORCENT) GT 0 THEN
            VAR.PIG = (P.TOTAL.OUT * VAR.PORCENT)/100
            VAR.PIG = DROUND(VAR.PIG,2)
            R.NEW(COLL.NOMINAL.VALUE) = VAR.PIG
        END
        ELSE
            AF = COLL.LOCAL.REF
            AV = YPOS<1,1>
            ETEXT = 'ST-PORCET.NOT.EXIST'
            CALL STORE.END.ERROR
            RETURN
        END


    REPEAT

    RETURN
*------------
*=============
GET.AA.CURBAL:
*=============
*
* Get outstanding from AA
    P.TOTAL.OUT = ''
    CALL REDO.S.GET.OUT.BALANCE(Y.AA.ID,TOTAL.AMT)
    P.TOTAL.OUT    += TOTAL.AMT
*
    RETURN
*
*=============================
READ.AA.ARRANGEMENT:
*=============================
    CALL F.READ(FN.AA.ARRANGEMENT, Y.AA.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, Y.ERR)
    Y.ACCOUNT.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    VAR.CUS.CRED = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    VAR.PRODUCTO =  R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    VAR.MONEDA   =  R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    RETURN
*=============================
READ.ACCOUNT:
*=============================
    CALL F.READ(FN.ACCOUNT,Y.AA.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    Y.ACCOUNT.ID = Y.AA.ID    ;* PACS00307565 - S
    Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>        ;* PACS00307565 - E
    GOSUB READ.AA.ARRANGEMENT
    RETURN

END

