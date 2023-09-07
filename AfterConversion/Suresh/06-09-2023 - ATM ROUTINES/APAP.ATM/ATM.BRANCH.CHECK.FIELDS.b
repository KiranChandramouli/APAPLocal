* @ValidationCode : MjotMjEzNDI3Mjg5ODpDcDEyNTI6MTY4MjA2NTcxOTMwMDphaml0aDotMTotMTowOjA6dHJ1ZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 13:58:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
* Version 2 03/04/00  GLOBUS Release No. G10.1.02 28/10/99
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE ATM.BRANCH.CHECK.FIELDS
************************************************************************
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





*
************************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.BRANCH
    $INSERT I_F.ACCOUNT
    $INSERT I_F.MNEMONIC.COMPANY
************************************************************************
*
*
************************************************************************
*
    GOSUB INITIALISE
*
************************************************************************
*
* Default the current field if input is null and the field is null
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
    IF COMI EQ '' AND INTO.FIELD EQ '' THEN ;*R22 AUTO CODE CONVERSION
        GOSUB DEFAULT.FIELDS
    END

*
* Real validation here....
*
    GOSUB CHECK.FIELDS

*
* Now default other fields from this one if there is a value...
*
    IF COMI THEN
        COMI.ENRI.SAVE = COMI.ENRI
        COMI.ENRI = ''
        GOSUB DEFAULT.OTHER.FIELDS
        COMI.ENRI = COMI.ENRI.SAVE
    END

************************************************************************
*
* All done here
*
RETURN
*
************************************************************************
* Local subroutines...
************************************************************************
*
INITIALISE:
    E = ''
    ETEXT = ''
*
* Open files...
*
RETURN
*
************************************************************************
*
DEFAULT.FIELDS:
*
    BEGIN CASE
*         CASE AF = XX.FIELD.NUMBER
*            COMI = TODAY

    END CASE

    CALL REFRESH.FIELD(AF,'')

RETURN
************************************************************************
DEFAULT.OTHER.FIELDS:

    DEFAULTED.FIELD = ''
    DEFAULTED.ENRI = ''
    BEGIN CASE
*         CASE AF = XX.FIELD.NUMBER
*              DEFAULTED.FIELD = XX.FIELD.NUMBER
*              DEFAULTED.ENRI = ENRI

    END CASE

    CALL REFRESH.FIELD(DEFAULTED.FIELD, DEFAULTED.ENRI)

RETURN
*
************************************************************************
*
CHECK.FIELDS:
*
* Where an error occurs, set E
*
*
    BEGIN CASE
        CASE AF EQ ATM.BR.COMPANY.CODE
            Y.F.ATM.BR = 'F.ATM.BRANCH'
*** CHECKS FOR EXISTENCE COMPANY CODE IN LIVE FILE
            GOSUB CHECK.COMPANY.CODE
            Y.F.ATM.BR = 'F.ATM.BRANCH$NAU'
*** CHECKS FOR EXISTENCE COMPANY CODE IN UNAUTHORISED FILE
            GOSUB CHECK.COMPANY.CODE
        CASE AF EQ ATM.BR.DEV.ID.CATEG
            IF COMI AND R.NEW(ATM.BR.DEV.ID.INT.ACCT)<1, AV> THEN
*** CHECKS FOR
                E = 'COMBINATION OF DEV.ID.CATEG AND DEV.ID.AC.SUFX OR DEV.ID.INT.ACCT ONLY ALLOWED'
            END ELSE
                IF COMI AND( (COMI LT 10000) OR (COMI GT 19999) ) THEN
                    E = 'DEV.ID.CATEG SHOULD BE IN THE RANGE OF 10000-19999'
                END
            END
        CASE AF EQ ATM.BR.DEV.ID.AC.SUFX
            IF COMI AND R.NEW(ATM.BR.DEV.ID.CATEG)<1, AV> EQ '' THEN
                E = 'DEV.ID.CATE SHOULD BE ENTERED FIRST'
            END ELSE
                IF COMI EQ '' AND R.NEW(ATM.BR.DEV.ID.CATEG)<1, AV> THEN
                    E = 'INPUT MISSING'
                END
