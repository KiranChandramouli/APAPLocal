* @ValidationCode : Mjo4OTQ2Njc5NTQ6Q3AxMjUyOjE2OTg3NTA2NzM4NDU6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:13
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
$PACKAGE APAP.TFS
* Version 9 15/11/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>3252</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE T24.FUND.SERVICES
*-----------------------------------------------------------------------------
*
* A local template to facilitate multiple fund transfers/widthdrawals/deposits/
* Correction entries in the same window.
*
*-----------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
* 05/12/05 - Sathish PS
*            Introduction of 2 new common variables - TFS$LINE.FIRST.FIELD &
*            TFS$LINE.LAST.FIELD pointing to fields TFS.TRANSACTION & TFS.RETRY resp.
*
* 12/27/05 - Sathish PS
*            Donot process when TXN.CANCELLED (MESSAGE = RET from UNAUTH.RECORD.WRITE)
*
* 29 AUG 07 - Sathish PS
*             Stupid mistake of repeating CROSSVAL at AUTH.CROSS.VALIDATION - shouldnt
*             have been there in the first place.
*
* 07 SEP 07 - Sathish PS
*             Stop the transaction if NET.ENTRY NE NO and no Netted Entry...
*
* 09 SEP 07 - Sathish PS
*             Dont return any error messages from SET.OUR.ENRICHMENTS. if something is wrong
*             it will anyway be out with Validation.
*             Even otherwise, if anything needs to be stopped at record launch, should be done
*             at CHECK.RECORD
*             Also restrict the number of times SET.OUT.ENRICHMENT will be called based on
*             when we set SHOW.OFF.OURSELVES
*
* 18 SEP 07 - GP
*             Set MESSAGE = ERROR for Check fields errors.
*
* 11 NOV 09 - Sathish PS
*             Handle INAO
* 11 NOV 09 - ANITHA
*             Handle INAO
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Suresh             R22 Manual Conversion             GLOBUS.BP File Removed, USPLATFORM.BP File Removed, CALL routine format modified, FM TO @FM, VM TO @VM, SM TO @SM
*-----------------------------------------------------------------------------
    $INCLUDE I_COMMON ;*R22 Manual Conversion - START
    $INCLUDE I_EQUATE
    $INCLUDE I_GTS.COMMON
    $INCLUDE I_F.COMPANY
    $INCLUDE I_F.USER
    $INCLUDE I_F.OFS.SOURCE
    $INCLUDE I_F.VERSION
    $INCLUDE I_F.OVERRIDE

    $INCLUDE I_F.CATEGORY
    $INCLUDE I_F.TRANSACTION
    $INCLUDE I_F.FT.TXN.TYPE.CONDITION
    $INCLUDE I_F.TELLER.TRANSACTION
    $INCLUDE I_F.FUNDS.TRANSFER
    $INCLUDE I_F.TELLER
    $INCLUDE I_F.ACCOUNT
    $INCLUDE I_F.CHEQUE.REGISTER

    $INCLUDE I_F.OFS.STATUS.FLAG

    $INCLUDE I_F.T24.FUND.SERVICES
    $INCLUDE I_F.TFS.PARAMETER
    $INCLUDE I_F.TFS.TRANSACTION
    $INCLUDE I_T24.FS.COMMON ;*R22 Manual Conversion - END
    
    
*-----------------------------------------------------------------------------

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE          ;* Special Initialising
*-----------------------------------------------------------------------------

* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL (MESSAGE EQ 'RET')

        V$ERROR = ''

        IF MESSAGE EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            GOSUB CHECK.RECORD          ;* Special Editing of Record

            CALL MATRIX.ALTER

            IF SHOW.OFF.OURSELVES THEN
                GOSUB SET.OUR.ENRICHMENTS         ;* Similar to Check Record but to set Enrichments in T.ENRI
            END

            IF V$ERROR THEN GOTO MAIN.REPEAT

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE (MESSAGE EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:
    REPEAT

V$EXIT:
RETURN          ;* From main program

*-----------------------------------------------------------------------------
*                      S u b r o u t i n e s                            *
*-----------------------------------------------------------------------------

PROCESS.FIELDS:

* Input or display the record fields.

    LOOP
        IF SCREEN.MODE EQ 'MULTI' THEN
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.MULTI.INPUT
            END ELSE
                CALL FIELD.MULTI.DISPLAY
            END
        END ELSE
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.INPUT
            END ELSE
                CALL FIELD.DISPLAY
            END
        END

    WHILE NOT(MESSAGE)

        GOSUB CHECK.FIELDS    ;* Special Field Editing

        IF T.SEQU NE '' THEN T.SEQU<-1> = A + 1

    REPEAT

RETURN

*-----------------------------------------------------------------------------

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    TFS$MESSAGE = MESSAGE     ;* Save MESSAGE
    IF MESSAGE EQ 'DEFAULT' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF MESSAGE EQ 'PREVIEW' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
REM >               GOSUB DELIVERY.PREVIEW   ; * Activate print preview
            END
        END
    END

    IF MESSAGE EQ 'VAL' THEN
        MESSAGE = ''
        BEGIN CASE
            CASE V$FUNCTION EQ 'D'
                GOSUB CHECK.DELETE          ;* Special Deletion checks
            CASE V$FUNCTION EQ 'R'
                GOSUB CHECK.REVERSAL        ;* Special Reversal checks
            CASE OTHERWISE
                GOSUB CROSS.VALIDATION      ;* Special Cross Validation
                IF NOT(V$ERROR) THEN
                    GOSUB OVERRIDES
                END
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE     ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
            CALL UNAUTH.RECORD.WRITE
            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END
    END

    IF MESSAGE EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN
            CALL AUTH.RECORD.WRITE
            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
            END
        END

    END

    TFS$MESSAGE = MESSAGE     ;* Reset to Original

RETURN

*-----------------------------------------------------------------------------
*                      Special Tailored Subroutines                          *
*-----------------------------------------------------------------------------

CHECK.ID:
* Validation and changes of the ID entered.  Set ERROR to 1 if in error.
    V$ERROR = 0
    E = ''

    CALL EB.FORMAT.ID('T24FS')

    IF E THEN
        CALL ERR
        V$ERROR = 1
    END

RETURN

*-----------------------------------------------------------------------------
CHECK.RECORD:

* Validation and changes of the Record.  Set ERROR to 1 if in error.

    CHECK.RECORD = 0
    IF GTSACTIVE THEN
        IF OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> EQ 'SESSION' THEN
            IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN
                CHECK.RECORD = 1
            END
        END ELSE
            CHECK.RECORD = 1
        END
    END ELSE
        CHECK.RECORD = 1
    END

    CHECK.RECORD = 1          ;* Always do CHECK.RECORD
    IF CHECK.RECORD THEN

        IF PGM.VERSION EQ '' THEN
            TFS$AUTH.NO = R.COMPANY(EB.COM.DEFAULT.NO.OF.AUTH)
        END ELSE
            TFS$AUTH.NO = R.VERSION(EB.VER.NO.OF.AUTH)
        END
        IF TFS$AUTH.NO NE 0 AND V$FUNCTION MATCHES 'I' :@VM: 'C' THEN UNAUTH.PROCESSING = 1 ELSE UNAUTH.PROCESSING = 0

*        CALL T24.FS.CHECK.RECORD
        APAP.TFS.t24FsCheckFields() ;*R22 Manual Conversion
        TFS$MESSAGE = ''      ;* Reset everytime a record is loaded
    END

    IF E THEN
        CALL ERR
        V$ERROR = 1
        MESSAGE = 'REPEAT'
    END

RETURN
*-----------------------------------------------------------------------------
CHECK.FIELDS:

    TFS$MESSAGE = ''
*    CALL T24.FS.CHECK.FIELDS
    APAP.TFS.t24FsCheckFields();*R22 Manual Conversion
    
    IF E THEN
        T.SEQU = "IFLD"
        MESSAGE = 'ERROR'     ;* 14 SEP 07 - GP s/e
        CALL ERR
    END

RETURN
*-----------------------------------------------------------------------------
CROSS.VALIDATION:

*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
*GP 08/25/05
    TFS$MESSAGE = 'VAL'
* CALL T24.FS.CROSSVAL
    APAP.TFS.t24FsCrossval() ;*R22 Manual Conversion
  
* CALL T24.FS.VALIDATE
    APAP.TFS.t24FsValidate() ;*R22 Manual Conversion
*
* If END.ERROR has been set then a cross validation error has occurred
*
    IF END.ERROR THEN
        A = 1
        LOOP UNTIL T.ETEXT<A> <> "" DO A = A+1 ; REPEAT
        T.SEQU = "D"
        T.SEQU<-1> = A
        V$ERROR = 1
        MESSAGE = 'ERROR'
    END

RETURN          ;* Back to field input via UNAUTH.RECORD.WRITE
*-----------------------------------------------------------------------------
OVERRIDES:
*
*  Overrides should reside here.
*

    CALL STORE.OVERRIDE(0)    ;* Reset all Overrides
*
    IF TEXT EQ "NO" THEN       ;* Said NO to override
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input

    END

RETURN

*-----------------------------------------------------------------------------
AUTH.CROSS.VALIDATION:


    LAST.STAGE = TFS$MESSAGE
    IF LAST.STAGE EQ 'BEFORE.UNAUTH' THEN RETURN  ;* Validations already done - Applicable only for 0 Auth versions.

    !    CALL T24.FS.CROSSVAL ;* 29 AUG 07 - Sathish PS s/e Dont repeat Crossval. If anything to be added, add it as 'Auth Cross Val'.

    IF END.ERROR THEN
        V$ERROR = 1
        MESSAGE = 'ERROR'
    END

RETURN

*-----------------------------------------------------------------------------
CHECK.DELETE:


RETURN
*-----------------------------------------------------------------------------
CHECK.REVERSAL:


RETURN
*-----------------------------------------------------------------------------
DELIVERY.PREVIEW:

RETURN
*-----------------------------------------------------------------------------
BEFORE.UNAU.WRITE:
*
* We are doing this to check for Overrides from the Underlying Application.
*
    E = ''
    ETEXT = ''
    V$ERROR = ''
* 07 SEP 07 - Sathish PS /s
    IF OFS$OPERATION EQ 'PROCESS' THEN
        IF R.NEW(TFS.NET.ENTRY) NE 'NO' THEN
            AF = TFS.NET.ENTRY          ;* Added for the issue HD1008046 by umar
            LOCATE 'YES' IN R.NEW(TFS.NETTED.ENTRY)<1,1> SETTING NET.ENTRY.POS ELSE
                ETEXT = 'EB-TFS.NET.ENTRY.MISSING'
                CALL STORE.END.ERROR
            END
        END
    END
* 07 SEP 07 - Sathish PS /e
    IF NOT(END.ERROR) THEN    ;* 07 SEP 07 - Sathish PS s/e
        TFS.OVERRIDES.STORED = ''
        OFS.ACTION = 'VALIDATE'
        TFS$MESSAGE = 'BEFORE.UNAUTH'

        GOSUB CLEAN.UP.DENOMS

*        CALL T24.FS.INTERFACE(OFS.ACTION)
        APAP.TFS.t24FsInterface(OFS.ACTION) ;*R22 Manual Conversion
        
    END   ;* 07 SEP 07 - Sathish PS s/e

    IF NOT(END.ERROR) THEN
        IF OFS.ACTION THEN
            F.OVE = ''
            NO.OF.TXNS = DCOUNT(R.NEW(TFS.TRANSACTION),@VM) ;*R22 Manual Conversion
            FOR XX = 1 TO NO.OF.TXNS
                TXN.OVERRIDES = OFS.ACTION<XX>
                NO.OF.OVERRIDES = DCOUNT(TXN.OVERRIDES,@VM)
                FOR YY = 1 TO NO.OF.OVERRIDES
                    TEMP.TEXT = TXN.OVERRIDES<1,YY>
*09 dec 2009 anitha-added for issue in OVERRIDE.CLASS as per sathish's advice
                    TEMP.TEXT = TEMP.TEXT['*',1,1]          ;! Remove Override class from the message
*09 dec 2009 e
                    CONVERT '}' TO @VM IN TEMP.TEXT
                    CONVERT '{' TO @FM IN TEMP.TEXT
                    IF TEMP.TEXT<1,1> THEN TEXT = TEMP.TEXT<1,1> ELSE TEXT = TEMP.TEXT<1,2>
                    IF TEMP.TEXT<2> THEN TEXT := @FM: TEMP.TEXT<2> ;*R22 Manual Conversion
                    LOWER.TEXT = LOWER(TEXT)
                    IF LOWER.TEXT THEN
                        LOCATE LOWER.TEXT IN TFS.OVERRIDES.STORED<1> SETTING IGNORE.THIS.OVE ELSE
                            TFS.OVERRIDES.STORED<-1> = LOWER.TEXT
                            SAVE.TEXT = TEXT
                            CALL STORE.OVERRIDE(1)
                            IF TEXT EQ 'NO' THEN
                                COMI = ''
                                GOSUB BUILD.ETEXT.FROM.OVE
                                ETEXT = OVE.MSG
                                AF = 1
                                CALL STORE.END.ERROR
                                BREAK
                            END
                        END
                    END
                NEXT YY
                IF TEXT EQ 'NO' THEN BREAK
            NEXT XX
        END
    END
*

    IF TEXT EQ "NO" OR END.ERROR OR ETEXT OR E THEN          ;* Said No to override
        CALL TRANSACTION.ABORT          ;* Cancel current transaction
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input
    END

RETURN
*-----------------------------------------------------------------------------
AFTER.UNAU.WRITE:

* Only if we are not in Zero auth

    IF MESSAGE EQ 'RET' THEN RETURN     ;* 12/27/05 - Sathish PS s/e
* 11 NOV 09 - Sathish PS /s
* UNAUTH.PROCESSING is set in CHECK.RECORD based on TFS$AUTH.NO. In 0 auth versions
* if the user doesnt have Override class, then TFS would be placed in INAO even
* though TFS$AUTH.NO will still be 0. At AFTER.UNAU.WRITE, we would know if this
* is the case based on RECORD.STATUS which would have been set to INAO by
* UNAUTH.RECORD.WRITE. So set UNAUTH.PROCESSING if RECORD.STATUS is NAO.
*
    IF NOT(UNAUTH.PROCESSING) THEN
        IF TFS$AUTH.NO EQ 0 AND R.NEW(TFS.RECORD.STATUS)[2,3] EQ 'NAO' THEN     ;* For both I and C functions
            UNAUTH.PROCESSING = 1
        END
    END
* 11 NOV 09 - Sathish PS /e
    IF UNAUTH.PROCESSING THEN
* PACS00329652 - S
        TFS$AUTH.NO = '1'
* PACS00329652 - E
        OFS.ACTION = 'PROCESS'
        TFS$MESSAGE = 'AFTER.UNAUTH'

*        CALL T24.FS.INTERFACE(OFS.ACTION)
        APAP.TFS.t24FsInterface(OFS.ACTION) ;*R22 Manual Conversion


        GOSUB CHECK.AND.RAISE.ERROR

    END

RETURN
*-----------------------------------------------------------------------------
BEFORE.AUTH.WRITE:
*
    IF NOT(V$FUNCTION MATCHES 'A' :@VM: 'R') THEN  ;* Can't Validate for A and if its R, all Lines would have been Reversed. VALIDATE option not avialable for Function 'A'
        LAST.STAGE = TFS$MESSAGE
        IF LAST.STAGE EQ 'BEFORE.UNAUTH' THEN RETURN        ;* Validations already done - Applicable only for 0 Auth versions.
        OFS.ACTION = 'VALIDATE'
        TFS$MESSAGE = 'BEFORE.AUTH'

        IF R.NEW(TFS.ACCOUNTING.STYLE) EQ 'ATOMIC' THEN     ;* If its not Atomic, then the user can always RETRY
*            CALL T24.FS.INTERFACE(OFS.ACTION)
            APAP.TFS.t24FsInterface(OFS.ACTION) ;*R22 Manual Conversion
            
            IF END.ERROR OR ETEXT OR E THEN GOSUB CHECK.AND.RAISE.ERROR
        END
    END
    IF V$ERROR EQ 1 THEN
        CALL TRANSACTION.ABORT
        MESSAGE = 'ERROR'     ;* Back to Field Input
    END

RETURN
*-----------------------------------------------------------------------------
AFTER.AUTH.WRITE:

    E = ''
    ETEXT = ''
    V$ERROR = ''

    IF R.NEW(TFS.RECORD.STATUS) EQ 'REVE' THEN RETURN

    OFS.ACTION = 'PROCESS'
    TFS$MESSAGE = 'AFTER.AUTH'

*    CALL T24.FS.INTERFACE(OFS.ACTION)
    APAP.TFS.t24FsInterface(OFS.ACTION) ;*R22 Manual Conversion
    
*
    GOSUB CHECK.AND.RAISE.ERROR

RETURN
*-----------------------------------------------------------------------------
CHECK.FUNCTION:

* Validation of function entered.  Set FUNCTION to null if in error.

    IF INDEX('V',V$FUNCTION,1) THEN
        E = 'EB.RTN.FUNT.NOT.ALLOWED.APP'
        CALL ERR
        V$FUNCTION = ''
    END

RETURN
*-----------------------------------------------------------------------------
INITIALISE:

*    CALL T24.FS.INITIALISE
    APAP.TFS.t24FsInitialise() ;*R22 Manual Conversion
    
    MY.NAME = APPLICATION
    LINE.FIRST.FIELD = TFS$LINE.FIRST.FIELD
    LINE.LAST.FIELD = TFS$LINE.LAST.FIELD
    U.LANG = R.USER<EB.USE.LANGUAGE>

    FN.TXN = 'F.TRANSACTION' ; F.TXN = ''
    FN.FT = 'F.FUNDS.TRANSFER' ; F.FT = ''
    FN.FT.HIS = FN.FT :'$HIS' ; F.FT.HIS = ''
    FN.FT.TXN = 'F.FT.TXN.TYPE.CONDITION' ; F.FT.TXN = ''
    FN.TT = 'F.TELLER' ; F.TT = ''
    FN.TT.HIS = FN.TT :'$HIS' ; F.TT.HIS = ''
    FN.TT.TXN = 'F.TELLER.TRANSACTION' ; F.TT.TXN = ''
    FN.AC = 'F.ACCOUNT' ; F.AC = ''
    FN.CATEG = 'F.CATEGORY' ; F.CATEG = ''
    FN.OFSS = 'F.OFS.SOURCE' ; F.OFSS = ''
    FN.OVE = 'F.OVERRIDE' ; F.OVE = ''

    FN.TFS = 'F.T24.FUND.SERVICES' ; F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)
    FN.TFS.HIS = FN.TFS:'$HIS' ; F.TFS.HIS = ''
    CALL OPF(FN.TFS.HIS,F.TFS.HIS)
    FN.TFS.NAU = FN.TFS:'$NAU' ; F.TFS.NAU = ''
    CALL OPF(FN.TFS.NAU,F.TFS.NAU)

    ! 09 SEP 07 - Sathish PS /s
    !    SHOW.OFF.OURSELVES = NOT(GTSACTIVE) OR (GTSACTIVE AND OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> EQ 'SESSION')
    SHOW.OFF.OURSELVES = NOT(GTSACTIVE)
    IF GTSACTIVE AND OFS$SOURCE.REC<OFS.SRC.SOURCE.TYPE> EQ 'SESSION' THEN
        IF (OFS$OPERATION EQ 'BUILD' AND OFS$HOT.FIELD EQ '') OR (OFS$OPERATION EQ 'VALIDATE') OR (OFS$STATUS<STAT.FLAG.FIRST.TIME>) THEN
            SHOW.OFF.OURSELVES = 1
        END
    END
    ! 09 SEP 07 - Sathish PS /e

