* @ValidationCode : MjotNDgyOTEwNzUxOkNwMTI1MjoxNjgyNDEyMzYxOTMwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:16:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.INFO.FS

* ====================================================================================
*
*
*
*
* ====================================================================================

*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.INFO.FS
* Attached as     : ROUTINE
* Primary Purpose : Validate nformation for FS where the user record the register.
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
* Date            :
*
*-----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*17-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*17-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.CUSTOMER

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======

    GUAR.CUS.ID  = R.NEW(COLL.LOCAL.REF)<1,WPOSCUST>

*GET THE ID FROM CUSTOMER DEBTOR
    LOAN.DEBTORS.ID =  R.NEW(COLL.LOCAL.REF)<1,WPOSLI>

* GET INFORMATION FOR CUSTOMER
    CALL F.READ(FN.CUSTOMER,LOAN.DEBTORS.ID,R.CUSTOMER,F.CUSTOMER,ERR.MSJ)

    IF R.CUSTOMER THEN
        VAL.CUS.NAME.LOAN = R.CUSTOMER<EB.CUS.NAME.1>
        VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LEGAL.ID>
        VAL.NACIONALIDAD  = R.CUSTOMER<EB.CUS.NATIONALITY>

*--SET THE ID AS TYPE ID CUSTOMER
        VAR.TIPO = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSTCUS>

        BEGIN CASE
            CASE VAR.TIPO EQ "PERSONA FISICA"
                VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSCEDULA>

*Verify the customer type foreigner or national.
                IF VAL.NACIONALIDAD EQ 'DO' THEN
                    VAR.NAC = 'P1'
                END
                ELSE
                    VAR.NAC = 'P2'
                END

            CASE VAR.TIPO EQ "PERSONA JURIDICA"
                VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSRUC>
                VAR.NAC = 'E1'

            CASE VAR.TIPO EQ "CLIENTE MENOR"
                VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSPARTIDA>
                VAR.NAC = ''

            CASE VAR.TIPO EQ  ""
                VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSUNICO>

        END CASE
*--END ID

*VERIFY THE INFORMATION OF TYPE ID CUSTOMER
        GOSUB VERIFICAR

*\\VERIFY IF TYPE FOR CUSTOMER IS THE SAME TO SET IN PARAMETERS\\
        GOSUB VALIDAR

    END


*VERIFY INFORMATION CUSTOMER EN GURATOR
    LOAN.DEBTORS.ID =  R.NEW(COLL.LOCAL.REF)<1,WPOSLDID>
    IF GUAR.CUS.ID EQ LOAN.DEBTORS.ID THEN
        AF = COLL.LOCAL.REF
        AV = ZPOS<1,1>
        ETEXT = 'ST-REDO.COLLA.GARA.EQ.DEU'
        CALL STORE.END.ERROR
    END

RETURN
*----------------------------------------------------------------------------

VALIDAR:
*=======
***VERIFY IF TYPE FOR CUSTOMER IS THE SAME TO SET IN PARAMETERS
    VAR.TIPO.REG = R.NEW(COLL.LOCAL.REF)<1,WPOSTYPE>

    IF (VAR.TIPO.REG NE VAR.NAC) AND (VAR.TIPO NE "CLIENTE MENOR") THEN
*  TEXT = "COLL.TIP.ID"
*  M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
*  CALL STORE.OVERRIDE(M.CONT)
        AF = COLL.LOCAL.REF
        AV = ZPOS<1,7>
        ETEXT = 'ST-COLL.TIP.ID'
        CALL STORE.END.ERROR
    END

    IF (VAR.TIPO.REG EQ 'E1') AND (VAR.TIPO EQ "CLIENTE MENOR") THEN
*TEXT = "COLL.TIP.ID"
*M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
*CALL STORE.OVERRIDE(M.CONT)
        AF = COLL.LOCAL.REF
        AV = ZPOS<1,7>
        ETEXT = 'ST-COLL.TIP.ID'
        CALL STORE.END.ERROR

    END

    IF LEN(VAL.LEGAL.ID.LOAN) LE 0  THEN
        AF = COLL.LOCAL.REF
        AV = ZPOS<1,6>
        ETEXT = 'ST-ID.CLIENTE'
        CALL STORE.END.ERROR
    END

**VERIFY THAT TYPEXIST IN THE CUSTOMER SELECTED
    IF VAR.TIPO EQ '' THEN
        AF = COLL.LOCAL.REF
        AV = ZPOS<1,7>
        ETEXT = 'ST-CUS.S.TIPO'
        CALL STORE.END.ERROR
    END

RETURN


VERIFICAR:
*=========
*IF THE USER HAVE NULL ID SERCH FIELD PER FIELD IF EXIST ANY FIELD
    IF LEN(VAL.LEGAL.ID.LOAN) LE 0  THEN
        VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSCEDULA>
    END

    IF LEN(VAL.LEGAL.ID.LOAN) LE 0  THEN
        VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSRUC>
    END

    IF LEN(VAL.LEGAL.ID.LOAN) LE 0  THEN
        VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSPARTIDA>
    END

    IF LEN(VAL.LEGAL.ID.LOAN) LE 0  THEN
        VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LOCAL.REF,WPOSUNICO>
    END

    IF LEN(VAL.LEGAL.ID.LOAN) LE 0  THEN
        VAL.LEGAL.ID.LOAN = R.CUSTOMER<EB.CUS.LEGAL.ID>
    END
RETURN

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1

    WCAMPO ="L.COL.GUAR.ID"
    WCAMPO<2> = "L.COL.GUR.LEGID"
    WCAMPO<3> ="L.COL.GUAR.NAME"
    WCAMPO<4> ="L.COL.DEBTOR.ID"
    WCAMPO<5> ="L.COL.DEBTOR.NA"
    WCAMPO<6> ="L.COL.DBR.LEGID"
    WCAMPO<7> ="L.COL.GUAR.TYPE"
    WCAMPO<8> ="L.COL.SEC.HOLD"

    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,ZPOS)
    WPOSLI=ZPOS<1,1>
    WPOSLEGID=ZPOS<1,2>
    WPOSNAME=ZPOS<1,3>
    WPOSLDID=ZPOS<1,4>
    WPOSDEBNAME=ZPOS<1,5>
    WPOSDEBLEGNAME=ZPOS<1,6>
    WPOSTYPE=ZPOS<1,7>
    WPOSCUST=ZPOS<1,8>



*DEFINE INFORMATION FOR LOCAL FIELDS FOR CUSTOMER

    FN.CUSTOMER= "F.CUSTOMER"
    F.CUSTOMER=""

    WCAMPOC    = "L.CU.CIDENT"
    WCAMPOC<2> = "L.CU.NOUNICO"
    WCAMPOC<3> = "L.CU.ACTANAC"
    WCAMPOC<4> = "L.CU.TIPO.CL"
    WCAMPOC<5> = "L.CU.RNC"

    WCAMPOC = CHANGE(WCAMPOC,@FM,@VM)
    CALL MULTI.GET.LOC.REF("CUSTOMER",WCAMPOC,XPOS)
    WPOSCEDULA=XPOS<1,1>
    WPOSUNICO=XPOS<1,2>
    WPOSPARTIDA=XPOS<1,3>
    WPOSTCUS=XPOS<1,4>
    WPOSRUC=XPOS<1,5>
RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN
*------------
END
