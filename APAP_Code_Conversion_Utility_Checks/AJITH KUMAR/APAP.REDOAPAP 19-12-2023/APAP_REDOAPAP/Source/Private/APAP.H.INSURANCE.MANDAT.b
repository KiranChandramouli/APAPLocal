* @ValidationCode : Mjo1NDQ4NTA0OkNwMTI1MjoxNjg0ODM2MDMxNDc4OklUU1M6LTE6LTE6MTQ1NzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1457
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.H.INSURANCE.MANDAT
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
* Primary Purpose : control mandatory fields
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
* Development by  : Santiago Jijon
* Date            :
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   I to I.VAR , K to K.VAR , ++ to +=, SM to @SM , VM tO @VM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.CLASS.POLICY
    $INSERT I_F.APAP.H.INSURANCE.COMB.PARAM
    $INSERT I_F.APAP.H.INSURANCE.POLICY.TYPE
    $INSERT I_F.APAP.H.INSURANCE.EVENTFIELD
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS

*************************************************************************

    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB PROCESS

*
RETURN
*
* ======
PROCESS:
* ======

    ID.COMB = R.NEW(INS.DET.INS.POLICY.TYPE):"-": R.NEW(INS.DET.CLASS.POLICY)
    CALL F.READ(FN.INS.COMB, ID.COMB, R.COMB, F.INS.COMB, Y.APP.ERR)
    Y.CONT = DCOUNT(R.COMB<INS.CL.POL.FIELD.VALUES>,@VM)
    I.VAR = 1 ;* R22 AUTO CODE CONVERSION
    LOOP
    WHILE I.VAR LE Y.CONT ;* R22 AUTO CODE CONVERSION
        IF R.COMB<INS.CL.POL.FIELD.VALUES,I.VAR> EQ "CAMPO MANDATORIO" THEN ;* R22 AUTO CODE CONVERSION
            Y.CAMPO = R.COMB<INS.CL.POL.FIELD.NAME>
            Y.CAMPO.NOM = R.COMB<INS.CL.POL.FIELD.NAME>
            Y.VAR1 = Y.CAMPO['-',1,1]
            Y.VAR2 = Y.CAMPO['-',2,1]

            GOSUB GET.MANDATORY.FIELD
        END
        I.VAR += 1 ;* R22 AUTO CODE CONVERSION
    REPEAT

    ID.CLASS = R.NEW(INS.DET.CLASS.POLICY)
    CALL F.READ(FN.CLASS.POLICY, ID.CLASS, R.CLASS, F.CLASS.POLICY, Y.APP.ERR)
    Y.CONT = DCOUNT(R.CLASS<INS.CL.POL.FIELD.VALUES>,@VM)
    I.VAR = 1 ;* R22 AUTO CODE CONVERSION
    LOOP
    WHILE I.VAR LE Y.CONT
        IF R.CLASS<INS.CL.POL.FIELD.VALUES,I.VAR> EQ "CAMPO MANDATORIO" THEN
            Y.CAMPO = R.CLASS<INS.CL.POL.FIELD.NAME,I.VAR>
            Y.CAMPO.NOM = R.CLASS<INS.CL.POL.FIELD.NAME,I.VAR>
            Y.VAR1 = Y.CAMPO['-',1,1]
            Y.VAR2 = Y.CAMPO['-',2,1]

            GOSUB GET.MANDATORY.FIELD

        END
        I.VAR += 1
    REPEAT

    ID.POLICY = R.NEW(INS.DET.INS.POLICY.TYPE)
    CALL F.READ(FN.POLICY.TYPE, ID.POLICY, R.POLICY, F.POLICY.TYPE, Y.APP.ERR)
    Y.CONT = DCOUNT(R.POLICY<INS.POL.TYP.FIELD.VALUES>,@VM)
    I.VAR = 1
    LOOP
    WHILE I.VAR LE Y.CONT ;* R22 AUTO CODE CONVERSION
        IF R.POLICY<INS.POL.TYP.FIELD.VALUES,I.VAR> EQ "CAMPO MANDATORIO" THEN
            Y.CAMPO = R.POLICY<INS.POL.TYP.FIELD.NAME,I.VAR> ;* R22 AUTO CODE CONVERSION
            Y.CAMPO.NOM = R.POLICY<INS.POL.TYP.FIELD.NAME,I.VAR> ;* R22 AUTO CODE CONVERSION
            Y.VAR1 = Y.CAMPO['-',1,1]
            Y.VAR2 = Y.CAMPO['-',2,1]

            GOSUB GET.MANDATORY.FIELD

        END
        I.VAR += 1 ;* R22 AUTO CODE CONVERSION
    REPEAT


    IF R.NEW(INS.DET.MANAGEMENT.TYPE) EQ "INCLUIR EN CUOTA" THEN
        POS = 1
    END ELSE
        POS = 2
    END

    CALL F.READ(FN.EVENT.FIELD, "MANAGEMENT.TYPE", R.EVENT.FIELD, F.EVENT.FIELD, Y.APP.ERR)
    Y.CONT = DCOUNT(R.EVENT.FIELD<INS.EVF.ASSOCIATED.FIELDS,POS>,@SM)

    I.VAR = 1
    LOOP
    WHILE I.VAR LE Y.CONT
        IF R.EVENT.FIELD<INS.EVF.ASSOCIATED.ACTION,POS,I.VAR> EQ "INPUT" THEN
            Y.CAMPO = R.EVENT.FIELD<INS.EVF.ASSOCIATED.FIELDS,POS,I.VAR>
            Y.CAMPO.NOM = R.EVENT.FIELD<INS.EVF.ASSOCIATED.FIELDS,POS,I.VAR>
            Y.VAR1 = Y.CAMPO['-',1,1]
            Y.VAR2 = Y.CAMPO['-',2,1]

            GOSUB GET.MANDATORY.FIELD

        END
        I.VAR += 1 ;* R22 AUTO CODE CONVERSION
    REPEAT

