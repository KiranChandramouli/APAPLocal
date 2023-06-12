* @ValidationCode : Mjo0MjA5OTQ0MzA6VVRGLTg6MTY4NTUyNjQzMDEyOTpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 15:17:10
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.PRINCIPAL.VAL
* ============================================================================
* Subroutine Type : ROUTINE
* Attached to     : VALIDATION.ROUTINE
* Attached as     :
* Primary Purpose : VALIDATE THE DATE, CURRENCY, AMOUNT AND TERM FROM HEADER TO REDO.CREATE.ARRANGEMENT TEMPLATE.
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Adapted by      : Jorge Valarezo - TAM Latin America
* Base on         : REDO.FC.VAL.CURRENCY REDO.FC.VAL.VALUE.DATE REDO.FC.VAL.AMOUNT REDO.FC.VAL.PLAZO
* Date            : Oct 27 2011
* Notes           :
* Adapted by      : MGUDINO - TAM Latin America
* Base on         : CALLING validations to the limits - REDO.FC.POPULATED.LIM
* Date            : Mar 19 2013
* Notes           :
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION           CALL RTN METHOD ADDED
*==============================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.USER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_GTS.COMMON

********************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

* UPLOAD THE LIMIT IF THIS EXIST
    APAP.REDOFCFI.redoFcPopulatedLim();*MANUAL R22 CODE CONVERSION
    

RETURN

* ======
PROCESS:
* ======
    GOSUB FECHA.CREACION.GARANTIA
    GOSUB MONTO
    GOSUB CURRENCY
    GOSUB PLAZO

RETURN

* =====================
FECHA.CREACION.GARANTIA:
* =====================
    Y.USR.ID = OPERATOR
    CALL CACHE.READ(FN.USR, Y.USR.ID, R.USR, USR.ERR);* R22 Auto conversion
    IF USR.ERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.USR
        CALL STORE.END.ERROR
    END

    VAR.BAN.DATE = R.USR<EB.USE.LOCAL.REF,WPOSUSER>

    IF (VAR.BAN.DATE EQ '') THEN
        AF = REDO.FC.EFFECT.DATE
        TEXT = 'EB-FC-USER-ALOW-VALID'
        CALL STORE.END.ERROR
    END

    Y.F.CREA.GAR = R.NEW(REDO.FC.EFFECT.DATE)       ;*FECHA.CREACION.GARANTIA
    IF Y.F.CREA.GAR THEN
        IF (VAR.BAN.DATE EQ 2) AND (Y.F.CREA.GAR NE Y.TODAY) THEN
            AF = REDO.FC.EFFECT.DATE
            ETEXT = 'EB-FC-NO.ALLOW-TO-USER'
            CALL STORE.END.ERROR
        END
        IF Y.F.CREA.GAR GT Y.TODAY THEN
            AF = REDO.FC.EFFECT.DATE
            ETEXT = 'EB-FC-DONT-AFTER-DATE'
            CALL STORE.END.ERROR
        END
    END

RETURN


* =========
MONTO:
* =========
*
    Y.AMOUNT = R.NEW(REDO.FC.AMOUNT)

    Y.ID.ARR.PRD.CAT.TERM.AMOUNT = Y.ARR.PRODUCT:'-COMMITMENT':'-':Y.ARR.CURRENCY:'...'
    SELECT.STATEMENT = 'SELECT ':FN.AA.PRD.CAT.TERM.AMOUNT:' ':'WITH @ID LIKE ':Y.ID.ARR.PRD.CAT.TERM.AMOUNT:' BY-DSND ID.COMP.5'
    AA.PRD.CAT.TERM.AMOUNT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,AA.PRD.CAT.TERM.AMOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    REMOVE Y.ID.AA.PRD FROM AA.PRD.CAT.TERM.AMOUNT.LIST SETTING POS

    CALL CACHE.READ(FN.AA.PRD.CAT.TERM.AMOUNT, Y.ID.AA.PRD, R.ARR.PRD.CAT.TERM.AMOUNT, Y.ERR)
    Y.ATTRIBUTE = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.ATTRIBUTE>
    Y.NR.TYPE  = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.TYPE>
    Y.NR.VALUE = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.VALUE>

    LOCATE "AMOUNT" IN Y.ATTRIBUTE<1,1> SETTING APOS THEN

        LOCATE Y.MAXIMUN IN Y.NR.TYPE<1,APOS,1> SETTING YPOS THEN
            Y.NR.VALUE.MAX = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.VALUE,APOS,YPOS>

            IF Y.AMOUNT GT Y.NR.VALUE.MAX THEN ;*R22 AUTO CODE CONVERSION
                AF = REDO.FC.AMOUNT
                TEXT = 'OEB-FC-AMOUNT-NO-PRODUCT'
                M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
                CALL STORE.OVERRIDE(M.CONT)
            END
        END
        LOCATE Y.MINIMUN IN Y.NR.TYPE<1,APOS,1> SETTING ZPOS THEN
            Y.NR.VALUE.MIN = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.VALUE,APOS,ZPOS>

            IF Y.AMOUNT LT Y.NR.VALUE.MIN THEN
                AF = REDO.FC.AMOUNT
                TEXT = 'OEB-FC-AMOUNT-NO-PRODUCT'
                M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
                CALL STORE.OVERRIDE(M.CONT)
            END
        END


    END

RETURN

