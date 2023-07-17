* @ValidationCode : MjotMTM0MzMxMTc0NjpDcDEyNTI6MTY4MzAzMDI5NTI2MTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 02 May 2023 17:54:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.GET.INSURANCE.AMT.RTN
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
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @ FM , VM to @VM
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

    FIELD.NO='INS.POLICY.TYPE'
    CALL EB.GET.APPL.FIELD(APPLICATION,FIELD.NO,'',Y.APP.ERR)
    POLICY.TYPE=R.NEW(FIELD.NO)

    FIELD.NO='CLASS.POLICY'
    CALL EB.GET.APPL.FIELD(APPLICATION,FIELD.NO,'',Y.APP.ERR)
    CLASS.POLICY=R.NEW(FIELD.NO)

    SEL.CMD='SELECT ':FN.INS.COMB:' WITH INS.POLICY.TYPE EQ ':POLICY.TYPE:' AND INS.POLICY.CLASS EQ ':CLASS.POLICY :' AND FIELD.NAME EQ ': AMT.NAME
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC, Y.APP.ERR)

    IF NO.OF.REC GT 0 THEN
        LOOP
            REMOVE ID.INS.COMB FROM SEL.LIST SETTING ITR
        WHILE ID.INS.COMB:ITR
            CALL F.READ(FN.INS.COMB, ID.INS.COMB, R.INS.COMB, F.INS.COMB, Y.APP.ERR)
            IF R.INS.COMB NE '' THEN
                PRIORITY=0
                AP.NAME = 'APAP.H.INSURANCE.COMB.PARAM'
                R.BEHA.FLDS = R.INS.COMB
                GOSUB SET.BEHAVIOUR
            END

        REPEAT
    END

    CALL F.READ(FN.CLASS.POLICY, CLASS.POLICY, R.CLASS.POLICY, F.CLASS.POLICY ,Y.APP.ERR)
    IF R.CLASS.POLICY NE '' THEN
        PRIORITY=2
        AP.NAME = 'APAP.H.INSURANCE.CLASS.POLICY'
        R.BEHA.FLDS = R.CLASS.POLICY
        GOSUB SET.BEHAVIOUR
    END

    CALL F.READ(FN.POLICY.TYPE, POLICY.TYPE, R.POLICY.TYPE, F.POLICY.TYPE, Y.APP.ERR)
    IF R.POLICY.TYPE NE '' THEN
        PRIORITY=1
        AP.NAME = 'APAP.H.INSURANCE.POLICY.TYPE'
        R.BEHA.FLDS = R.POLICY.TYPE
        GOSUB SET.BEHAVIOUR
    END

    NO.OF.AMT = DCOUNT(R.NEW(INS.DET.MON.POL.AMT),@VM)
    FOR ITR.POL=1 TO NO.OF.AMT
        R.NEW(INS.DET.MON.TOT.PRE.AMT)<1,ITR.POL> = R.NEW(INS.DET.MON.POL.AMT)<1,ITR.POL> + R.NEW(INS.DET.EXTRA.AMT)<1,ITR.POL>
    NEXT

* R.NEW(INS.DET.TOTAL.PRE.AMT) = R.NEW(INS.DET.MON.TOT.PRE.AMT)

RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.APAP.H.INS.DET,F.APAP.H.INS.DET)
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

    LOOP.CNT             =  0
    MAX.LOOPS            =  0
    PROCESS.GOAHEAD      =  1

    FN.APAP.H.INS.DET    =  'F.APAP.H.INSURANCE.DETAILS'
    F.APAP.H.INS.DET     =  ''
    R.APAP.H.INS.DET     =  ''

    NO.OF.REC            = 0
    AMT.NAME             = 'INS.AMOUNT-1'
    COLL.ID              = ''
    COLL.FIELD.NAME      = ''
    FIELD.NAME           = ''
    FIELD.NAME.BEHA      = ''
    FIELD.NAME.VALU      = ''

    PRIORITY             = 0
    AP.NAME              = ''
    AMOUNT               = 0
    R.BEHA.FLDS          = ''
    NO.OF.BEHA           = 0
    ITR                  = 0

    POLICY.TYPE          = ''
    CLASS.POLICY         = ''
    FIELD.NO             = ''
    Y.APP.ERR            = ''

    FN.CLASS.POLICY      = 'F.APAP.H.INSURANCE.CLASS.POLICY'
    F.CLASS.POLICY       = ''
    R.CLASS.POLICY       = ''
    CLASS.POLICY         = ''

    FN.POLICY.TYPE       = 'F.APAP.H.INSURANCE.POLICY.TYPE'
    F.POLICY.TYPE        = ''
    R.POLICY.TYPE        = ''

    FN.INS.COMB          = 'F.APAP.H.INSURANCE.COMB.PARAM'
    F.INS.COMB           = ''
    R.INS.COMB           = ''
    ID.INS.COMB          = ''

    POL.EXP.DATE.VALUE = ''

    SEL.CMD              = ''
    SEL.LIST             = ''
    FIELD.PREFIX         = ''
    REVIEW               = 0
    POS                  = 0
    POSSITION            = 0