* validate POL.EXP.DATE
    NO.OF.LOAN=DCOUNT(R.NEW(INS.DET.ASSOCIATED.LOAN),@VM)

    ITR.LOAN = 1
    LOOP
    WHILE ITR.LOAN LE NO.OF.LOAN
        ARR.ID = R.NEW(INS.DET.ASSOCIATED.LOAN)<1,ITR.LOAN>
        CALL F.READ(FN.AA.ACCOUNT.DETAILS, ARR.ID, R.AA.ACCOUNT.DETAILS, F.AA.ACCOUNT.DETAILS, READ.ERR)
        POL.EXP.DATE.LOANS<-1> = R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>

        IF ITR.LOAN EQ 1 THEN
            MAX.EXP.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>
        END ELSE
            IF R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE> GT MAX.EXP.DATE THEN
                MAX.EXP.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>
            END
        END
        ITR.LOAN += 1 ;* R22 AUTO CODE CONVERSION
    REPEAT

    Y.VAR1 = "POL.EXP.DATE"
    CALL EB.GET.APPL.FIELD('APAP.H.INSURANCE.DETAILS',Y.VAR1,'',Y.APP.ERR)
    IF  R.NEW(INS.DET.POL.EXP.DATE) GT MAX.EXP.DATE THEN
        AF = Y.VAR1
        ETEXT = "EB-B2-MATURITYDATE.GREATER": @FM : "Fec vencim"
        CALL STORE.END.ERROR
    END

    IF  R.NEW(INS.DET.POL.EXP.DATE) LT TODAY THEN
        AF = Y.VAR1
        ETEXT = "EB-B2-MATURITYDATE.LOWER": @FM : "Fec vencim"
        CALL STORE.END.ERROR
    END

*IF R.NEW(INS.DET.CLASS.POLICY) NE 'ED' THEN
    IF R.NEW(INS.DET.MANAGEMENT.TYPE) EQ 'INCLUIR EN CUOTA' THEN
        Y.VAR.CARGO = "INS.END.DATE"
        CALL EB.GET.APPL.FIELD('APAP.H.INSURANCE.DETAILS',Y.VAR.CARGO,'',Y.APP.ERR)
        IF  R.NEW(INS.DET.INS.END.DATE) GT MAX.EXP.DATE THEN
            AF = Y.VAR.CARGO
            ETEXT = "EB-B2-MATURITYDATE.GREATER": @FM : "Fec cargo"
            CALL STORE.END.ERROR
        END

        IF  R.NEW(INS.DET.INS.END.DATE) LT TODAY THEN
            AF = Y.VAR.CARGO
            ETEXT = "EB-B2-MATURITYDATE.LOWER": @FM : "Fec cargo"
            CALL STORE.END.ERROR
        END
    END