RETURN
*-----------------------------------------------------------------------------
DEFINE.PARAMETERS:

*    CALL T24.FS.FIELD.DEFINITIONS
    APAP.TFS.t24FsFieldDefinitions() ;*R22 Manual Conversion

RETURN
*----------------------------------------------------------------------------*
*                   L O C A L   S U B R O U T I N E S                        *
*----------------------------------------------------------------------------*
SET.OUR.ENRICHMENTS:

    DUMP.DATA = ''
    SAVE.AF = AF ; SAVE.AV = AV ; SAVE.AS = AS ; SAVE.COMI = COMI ; SAVE.COMI.ENRI = COMI.ENRI ; SAVE.E = E
    TFS$MESSAGE = 'CHECK.RECORD'

    OUR.ENRI.FIELDS = TFS.ACCOUNT.DR :@FM: TFS.ACCOUNT.CR :@FM: TFS.EXP.SCHEDULE
    OUR.ENRI.FIELDS := @FM: TFS.ACCOUNTING.STYLE :@FM: TFS.SURROGATE.AC
    LOOP
        REMOVE AF FROM OUR.ENRI.FIELDS SETTING NEXT.AF.POS
    WHILE AF : NEXT.AF.POS DO
        GOSUB SETUP.FLD.ENRI
    REPEAT
