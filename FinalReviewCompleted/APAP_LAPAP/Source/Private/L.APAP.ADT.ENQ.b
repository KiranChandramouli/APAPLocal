$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ADT.ENQ
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INSERT TAM.BP TO $INSERT 
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*----------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CARD.RENEWAL

    CUENTA  = O.DATA

    FN.CARD = 'F.REDO.CARD.RENEWAL'
    F.CARD = ''
    CALL OPF(FN.CARD,F.CARD)
    SELECT.STATEMENT = 'SELECT ':FN.CARD : " WITH @ID LIKE ..." : CUENTA  : " AND TYPE.OF.CARD EQ ADICIONAL ADDITIONAL "
    CARD.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    SYSTEM.RETURN.CODE = ''
    CALL EB.READLIST(SELECT.STATEMENT,CARD.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

    LOOP
        REMOVE CARD.ID FROM CARD.LIST SETTING CARD.MARK
    WHILE CARD.ID : CARD.MARK

        R.CARD = ''
        YERR = ''
        CALL F.READ(FN.CARD,CARD.ID,R.CARD,F.CARD,YERR)
        TARJETA = R.CARD<REDO.RENEW.PREV.CARD.NO>

    REPEAT

    IF TARJETA NE "" THEN

        O.DATA =  "Y"

    END ELSE

        O.DATA =  "N"

    END

RETURN

END
