SUBROUTINE REDO.CARD.DAMAGE.ID

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CARD.DAMAGE.ID
*--------------------------------------------------------------------------------
* Description: This is an ID routine for REDO.CARD.DAMAGE and it gets the Request
* ID from REDO.CARD.REQUEST based on entered card number
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 04-May-2011    H GANESH       PACS00054728    INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.CARD.DAMAGE.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------
    REQ.ID=''
    Y.CARD.TYPE=''
    ERR=''

    FN.REDO.CARD.REQUEST='F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST=''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
* This part gets the REDO.CARD.REQUEST for card and assignt to ID.NEW

    REDO.CARD.TYPE= ''
    REDO.CARD.NO= ''

    Y.ID = ID.NEW     ;* Get the Latam Card No

    IF Y.ID[1,3] EQ 'REQ' THEN
        R.CARD.REQ=''
        CALL F.READ(FN.REDO.CARD.REQUEST,Y.ID,R.CARD.REQ,F.REDO.CARD.REQUEST,REQ.ERR)
        IF R.CARD.REQ EQ '' THEN
            E='EB-MISSING.RECORD':@FM:'REDO.CARD.REQUEST'
        END
        RETURN
    END
    CALL REDO.GET.CARD.REQUEST.ID(Y.ID,REQ.ID,Y.CARD.TYPE,ERR)

    IF ERR THEN
        E='EB-INVALID.CARD.NO'
        RETURN
    END
    REDO.CARD.TYPE=Y.CARD.TYPE
    REDO.CARD.NO=Y.ID
    ID.NEW=REQ.ID
RETURN
END
