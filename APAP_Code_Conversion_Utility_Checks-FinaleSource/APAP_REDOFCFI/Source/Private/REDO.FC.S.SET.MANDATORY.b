* @ValidationCode : MjoxMTE1MDU5OTI3OkNwMTI1MjoxNzAyOTkwOTQ3OTM1OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:32:27
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
SUBROUTINE REDO.FC.S.SET.MANDATORY
    

*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.CREATE.ARRANGEMENT.VALIDATE
* Attached as     : ROUTINE
* Primary Purpose : Setting the mandatory fields using table REDO.FC.COLL.CODE.PARAMS
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
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 08 Julio 2011
** Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*15-12-2023          VIGNESHWARI                     MANUAL R22 CODE CONVERSION            OPF IS ADDED,F.READ TO F.CACHE.READ
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.COLL.CODE.PARAMS
    $INSERT I_F.REDO.FC.PROD.COLL.POLICY

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.MAIN
        GOSUB OTHER.PARTY.VALIDATION:
    END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS.MAIN:
*======================

    CALL F.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.PRODUCT, R.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY ,YERR)

    NRO.COLL.CODE = DCOUNT(R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>, @VM)
    IF NRO.COLL.CODE GT 1 THEN
        E = 'DEBE EXISTIR AL MENOS UNA GARANTIA'
        Y.B = 0
        J.VAR= 1
        LOOP
        WHILE J.VAR LE NRO.COLL.CODE
            Y.COLL.CODE = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE,J.VAR>
            GOSUB VAL.EMPTY
            IF NOT(E) AND Y.B THEN
                GOSUB SET.MAND
                Y.B = 0
            END
            J.VAR += 1
        REPEAT
        IF E THEN
            TEXT = E
            E = ''
            M.CONT = DCOUNT(R.NEW(REDO.FC.OVERRIDE),@VM) + 1
            CALL STORE.OVERRIDE(M.CONT)
        END
    END ELSE
        Y.COLL.CODE = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE,1>
        GOSUB SET.MAND
    END
RETURN
*------------------------
VAL.EMPTY:
*=========
    BEGIN CASE
        CASE Y.COLL.CODE EQ 450
* 450 Bienes raicea
            IF R.NEW(REDO.FC.TYPE.OF.SEC.BR) THEN
                Y.B = 1
                E = ''
            END
        CASE Y.COLL.CODE EQ 350
* 350 Vehiculos
            IF R.NEW(REDO.FC.TYPE.OF.SEC.VS) THEN
                E = ''
                Y.B = 1
            END
        CASE Y.COLL.CODE EQ 100
* 100 Titulos Publicos
            IF R.NEW(REDO.FC.TYPE.OF.SEC.TP) THEN
                E = ''
                Y.B = 1
            END
        CASE Y.COLL.CODE EQ 150
* 150 Depositos Internos
            IF R.NEW(REDO.FC.TYPE.OF.SEC.DI) THEN
                E = ''
                Y.B = 1
            END
        CASE Y.COLL.CODE EQ 200
* 200 Depositos Externos
            IF R.NEW(REDO.FC.TYPE.OF.SEC.DE) THEN
                E = ''
                Y.B = 1
            END
        CASE Y.COLL.CODE EQ 970
* 970 Firmas Solidarias
            IF R.NEW(REDO.FC.TYPE.OF.SEC.FS) THEN
                E = ''
                Y.B = 1
            END
    END CASE