* Change for KCB \s
*ELSE
*                IF COMI AND LEN(COMI) NE 4 THEN
*                    E = 'MUST BE LENGTH OF 4'
*                END
*            END
* Change for KCB \e
            END
        CASE AF EQ ATM.BR.DEV.ID.INT.ACCT
            IF COMI AND R.NEW(ATM.BR.DEV.ID.CATEG)<1, AV> THEN
                E = 'COMBINATION OF DEV.ID.CATEG AND DEV.ID.AC.SUFX OR DEV.ID.INT.ACCT ONLY ALLOWED'
            END ELSE
                IF COMI AND ( (COMI[4,5] LT 10000) OR (COMI[4,5] GT 19999) ) THEN
                    E = 'CATEGORY SHOULD BE IN THE RANGE 10000-19999'
                END
            END

            IF COMI THEN
                IF R.NEW(ATM.BR.COMPANY.CODE) THEN
                    SAV.COMPANY.CODE = ID.COMPANY
                    IF R.NEW(ATM.BR.COMPANY.CODE) NE ID.COMPANY THEN
                        CALL LOAD.COMPANY(R.NEW(ATM.BR.COMPANY.CODE))
                    END
                    FN.ACCOUNT = 'F.ACCOUNT'
                    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
                    CALL F.READ(FN.ACCOUNT,COMI,R.ACCOUNT,F.ACCOUNT,ER.ACCOUNT)
                    IF R.ACCOUNT THEN
                        COMI.ENRI = R.ACCOUNT<AC.SHORT.TITLE>

                    END ELSE
                        E = 'ACCOUNT not found in the branch!'
                    END

                    CALL LOAD.COMPANY(SAV.COMPANY.CODE)
                END
            END



        CASE AF EQ ATM.BR.UTILITY.NAME
            IF R.NEW(ATM.BR.UTIL.NO)<1,AV> AND COMI EQ '' THEN
                E = 'INPUT MISSING'
            END
        CASE AF EQ ATM.BR.UTIL.NO
            IF R.NEW(ATM.BR.UTILITY.NAME)<1,AV> AND COMI EQ '' THEN
                E = 'INPUT MISSING'
            END
        CASE AF EQ ATM.BR.UTIL.CATEG
            IF COMI THEN
                IF R.NEW(ATM.BR.UTIL.INT.ACCT)<1, AV> THEN
                    E = 'COMBINATION OF UTIL.CATEG AND UTIL.AC.SUFX OR UTIL.INT.ACCT ONLY ALLOWED'
                END ELSE
                    IF (COMI LT 10000) OR (COMI GT 19999) THEN
                        E = 'UTIL.CATEG SHOULD BE IN THE RANGE OF 10000-19999'
                    END
                END
            END
        CASE AF EQ ATM.BR.UTIL.AC.SUFX
            IF COMI AND R.NEW(ATM.BR.UTIL.INT.ACCT)<1, AV> THEN
                E = 'COMBINATION OF DEV.ID.CATEG AND DEV.ID.AC.SUFX OR DEV.ID.INT.ACCT ONLY ALLOWED'
            END ELSE
                IF R.NEW(ATM.BR.UTIL.CATEG)<1,AV> AND COMI EQ '' THEN
                    E = 'INPUT MISSING'
                END ELSE
                    IF COMI AND LEN(COMI) NE 4 THEN
                        E = 'MUST BE LENGTH OF 4'
                    END
                END
            END
        CASE AF EQ ATM.BR.UTIL.INT.ACCT
            IF (R.NEW(ATM.BR.UTIL.CATEG)<1, AV> OR R.NEW(ATM.BR.UTIL.AC.SUFX)<1,AV>) AND COMI THEN
                E = 'COMBINATION OF DEV.ID.CATEG AND DEV.ID.AC.SUFX OR DEV.ID.INT.ACCT ONLY ALLOWED'
            END
    END CASE
CHECK.FIELD.END:
*
RETURN
*
* ***********************************************************************
*

****CHECKS FOR ALREADY ASSIGNED COMPANY CODE*********
CHECK.COMPANY.CODE:
    CALL OPF(Y.F.ATM.BR,Y.FV.ATM.BR)
    Y.SEL.COMM = 'SSELECT ' : Y.F.ATM.BR
    CALL EB.READLIST(Y.SEL.COMM,Y.ATM.BR.LIST,Y.ATM.BR.NAME,Y.NO.OF.REC,Y.RETURN)
    FOR Y.CTR = 1 TO Y.NO.OF.REC
        CALL DBR(Y.F.ATM.BR[3,(LEN(Y.F.ATM.BR) - 2)]:@FM:ATM.BR.COMPANY.CODE,Y.ATM.BR.LIST<Y.CTR>,Y.COMPANY.CODE)
        IF COMI EQ Y.COMPANY.CODE AND Y.ATM.BR.LIST<Y.CTR> NE ID.NEW THEN
            E = 'ALREADY ASSIGNED TO BRANCH CODE ' : Y.ATM.BR.LIST<Y.CTR>
        END
    NEXT Y.CTR
*********************************************************
END
