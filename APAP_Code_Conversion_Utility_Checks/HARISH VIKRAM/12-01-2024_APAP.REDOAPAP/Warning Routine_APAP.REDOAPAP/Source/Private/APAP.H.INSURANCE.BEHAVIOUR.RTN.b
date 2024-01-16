* @ValidationCode : MjotMTUzOTkyMDUxOkNwMTI1MjoxNzAzMTUwNTQxNjMzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Dec 2023 14:52:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.INSURANCE.BEHAVIOUR.RTN
* ====================================================================================
*
*    - this routine gives a Behaviour for fields
*
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
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM , = to EQ , SM to @SM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL ROUTINE FORMAT CAN BE MODIFIED
*20-12-2023      HARISHVIKRAM                R22 Manual Conversion      F.READ into CACHE.READ
*----------------------------------------------------------------------------------------



*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.APAP.H.INSURANCE.CLASS.POLICY
    $INSERT I_F.APAP.H.INSURANCE.COMB.PARAM
    $INSERT I_F.APAP.H.INSURANCE.POLICY.TYPE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS

*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
        APAP.REDOAPAP.apapActivarTipo2() ;*R22 MANUAL CODE CONVERSION
*       APAP.REDOAPAP.APAP.ACTIVAR.TIPO.2
    END

*
RETURN
*
* ======
PROCESS:
* ======

    APP.NAME=APPLICATION

    FIELD.NO='INS.POLICY.TYPE'
    CALL EB.GET.APPL.FIELD(APP.NAME,FIELD.NO,'',Y.APP.ERR)
    POLICY.TYPE=R.NEW(FIELD.NO)

    FIELD.NO.TEMP=FIELD.NO

    FIELD.NO='CLASS.POLICY'
    CALL EB.GET.APPL.FIELD(APP.NAME,FIELD.NO,'',Y.APP.ERR)
    IF R.NEW(FIELD.NO) EQ ''THEN
        CLASS.POLICY=COMI
    END ELSE
        CLASS.POLICY= R.NEW(FIELD.NO)
    END
    FIELD.NO.TEMP1=FIELD.NO

*APAP.REDOAPAP.APAP.H.INS.BEHA.CHECK.RTN(CLASS.POLICY, POLICY.TYPE) ;*R22 MANUAL CODE CONVERSION
    APAP.REDOAPAP.apapHInsBehaCheckRtn(CLASS.POLICY, POLICY.TYPE)
    COMI=CLASS.POLICY
    R.NEW(FIELD.NO.TEMP)=POLICY.TYPE


    SEL.CMD='SELECT ':FN.INS.COMB:' WITH INS.POLICY.TYPE EQ ':POLICY.TYPE:' AND INS.POLICY.CLASS EQ ':CLASS.POLICY
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC,RET.CODE)

    IF NO.OF.REC GT 0 THEN
        LOOP
            REMOVE ID.INS.COMB FROM SEL.LIST SETTING ITR
        WHILE ID.INS.COMB:ITR
*            CALL F.READ(FN.INS.COMB, ID.INS.COMB, R.INS.COMB, F.INS.COMB, Y.APP.ERR)
            CALL CACHE.READ(FN.INS.COMB, ID.INS.COMB, R.INS.COMB, Y.APP.ERR)        ;* R22 Manual Conversion
            IF R.INS.COMB NE '' THEN
                PRIORITY=0
                AP.NAME = 'APAP.H.INSURANCE.COMB.PARAM'
                R.BEHA.FLDS = R.INS.COMB
                GOSUB SET.BEHAVIOUR
            END
        REPEAT
    END


    IF CLASS.POLICY NE '' THEN
        CALL F.READ(FN.CLASS.POLICY, CLASS.POLICY, R.CLASS.POLICY, F.CLASS.POLICY ,Y.APP.ERR)
        IF R.CLASS.POLICY NE '' THEN
            PRIORITY=2
            AP.NAME = 'APAP.H.INSURANCE.CLASS.POLICY'
            R.BEHA.FLDS = R.CLASS.POLICY
            GOSUB SET.BEHAVIOUR
        END
    END

    IF POLICY.TYPE NE '' THEN
        CALL F.READ(FN.POLICY.TYPE, POLICY.TYPE, R.POLICY.TYPE, F.POLICY.TYPE, Y.APP.ERR)
        IF R.POLICY.TYPE NE '' THEN
            PRIORITY=1
            AP.NAME = 'APAP.H.INSURANCE.POLICY.TYPE'
            R.BEHA.FLDS = R.POLICY.TYPE
            GOSUB SET.BEHAVIOUR
        END

    END





RETURN
*
* =========
OPEN.FILES:
* =========
*
*    CALL OPF(FN.SS,F.SS)
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
* =========
INITIALISE:
* =========
*
    LOOP.CNT        =  0
    MAX.LOOPS       =  0
    PROCESS.GOAHEAD =  1

    APP.NAME        =  ''
    Y.APP.ERR       =  ''
    FIELD.NO        =  ''
    FIELD.NO.TEMP   =  ''
    FIELD.NO.TEMP1  =  ''
    NO.OF.FIELDS    =  0
    FIELD.VALUE     =  ''
    FIELD.BEHAVIOUR =  ''
    NO.BEHAVIOUR    =  ''
    POLICY.TYPE     =  ''
    CLASS.POLICY    =  ''

    FN.CLASS.POLICY =  'F.APAP.H.INSURANCE.CLASS.POLICY'
    F.CLASS.POLICY  =  ''
    R.CLASS.POLICY  =  ''
    CLASS.POLICY    =  ''

    FN.POLICY.TYPE  =  'F.APAP.H.INSURANCE.POLICY.TYPE'
    F.POLICY.TYPE   =  ''
    R.POLICY.TYPE   =  ''
    POLICY.TYPE.ERR =  ''

    FN.INS.COMB     =  'F.APAP.H.INSURANCE.COMB.PARAM'
    F.INS.COMB      =  ''
    R.INS.COMB      =  ''
    ID.INS.COMB     =  ''
    INS.COMB.ERR    =  ''

    SEL.CMD         =  ''
    SEL.LIST        =  ''
    NO.OF.REC       =  0
    RET.CODE        =  ''
    ITR.FIELDS      =  0
    ITR.BEHAVIOUR   =  0
    FIELD.PREFIX    =  ''
    PRIORITY        =  0
    REVIEW          =  0
    R.BEHA.FLDS     =  ''
    AP.NAME         =  ''
    F.NAMED         =  ''


    FIELD.NAME      = ''
    FIELD.NAME.BEHA = ''
    FIELD.NAME.VALU = ''