*
    UNDERLYING.TXNS = R.NEW(TFS.UNDERLYING)
    AF = TFS.UNDERLYING
    AV = 1
    LOOP
        REMOVE UL.TXN.ID FROM UNDERLYING.TXNS SETTING NEXT.TXN.ID.POS
    WHILE UL.TXN.ID : NEXT.TXN.ID.POS DO
        IF UL.TXN.ID THEN
            GOSUB SETUP.TXN.ENRI
        END
        AV += 1
    REPEAT
*
    UNDERLYING.TXNS = R.NEW(TFS.R.UNDERLYING)
    AF = TFS.R.UNDERLYING
    AV = 1
    LOOP
        REMOVE UL.TXN.ID FROM UNDERLYING.TXNS SETTING NEXT.TXN.ID.POS
    WHILE UL.TXN.ID : NEXT.TXN.ID.POS DO
        IF UL.TXN.ID THEN
            GOSUB SETUP.TXN.ENRI
        END
        AV += 1
    REPEAT
*
    NET.ACCOUNT.NUMBERS = R.NEW(TFS.ACCOUNT.NUMBER)
    AC.CNT = 1
    LOOP
        REMOVE AC.ID FROM NET.ACCOUNT.NUMBERS SETTING NEXT.ID.POS
    WHILE AC.ID : NEXT.ID.POS DO
        AC.ENRI = ''
        CALL F.READV(FN.AC,AC.ID,AC.ENRI,AC.SHORT.TITLE,F.AC,ERR.AC)
        IF AC.ENRI EQ '' THEN
            IF AC.ID[1,2] EQ 'PL' THEN
                PL = 1 ; AC.ID[1,2] = ''
            END ELSE PL = 0
            CALL F.READV(FN.CATEG,AC.ID,AC.ENRI,EB.CAT.DESCRIPTION,F.CATEG,ERR.CATEG)
            IF PL THEN AC.ENRI = 'P/L - ':AC.ENRI
        END
        IF AC.ENRI THEN
            LOCATE TFS.ACCOUNT.NUMBER :'.': AC.CNT IN T.FIELDNO<1> SETTING AC.AV.POS THEN
                T.ENRI<AC.AV.POS> = AC.ENRI
            END
        END
        AC.CNT += 1
    REPEAT

    IF E THEN
        ! 09 SEP 07 - Sathish PS /s
        !        CALL ERR
        !        V$ERROR = 1
        !        MESSAGE = 'REPEAT'
        ! 09 SEP 07 - Sathish PS /e
    END

    TFS$MESSAGE = ''
    AF = SAVE.AF ; AV = SAVE.AV ; AS = SAVE.AS ; COMI = SAVE.COMI ; COMI.ENRI = SAVE.COMI.ENRI ; E = SAVE.E

