* @ValidationCode : MjotMjEyODE2NDAyNDpDcDEyNTI6MTY4MTE5NzE5ODQ5NDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 12:43:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.INSURANCE.VAL.RTN
* ====================================================================================
*
*    - Validation Routine for APAP.H.INSURANCE.CLASS.POLICY, APAP.H.INSURANCE.COMB.PARAM, APAP.H.INSURANCE.POLICY.TYPE
*
*
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     : APAP.H.INSURANCE.CLASS.POLICY, APAP.H.INSURANCE.COMB.PARAM, APAP.H.INSURANCE.POLICY.TYPE
* Attached as     : VALIDATION ROUTINE
* Primary Purpose : Validates records on APAP.H.INSURANCE.CLASS.POLICY, APAP.H.INSURANCE.COMB.PARAM, APAP.H.INSURANCE.POLICY.TYPE
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
* Modify by       : Cristhian Herrera
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO.REP+1 to NO.REP+=1 , FM to @FM,SM to @SM , VM to @VM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.CLASS.POLICY
    $INSERT I_F.APAP.H.INSURANCE.COMB.PARAM
    $INSERT I_F.APAP.H.INSURANCE.POLICY.TYPE


*
*************************************************************************
*

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:
* ======


    APP.NAME=APPLICATION

    IF APP.NAME EQ 'APAP.H.INSURANCE.CLASS.POLICY' OR APP.NAME EQ 'APAP.H.INSURANCE.POLICY.TYPE' THEN
        GOSUB REPEAT.CHECK
    END


    IF APP.NAME EQ 'APAP.H.INSURANCE.COMB.PARAM'THEN
        POSSITION ='INS.POLICY.TYPE'
        CALL EB.GET.APPL.FIELD(APP.NAME,POSSITION,'',Y.APP.ERR)
        POLICY.TYPE     =  R.NEW(POSSITION)

        POSSITION ='INS.POLICY.CLASS'
        CALL EB.GET.APPL.FIELD(APP.NAME,POSSITION,'',Y.APP.ERR)
        CLASS.POLICY    =  R.NEW(POSSITION)

        SEL.CMD='SELECT ':FN.INS.COMB:' WITH @ID NE ':ID.NEW

        CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC,RET.CODE)

        LOOP
            REMOVE ID.INS.COMB FROM SEL.LIST SETTING ITR
        WHILE ID.INS.COMB:ITR
            CALL F.READ(FN.INS.COMB,ID.INS.COMB,R.INS.COMB,F.INS.COMB,INS.COMB.ERR)

            IF POLICY.TYPE EQ R.INS.COMB<INS.COMB.PARAM.INS.POLICY.TYPE> AND CLASS.POLICY EQ R.INS.COMB<INS.COMB.PARAM.INS.POLICY.CLASS> THEN
                FIELD.NO     = 1
                ERROR.TYPE   = 3

                GOSUB THROW.ERROR

            END
        REPEAT
        GOSUB REPEAT.CHECK

    END
RETURN

*
* =========
OPEN.FILES:
* =========
*

    CALL OPF(FN.CLASS.POLICY,F.CLASS.POLICY)
    CALL OPF(FN.POLICY.TYPE,F.POLICY.TYPE)
    CALL OPF(FN.INS.COMB,F.INS.COMB)


RETURN
*
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
*
* =========
INITIALISE:
* =========
*
    LOOP.CNT        =  0
    MAX.LOOPS       =  0
    PROCESS.GOAHEAD =  1

    FN.CLASS.POLICY =  'F.APAP.H.INSURANCE.CLASS.POLICY'
    F.CLASS.POLICY  =  ''
    R.CLASS.POLICY  =  ''

    FN.POLICY.TYPE  =  'F.APAP.H.INSURANCE.POLICY.TYPE'
    F.POLICY.TYPE   =  ''
    R.POLICY.TYPE   =  ''

    FN.INS.COMB     =  'F.APAP.H.INSURANCE.COMB.PARAM'
    F.INS.COMB      =  ''
    R.INS.COMB      =  ''
    ID.INS.COMB     =  ''
    INS.COMB.ERR    =  ''

    ERROR.TYPE      =  0
    FIELD.NO        =  ''
    FIELD.MV.POS    =  ''
    FIELD.SB.POS    =  ''

    APP.NAME        =  ''
    FIELD.CONTENT   =  ''
    DATA.NO         =  0
    TO.FIND         =  ''
    SEL.CMD         =  ''
    SEL.LIST        =  ''
    NO.OF.REC       =  0
    RET.CODE        =  ''

    POLICY.TYPE     =  ''
    CLASS.POLICY    =  ''
    POSSITION       =  0
    POSSITION1      =  0
    DATA.NO1        =  0
    TO.FIND1        =  ''
    FIELD.CONTENT1  =  ''
    MSG             =  ''
    ITR             =  0
    ITR1            =  0
    ITR.TIMES       =  0

