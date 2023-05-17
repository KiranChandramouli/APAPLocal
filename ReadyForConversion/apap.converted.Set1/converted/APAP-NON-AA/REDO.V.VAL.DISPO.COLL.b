SUBROUTINE REDO.V.VAL.DISPO.COLL
*
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DISPO.COLL
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : DISPO VALUE FOR ARRANGEMENT
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.ACCOUNT
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN  ;* Program RETURN
*----------------------------------------------------------------------------------
PROCESS:
*======

    VAR.CRED  =  R.NEW(COLL.LOCAL.REF)<1,WPOS.CRED>

*if the user change a creditos an delete the credit number
    IF VAR.CRED EQ '' THEN
        RETURN
    END
* GET THE INFORMATION FOR THE SALD FOR ARRANGEMENT
    GOSUB GET.AAID.SM ;* PACS00307565 - S/E
*
*ERROR MESSAGE WHEN THE ARRANGEMETN DO NOT EXIST
    IF Y.ACCOUNT.ID EQ "" THEN  ;* PACS00312875 - S/E
        AF = COLL.LOCAL.REF
        AV = YPOS<1,1>
        AS = Y.VAR      ;* PACS00312875 - S/E
        ETEXT = 'ST-ERROR.SEL.CRED'
        CALL STORE.END.ERROR
        RETURN
    END
*
*SET THE DISPONIBLE VALUE FOR COLLATERAL

    VAR.MAX   =  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX>
    VAR.TOTAL = VAR.MAX - P.TOTAL.OUT
    IF VAR.TOTAL GT 0 THEN
        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISP> = VAR.TOTAL
    END
    ELSE
        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISP> = 0
    END

RETURN
*----------------------------------------------------------------------------
*
GET.AAID.SM:
*===========
*
    Y.AA.NUM = DCOUNT(VAR.CRED,@SM)
    Y.VAR = 1
    LOOP
    WHILE Y.VAR LE Y.AA.NUM
        Y.AA.ID = FIELD(VAR.CRED,@SM,Y.VAR)
        GOSUB READ.AA.ACCT
        IF Y.ERR NE "" THEN
            BREAK
        END
        GOSUB GET.AA.CURBAL       ;* PACS00312875 - S/E
        Y.VAR += 1
    REPEAT
*
RETURN
*
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
READ.AA.ACCT:
*===========
*
    IF Y.AA.ID MATCHES "AA..." THEN       ;*GET THE INFORMATION FOR THE SALD FOR ARRANGEMENT
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


    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
    WPOS.CRED  = YPOS<1,1>
    WPOS.MAX   = YPOS<1,2>
    WPOS.DISP  = YPOS<1,3>

    P.TOTAL.OUT = 0

RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.SALD,F.SALD)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    CALL OPF(FN.AC.BALANCE.TYPE,F.AC.BALANCE.TYPE)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*------------

*=============================
READ.AA.ARRANGEMENT:
*=============================
    CALL F.READ(FN.AA.ARRANGEMENT, Y.AA.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, Y.ERR)
    Y.ACCOUNT.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>

RETURN
*=============================
READ.ACCOUNT:
*=============================
    CALL F.READ(FN.ACCOUNT,Y.AA.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    Y.ACCOUNT.ID = Y.AA.ID
    Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    GOSUB READ.AA.ARRANGEMENT
RETURN
END