RETURN
*------------------------
OTHER.PARTY.VALIDATION:
*===============

    Y.NUM.OTHER.PARTY = DCOUNT(R.NEW(REDO.FC.OTHER.PARTY),@VM)
    Y.NUM.OTHER.PARTY.ROLE = DCOUNT(R.NEW(REDO.FC.OTHER.PARTY),@VM)
    Y.CONT.MAX = 0
    IF Y.NUM.OTHER.PARTY GE Y.NUM.OTHER.PARTY.ROLE THEN
        Y.CONT.MAX = Y.NUM.OTHER.PARTY
    END ELSE
        Y.CONT.MAX = Y.NUM.OTHER.PARTY.ROLE
    END

    IF NOT(Y.CONT.MAX) THEN
        Y.CONT.MAX = 1
    END

    Y.OTHER.PARTY.ROLE = ''
    FOR I.C = 1 TO Y.CONT.MAX

        IF R.NEW(REDO.FC.OTHER.PARTY)<1,I.C>  THEN
            IF NOT(R.NEW(REDO.FC.OTHER.PARTY.ROLE)<1,I.C>) THEN
                ETEXT = "EB-FLD.NO.MISSING"
                AF = REDO.FC.OTHER.PARTY.ROLE
                AV = I.C
                CALL STORE.END.ERROR
            END
        END

        IF R.NEW(REDO.FC.OTHER.PARTY.ROLE)<1,I.C>  THEN
            IF NOT(R.NEW(REDO.FC.OTHER.PARTY)<1,I.C>) THEN
                ETEXT = "EB-FLD.NO.MISSING"
                AF = REDO.FC.OTHER.PARTY
                AV = I.C
                CALL STORE.END.ERROR
            END
        END

    NEXT I.C
RETURN
*-------------------------------------------
SET.MAND:
*=========
*    CALL F.READ(FN.REDO.FC.COLL.CODE.PARAMS,Y.COLL.CODE,R.REDO.FC.COLL.CODE.PARAMS,F.REDO.FC.COLL.CODE.PARAMS,YERR)
CALL F.CACHE.READ(FN.REDO.FC.COLL.CODE.PARAMS,Y.COLL.CODE,R.REDO.FC.COLL.CODE.PARAMS,F.REDO.FC.COLL.CODE.PARAMS,YERR);*MANUAL R22 CODE CONVERSION F.READ TO F.CACHE.READ

    NRO.CM = DCOUNT(R.REDO.FC.COLL.CODE.PARAMS<FC.PR.CAMPO.MAND>,@VM)
    I.VAR = 1
    LOOP
    WHILE I.VAR LE NRO.CM
        Y.FIELD.NO = R.REDO.FC.COLL.CODE.PARAMS<FC.PR.CAMPO.MAND,I.VAR>
        CALL EB.FIND.FIELD.NO(Y.APLICACION, Y.FIELD.NO)
        IF Y.FIELD.NO GT 0 THEN
            N(Y.FIELD.NO) = N(Y.FIELD.NO):'.1'
            IF NOT(R.NEW(Y.FIELD.NO)) THEN
                ETEXT = "EB-FLD.NO.MISSING"
                AF = Y.FIELD.NO
                CALL STORE.END.ERROR

            END
        END
        I.VAR += 1
    REPEAT

RETURN
*------------------------
INITIALISE:
*=========
    FN.REDO.FC.COLL.CODE.PARAMS = 'F.REDO.FC.COLL.CODE.PARAMS'
    F.REDO.FC.COLL.CODE.PARAMS=""
    
    R.REDO.FC.COLL.CODE.PARAMS = ''
    CALL OPF(FN.REDO.FC.COLL.CODE.PARAMS,F.REDO.FC.COLL.CODE.PARAMS)  ;*  MANUAL R22 CODE CONVERSION- OPF IS ADDED
    FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
    F.REDO.FC.PROD.COLL.POLICY =""
    R.REDO.FC.PROD.COLL.POLICY = ''
    CALL OPF(FN.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY);*  MANUAL R22 CODE CONVERSION- OPF IS ADDED
    

    Y.APLICACION = 'REDO.CREATE.ARRANGEMENT'
    Y.PRODUCT = R.NEW(REDO.FC.PRODUCT)
    PROCESS.GOAHEAD = 1

    TEXT = ""
    E = ""
RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------------

END
