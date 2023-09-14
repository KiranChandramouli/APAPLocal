* @ValidationCode : MjotNTE1NTQ0Njg1OkNwMTI1MjoxNjgyMDY5MDgyNDY5OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 14:54:42
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
$PACKAGE APAP.ATM
* Version 2 05/01/00  GLOBUS Release No. G10.2.01 25/02/00
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ , VM to @VM,IF STATEMENT MODIFIED
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION CALL RTN FORMAT CAN BE MODIFIED
*----------------------------------------------------------------------------------------




*-----------------------------------------------------------------------------
SUBROUTINE ATM.BRANCH.CROSSVAL
************************************************************************
*
*
************************************************************************
* XX/XX/XX - GBXXXXXXX
*            Pif Description
*
************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.BRANCH
*
************************************************************************
*
*
************************************************************************
*
    GOSUB INITIALISE
*
    GOSUB REPEAT.CHECK.FIELDS
*
    GOSUB REAL.CROSSVAL
*
RETURN
*
************************************************************************
*
REAL.CROSSVAL:
*
* Real cross validation goes here...
*
    Y.COUNT = DCOUNT(R.NEW(ATM.BR.DEVICE.ID),@VM)
    FOR Y.CTR = 1 TO Y.COUNT
        IF R.NEW(ATM.BR.DEV.ID.CATEG)<1,Y.CTR> EQ '' AND R.NEW(ATM.BR.DEV.ID.AC.SUFX)<1,Y.CTR> EQ '' AND R.NEW(ATM.BR.DEV.ID.INT.ACCT)<1,Y.CTR> EQ '' THEN ;*R22 AUTO CODE CONVERSION
            E='ENTER EITHER DEV.ID.CATEG AND DEV.ID.AC.SUFX OR DEV.ID.INT.ACCT'
            AV = Y.CTR
            AF = ATM.BR.DEV.ID.CATEG
        END ELSE
            IF R.NEW(ATM.BR.DEV.ID.INT.ACCT)<1,Y.CTR> EQ '' THEN
                IF R.NEW(ATM.BR.DEV.ID.CATEG)<1,Y.CTR> AND R.NEW(ATM.BR.DEV.ID.AC.SUFX)<1,Y.CTR> EQ '' THEN ;*R22 AUTO CODE CONVERSION
                    AV = Y.CTR
                    AF = ATM.BR.DEV.ID.AC.SUFX
                    E = 'ENTER DEV.ID.AC.SUFX'
                END ELSE
                    IF R.NEW(ATM.BR.DEV.ID.CATEG)<1,Y.CTR> EQ '' AND R.NEW(ATM.BR.DEV.ID.AC.SUFX)<1,Y.CTR> THEN ;*R22 AUTO CODE CONVERSION
                        AV = Y.CTR
                        AF = ATM.BR.DEV.ID.CATEG
                        E = 'ENTER DEV.ID.CATEG'
                    END
                END
            END
        END
        IF E THEN
            ETEXT = E
            CALL STORE.END.ERROR
        END
    NEXT Y.CTR

    Y.COUNT = DCOUNT(R.NEW(ATM.BR.UTILITY.NAME),@VM)
    IF Y.COUNT LT 1 THEN
        Y.COUNT = DCOUNT(R.NEW(ATM.BR.UTIL.NO),@VM)
    END
    FOR Y.CTR = 1 TO Y.COUNT
        IF R.NEW(ATM.BR.UTILITY.NAME)<1,Y.CTR> AND R.NEW(ATM.BR.UTIL.NO)<1,Y.CTR> EQ '' THEN ;*R22 AUTO CODE CONVERSION
            AV = Y.CTR
            AF = ATM.BR.UTIL.NO
            E = 'INPUT MISSING'
        END ELSE
            IF R.NEW(ATM.BR.UTIL.NO)<1,Y.CTR> AND R.NEW(ATM.BR.UTILITY.NAME)<1,Y.CTR> EQ '' THEN ;*R22 AUTO CODE CONVERSION
                AV = Y.CTR
                AF = ATM.BR.UTILITY.NAME
                E = 'INPUT MISSING'
            END ELSE
                IF R.NEW(ATM.BR.UTILITY.NAME)<1,Y.CTR> OR R.NEW(ATM.BR.UTIL.NO)<1,Y.CTR> THEN
                    IF R.NEW(ATM.BR.UTIL.CATEG)<1,Y.CTR> EQ '' AND R.NEW(ATM.BR.UTIL.AC.SUFX)<1,Y.CTR> EQ '' AND R.NEW(ATM.BR.UTIL.INT.ACCT)<1,Y.CTR> EQ '' THEN
                        E='ENTER EITHER UTIL.CATEG AND UTIL.AC.SUFX OR UTIL.INT.ACCT'
                        AV = Y.CTR
                        AF = ATM.BR.UTIL.CATEG

                    END ELSE
                        IF R.NEW(ATM.BR.UTIL.INT.ACCT)<1,Y.CTR> EQ '' THEN
                            IF R.NEW(ATM.BR.UTIL.CATEG)<1,Y.CTR> AND R.NEW(ATM.BR.UTIL.AC.SUFX)<1,Y.CTR> EQ '' THEN
                                AV = Y.CTR
                                AF = ATM.BR.UTIL.AC.SUFX
                                E = 'ENTER UTIL.AC.SUFX'
                            END ELSE
                                IF R.NEW(ATM.BR.UTIL.CATEG)<1,Y.CTR> EQ '' AND R.NEW(ATM.BR.UTIL.AC.SUFX)<1,Y.CTR> THEN
                                    AV = Y.CTR
                                    AF = ATM.BR.UTIL.CATEG
                                    E = 'ENTER UTIL.CATEG'
                                END
                            END
                        END
                    END
                END
            END
        END
        IF E THEN
            ETEXT = E
            CALL STORE.END.ERROR
        END
    NEXT Y.CTR




    AF = ATM.BR.DEVICE.ID
    ETEXT=''
    CALL DUP
    AF = ATM.BR.UTILITY.NAME
    ETEXT=''
    CALL DUP
    AF = ATM.BR.UTIL.NO
    ETEXT = ''
    CALL DUP
