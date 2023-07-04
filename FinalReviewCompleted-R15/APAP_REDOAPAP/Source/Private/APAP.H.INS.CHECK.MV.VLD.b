* @ValidationCode : MjotMTAzNzE1OTkzMDpDcDEyNTI6MTY4NDgzNjAzMTA0MzpJVFNTOi0xOi0xOjU0MjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 542
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.INS.CHECK.MV.VLD
* ====================================================================================
*
*    - THIS ROUTINE VERIFY IF A FIELD THAT WAS SET LIKE IT DOESNT ALLOW MULTIVALUES OR SUBVALUES
*      WETHER IT DOESNT ALLOW THEN THROW ERROR
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
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
* Development for :
* Development by  : Jorge Valarezo
* Date            :
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM tO @FM , VM to @ VM ,SM to @SM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
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


    FIELD.NO='CLASS.POLICY'
    CALL EB.GET.APPL.FIELD(APP.NAME,FIELD.NO,'',Y.APP.ERR)
    CLASS.POLICY= R.NEW(FIELD.NO)


    SEL.CMD='SELECT ':FN.INS.COMB:' WITH INS.POLICY.TYPE EQ ':POLICY.TYPE:' AND INS.POLICY.CLASS EQ ':CLASS.POLICY:' AND (FIELD.NAME EQ CLASS.POLICY OR FIELD.NAME EQ INS.POLICY.TYPE)'
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC,RET.CODE)

    IF NO.OF.REC GT 0 THEN
        LOOP
            REMOVE ID.INS.COMB FROM SEL.LIST SETTING ITR
        WHILE ID.INS.COMB:ITR
            CALL F.READ(FN.INS.COMB, ID.INS.COMB, R.INS.COMB, F.INS.COMB, Y.APP.ERR)
            IF R.INS.COMB NE '' THEN
                AP.NAME='APAP.H.INSURANCE.COMB.PARAM'
                R.BEHA.FLDS = R.INS.COMB
                GOSUB GET.VALUES


            END

        REPEAT
    END

    IF POLICY.TYPE NE '' THEN
        CALL F.READ(FN.POLICY.TYPE, POLICY.TYPE, R.POLICY.TYPE, F.POLICY.TYPE, Y.APP.ERR)
        IF R.POLICY.TYPE NE '' THEN
            AP.NAME='APAP.H.INSURANCE.POLICY.TYPE'
            R.BEHA.FLDS = R.POLICY.TYPE
            GOSUB GET.VALUES
        END

    END

    IF CLASS.POLICY NE '' THEN
        CALL F.READ(FN.CLASS.POLICY, CLASS.POLICY, R.CLASS.POLICY, F.CLASS.POLICY ,Y.APP.ERR)
        IF R.CLASS.POLICY NE '' THEN
            AP.NAME='APAP.H.INSURANCE.CLASS.POLICY'
            R.BEHA.FLDS = R.CLASS.POLICY
            GOSUB GET.VALUES
        END
    END

    R.NEW(INS.DET.MON.TOT.PRE.AMT) = R.NEW(INS.DET.MON.POL.AMT) + R.NEW(INS.DET.EXTRA.AMT)


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
    POLICY.TYPE.ERR =  ''

    FN.INS.COMB     =  'F.APAP.H.INSURANCE.COMB.PARAM'
    F.INS.COMB      =  ''
    R.INS.COMB      =  ''
    ID.INS.COMB     =  ''
    INS.COMB.ERR    =  ''
    R.BEHA.FLDS     =  ''

    POS             =  0
    FIELD.NAME      =  ''
    FIELD.NAME.BEHA =  ''
    FIELD.NAME.VALU =  ''
    POLICY.TYPE     =  ''
    CLASS.POLICY    =  ''
    NO.OF.FIELDS    =  0
    ITR             =  0
    MV.FIELD        =  ''
    MV.FIELD.ALLOW  =  ''
    MV.NO.VALUE     =  0
    SV.NO.VALUE     =  0
    FIELD.NO        =  ''

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
*================
GET.VALUES:
*===============

    GOSUB GET.FIELDS.POS
    NO.OF.FIELDS = DCOUNT(R.BEHA.FLDS<FIELD.NAME>,@VM)
    FOR ITR =  1 TO NO.OF.FIELDS
        LOCATE 'MULTIVALUE' IN R.BEHA.FLDS<FIELD.NAME.BEHA,ITR,1> SETTING POS THEN
            MV.FIELD= R.BEHA.FLDS<FIELD.NAME,ITR>
            MV.FIELD.ALLOW = R.BEHA.FLDS<FIELD.NAME.VALU,ITR,POS>
            GOSUB THROW.ERROR
        END
    NEXT ITR


RETURN

*============
THROW.ERROR:
*============
    CALL EB.GET.APPL.FIELD(APP.NAME,MV.FIELD,'',Y.APP.ERR)
    CHANGE '.' TO @FM IN MV.FIELD
    MV.FIELD=MV.FIELD<1>
    MV.NO.VALUE = DCOUNT (R.NEW(MV.FIELD),@VM)
    SV.NO.VALUE = DCOUNT (R.NEW(MV.FIELD),@SM)

    IF MV.FIELD.ALLOW EQ 'SI' AND ( SV.NO.VALUE GT 1 OR MV.NO.VALUE GT 1 ) THEN
        AF    = MV.FIELD
        ETEXT = "EB-B2-NO.MULTIVALUE"
        CALL STORE.END.ERROR
    END


RETURN

END