* This field is used in the enquiries for autorization in order to distinguish the source
    R.NEW(INS.DET.INDICADOR) = PGM.VERSION

RETURN

*
* =========
GET.MANDATORY.FIELD:
* =========
*
    BEGIN CASE
        CASE Y.VAR2 EQ '1'
            GOSUB CHECK.VM

        CASE Y.VAR2 EQ '1.1'
            GOSUB CHECK.SM

        CASE 1
            GOSUB CHECK.OTHER

    END CASE

RETURN

*
* =========
CHECK.VM:
* =========
*
    CALL EB.GET.APPL.FIELD('APAP.H.INSURANCE.DETAILS',Y.VAR1,'',Y.APP.ERR)
    Y.CONTSV = DCOUNT(R.NEW(Y.VAR1),@VM)
    IF Y.CONTSV GT 0 THEN
        K.VAR = 1 ;* R22 AUTO CODE CONVERSION
        LOOP
        WHILE K.VAR LE Y.CONTSV
            IF R.NEW(Y.VAR1)<1,K.VAR> EQ '' THEN
                AF = Y.VAR1
                AV = K.VAR   ;* R22 AUTO CODE CONVERSION
                ETEXT = "EB-B2-MANDATORY.FIELDS"
                CALL STORE.END.ERROR
            END
            K.VAR += 1 ;* R22 AUTO CODE CONVERSION
        REPEAT
    END ELSE
        IF R.NEW(Y.VAR1) EQ '' THEN
            AF = Y.VAR1
            ETEXT = "EB-B2-MANDATORY.FIELDS"
            CALL STORE.END.ERROR
        END
    END
RETURN

*
* =========
CHECK.SM:
* =========
*
    CALL EB.GET.APPL.FIELD('APAP.H.INSURANCE.DETAILS',Y.VAR1,'',Y.APP.ERR)
    Y.CONTSV = DCOUNT(R.NEW(Y.VAR1),@SM)
    IF Y.CONTSV GT 0 THEN
        K.VAR = 1
        LOOP
        WHILE K.VAR LE Y.CONTSV    ;* R22 AUTO CODE CONVERSION
            IF R.NEW(Y.VAR1)<1,1,K.VAR> EQ '' THEN
                AF = Y.VAR1
                AV = 1
                AS = K.VAR       ;* R22 AUTO CODE CONVERSION
                ETEXT = "EB-B2-MANDATORY.FIELDS"
                CALL STORE.END.ERROR
            END
            K.VAR += 1 ;* R22 AUTO CODE CONVERSION
        REPEAT
    END ELSE
        IF R.NEW(Y.VAR1) EQ '' THEN
            AF = Y.VAR1
            ETEXT = "EB-B2-MANDATORY.FIELDS"
            CALL STORE.END.ERROR
        END
    END

RETURN

*
* =========
CHECK.OTHER:
* =========
*
    CALL EB.GET.APPL.FIELD('APAP.H.INSURANCE.DETAILS',Y.VAR1,'',Y.APP.ERR)
    IF R.NEW(Y.VAR1) EQ '' THEN
        AF = Y.VAR1
        ETEXT = "EB-B2-MANDATORY.FIELDS"
        CALL STORE.END.ERROR
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
    CALL OPF(FN.EVENT.FIELD,F.EVENT.FIELD)
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

RETURN

*
* =========
INITIALISE:
* =========
*
    FN.CLASS.POLICY =  'F.APAP.H.INSURANCE.CLASS.POLICY'
    F.CLASS.POLICY  =  ''
    R.CLASS         =  ''

    FN.POLICY.TYPE  =  'F.APAP.H.INSURANCE.POLICY.TYPE'
    F.POLICY.TYPE   =  ''
    R.POLICY        =  ''

    FN.INS.COMB     =  'F.APAP.H.INSURANCE.COMB.PARAM'
    F.INS.COMB      =  ''
    R.COMB          =  ''

    FN.EVENT.FIELD  =  'F.APAP.H.INSURANCE.EVENTFIELD'
    F.EVENT.FIELD   =  ''
    R.EVENT.FIELD   =  ''

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    R.AA.ACCOUNT.DETAILS  = ''
    ARR.ID                = ''

RETURN

END