RETURN
*
************************************************************************
*
REPEAT.CHECK.FIELDS:
*
* Loop through each field and repeat the check field processing if there is any defined
*
    FOR AF = 1 TO ATM.BR.UTIL.INT.ACCT
        IF INDEX(N(AF), "C", 1) THEN
*
* Is it a sub value, a multi value or just a field
*
            BEGIN CASE
                CASE F(AF)[4,2] EQ 'XX'    ; * Sv
                    NO.OF.AV = DCOUNT(R.NEW(AF), @VM)
                    IF NO.OF.AV EQ 0 THEN
                        NO.OF.AV = 1
                    END ;*R22 AUTO CODE CONVERSION
                    FOR AV = 1 TO NO.OF.AV
                        NO.OF.SV = DCOUNT(R.NEW(AF)<1,AV>, @SM)
                        IF NO.OF.SV EQ 0 THEN
                            NO.OF.SV = 1
                        END ;*R22 AUTO CODE CONVERSION
                        FOR AS = 1 TO NO.OF.SV
                            GOSUB DO.CHECK.FIELD
                        NEXT AS
                    NEXT AV
                CASE F(AF)[1,2] = 'XX'    ; * Mv
                    AS = ''
                    NO.OF.AV = DCOUNT(R.NEW(AF), @VM)
                    IF NO.OF.AV EQ 0 THEN
                        NO.OF.AV = 1
                    END ;*R22 AUTO CODE CONVERSION
                    FOR AV = 1 TO NO.OF.AV
                        GOSUB DO.CHECK.FIELD
                    NEXT AV
                CASE OTHERWISE
                    AV = '' ; AS = ''
                    GOSUB DO.CHECK.FIELD
            END CASE
        END
    NEXT AF
RETURN
*
************************************************************************
*
DO.CHECK.FIELD:
** Repeat the check field validation - errors are returned in the
** variable E
*
    COMI.ENRI = ""
    BEGIN CASE
        CASE AS
            COMI = R.NEW(AF)<1,AV,AS>
        CASE AV
            COMI = R.NEW(AF)<1,AV>
        CASE AF
            COMI = R.NEW(AF)
    END CASE
*
    CALL APAP.ATM.ATM.BRANCH.CHECK.FIELDS ;*R22 MANAUL CODE CONVERSION
    IF E THEN
        ETEXT = E
        CALL STORE.END.ERROR
    END ELSE
        BEGIN CASE
            CASE AS
                R.NEW(AF)<1,AV,AS> = COMI
                YENRI.FLD = AF:".":AV:".":AS ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
            CASE AV
                R.NEW(AF)<1,AV> = COMI
                YENRI.FLD = AF:".":AV ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
            CASE AF
                R.NEW(AF) = COMI
                YENRI.FLD = AF ; YENRI = COMI.ENRI
                GOSUB SET.UP.ENRI
        END CASE
    END
RETURN
*
************************************************************************
*
SET.UP.ENRI:
*
    LOCATE YENRI.FLD IN T.FIELDNO<1> SETTING YPOS THEN
*         T.ENRI<YPOS> = YENRI
    END
RETURN
*
************************************************************************
*
INITIALISE:
*
RETURN
*
************************************************************************
*
END