RETURN
*-----------------------------------------------------------------------------
SETUP.FLD.ENRI:

    NO.OF.MVS = DCOUNT(R.NEW(AF),@VM)
    IF NOT(NO.OF.MVS) THEN NO.OF.MVS = 1
    FOR AV = 1 TO NO.OF.MVS
        NO.OF.SVS = DCOUNT(R.NEW(AF)<1,AV>,@SM) ;*R22 Manual Conversion
        IF NOT(NO.OF.SVS) THEN NO.OF.SVS = 1
        FOR AS = 1 TO NO.OF.SVS

            YT.FIELD = AF
            IF F(AF)[1,2] EQ "XX" OR AF EQ LOCAL.REF.FIELD THEN
                YT.FIELD := ".":AV
            END
            IF F(AF)[4,2] EQ "XX" OR AF EQ LOCAL.REF.FIELD THEN
                IF COUNT(R.NEW(AF)<1, AV>, @SM) THEN
                    YT.FIELD := ".":AS
                END
            END
*
            COMI = R.NEW(AF)<1,AV,AS>
            COMI.ENRI = ''
            IF COMI THEN
*              CALL T24.FS.CHECK.FIELDS
                APAP.TFS.t24FsCheckFields() ;*R22 Manual Conversion
                IF COMI.ENRI THEN
                    LOCATE YT.FIELD IN T.FIELDNO<1> SETTING ENRI.POS THEN
                        T.ENRI<ENRI.POS> = COMI.ENRI
                    END