* ======
CURRENCY:
* ======


    SEL.CMD  = 'SELECT ' :FN.AA.PRODUCT.DESIGNER
    SEL.CMD := '  LIKE ' :Y.PRODUCT: '-... BY-DSND @ID'
    SEL.LIST = ''
    NO.REC   = ''
    SEL.ERR  = ''
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.REC, SEL.ERR)
    IF SEL.LIST THEN
        REMOVE ID.PRODUCT FROM SEL.LIST SETTING POS
        CALL CACHE.READ(FN.AA.PRODUCT.DESIGNER, ID.PRODUCT, R.AA.PRODUCT.DESIGNER, Y.ERR)
        Y.CURRENCY =  R.AA.PRODUCT.DESIGNER<AA.PRD.CURRENCY>

        LOCATE  Y.ARR.CURRENCY IN Y.CURRENCY<1,1> SETTING YPOS ELSE

            AF = REDO.FC.LOAN.CURRENCY
            ETEXT = 'EB-FC-CURRENCY-NOTIN-PRODUCT'
            CALL STORE.END.ERROR

        END
    END


RETURN

* =========
PLAZO:
* =========
*


    Y.TERM = R.NEW(REDO.FC.TERM)
    Y.TERM.AUX=Y.TERM
    Y.TERM.AUX1=Y.TERM
    Y.ID.ARR.PRD.CAT.TERM.AMOUNT = Y.ARR.PRODUCT:'-COMMITMENT':'-':Y.ARR.CURRENCY:'...'
    SELECT.STATEMENT = 'SELECT ':FN.AA.PRD.CAT.TERM.AMOUNT:' ':'WITH @ID LIKE ':Y.ID.ARR.PRD.CAT.TERM.AMOUNT:' BY-DSND ID.COMP.5'
    AA.PRD.CAT.TERM.AMOUNT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    Y.ID.AA.PRD = ''
    CALL EB.READLIST(SELECT.STATEMENT,AA.PRD.CAT.TERM.AMOUNT.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    REMOVE Y.ID.AA.PRD FROM AA.PRD.CAT.TERM.AMOUNT.LIST SETTING POS

    CALL CACHE.READ(FN.AA.PRD.CAT.TERM.AMOUNT, Y.ID.AA.PRD, R.ARR.PRD.CAT.TERM.AMOUNT, Y.ERR)
    Y.ATTRIBUTE = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.ATTRIBUTE>
    Y.NR.TYPE  = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.TYPE>
    Y.NR.VALUE = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.VALUE>

    LOCATE "TERM" IN Y.ATTRIBUTE<1,1> SETTING APOS THEN

        LOCATE "MINPERIOD" IN Y.NR.TYPE<1,APOS,1> SETTING YPOS THEN
            Y.NR.VALUE.MIN = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.VALUE><1,APOS,YPOS>


            CALL CALENDAR.DAY(Y.ACTUAL,'+',Y.NR.VALUE.MIN)
            CALL CALENDAR.DAY(Y.ACTUAL,'+',Y.TERM.AUX)


            IF  Y.TERM.AUX LT Y.NR.VALUE.MIN THEN
                AF = REDO.FC.TERM
                TEXT = 'OEB-FC-DONT-PRODUCT'
                M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
                CALL STORE.OVERRIDE(M.CONT)
            END
        END
        LOCATE "MAXPERIOD" IN Y.NR.TYPE<1,APOS,1> SETTING ZPOS THEN
            Y.NR.VALUE.MAXP = R.ARR.PRD.CAT.TERM.AMOUNT<AA.AMT.NR.VALUE><1,APOS,ZPOS>


            CALL CALENDAR.DAY(Y.ACTUAL,'+',Y.NR.VALUE.MAXP)
            CALL CALENDAR.DAY(Y.ACTUAL,'+',Y.TERM.AUX1)


            IF  Y.TERM.AUX1 GT Y.NR.VALUE.MAXP THEN
                AF = REDO.FC.TERM
                TEXT = 'OEB-FC-DONT-PRODUCT'
                M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
                CALL STORE.OVERRIDE(M.CONT)
            END
        END


    END

RETURN


* =========
OPEN.FILES:
* =========
    CALL OPF(FN.AA.PRD.CAT.TERM.AMOUNT, F.AA.PRD.CAT.TERM.AMOUNT)
    CALL OPF(FN.USR, F.USR)
    CALL OPF(FN.AA.PRODUCT.DESIGNER,F.AA.PRODUCT.DESIGNER)

RETURN

* =========
INITIALISE:
* =========
    Y.TODAY= TODAY
*< OF DATE VALIDATION
    FN.USR  = 'F.USER'
    F.USR   = ''
    R.USR   = ''
    WCAMPOU = "VAL.MODI.DATE"
    WCAMPOU = CHANGE(WCAMPOU,@FM,@VM)
    YPOSU=''
    CALL MULTI.GET.LOC.REF("USER",WCAMPOU,YPOSU)
    WPOSUSER  = YPOSU<1,1>

    Y.ACTUAL = TODAY
*>
*< OF AMOUNT VALIDATION

    Y.MAXIMUN="MAXIMUM"
    Y.MINIMUN="MINIMUM"
*>
*< OF TERM VALIDATION
    FN.AA.PRD.CAT.TERM.AMOUNT = 'FBNK.AA.PRD.CAT.TERM.AMOUNT'
    F.AA.PRD.CAT.TERM.AMOUNT = ''
    Y.ARR.PRODUCT =  R.NEW(REDO.FC.PRODUCT)
    Y.ARR.CURRENCY = R.NEW(REDO.FC.LOAN.CURRENCY)

*>


*< OF CURR VALIDATION
    Y.PRODUCT = R.NEW(REDO.FC.PRODUCT)
    FN.AA.PRODUCT.DESIGNER= "F.AA.PRODUCT.DESIGNER"
    F.AA.PRODUCT.DESIGNER=""
    Y.ARR.CURRENCY = R.NEW(REDO.FC.LOAN.CURRENCY)

*>

RETURN

END