RETURN
* ======
THROW.ERROR:
* ======
*ERROR TYPE 1 MEANS WHEN A USER WANTS TO DUPLICATE THE FIELD.NAME IN THE SAME RECORD
    IF ERROR.TYPE EQ 1 THEN
        AF = FIELD.NO
        AV = FIELD.MV.POS
        ETEXT = "EB-B2-PARAMS.REPEAT.VALUE": @FM : TO.FIND
        CALL STORE.END.ERROR
    END

*ERROR TYPE 1 MEANS WHEN A USER WANTS TO DUPLICATE THE BEHAVIOUR IN THE SAME RECORD
    IF ERROR.TYPE EQ 2 THEN
        AF = FIELD.NO
*VF=FIELD.MV.POS
*SF=FIELD.SB.POS
        AV = ITR
        AS = ITR1
        ETEXT = "EB-B2-PARAMS.REPEAT.BEHAVIOUR": @FM :TO.FIND1: @FM :TO.FIND
        CALL STORE.END.ERROR
    END

*ERROR TYPE 1 MEANS WHEN A USER WANTS TO DUPLICATE THE COMBINATION BETWEEN POLICY CLASS AND TYPE
    IF ERROR.TYPE EQ 3 THEN
        AF    = FIELD.NO
        AV    = ITR
        AS    = ITR1
        ETEXT = "EB-B2-PARAMS.REPEAT.COMBINATION"
        CALL STORE.END.ERROR

    END

    IF ERROR.TYPE EQ 4 THEN
        AF    = FIELD.NO
        AV    = ITR
        AS    = ITR1
        ETEXT = MSG
        CALL STORE.END.ERROR
    END

* ERROR TYPE 5 MEANS THE FIELD IS A SINGLE VALUE OR SUBVALUE FIELD AND
* THE MULTIVALUE BEHAVIOUR CAN NOT BE SELECTED
    IF ERROR.TYPE EQ 5 THEN
        AF    = FIELD.NO
        AV    = ITR
        AS    = ITR1
        ETEXT = MSG
        CALL STORE.END.ERROR
    END

RETURN

* ======
REPEAT.CHECK:
* ======
    POSSITION ='FIELD.NAME'
    CALL EB.GET.APPL.FIELD(APP.NAME,POSSITION,'',Y.APP.ERR)

*Evaluate if FIELD named FIELD.NAME has the same content more one time
    FIELD.CONTENT<1>=R.NEW(POSSITION)
    NO.DATA= DCOUNT(FIELD.CONTENT, @VM)
    FOR ITR=1 TO NO.DATA

        TO.FIND = FIELD.CONTENT<1,ITR>
        GOSUB CHECK.FIELDS.TIMES

        POSSITION1 ='FIELD.BEHA'
        CALL EB.GET.APPL.FIELD(APP.NAME,POSSITION1,'',Y.APP.ERR)
        POSSITION2 ='FIELD.VALUES'
        CALL EB.GET.APPL.FIELD(APP.NAME,POSSITION2,'',Y.APP.ERR)

*Evaluate if FIELD named FIELD.BEHAVIOR has the same content more one time.
        FIELD.CONTENT1<1>=R.NEW(POSSITION1)<1,ITR>
        FIELD.CONTENT2<1>=R.NEW(POSSITION2)<1,ITR>
        NO.DATA1= DCOUNT(FIELD.CONTENT1, @SM)

        FOR ITR1=1 TO NO.DATA1

            TO.FIND1 = FIELD.CONTENT1<1,1,ITR1>
            TO.FIND2 = FIELD.CONTENT2<1,1,ITR1>
            GOSUB CHECK.BEHA.TIMES
            GOSUB BEHA.VALIDATION
        NEXT ITR1

    NEXT ITR