*
                END
            END
        NEXT AS
    NEXT AV

RETURN
*------------------------------------------------------------------------------
SETUP.TXN.ENRI:

    TXN.ENRI = ''
    BEGIN CASE
        CASE UL.TXN.ID[1,2] EQ 'FT'
            CALL F.READ(FN.FT,UL.TXN.ID,R.FT,F.FT,ERR.FT)
            IF NOT(R.FT) THEN
                CALL F.READ.HISTORY(FN.FT.HIS,UL.TXN.ID,R.FT,F.FT.HIS,ERR.FT.HIS)
            END
            IF R.FT THEN
                FT.TXN = R.FT<FT.TRANSACTION.TYPE>
                CALL F.READV(FN.FT.TXN,FT.TXN,FT.TXN.DESC,FT6.DESCRIPTION,F.FT.TXN,ERR.FT.TXN)
                IF FT.TXN.DESC THEN
                    IF INDEX(FT.TXN.DESC,@SM,1) THEN TXN.ENRI = FT.TXN.DESC<1,1,U.LANG> ELSE TXN.ENRI = FT.TXN.DESC<1,U.LANG>
                END
            END

        CASE UL.TXN.ID[1,2] EQ 'TT'
            CALL F.READ(FN.TT,UL.TXN.ID,R.TT,F.TT,ERR.TT)
            IF NOT(R.TT) THEN
                CALL F.READ.HISTORY(FN.TT.HIS,UL.TXN.ID,R.TT,F.TT.HIS,ERR.TT.HIS)
            END
            IF R.TT THEN
                TT.TXN = R.TT<TT.TE.TRANSACTION.CODE>
                CALL F.READV(FN.TT.TXN,TT.TXN,TT.TXN.DESC,TT.TR.DESC,F.TT.TXN,ERR.TT.TXN)
                IF TT.TXN.DESC THEN
                    IF INDEX(TT.TXN.DESC,@SM,1) THEN TXN.ENRI = TT.TXN.DESC<1,1,U.LANG> ELSE TXN.ENRI = TT.TXN.DESC<1,U.LANG>
                END
            END

        CASE OTHERWISE
            TXN.ENRI = ''
    END CASE

    IF TXN.ENRI THEN
        LOCATE AF :'.': AV IN T.FIELDNO<1> SETTING AF.POS THEN
            T.ENRI<AF.POS> = TXN.ENRI
        END
    END