RETURN

*
* ======================
SET.BEHAVIOUR:
* ======================
*
    GOSUB GET.FIELDS.POS

    NO.OF.FIELDS=DCOUNT(R.BEHA.FLDS<FIELD.NAME>,@VM)
    FOR ITR.FIELDS=1 TO NO.OF.FIELDS
        FIELD.NO=R.BEHA.FLDS<FIELD.NAME,ITR.FIELDS>
        F.NAMED = R.BEHA.FLDS<FIELD.NAME,ITR.FIELDS>
        IF F.NAMED EQ "MANAGEMENT.TYPE" THEN
            GOSUB PROCESS.MANAGEMENT.TYPE
        END ELSE
            GOSUB PROCESS.OTHER.FIELDS
        END
    NEXT ITR.FIELDS
RETURN

*================
PROCESS.MANAGEMENT.TYPE:
*================

    Y.SW = 0
    Y.MAG.TYPE = ""
    IF R.NEW(INS.DET.MANAGEMENT.TYPE) NE '' THEN
        Y.SW = 1
        Y.MAG.TYPE = R.NEW(INS.DET.MANAGEMENT.TYPE)
    END

    IF PRIORITY EQ 1 OR PRIORITY EQ 2 THEN
        LOCATE FIELD.NO IN R.INS.COMB<INS.COMB.PARAM.FIELD.NAME,1> SETTING POS THEN
            REVIEW =1
        END ELSE
            REVIEW= 0
        END
    END

    IF REVIEW EQ 0 THEN
        CALL EB.GET.APPL.FIELD(APP.NAME,FIELD.NO,'',Y.APP.ERR)

        NO.BEHAVIOUR=DCOUNT(R.BEHA.FLDS<FIELD.NAME.BEHA,ITR.FIELDS>,@SM)

        FOR ITR.BEHAVIOUR=1 TO NO.BEHAVIOUR
            FIELD.BEHAVIOUR=R.BEHA.FLDS<FIELD.NAME.BEHA,ITR.FIELDS,ITR.BEHAVIOUR>
            FIELD.VALUE=R.BEHA.FLDS<FIELD.NAME.VALU,ITR.FIELDS,ITR.BEHAVIOUR>

            CALL FIELD.BEHAVIOUR.RTN(FIELD.NO, FIELD.BEHAVIOUR, FIELD.VALUE, F.NAMED)
        NEXT ITR.BEHAVIOUR
    END
*END

    IF Y.SW EQ 1 THEN ;*R22 AUTO CODE CONVERSION
        R.NEW(INS.DET.MANAGEMENT.TYPE) = Y.MAG.TYPE
    END

RETURN
*================
PROCESS.OTHER.FIELDS:
*================
    IF PRIORITY EQ 1 OR PRIORITY EQ 2 THEN
        LOCATE FIELD.NO IN R.INS.COMB<INS.COMB.PARAM.FIELD.NAME,1> SETTING POS THEN
            REVIEW =1
        END ELSE
            REVIEW= 0
        END
    END

    IF REVIEW EQ 0 THEN
        CALL EB.GET.APPL.FIELD(APP.NAME,FIELD.NO,'',Y.APP.ERR)

        NO.BEHAVIOUR=DCOUNT(R.BEHA.FLDS<FIELD.NAME.BEHA,ITR.FIELDS>,@SM)

        FOR ITR.BEHAVIOUR=1 TO NO.BEHAVIOUR
            FIELD.BEHAVIOUR=R.BEHA.FLDS<FIELD.NAME.BEHA,ITR.FIELDS,ITR.BEHAVIOUR>
            FIELD.VALUE=R.BEHA.FLDS<FIELD.NAME.VALU,ITR.FIELDS,ITR.BEHAVIOUR>
            CALL FIELD.BEHAVIOUR.RTN(FIELD.NO, FIELD.BEHAVIOUR, FIELD.VALUE, F.NAMED)
        NEXT ITR.BEHAVIOUR
    END
RETURN

*================
GET.FIELDS.POS:
*===============
    FIELD.NAME      = 'FIELD.NAME'
    FIELD.NAME.BEHA = 'FIELD.BEHA'
    FIELD.NAME.VALU = 'FIELD.VALUES'

    CALL EB.GET.APPL.FIELD(AP.NAME,FIELD.NAME,'',Y.APP.ERR)
    CALL EB.GET.APPL.FIELD(AP.NAME,FIELD.NAME.BEHA,'',Y.APP.ERR)
    CALL EB.GET.APPL.FIELD(AP.NAME,FIELD.NAME.VALU,'',Y.APP.ERR)


RETURN

END
