* @ValidationCode : MjoyMDk0NDQ0NjE2OkNwMTI1MjoxNjgyNjkxNTIwMjU3OklUU1M6LTE6LTE6NTIwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 28 Apr 2023 19:48:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 520
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.DIPONIBLE

*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.DIPONIBLE
* Attached as     : ROUTINE
* Primary Purpose : SET THE DISPONIBLE VALUE FOR THE COLLATERAL
*
* Incoming:
* ---------
*
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
* Date            : DISPO VALUE FOR ARRANGEMENT
*
*-----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*13-04-2023              Samaran T                R22 Manual Code conversion                        CALL ROUTINE FORMAT MODIFIED
*-----------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.BALANCE.TYPE
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_GTS.COMMON
    $USING APAP.REDOSRTN

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

*EXCECUTE ONLY IF PRESS HOT FIELD
    VAR.HOT = OFS$HOT.FIELD
    IF LEN(VAR.HOT) EQ 0 THEN
        RETURN
    END
*
*if the user change a creditos an delete the credit number
    IF VAR.CRED EQ '' THEN
        R.NEW(COLL.LOCAL.REF)<1,WPOS.ESTAD> = "IN-FORCE"        ;*Set state in ACTIVA
        RETURN
    END
*
    Y.AA.ID = VAR.CRED
    GOSUB READ.AA.ACCT
*
*ERROR MESSAGE WHEN THE ARRANGEMENT DO NOT EXIST
    IF Y.ACCOUNT.ID EQ "" THEN
        ETEXT = 'ST-ERROR.SEL.CRED'
        CALL STORE.END.ERROR
        RETURN
    END
*
    GOSUB GET.AA.CURBAL         ;* PACS00312875 - S/E
*
    VAR.MAX  =  R.NEW(COLL.LOCAL.REF)<1,WPOS.MAX>
    VAR.TOTAL = VAR.MAX - P.TOTAL.OUT

    R.NEW(COLL.LOCAL.REF)<1,WPOS.ESTAD> = "IN-USE"  ;*Set state in ACTIVA

    IF VAR.TOTAL GT 0 THEN
        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISP> = VAR.TOTAL
    END
    ELSE
        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISP> = 0
        RETURN
    END

RETURN
*----------------------------------------------------------------------------

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

*      Y.ACCOUNT.ID = 0 ;* PACS00312875 - S/E

    FN.AC.BALANCE.TYPE = 'F.AC.BALANCE.TYPE'
    F.AC.BALANCE.TYPE  = ''
    R.AC.BALANCE.TYPE  = ''

*Read the local fields
    WCAMPO = "L.AC.LK.COL.ID"
    WCAMPO<2> = "L.COL.LN.MX.VAL"
    WCAMPO<3> = "L.COL.VAL.AVA"
    WCAMPO<4> = "L.COL.EXE.DATE"
    WCAMPO<5> = "L.COL.SEC.HOLD"
    WCAMPO<6> = "L.COL.SEC.STA"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    YPOS=0

*Get the position for all fields
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
    WPOS.CRED  = YPOS<1,1>
    WPOS.MAX   = YPOS<1,2>
    WPOS.DISP  = YPOS<1,3>
    WPOS.FECH  = YPOS<1,4>
    WPOS.CUST  = YPOS<1,5>
    WPOS.ESTAD = YPOS<1,6>
* PACS00312875 - S
    VAR.CRED   = COMI
    Y.AA.ID    = ''
* PACS00312875 - E
*
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
    VAR.CUS.CRED = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
RETURN
*
*=============
GET.AA.CURBAL:
*=============
*
* Get outstanding from AA
    P.TOTAL.OUT = ''
    APAP.REDOSRTN.redoSGetOutBalance(Y.AA.ID,TOTAL.AMT) ;*R22 MANUAL CODE CONVERSION
    P.TOTAL.OUT    = TOTAL.AMT
*
RETURN
*
*============
READ.AA.ACCT:
*============
*GET THE INFORMATION FOR THE SALD FOR ARRANGEMENT
    IF Y.AA.ID MATCHES "AA..." THEN
        GOSUB READ.AA.ARRANGEMENT
    END
    ELSE
        GOSUB READ.ACCOUNT
    END
*
RETURN
*
*=============================
READ.ACCOUNT:
*=============================
    CALL F.READ(FN.ACCOUNT,Y.AA.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    Y.ACCOUNT.ID = Y.AA.ID      ;* PACS00312875 - S
    Y.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>          ;* PACS00312875 - E
    GOSUB READ.AA.ARRANGEMENT
RETURN
END
