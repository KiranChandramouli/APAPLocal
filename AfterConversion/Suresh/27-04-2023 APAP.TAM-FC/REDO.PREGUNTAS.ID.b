$PACKAGE APAP.TAM
SUBROUTINE REDO.PREGUNTAS.ID

** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES

*-----------------------------------------------------------------------------

    GOSUB INITIALISE

RETURN

*-----------------------------------------------------------------------------
INITIALISE:
* V$SEQ = ID.NEW
* IF V$SEQ LT '000000001' OR V$SEQ GT '999999999' THEN
*    E ='Secuencial Invalido'
*    V$ERROR = 1
*    GOSUB FIELD.ERROR
* END

* ID.NEW = TODAY:FMT(ID.NEW,'9"0"R')

* RMONDRAGON - FEB/10/2012 - S
* CORRECTION TO SEE OR MODIFY PREVIOUS RECORDS THAN TODAY
    ID.LENGHT = LEN(ID.NEW)
    IF ID.LENGHT LT 17 THEN
        ID.NEW = TODAY:FMT(ID.NEW,"R%9")
    END
* RMONDRAGON - FEB/10/2012 - E

    V$ERROR = 0
    E = ''

    IF E THEN
        V$ERROR = 1
        GOSUB FIELD.ERROR
    END


RETURN
*-----------------------------------------------------------------------------
FIELD.ERROR:
*
    T.SEQU = "IFLD"
    CALL ERR
RETURN

*-----------------------------------------------------------------------------
*
END