RETURN
*-----------------------------------------------------------------------------
BUILD.ETEXT.FROM.OVE:

    OVE.MSG = ''
    OVE.ID = SAVE.TEXT<1>
    VAR.PARTS = SAVE.TEXT<2>
    IF VAR.PARTS THEN         ;* If there are variable parts
        CALL F.READ(FN.OVE,OVE.ID,R.OVE,F.OVE,ERR.OVE)
        OVE.MSG = R.OVE<EB.OR.MESSAGE>
        IF NOT(OVE.MSG) THEN OVE.MSG = OVE.ID     ;* If Its not a valid OVERRIDE record, then OVE id becomes the messages.
        IF INDEX(OVE.MSG,'&',1) THEN
            LOOP
                REMOVE VAR.PART FROM VAR.PARTS SETTING NEXT.PART.POS
            WHILE VAR.PART : NEXT.PART.POS DO
                OVE.MSG = CHANGE(OVE.MSG,'&',VAR.PART,1)    ;* Replace the & with the dynamic values
            REPEAT
        END
    END ELSE
        OVE.MSG = OVE.ID      ;* Else, the OVE Id becomes the message itself
    END
*
    IF NOT(OVE.MSG) THEN
        OVE.MSG = 'NO REPLIED TO OVERRIDE'
    END

