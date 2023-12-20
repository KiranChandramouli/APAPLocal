* @ValidationCode : Mjo0ODk0Mzk5NTA6Q3AxMjUyOjE3MDI5OTA5NDUyMjA6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:32:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.S.ACC.VAL

* Subroutine Type : ROUTINE
* Attached to     : ACC.TO.DEBIT field
* Attached as     : ROUTINE
* Primary Purpose : Validate if the account chosed belongs to client or it is not.
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
*
*-----------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 31 Oct 2011
*
* Edited by  : Jorge Valarezo - TAM Latin America
* Date            : 03 Jan 2012
*
* Edited by       :  Edwin Charles
* Date            :  01 Nov 2017
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
**14-12-2023         VIGNESHWARI                       MANUAL R22 CODE CONVERSION           VARIABLE IS HARDCODED
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.AA.DD.CATEGORY
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER

    CAMPO.ACTUAL = OFS$HOT.FIELD
    NOMBRE.CAMPO = 'ACC.TO.DEBIT'
    IF CAMPO.ACTUAL EQ NOMBRE.CAMPO THEN
        NRO.ACC = COMI
        Y.DEBIT.ACCT.NO = ''
        Y.DEBIT.ACCT.NO = COMI
    END
    ELSE
        NRO.ACC = R.NEW(REDO.FC.ACC.TO.DEBIT)
        Y.DEBIT.ACCT.NO = ''
        Y.DEBIT.ACCT.NO = R.NEW(REDO.FC.ACC.TO.DEBIT)
    END
* edited de content according to content LOCAL.FIELD 304
    IF R.NEW(REDO.FC.PAYMT.MHD) NE 'Direct Debit' OR NRO.ACC EQ '' THEN
        RETURN
    END

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    IF PGM.VERSION EQ ',GEN' OR PGM.VERSION EQ ',MANUAL.DE' OR PGM.VERSION EQ ',MANUAL.FS' THEN
    END ELSE
        IF PROCESS.GOAHEAD THEN
            GOSUB PROCESS.MAIN
        END
    END

    GOSUB PROCESS

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*============

    CALL F.READ(FN.ACCOUNT,NRO.ACC,R.ACCOUNT,F.ACCOUNT,YERR)
    IF YERR THEN
        ETEXT = "EB-FC-READ.ERROR" : @FM : FN.ACCOUNT
        CALL STORE.END.ERROR
        RETURN
    END

    IF R.ACCOUNT<AC.CUSTOMER> NE R.NEW(REDO.FC.CUSTOMER) THEN

        TEXT = "REDO.FC.ACC.ISNOT"
        M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(M.CONT)

    END

RETURN

PROCESS:
*-------

    Y.FROM.CAT.LIST = R.REDO.AA.DD.CATEGORY<DD.CT.FROM.CATEGORY>
    Y.TO.CAT.LIST = R.REDO.AA.DD.CATEGORY<DD.CT.TO.CATEGORY>

    IF NOT(Y.FROM.CAT.LIST) THEN
        ETEXT = 'EB-ACCT.NOT.DD.CATEGORY'
        CALL STORE.END.ERROR
        RETURN
    END

    IF Y.DEBIT.ACCT.NO THEN
        CHANGE @VM TO @FM IN Y.FROM.CAT.LIST
        CHANGE @VM TO @FM IN Y.TO.CAT.LIST
        Y.ACCT.CATEG = '' ; R.ACCOUNT = ''; ACC.ERR = '' ; Y.DD.CUSTOMER = '' ; Y.DD.JOINT.HOLDER = '' ; Y.DD.RELATION.CODE = ''
        CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        Y.ACCT.CATEG = R.ACCOUNT<AC.CATEGORY>
        Y.DD.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
        Y.TOT.CAT.CNT = DCOUNT(Y.FROM.CAT.LIST, @FM)
        PROCESS.GOAHEAD = ''

        CNT = 1
        LOOP
        WHILE CNT LE Y.TOT.CAT.CNT
            GOSUB CHECK.CATEGORY.RANGE
            CNT += 1
        REPEAT

        IF NOT(PROCESS.GOAHEAD) THEN
            ETEXT = 'EB-ACCT.NOT.DD.CATEGORY'
            CALL STORE.END.ERROR
            RETURN
        END

        IF Y.LOAN.CUSTOMER NE Y.DD.CUSTOMER THEN
            GOSUB GET.SAVINGS.RELATION
            GOSUB GET.LOAN.CUST.RELATION
            GOSUB RAISE.OVERRIDE
        END
    END

RETURN

CHECK.CATEGORY.RANGE:
*-------------------

    BEGIN CASE

        CASE Y.ACCT.CATEG EQ Y.FROM.CAT.LIST<CNT> OR (Y.TO.CAT.LIST<CNT> AND Y.ACCT.CATEG EQ Y.TO.CAT.LIST<CNT>)
            PROCESS.GOAHEAD = '1'
        CASE Y.ACCT.CATEG GT Y.FROM.CAT.LIST<CNT> AND Y.ACCT.CATEG LT Y.TO.CAT.LIST<CNT>
            PROCESS.GOAHEAD = '1'
        CASE 1

    END CASE

RETURN

