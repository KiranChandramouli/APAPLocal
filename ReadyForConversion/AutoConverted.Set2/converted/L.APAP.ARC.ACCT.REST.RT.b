SUBROUTINE L.APAP.ARC.ACCT.REST.RT
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