RETURN
*
* ======================
SET.BEHAVIOUR:
* ======================
*
    GOSUB GET.FIELDS.POS

    LOCATE AMT.NAME IN R.BEHA.FLDS<FIELD.NAME,1> SETTING POSSITION THEN
        FIELD.NO = AMT.NAME
        GOSUB CONTROL.PRIORITY
        IF REVIEW EQ 0 THEN
            GOSUB GET.REVIEW.0
        END
    END

    IF R.NEW(INS.DET.POL.EXP.DATE) EQ '' THEN
        Y.CAMPO = 'POL.EXP.DATE'
        GOSUB GET.EXP.DATE
    END

    IF R.NEW(INS.DET.MANAGEMENT.TYPE) EQ 'INCLUIR EN CUOTA' THEN
        IF R.NEW(INS.DET.INS.END.DATE) EQ '' THEN
            Y.CAMPO = 'INS.END.DATE-1'
            GOSUB GET.EXP.DATE
        END
    END


RETURN

* ======================
CONTROL.PRIORITY:
* ======================
    IF PRIORITY EQ 1 OR PRIORITY EQ 2 THEN
        LOCATE FIELD.NO IN R.INS.COMB<INS.COMB.PARAM.FIELD.NAME,1> SETTING POS THEN
            REVIEW =1
        END ELSE
            REVIEW= 0
        END
    END



RETURN

*================
GET.REVIEW.0:
*================

    CALL EB.GET.APPL.FIELD(APPLICATION,FIELD.NO,'',Y.APP.ERR)

    CHANGE '.' TO @FM IN FIELD.NO
    FIELD.NO=FIELD.NO<1>

    NO.OF.BEHA = DCOUNT(R.BEHA.FLDS<FIELD.NAME.BEHA,POSSITION>,@SM)

    FOR ITR = 1 TO NO.OF.BEHA
        FIELD.BEHAVIOUR=R.BEHA.FLDS<FIELD.NAME.BEHA,POSSITION,ITR>
        FIELD.VALUE=R.BEHA.FLDS<FIELD.NAME.VALU,POSSITION,ITR>

        CALL APAP.REDOAPAP.apapHGetCollAmtRtn(FIELD.VALUE, AMOUNT, R.BEHA.FLDS, FIELD.NAME)
    NEXT

RETURN

*================
GET.EXP.DATE:
*================

    LOCATE Y.CAMPO IN R.BEHA.FLDS<FIELD.NAME,1> SETTING POSSITION THEN
        IF R.BEHA.FLDS<FIELD.NAME.VALU,POSSITION,1> EQ 'FECHA VENCIMIENTO PRESTAMO' THEN
            FIELD.NO = Y.CAMPO

            GOSUB CONTROL.PRIORITY

            IF REVIEW EQ 0 THEN
                CALL EB.GET.APPL.FIELD(APPLICATION,FIELD.NO,'',Y.APP.ERR)
                CHANGE '.' TO @FM IN FIELD.NO
                FIELD.NO=FIELD.NO<1>
*R.NEW(FIELD.NO)=''

                FIELD.BEHAVIOUR=R.BEHA.FLDS<FIELD.NAME.BEHA,POSSITION,1>
                FIELD.VALUE=R.BEHA.FLDS<FIELD.NAME.VALU,POSSITION,1>

                CALL APAP.REDOAPAP.apapHGetCollAmtRtn(FIELD.VALUE, POL.EXP.DATE.VALUE,R.BEHA.FLDS, FIELD.NAME)
                R.NEW(FIELD.NO)=POL.EXP.DATE.VALUE
            END
        END
    END

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
