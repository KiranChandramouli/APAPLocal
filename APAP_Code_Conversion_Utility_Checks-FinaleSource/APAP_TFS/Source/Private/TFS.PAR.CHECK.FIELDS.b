* @ValidationCode : Mjo1NDAzMjE1MDU6Q3AxMjUyOjE2OTg3NTA2NzQzODU6SVRTUzE6LTE6LTE6MDoxOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
* Version 3 21/07/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>1313</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.PAR.CHECK.FIELDS
*
*-----------------------------------------------------------------------
* Check fields subroutine for TFS.PARAMETER template
*
*-----------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
* 10/28/04 - Sathish PS
*            Added validations for new field APPLICATION.API
*
* 03/25/05 - Sathish PS
*            Validations for new field RESET.FIELDS

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion        USPLATFORM.BP File is Removed , FM , VM to @FM ,@Vm, CALL REFRESH.FIELD Changed,
*
*-----------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON

    $INSERT I_F.COMPANY
    $INSERT I_F.OFS.SOURCE
    $INSERT I_F.TRANSACTION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.STANDARD.SELECTION
    $USING EB.Display

    $INCLUDE I_F.TFS.PARAMETER ;*R22 Manual Conversion
*
    GOSUB INITIALISE
*
    BEGIN CASE
        CASE AS
            INTO.FIELD = R.NEW(AF)<1,AV,AS>
        CASE AV
            INTO.FIELD = R.NEW(AF)<1,AV>
        CASE OTHERWISE
            INTO.FIELD = R.NEW(AF)
    END CASE
*
    IF COMI = '' AND INTO.FIELD = '' THEN
        GOSUB DEFAULT.FIELDS
    END

    GOSUB CHECK.FIELDS

    IF COMI THEN
        COMI.ENRI.SAVE = COMI.ENRI
        COMI.ENRI = ''
        GOSUB DEFAULT.OTHER.FIELDS
        COMI.ENRI = COMI.ENRI.SAVE
    END

RETURN
*-----------------------------------------------------------------------
INITIALISE:

    E = ''
    ETEXT = ''
    ALLOWED.INTERFACES = CHANGE('FT TT DC',' ',@VM,0) ;*R22 Manual Conversion
    DEFAULT.DC.DEPT.POS = '1,4'
    DEFAULT.DC.BATCH.POS = '5,3'

    FN.OFSS = 'F.OFS.SOURCE' ; F.OFSS = ''
    FN.VER = 'F.VERSION' ; F.VER = ''
    FN.TXN = 'F.TRANSACTION' ; F.TXN = ''
    FN.SS = 'F.STANDARD.SELECTION' ; F.SS = ''

RETURN
*-----------------------------------------------------------------------
DEFAULT.FIELDS:

    BEGIN CASE
REM > CASE AF EQ XXX
    END CASE

*    CALL REFRESH.FIELD(AF,"")
    EB.Display.RefreshField(AF,"")    ;*R22 Manual Conversion

RETURN
*-----------------------------------------------------------------------
DEFAULT.OTHER.FIELDS:


REM >      CALL REFRESH.FIELD(DEFAULTED.FIELD, DEFAULTED.ENRI)