RETURN

*================
BEHA.VALIDATION:
*================

    IF TO.FIND2 EQ 'CAMPO NO APLICA' AND NO.DATA1 GT 1 THEN
        MSG = "EB-B2-PARAMS.NOAPLICA"
        FIELD.NO     = POSSITION2
        FIELD.MV.POS = ITR
        FIELD.SB.POS = ITR1
        ERROR.TYPE   = 4
        GOSUB THROW.ERROR
    END

    IF TO.FIND1 EQ 'DEFAULT' THEN
        LOCATE 'FIXED.VALUE'IN FIELD.CONTENT1<1,1,1> SETTING POS1 THEN
            MSG='EB-B2-PARAMS.DEFAULT'
            FIELD.NO     = POSSITION2
            FIELD.MV.POS = ITR
            FIELD.SB.POS = ITR1
            ERROR.TYPE   = 4
            GOSUB THROW.ERROR
            RETURN
        END
    END

    IF TO.FIND1 EQ 'FIXED.VALUE' THEN
        LOCATE 'DEFAULT' IN FIELD.CONTENT1<1,1,1> SETTING POS1 THEN
            MSG='EB-B2-PARAMS.FIXEDVALUE'
            FIELD.NO     = POSSITION2
            FIELD.MV.POS = ITR
            FIELD.SB.POS = ITR1
            ERROR.TYPE   = 4
            GOSUB THROW.ERROR
            RETURN
        END
    END

* WHEN THE FIELD IS NOT A MULTIVALUE FIELD SUCH AS SUBVALUE OR SINGLE VALUE FIELD
* THE BEHAVIOUR RESTRICT MULTIVALUE(MULTIVALUE) CAN NOT BE SELECTED

    IF TO.FIND1 EQ 'MULTIVALUE' THEN
        MSG='EB-B2-PARAMS.MULTIVALUE': @FM :TO.FIND: @VM :TO.FIND1
        FIELD.NO=POSSITION1
        FIELD.MV.POS=ITR
        FIELD.SB.POS=ITR1


        BEGIN CASE
            CASE TO.FIND EQ 'CUSTOMER-1'
                ERROR.TYPE=0
            CASE TO.FIND EQ 'ASSOCIATED.LOAN-1'
                ERROR.TYPE=0
            CASE TO.FIND EQ 'INS.AMOUNT-1'
                ERROR.TYPE=0
            CASE TO.FIND EQ 'MON.POL.AMT-1'
                ERROR.TYPE=0
            CASE 1
                ERROR.TYPE=5
        END CASE

        IF ERROR.TYPE EQ 5 THEN
            GOSUB THROW.ERROR
            RETURN
        END

    END

RETURN

*==================
CHECK.FIELDS.TIMES:
*==================
    NO.REP = 0

    FOR ITR.TIMES = 1  TO NO.DATA
        IF TO.FIND EQ FIELD.CONTENT<1,ITR.TIMES> THEN
            NO.REP += 1 ;*R22 AUTO CODE CONVERSION
        END
    NEXT ITR.TIMES

    IF NO.REP GT 1 THEN
        FIELD.NO     = POSSITION
        FIELD.MV.POS = ITR
        ERROR.TYPE   = 1
        GOSUB THROW.ERROR
    END


RETURN

*==================
CHECK.BEHA.TIMES:
*==================

    NO.REP1 = 0
    FOR ITR.TIMES = 1 TO NO.DATA1
        IF TO.FIND1 EQ FIELD.CONTENT1<1,1,ITR.TIMES> THEN
            NO.REP1 += 1  ;*R22 AUTO CODE CONVERSION
        END

    NEXT ITR.TIMES

    IF NO.REP1 GT 1 THEN
        FIELD.NO     = POSSITION1
        FIELD.MV.POS = ITR
        FIELD.SB.POS = ITR1
        ERROR.TYPE   = 2
        GOSUB THROW.ERROR
    END

RETURN
END
