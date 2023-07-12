* Version 2 03/04/00  GLOBUS Release No. G10.1.02 28/10/99
*-----------------------------------------------------------------------------
* <Rating>1105</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATM.PARAMETER.CHECK.FIELDS
************************************************************************
*
*
************************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ATM.PARAMETER
    $INSERT I_F.TRANSACTION
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
    IF COMI = '' AND INTO.FIELD = '' THEN
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
    BEGIN CASE
    CASE AF = ATM.PARA.NET.IMD.CATEG
*** VALIDATED CATEGORY SHOULD BE ENTERED AFTER NETWORK.ID IS ENTERED,
*** SHOULD NOT BE ENTERED WHEN NET.IMD.INT.AC IS ALREADY ENTERED
*** AND SHOULD BE IN THE RANGE OF 10000 TO 19999
        IF COMI AND R.NEW(ATM.PARA.NETWORK.IMD)<1, AV> EQ '' THEN
            E = 'NETWORK.IMD SHOULD BE ENTERED FIRST'
        END ELSE
            IF COMI AND R.NEW(ATM.PARA.NET.IMD.INT.AC)<1, AV> THEN
                E = 'COMBINATION OF NET.IMD.CATEG AND NET.IMD.AC.SUFX OR NET.IMD.INT.AC  ONLY ALLOWED'
            END ELSE
                IF COMI THEN
                    IF (COMI LT 10000) OR (COMI GT 19999) THEN
                        E = 'CATEGORY SHOULD BE IN THE RANGE OF 10000-19999'
                    END
                END
            END
        END
    CASE AF = ATM.PARA.NET.IMD.AC.SUFX
        IF COMI AND R.NEW(ATM.PARA.NET.IMD.CATEG)<1, AV> EQ '' THEN
            E = 'CATEGORY SHOULD BE ENTERED FIRST'
        END ELSE
            IF COMI EQ '' AND R.NEW(ATM.PARA.NET.IMD.CATEG)<1, AV> THEN
                E = 'INPUT MISSING'
*CHANGED FOR KCB ANITHA S
*  END ELSE
*     IF COMI AND LEN(COMI) NE 4 THEN
*        E = 'MUST BE LENGTH OF 4'
*     END
*CHANGED FOR KCB ANITHA E
            END
        END
    CASE AF = ATM.PARA.ACCT.NO.LEN
        IF COMI GT 16 THEN
            E = 'ACCT.NO.LEN CANNOT BE GREATER THAN 16'
        END
    CASE AF = ATM.PARA.NET.IMD.INT.AC
        IF COMI AND R.NEW(ATM.PARA.NETWORK.IMD)<1, AV> EQ '' THEN
            E = 'NETWORK.IMD SHOULD BE ENTERED FIRST'
        END ELSE
            IF COMI AND R.NEW(ATM.PARA.NET.IMD.CATEG)<1, AV> THEN
                E = 'COMBINATION OF NET.IMD.CATEG AND NET.IMD.AC.SUFX OR NET.IMD.INT.AC  ONLY ALLOWED'
            END ELSE
                IF COMI THEN
                    IF (COMI[4,5] LT 10000) OR (COMI[4,5] GT 19999) THEN
                        E = 'CATEGORY SHOULD BE IN THE RANGE 10000-19999'
                    END
                END
            END
        END
    CASE AF = ATM.PARA.BAL.UPLOAD.PATH
        IF COMI THEN
            OPENPATH COMI ON ERROR E = 'ERROR IN OPENING DIRECTORY'
            ELSE E = 'DIRECTORY DOES NOT EXISTS'
        END ELSE
            EXECUTE 'pwd' CAPTURING Y.PWD
            COMI=Y.PWD<1,1>
        END
    CASE AF = ATM.PARA.CARD.UPLOAD.PATH
        IF COMI THEN
            OPENPATH COMI ON ERROR E = 'ERROR IN OPENING DIRECTORY'
            ELSE E = 'DIRECTORY DOES NOT EXISTS'
        END ELSE
            EXECUTE 'pwd' CAPTURING Y.PWD
            COMI=Y.PWD<1,1>
        END
    CASE AF = ATM.PARA.LOG.FILE.LOC
        IF COMI THEN
            OPENPATH COMI ON ERROR E = 'ERROR IN OPENING DIRECTORY'
            ELSE E = 'DIRECTORY DOES NOT EXISTS'
        END ELSE
            EXECUTE 'pwd' CAPTURING Y.PWD
            COMI=Y.PWD<1,1>
        END
    CASE AF = ATM.PARA.DB.TXN.CODE
        IF COMI THEN
            CALL DBR('TRANSACTION':FM:AC.TRA.DEBIT.CREDIT.IND,COMI, Y.DB.CR)
            IF Y.DB.CR[1, 1] EQ 'C' THEN
                E = 'ITS NOT A DEBIT TRANSACTION CODE'
            END
        END
    CASE AF = ATM.PARA.CR.TXN.CODE
        IF COMI THEN
            CALL DBR('TRANSACTION':FM:AC.TRA.DEBIT.CREDIT.IND,COMI, Y.DB.CR)
            IF Y.DB.CR[1, 1] EQ 'D' THEN
                E = 'ITS NOT A CREDIT TRANSACTION CODE'
            END
        END
    CASE AF = ATM.PARA.DB.SUSP.ACCT
        IF COMI THEN
            IF COMI[1,3] NE LCCY THEN
                E = 'CURRENCY SHOULD BE LOCAL CURRENCY'
            END ELSE
                IF (COMI[4,5] LT 10000) OR (COMI[4,5] GT 19999) THEN
                    E = 'CATEGORY SHOULD BE IN THE RANGE 10000-19999'
                END
            END
        END
    CASE AF = ATM.PARA.CR.SUSP.ACCT
        IF COMI THEN
            IF COMI[1,3] NE LCCY THEN
                E = 'CURRENCY SHOULD BE LOCAL CURRENCY'
            END ELSE
                IF (COMI[4,5] LT 10000) OR (COMI[4,5] GT 19999) THEN
                    E = 'CATEGORY SHOULD BE IN THE RANGE 10000-19999'
                END
            END
        END
    CASE AF = ATM.PARA.COMM.CATEG
        IF COMI AND ( COMI LT 52000 OR COMI GT 52999 ) THEN
            E = 'COMM.CATEG SHOULD BE IN THE RANGE 52000 TO 52999'
        END

    CASE AF = ATM.PARA.POSTING.DATE
        IF COMI NE 'ATM' AND COMI NE 'BANK' THEN
            E = 'It has to be either ATM or BANK - Indicating the VALUE DATE for TXNS'
        END
    END CASE
*
CHECK.FIELD.END:
*
    RETURN
*
* ***********************************************************************
*
END