RETURN
*-----------------------------------------------------------------------
CHECK.FIELDS:

    DEFAULTED.FIELD = '' ; DEFAULTED.ENRI = ''

    BEGIN CASE
        CASE AF EQ TFS.PAR.DEF.TFS.TXNS
            IF NOT(COMI) THEN
                NO.OF.MVS = DCOUNT(R.NEW(TFS.PAR.DEF.TFS.TXNS),@VM)
                IF NO.OF.MVS GT 1 THEN
                    E = 'EB-INP.OR.LINEDELETION.MISS'
                END
            END

        CASE AF EQ TFS.PAR.OFS.SOURCE
            IF COMI THEN
                OFSS.ID = COMI
                CALL F.READ(FN.OFSS,OFSS.ID,R.OFSS,F.OFSS,ERR.OFSS)
                IF R.OFSS<OFS.SRC.SOURCE.TYPE> NE 'GLOBUS' THEN
                    E = 'EB-TFS.SRC.TYPE.MUST.BE.GLOBUS'
                END
            END

        CASE AF EQ TFS.PAR.APPLICATION
            IF COMI THEN
                IF NOT(COMI MATCHES ALLOWED.INTERFACES) THEN
                    E = 'EB-TFS.ALLOWED.INTERFACES' :@FM: CHANGE(ALLOWED.INTERFACES,@VM,' ',0) ;*R22 Manual Conversion
                END
            END

        CASE AF EQ TFS.PAR.APPLICATION.API
            IF COMI THEN
                COMP.OR.NOT = '' ; RTN.NAME = COMI
                CALL CHECK.ROUTINE.EXIST(RTN.NAME,COMP.OR.NOT,'')
                IF NOT(COMP.OR.NOT) THEN
                    E = 'EB-ROUTINE.DOES.NOT.EXIST'
                END
            END ELSE
                IF R.NEW(TFS.PAR.APPLICATION)<1,AV> THEN
                    E = 'EB-INPUT.MISSING'
                END
            END

        CASE AF EQ TFS.PAR.OFS.VERSION
            IF COMI THEN
                APPL = R.NEW(TFS.PAR.APPLICATION)<1,AV>
                IF APPL THEN
                    BEGIN CASE
                        CASE APPL EQ 'FT'
                            APPL = 'FUNDS.TRANSFER'
                        CASE APPL EQ 'TT'
                            APPL = 'TELLER'
                        CASE APPL EQ 'DC'
                            APPL = 'DATA.CAPTURE'
                        CASE OTHERWISE
                            APPL = ''
                    END CASE
                    IF APPL THEN
                        VER.ID = APPL : COMI
                        CALL F.READ(FN.VER,VER.ID,R.VER,F.VER,ERR.VER)
                        IF R.VER THEN
                            COMI.ENRI = VER.ID
                        END ELSE
                            E = 'EB-TFS.MISS.VERSION' :@FM: VER.ID
                        END
                    END ELSE
                        E = 'EB-TFS.INVALID.APPL'
                    END
                END ELSE
                    E = 'EB-TFS.APPL.INPUT.MISSING'
                END
            END

        CASE AF EQ TFS.PAR.STO.ENRICHMENT
            IF COMI THEN
                FIELD.NAME = COMI ; SS.ID = 'STANDING.ORDER' ; MUST.BE.SYSTEM.FIELD = 0
                GOSUB CHECK.FIELD.VALIDITY
            END

        CASE AF EQ TFS.PAR.RESET.FIELDS
            IF COMI THEN
                FIELD.NAME = COMI ; SS.ID = 'T24.FUND.SERVICES' ; MUST.BE.SYSTEM.FIELD = 1
                GOSUB CHECK.FIELD.VALIDITY
            END

        CASE AF EQ TFS.PAR.DEF.ACCNTG.STYLE
            IF COMI THEN
                BEGIN CASE
                    CASE COMI EQ 'ATOMIC'
                        COMI.ENRI = 'Lines - All Done or None'

                    CASE COMI EQ 'INDEPENDENT'
                        COMI.ENRI = 'Lines - Independent of each other'
                END CASE
            END

        CASE AF EQ TFS.PAR.DC.TXN.CODE.CR
            IF COMI THEN
                CR.DR = 'CREDIT'
                GOSUB VALIDATE.TXN.CODE
            END

        CASE AF EQ TFS.PAR.DC.TXN.CODE.DR
            IF COMI THEN
                CR.DR = 'DEBIT'
                GOSUB VALIDATE.TXN.CODE
            END

        CASE AF EQ TFS.PAR.DC.DEPT.IN.DC.ID
            IF NOT(COMI) THEN COMI = DEFAULT.DC.DEPT.POS
            GOSUB VALIDATE.DC.DEPT.BATCH

        CASE AF EQ TFS.PAR.DC.BATCH.IN.DC.ID
            IF NOT(COMI) THEN COMI = DEFAULT.DC.BATCH.POS
            GOSUB VALIDATE.DC.DEPT.BATCH

        CASE AF EQ TFS.PAR.ALLOW.DC.ZERO.AUT
            IF NOT(COMI) THEN COMI = 'NO'

        CASE AF EQ TFS.PAR.ALLOW.FT.HIS.REV
            IF NOT(COMI) THEN COMI = 'NO'

    END CASE

*    IF DEFAULTED.FIELD AND NOT(GTSACTIVE) THEN CALL REFRESH.FIELD(DEFAULTED.FIELD,DEFAULTED.ENRI)
    IF DEFAULTED.FIELD AND NOT(GTSACTIVE) THEN CALL EB.Display.RefreshField(DEFAULTED.FIELD,DEFAULTED.ENRI)     ;*R22 Manual Conversion

RETURN
*-----------------------------------------------------------------------
CHECK.FIELD.VALIDITY:

    CALL CACHE.READ(FN.SS,SS.ID,R.SS,ERR.SS)
    IF R.SS THEN
        LOCATE FIELD.NAME IN R.SS<SSL.SYS.FIELD.NAME,1> SETTING FLD.POS THEN
            IF MUST.BE.SYSTEM.FIELD THEN
                IF NOT(R.SS<SSL.SYS.FIELD.NO,FLD.POS>) THEN
                    E = 'EB-TFS.INVALID.FIELD'
                END
            END
        END ELSE
            E = 'EB-TFS.INVALID.FIELD'
        END
    END ELSE
        E = 'EB-US.REC.MISS.FILE' :@FM: SS.ID :@VM: FN.SS
    END

RETURN
*--------------------------------------------------------------------------
VALIDATE.TXN.CODE:

    TXN.ID = COMI
    CALL F.READ(FN.TXN,TXN.ID,R.TXN,F.TXN,ERR.TXN)
    IF R.TXN THEN
        IF R.TXN<AC.TRA.DATA.CAPTURE> EQ 'Y' THEN
            IF R.TXN<AC.TRA.DEBIT.CREDIT.IND> NE CR.DR THEN
                E = 'EB-TFS.TXN.CODE.MUST.BE' :@FM: CR.DR
            END
        END ELSE
            E = 'EB-TFS.TXN.CODE.CANT.BE.USED.IN.DC'
        END
    END

RETURN
*-----------------------------------------------------------------------
VALIDATE.DC.DEPT.BATCH:

    START.POS.PART = COMI[',',1,1]
    LEN.PART = COMI[',',2,1]
    IF NOT(START.POS.PART) OR NOT(LEN.PART) THEN
        E = 'EB-TFS.INVALID.FORMAT.CR.FOR.DEFAULT'
    END
*
    IF NOT(E) THEN
        COMI.ENRI = 'Starting from Position ':START.POS.PART:', Upto ':LEN.PART:' Digits'
    END

RETURN
*-----------------------------------------------------------------------
END




















