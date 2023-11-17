* @ValidationCode : MjoxMjUzNjY2NzI3OkNwMTI1MjoxNjgwNjE3NTAzMTEyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 19:41:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE FIELD.BEHAVIOUR.RTN(FIELD.NO, BEHAVIOUR, VALUE, FIELD.NAME)

* ====================================================================================
*
* - this routine gives a Behaviour for fields
*
* -
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose : gives a Behaviour for fields
*
*
* Incoming:
* ---------
* NA
*
*
* Outgoing:
* ---------
* NA
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Jorge Valarezo
* Date            :
* Amended by      : Santiago Jijon
* Date            : 2011/11/22 (INS.END.DATE issue at get default value)
*
* Date             Who                   Reference      Description
*04.04.2023    Conversion Tool      R22               Auto Conversion     - VM TO @VM, FM TO @FM
*04.04.2023    Shanmugapriya M      R22               Manual Conversion   - No changes
*=======================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
*
*************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
RETURN
*
* ========
PROCESS:
* ========



    CHANGE '.' TO @FM IN FIELD.NO
    FIELD.NO=FIELD.NO<1>

    BEGIN CASE
        CASE BEHAVIOUR EQ 'INPUT'
            GOSUB BEHAVIOUR.INPUT

        CASE BEHAVIOUR EQ 'FIXED.VALUE'
            GOSUB ASSIGN.VALUES
            T(FIELD.NO)<3>='NOINPUT'

        CASE BEHAVIOUR EQ 'DEFAULT'
            VALUE1 = VALUE
*CHANGE ' ' TO '.' IN VALUE1

*IF (R.NEW(FIELD.NO) NE '' AND R.NEW(FIELD.NO) NE VALUE1) AND (VALUE NE 'INGRESO MANUAL' AND VALUE NE 'VALOR NOMINAL GARANTIA' AND VALUE NE 'VALOR DE LA CONSTRUCCION' AND VALUE NE 'MONTO DEL PRESTAMO' AND VALUE NE 'FECHA DEL SISTEMA' AND VALUE NE 'FECHA VENCIMIENTO PRESTAMO') THEN
            IF (R.NEW(FIELD.NO) NE '' AND R.NEW(FIELD.NO) NE VALUE1) AND (VALUE NE 'INGRESO MANUAL' AND VALUE NE 'VALOR NOMINAL GARANTIA' AND VALUE NE 'VALOR DE LA CONSTRUCCION' AND VALUE NE 'MONTO DEL PRESTAMO' AND VALUE NE 'FECHA DEL SISTEMA' AND VALUE NE 'FECHA VENCIMIENTO PRESTAMO' AND VALUE NE 'INCLUIR EN CUOTA' AND VALUE NE 'NO INCLUIR EN CUOTA') THEN
                TEXT="APAP.DEFAULT.OVERRIDE":@FM:FIELD.NAME
                CURR.NO = DCOUNT(R.NEW(INS.DET.OVERRIDE),@VM) + 1
                CALL STORE.OVERRIDE(CURR.NO)
            END ELSE
                GOSUB ASSIGN.VALUES
            END
        CASE BEHAVIOUR EQ 'MULTIVALUE'

            T(FIELD.NO)<8>='NOEXPAND'

        CASE 1

            AF    = FIELD.NO
            ETEXT = "EB-B2-BEHAVIOUR"
            CALL STORE.END.ERROR
    END CASE
RETURN
*
* =========
OPEN.FILES:
* =========
*
RETURN
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1
        END CASE
        LOOP.CNT +=1
    REPEAT
*
RETURN
*
* =========
INITIALISE:
* =========
*
    CURR.NO         =  0
    LOOP.CNT        =  0
    MAX.LOOPS       =  0
    PROCESS.GOAHEAD =  1
    SET.VALUES      =  0
    VALUE1          =  ''
    R.NEW(INS.DET.OVERRIDE) = ""

RETURN
*=====================
BEHAVIOUR.INPUT:
*=====================

    IF VALUE EQ 'CAMPO NO APLICA' THEN
        R.NEW(FIELD.NO)= ''
        T(FIELD.NO)<3>='NOINPUT'

    END
    IF VALUE EQ 'CAMPO NO INPUT' THEN
        T(FIELD.NO)<3>='NOINPUT'

    END

    IF VALUE EQ 'CAMPO MANDATORIO' THEN
* CHANGE '.' TO FM IN N(FIELD.NO)
* N(FIELD.NO)=N(FIELD.NO)<1>
* N(FIELD.NO):='.1'

*       CALL EB.FIND.FIELD.NO(Y.APLICACION, Y.FIELD.NO)
*      IF Y.FIELD.NO GT 0 THEN
        N(FIELD.NO) = N(FIELD.NO):'.1'
*END

    END
RETURN

*==============
ASSIGN.VALUES:
*==============


    IF VALUE EQ 'FECHA DEL SISTEMA' THEN
        IF R.NEW(FIELD.NO) EQ '' THEN
            R.NEW(FIELD.NO)= TODAY
        END
        RETURN
    END

    IF (FIELD.NAME EQ 'MANAGEMENT.TYPE' OR FIELD.NAME EQ 'POLICY.STATUS') AND SET.VALUES EQ 0 THEN
*CHANGE ' ' TO '.' IN VALUE
        R.NEW(FIELD.NO) = VALUE
        RETURN
    END
    IF FIELD.NAME EQ 'INS.AMOUNT-1' THEN  ;*OR FIELD.NAME EQ 'POL.EXP.DATE'
*    R.NEW(FIELD.NO)<1,1>= ''
        RETURN
    END
    IF FIELD.NAME EQ 'POL.EXP.DATE' THEN
        R.NEW(FIELD.NO) = R.NEW(INS.DET.POL.EXP.DATE)
        RETURN
    END
    IF FIELD.NAME EQ 'INS.END.DATE-1' THEN
        R.NEW(FIELD.NO) = R.NEW(INS.DET.INS.END.DATE)
        RETURN
    END

    R.NEW(FIELD.NO) = VALUE
RETURN

END
