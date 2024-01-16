* @ValidationCode : MjoxODcwMzE0NDQ3OkNwMTI1MjoxNzAzMTUwMzU2Mjg1OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Dec 2023 14:49:16
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
*-----------------------------------------------------------------------------
* <Rating>-81</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE APAP.H.INS.BEHA.CHECK.RTN (CLASS.POLICY, POLICY.TYPE)
* ====================================================================================
*
*    - DESCRIPTION
*
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
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION 0THEN = 0 THEN
*20-12-2023      HARISHVIKRAM             R22 Manual Conversion        F.READ into CACHE.READ
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

    SEL.CMD='SELECT ':FN.INS.COMB:' WITH INS.POLICY.TYPE EQ ':POLICY.TYPE:' AND INS.POLICY.CLASS EQ ':CLASS.POLICY:' AND (FIELD.NAME EQ CLASS.POLICY OR FIELD.NAME EQ INS.POLICY.TYPE)'
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC,RET.CODE)

    IF NO.OF.REC GT 0 THEN
        LOOP
            REMOVE ID.INS.COMB FROM SEL.LIST SETTING ITR
        WHILE ID.INS.COMB:ITR
*            CALL F.READ(FN.INS.COMB, ID.INS.COMB, R.INS.COMB, F.INS.COMB, Y.APP.ERR)
            CALL CACHE.READ(FN.INS.COMB, ID.INS.COMB, R.INS.COMB, Y.APP.ERR)   ;*R22 Manual Conversion
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
    POS1            =  0
    FLAG            =  0
    FIELD.NAME      = ''
    FIELD.NAME.BEHA = ''
    FIELD.NAME.VALU = ''
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
    LOCATE 'CLASS.POLICY' IN R.BEHA.FLDS<FIELD.NAME,1> SETTING POS THEN
        FLAG=1
        GOSUB BEHA.CHECK
    END

    LOCATE 'INS.POLICY.TYPE' IN R.BEHA.FLDS<FIELD.NAME,1> SETTING POS THEN
        FLAG=2
        GOSUB BEHA.CHECK
    END


RETURN

*============
BEHA.CHECK:
*============
    LOCATE 'DEFAULT' IN R.BEHA.FLDS<FIELD.NAME.BEHA,POS,1> SETTING POS1 THEN

    END

    LOCATE 'FIXED.VALUE' IN R.BEHA.FLDS<FIELD.NAME.BEHA,POS,1> SETTING POS1 THEN

    END
    IF FLAG EQ 1 AND POS1 NE 0 THEN  ;*R22 MANUAL CODE CONVERSION
        CLASS.POLICY =R.BEHA.FLDS<FIELD.NAME.VALU,POS,POS1>
    END
    IF FLAG EQ 2 AND POS1 NE 0 THEN
        POLICY.TYPE=R.BEHA.FLDS<FIELD.NAME.VALU,POS,POS1>
    END



RETURN
END
