SUBROUTINE REDO.SOLICITUD.CANAL.ID
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES

*-----------------------------------------------------------------------------

    GOSUB INITIALISE

RETURN

*-----------------------------------------------------------------------------
INITIALISE:

*V$SEQ = ID.NEW
*IF V$SEQ LT '000000001' OR V$SEQ GT '999999999' THEN
*   E ='Secuencial Invalido'
*   V$ERROR = 1
*   GOSUB FIELD.ERROR
*END

*ID.NEW = TODAY:FMT(ID.NEW,'9"0"R')
    ID.NEW = TODAY:FMT(ID.NEW,"R%9")

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
