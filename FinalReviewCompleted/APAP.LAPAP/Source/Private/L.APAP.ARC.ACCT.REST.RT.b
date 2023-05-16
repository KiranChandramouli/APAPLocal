$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ARC.ACCT.REST.RT
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 21-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND <> TO NE  AND DCOUNT(REC.LIST,@FM) TO CNT
* 21-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    FN.AC.ARC = "FBNK.ACCOUNT$ARC"

    P.ACCOUNT.ID = ID.NEW.LAST          ;*COMI
**DEBUG
    SEL.CMD = 'SELECT ': FN.AC.ARC :' WITH @ID LIKE ' : P.ACCOUNT.ID  : ';... '
    EXECUTE SEL.CMD CAPTURING OUTPUT
    READLIST REC.LIST ELSE REC.LIST = ''

    IF REC.LIST NE '' THEN
        CNT = DCOUNT(REC.LIST,@FM)
        FOR REC.IDX = 1 TO CNT
            EXECUTE 'COPY FROM FBNK.ACCOUNT$ARC TO FBNK.ACCOUNT$HIS ' : REC.LIST<REC.IDX> : ' OVERWRITING'
        NEXT REC.IDX
    END

RETURN
END