GET.SAVINGS.RELATION:
*-------------------

    R.CUSTOMER.ACCOUNT = '' ; Y.DD.JOINT.HOLDER.LIST = '' ; Y.DD.RELATION.CODE.LIST = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.DD.CUSTOMER,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)

    Y.DD.JOINT.HOLDER.LIST<1, -1> = Y.DD.CUSTOMER

    IF R.CUSTOMER.ACCOUNT THEN
        TOT.ACCT.CNT = DCOUNT(R.CUSTOMER.ACCOUNT, @FM)
        CNT = 1
        LOOP
        WHILE CNT LE TOT.ACCT.CNT
            Y.ACCT = R.CUSTOMER.ACCOUNT<CNT>
            CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            Y.DD.JOINT.HOLDER.LIST<1, -1> = R.ACCOUNT<AC.JOINT.HOLDER>
            Y.DD.RELATION.CODE.LIST<1, -1> = R.ACCOUNT<AC.RELATION.CODE>
            CNT += 1
        REPEAT
    END

RETURN

GET.LOAN.CUST.RELATION:
*----------------------
    RAISE.OVERRIDE = ''
    R.CUSTOMER.ACCOUNT = '' ; Y.LN.JOINT.HOLDER.LIST = '' ; Y.LN.RELATION.CODE.LIST = ''
    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.LOAN.CUSTOMER,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)

    IF R.CUSTOMER.ACCOUNT THEN
        TOT.ACCT.CNT = DCOUNT(R.CUSTOMER.ACCOUNT, @FM)
        CNT = 1
        LOOP
        WHILE CNT LE TOT.ACCT.CNT
            Y.ACCT = R.CUSTOMER.ACCOUNT<CNT>
            CALL F.READ(FN.ACCOUNT,Y.ACCT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            Y.LN.JOINT.HOLDER = R.ACCOUNT<AC.JOINT.HOLDER>
            Y.LN.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE>
            GOSUB VALIDATE.RELATION.CODE
            CNT += 1
        REPEAT
    END

RETURN

VALIDATE.RELATION.CODE:
*----------------------
    Y.DD.RELATION.CODE = Y.DD.RELATION.CODE.LIST<1,1>
    BEGIN CASE
* NULL / OR condition
        CASE NOT(Y.LN.JOINT.HOLDER) OR (Y.LN.JOINT.HOLDER AND Y.LN.RELATION.CODE EQ '501')
            IF Y.LOAN.CUSTOMER MATCHES Y.DD.JOINT.HOLDER.LIST AND Y.DD.RELATION.CODE EQ '501' THEN
                RAISE.OVERRIDE = '1'
            END ELSE
            END
* AND / AND condition
        CASE Y.LN.RELATION.CODE EQ '500' AND Y.DD.RELATION.CODE EQ '500'
            IF Y.LOAN.CUSTOMER MATCHES Y.DD.JOINT.HOLDER.LIST AND Y.LN.JOINT.HOLDER MATCHES Y.DD.JOINT.HOLDER.LIST THEN
                RAISE.OVERRIDE = '1'
            END ELSE
            END
* AND / OR condition
        CASE Y.LN.RELATION.CODE EQ '500' AND Y.DD.RELATION.CODE EQ '501'
            IF Y.LOAN.CUSTOMER MATCHES Y.DD.JOINT.HOLDER.LIST OR Y.LN.JOINT.HOLDER MATCHES Y.DD.JOINT.HOLDER.LIST THEN
                RAISE.OVERRIDE = '1'
            END ELSE
            END
*   AND / NULL condition
        CASE Y.LN.RELATION.CODE EQ '500' AND NOT(Y.DD.RELATION.CODE)
            IF Y.LOAN.CUSTOMER MATCHES Y.DD.JOINT.HOLDER.LIST OR Y.LN.JOINT.HOLDER MATCHES Y.DD.JOINT.HOLDER.LIST THEN
                RAISE.OVERRIDE = '1'
            END ELSE
            END
* remaining condition
        CASE 1

    END CASE

RETURN

RAISE.OVERRIDE:
*--------------

    IF NOT(RAISE.OVERRIDE) THEN
        CURR.NO = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM)
        TEXT = 'AA-CUSTOMER.SHOULD.APPROVE.PROCEED'
        CALL STORE.OVERRIDE(CURR.NO+1)
    END

RETURN

*---------
INITIALISE:
*=========

    YERR = ''
    PROCESS.GOAHEAD = 1

RETURN
*------------------------
OPEN.FILES:
*=========

    FN.REDO.AA.DD.CATEGORY = 'F.REDO.AA.DD.CATEGORY'
    F.REDO.AA.DD.CATEGORY = ''
    CALL OPF(FN.REDO.AA.DD.CATEGORY, F.REDO.AA.DD.CATEGORY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)
    ID.VAR='SYSTEM'
    CALL CACHE.READ(FN.REDO.AA.DD.CATEGORY,ID.VAR , R.REDO.AA.DD.CATEGORY, DD.CATEG.ERR);* R22 Auto Conversion  ;*MANUAL R22 CODE CONVERSION-VARIABLE IS HARDCODED

    Y.LOAN.CUSTOMER = ''
    Y.LOAN.CUSTOMER = R.NEW(REDO.FC.CUSTOMER)

RETURN
*------------
END