RETURN
*-----------------------------------------------------------------------------
CHECK.AND.RAISE.ERROR:

    BEGIN CASE
        CASE END.ERROR
            IF END.ERROR NE 'Y' THEN
                E = END.ERROR
                CALL ERR
                V$ERROR = 1
            END

        CASE ETEXT
            E = ETEXT
            CALL ERR
            V$ERROR = 1

        CASE E
            CALL ERR
            V$ERROR = 1
    END CASE

    IF V$ERROR = 1 THEN MESSAGE = 'ERROR'

RETURN
*-------------------------------------------------------------------------------
CLEAN.UP.DENOMS:

    IF NOT(V$FUNCTION MATCHES 'A' :@VM: 'I' :@VM: 'C') THEN RETURN

    ALL.TXNS = R.NEW(TFS.TRANSACTION)
    NO.OF.TXNS = DCOUNT(ALL.TXNS,@VM)
    FOR TXN.CNT = 1 TO NO.OF.TXNS
        IF ALL.TXNS<1,TXN.CNT> THEN
            ALL.DENOMS = R.NEW(TFS.CR.DENOM)<1,TXN.CNT>
            IF ALL.DENOMS THEN
                DENOM.FIELD = TFS.CR.DENOM ; UNIT.FIELD = TFS.CR.DEN.UNIT ; SERIAL.FIELD = TFS.CR.SERIAL.NO
                GOSUB DELETE.DENOMS
            END
*
            ALL.DENOMS = R.NEW(TFS.DR.DENOM)<1,TXN.CNT>
            IF ALL.DENOMS THEN
                DENOM.FIELD = TFS.DR.DENOM ; UNIT.FIELD = TFS.DR.DEN.UNIT ; SERIAL.FIELD = TFS.DR.SERIAL.NO
                GOSUB DELETE.DENOMS
            END
        END
    NEXT TXN.CNT
*
RETURN
*-----------------------------------------------------------------------
DELETE.DENOMS:

    TEMP.ARR = ''
    ALL.DEN.UNITS = R.NEW(UNIT.FIELD)<1,TXN.CNT>
    ALL.SERIAL.NOS = R.NEW(SERIAL.FIELD)<1,TXN.CNT>
    NO.OF.DENOMS = DCOUNT(ALL.DENOMS,@SM)

    FOR DEN.CNT = 1 TO NO.OF.DENOMS
        IF R.NEW(UNIT.FIELD)<1,TXN.CNT,DEN.CNT> NE '' THEN
            IF TEMP.ARR<1> THEN
                TEMP.ARR<1> := @SM: R.NEW(DENOM.FIELD)<1,TXN.CNT,DEN.CNT>
                TEMP.ARR<2> := @SM: R.NEW(UNIT.FIELD)<1,TXN.CNT,DEN.CNT>
                TEMP.ARR<3> := @SM: R.NEW(SERIAL.FIELD)<1,TXN.CNT,DEN.CNT>
            END ELSE
                TEMP.ARR<1> = R.NEW(DENOM.FIELD)<1,TXN.CNT,DEN.CNT>
                TEMP.ARR<2> = R.NEW(UNIT.FIELD)<1,TXN.CNT,DEN.CNT>
                TEMP.ARR<3> = R.NEW(SERIAL.FIELD)<1,TXN.CNT,DEN.CNT>
            END
        END
    NEXT DEN.CNT

    R.NEW(DENOM.FIELD)<1,TXN.CNT> = TEMP.ARR<1>
    R.NEW(UNIT.FIELD)<1,TXN.CNT> = TEMP.ARR<2>
    R.NEW(SERIAL.FIELD)<1,TXN.CNT> = TEMP.ARR<3>
*
RETURN
*------------------------------------------------------------------------------
END

















































